import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../repositories/alarm_repository.dart';
import '../repositories/location_repository.dart';
import '../repositories/notification_repository.dart';
import '../entities/location_alarm.dart';
import '../entities/location.dart';
import '../../core/error/failures.dart';

/// Caso de uso principal para monitorar alarmes
class MonitorAlarmsUseCase {
  final AlarmRepository _alarmRepository;
  final LocationRepository _locationRepository;
  final NotificationRepository _notificationRepository;

  /// Callback chamado quando um alarme dispara
  Function(LocationAlarm alarm)? onAlarmTriggered;

  MonitorAlarmsUseCase(
    this._alarmRepository,
    this._locationRepository,
    this._notificationRepository,
  );

  /// Inicia o monitoramento de alarmes
  Future<Either<Failure, void>> startMonitoring() async {
    debugPrint('🔍 Iniciando monitoramento de alarmes...');

    // Primeiro verifica as permissões
    final hasLocationPermission =
        await _locationRepository.hasLocationPermission();
    if (hasLocationPermission.isLeft()) {
      debugPrint('❌ Erro ao verificar permissão de localização');
      return Left(hasLocationPermission.fold((l) => l,
          (r) => const PermissionFailure(message: 'Unknown permission error')));
    }

    if (!hasLocationPermission.getOrElse(() => false)) {
      debugPrint('🔒 Solicitando permissão de localização...');
      final requestResult =
          await _locationRepository.requestLocationPermission();
      if (requestResult.isLeft() || !requestResult.getOrElse(() => false)) {
        debugPrint('❌ Permissão de localização negada');
        return const Left(
            PermissionFailure(message: 'Location permission denied'));
      }
      debugPrint('✅ Permissão de localização concedida');
    } else {
      debugPrint('✅ Permissão de localização já concedida');
    }

    // Inicia o monitoramento de localização
    debugPrint('📡 Iniciando stream de localização...');
    final startResult = await _locationRepository.startLocationMonitoring();
    if (startResult.isLeft()) {
      debugPrint('❌ Erro ao iniciar monitoramento de localização');
      return startResult;
    }

    // Monitora as atualizações de localização
    _locationRepository.locationStream.listen((locationResult) {
      locationResult.fold(
        (failure) => debugPrint('❌ Erro de localização: ${failure.message}'),
        (location) {
          debugPrint(
              '📍 Nova localização recebida: (${location.latitude}, ${location.longitude})');
          _checkAlarmsForLocation(location);
        },
      );
    });

    debugPrint('✅ Monitoramento iniciado com sucesso');
    return const Right(null);
  }

  /// Verifica se algum alarme deve ser disparado para a localização atual
  Future<void> _checkAlarmsForLocation(Location currentLocation) async {
    debugPrint(
        '📍 Verificando alarmes para localização: (${currentLocation.latitude}, ${currentLocation.longitude})');

    final alarmsResult = await _alarmRepository.getActiveAlarms();

    alarmsResult.fold(
      (failure) => debugPrint('❌ Erro ao obter alarmes: ${failure.message}'),
      (alarms) {
        debugPrint('📋 Alarmes ativos encontrados: ${alarms.length}');

        for (final alarm in alarms) {
          debugPrint(
              '  - Alarme: ${alarm.title} (Ativo: ${alarm.isActive}, Disparado: ${alarm.isTriggered})');

          if (alarm.isActive && !alarm.isTriggered) {
            final alarmLocation = Location(
              latitude: alarm.latitude,
              longitude: alarm.longitude,
              timestamp: DateTime.now(),
            );

            final distance = currentLocation.distanceTo(alarmLocation);
            debugPrint(
                '    Distância: ${distance.toStringAsFixed(2)}m / Raio: ${alarm.radius}m');

            if (distance <= alarm.radius) {
              debugPrint('🚨 DISPARANDO ALARME: ${alarm.title}');
              _triggerAlarm(alarm);
            }
          }
        }
      },
    );
  }

  /// Dispara um alarme
  Future<void> _triggerAlarm(LocationAlarm alarm) async {
    // Atualiza o alarme como disparado
    final updatedAlarm = alarm.copyWith(
      isTriggered: true,
      triggeredAt: DateTime.now(),
    );

    await _alarmRepository.updateAlarm(updatedAlarm);

    // Mostra a notificação
    await _notificationRepository.showAlarmNotification(
      title: alarm.title,
      body: alarm.description,
      alarmId: alarm.id,
    );

    // Chama o callback se disponível (para abrir a página de alarme ativo)
    onAlarmTriggered?.call(updatedAlarm);
  }
}
