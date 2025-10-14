import '../../domain/entities/location_alarm.dart';
import '../../core/error/exceptions.dart';

/// DataSource local para alarmes usando armazenamento em memória (para demonstração)
class MemoryAlarmDataSource {
  final List<LocationAlarm> _alarms = [];

  Future<String> saveAlarm(LocationAlarm alarm) async {
    try {
      _alarms.add(alarm);
      return alarm.id;
    } catch (e) {
      throw DatabaseException(message: 'Failed to save alarm: $e');
    }
  }

  Future<void> updateAlarm(LocationAlarm alarm) async {
    try {
      final index = _alarms.indexWhere((a) => a.id == alarm.id);
      if (index != -1) {
        _alarms[index] = alarm;
      } else {
        throw DatabaseException(message: 'Alarm not found');
      }
    } catch (e) {
      throw DatabaseException(message: 'Failed to update alarm: $e');
    }
  }

  Future<void> deleteAlarm(String alarmId) async {
    try {
      _alarms.removeWhere((alarm) => alarm.id == alarmId);
    } catch (e) {
      throw DatabaseException(message: 'Failed to delete alarm: $e');
    }
  }

  Future<List<LocationAlarm>> getAllAlarms() async {
    try {
      return List<LocationAlarm>.from(_alarms);
    } catch (e) {
      throw DatabaseException(message: 'Failed to get alarms: $e');
    }
  }

  Future<List<LocationAlarm>> getActiveAlarms() async {
    try {
      return _alarms.where((alarm) => alarm.isActive).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to get active alarms: $e');
    }
  }

  Future<LocationAlarm?> getAlarmById(String alarmId) async {
    try {
      return _alarms.cast<LocationAlarm?>().firstWhere(
            (alarm) => alarm?.id == alarmId,
            orElse: () => null,
          );
    } catch (e) {
      throw DatabaseException(message: 'Failed to get alarm by id: $e');
    }
  }
}
