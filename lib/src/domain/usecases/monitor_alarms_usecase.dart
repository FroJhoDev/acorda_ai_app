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
    // Primeiro verifica as permissões
    final hasLocationPermission =
        await _locationRepository.hasLocationPermission();
    if (hasLocationPermission.isLeft()) {
      return Left(hasLocationPermission.fold((l) => l,
          (r) => const PermissionFailure(message: 'Unknown permission error')));
    }

    if (!hasLocationPermission.getOrElse(() => false)) {
      final requestResult =
          await _locationRepository.requestLocationPermission();
      if (requestResult.isLeft() || !requestResult.getOrElse(() => false)) {
        return const Left(
            PermissionFailure(message: 'Location permission denied'));
      }
    }

    // Inicia o monitoramento de localização
    final startResult = await _locationRepository.startLocationMonitoring();
    if (startResult.isLeft()) {
      return startResult;
    }

    // Monitora as atualizações de localização
    _locationRepository.locationStream.listen((locationResult) {
      locationResult.fold(
        (failure) => debugPrint('Location error: ${failure.message}'),
        (location) => _checkAlarmsForLocation(location),
      );
    });

    return const Right(null);
  }

  /// Verifica se algum alarme deve ser disparado para a localização atual
  Future<void> _checkAlarmsForLocation(Location currentLocation) async {
    final alarmsResult = await _alarmRepository.getActiveAlarms();

    alarmsResult.fold(
      (failure) => debugPrint('Error getting alarms: ${failure.message}'),
      (alarms) {
        for (final alarm in alarms) {
          if (!alarm.isTriggered) {
            final alarmLocation = Location(
              latitude: alarm.latitude,
              longitude: alarm.longitude,
              timestamp: DateTime.now(),
            );

            final distance = currentLocation.distanceTo(alarmLocation);

            if (distance <= alarm.radius) {
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
