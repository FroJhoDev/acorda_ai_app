import 'package:dartz/dartz.dart';
import '../entities/location_alarm.dart';
import '../../core/error/failures.dart';

/// Interface do repositório de alarmes
abstract class AlarmRepository {
  /// Salva um novo alarme
  Future<Either<Failure, String>> saveAlarm(LocationAlarm alarm);

  /// Atualiza um alarme existente
  Future<Either<Failure, void>> updateAlarm(LocationAlarm alarm);

  /// Remove um alarme pelo ID
  Future<Either<Failure, void>> deleteAlarm(String alarmId);

  /// Obtém todos os alarmes
  Future<Either<Failure, List<LocationAlarm>>> getAllAlarms();

  /// Obtém alarmes ativos
  Future<Either<Failure, List<LocationAlarm>>> getActiveAlarms();

  /// Obtém um alarme pelo ID
  Future<Either<Failure, LocationAlarm?>> getAlarmById(String alarmId);

  /// Ativa/desativa um alarme
  Future<Either<Failure, void>> toggleAlarm(String alarmId, bool isActive);
}
