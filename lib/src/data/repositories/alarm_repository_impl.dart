import 'package:dartz/dartz.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../../domain/entities/location_alarm.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/memory_alarm_datasource.dart';

/// Implementação do repositório de alarmes usando memória (versão simplificada)
class AlarmRepositoryImpl implements AlarmRepository {
  final MemoryAlarmDataSource _dataSource;

  AlarmRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, String>> saveAlarm(LocationAlarm alarm) async {
    try {
      final id = await _dataSource.saveAlarm(alarm);
      return Right(id);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAlarm(LocationAlarm alarm) async {
    try {
      await _dataSource.updateAlarm(alarm);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAlarm(String alarmId) async {
    try {
      await _dataSource.deleteAlarm(alarmId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<LocationAlarm>>> getAllAlarms() async {
    try {
      final alarms = await _dataSource.getAllAlarms();
      return Right(alarms);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<LocationAlarm>>> getActiveAlarms() async {
    try {
      final alarms = await _dataSource.getActiveAlarms();
      return Right(alarms);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, LocationAlarm?>> getAlarmById(String alarmId) async {
    try {
      final alarm = await _dataSource.getAlarmById(alarmId);
      return Right(alarm);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleAlarm(
      String alarmId, bool isActive) async {
    try {
      final alarm = await _dataSource.getAlarmById(alarmId);
      if (alarm == null) {
        return const Left(DatabaseFailure(message: 'Alarm not found'));
      }

      final updatedAlarm = alarm.copyWith(isActive: isActive);
      await _dataSource.updateAlarm(updatedAlarm);

      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: $e'));
    }
  }
}
