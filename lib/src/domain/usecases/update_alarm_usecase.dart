import 'package:dartz/dartz.dart';
import '../entities/location_alarm.dart';
import '../repositories/alarm_repository.dart';
import '../../core/error/failures.dart';

/// Caso de uso para atualizar um alarme existente
class UpdateAlarmUseCase {
  final AlarmRepository _repository;

  UpdateAlarmUseCase(this._repository);

  Future<Either<Failure, void>> call(LocationAlarm alarm) async {
    try {
      return await _repository.updateAlarm(alarm);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Erro ao atualizar alarme: $e'));
    }
  }
}
