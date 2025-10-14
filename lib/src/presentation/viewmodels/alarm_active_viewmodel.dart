import 'package:flutter/material.dart';
import '../../domain/entities/location_alarm.dart';
import '../../domain/usecases/update_alarm_usecase.dart';
import '../../core/services/alarm_sound_service.dart';

/// ViewModel para gerenciar o estado do alarme ativo
class AlarmActiveViewModel extends ChangeNotifier {
  final UpdateAlarmUseCase _updateAlarmUseCase;
  final AlarmSoundService _alarmSoundService = AlarmSoundService();

  AlarmActiveViewModel(this._updateAlarmUseCase);

  bool _isLoading = false;
  String? _errorMessage;
  LocationAlarm? _currentAlarm;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LocationAlarm? get currentAlarm => _currentAlarm;
  bool get hasActiveAlarm => _currentAlarm != null;

  /// Define o alarme atual
  void setCurrentAlarm(LocationAlarm alarm) {
    _currentAlarm = alarm;
    _errorMessage = null;
    notifyListeners();
  }

  /// Para o alarme atual
  Future<void> stopCurrentAlarm() async {
    if (_currentAlarm == null) return;

    _setLoading(true);

    try {
      // Para o som e vibração
      await _alarmSoundService.stopAlarm();

      // Atualiza o alarme no repositório como inativo
      final updatedAlarm = _currentAlarm!.copyWith(
        isActive: false,
        isTriggered: false,
      );

      final result = await _updateAlarmUseCase.call(updatedAlarm);

      result.fold(
        (failure) {
          _setError('Erro ao parar alarme: ${failure.message}');
        },
        (success) {
          _currentAlarm = null;
          _clearError();
        },
      );
    } catch (e) {
      _setError('Erro inesperado ao parar alarme: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Reativa um alarme (sem disparar novamente)
  Future<void> reactivateAlarm(LocationAlarm alarm) async {
    _setLoading(true);

    try {
      final reactivatedAlarm = alarm.copyWith(
        isActive: true,
        isTriggered: false,
        triggeredAt: null,
      );

      final result = await _updateAlarmUseCase.call(reactivatedAlarm);

      result.fold(
        (failure) {
          _setError('Erro ao reativar alarme: ${failure.message}');
        },
        (success) {
          _clearError();
        },
      );
    } catch (e) {
      _setError('Erro inesperado ao reativar alarme: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Para todos os alarmes de emergência
  Future<void> stopAllAlarms() async {
    try {
      await _alarmSoundService.stopAlarm();
      _currentAlarm = null;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Erro ao parar todos os alarmes: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _alarmSoundService.stopAlarm();
    super.dispose();
  }
}
