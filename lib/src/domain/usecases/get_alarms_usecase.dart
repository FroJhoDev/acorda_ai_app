import 'package:dartz/dartz.dart';
import '../repositories/alarm_repository.dart';
import '../entities/location_alarm.dart';
import '../../core/error/failures.dart';

/// Caso de uso para obter todos os alarmes
class GetAlarmsUseCase {
  final AlarmRepository _repository;

  GetAlarmsUseCase(this._repository);

  Future<Either<Failure, List<LocationAlarm>>> call() async {
    return await _repository.getAllAlarms();
  }
}

/// Caso de uso para obter alarmes ativos
class GetActiveAlarmsUseCase {
  final AlarmRepository _repository;

  GetActiveAlarmsUseCase(this._repository);

  Future<Either<Failure, List<LocationAlarm>>> call() async {
    return await _repository.getActiveAlarms();
  }
}
