import 'package:dartz/dartz.dart';
import '../repositories/alarm_repository.dart';
import '../entities/location_alarm.dart';
import '../../core/error/failures.dart';

/// Caso de uso para criar um novo alarme
class CreateAlarmUseCase {
  final AlarmRepository _repository;

  CreateAlarmUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    double radius = 100.0,
    String soundPath = '',
    bool vibrationEnabled = true,
    int volume = 100,
  }) async {
    final alarm = LocationAlarm(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      soundPath: soundPath,
      vibrationEnabled: vibrationEnabled,
      volume: volume,
      createdAt: DateTime.now(),
    );

    return await _repository.saveAlarm(alarm);
  }
}
