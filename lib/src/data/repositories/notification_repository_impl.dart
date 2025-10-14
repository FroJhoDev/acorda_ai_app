import 'package:dartz/dartz.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/notification_datasource.dart';

/// Implementação do repositório de notificações
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource _dataSource;

  NotificationRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      await _dataSource.initialize();
      return const Right(null);
    } on NotificationException catch (e) {
      return Left(NotificationFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(NotificationFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> showAlarmNotification({
    required String title,
    required String body,
    required String alarmId,
  }) async {
    try {
      await _dataSource.showAlarmNotification(
        title: title,
        body: body,
        alarmId: alarmId,
      );
      return const Right(null);
    } on NotificationException catch (e) {
      return Left(NotificationFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(NotificationFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelNotification(int notificationId) async {
    try {
      await _dataSource.cancelNotification(notificationId);
      return const Right(null);
    } on NotificationException catch (e) {
      return Left(NotificationFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(NotificationFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAllNotifications() async {
    try {
      await _dataSource.cancelAllNotifications();
      return const Right(null);
    } on NotificationException catch (e) {
      return Left(NotificationFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(NotificationFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasNotificationPermission() async {
    try {
      final hasPermission = await _dataSource.hasNotificationPermission();
      return Right(hasPermission);
    } on NotificationException catch (e) {
      return Left(NotificationFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(NotificationFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> requestNotificationPermission() async {
    try {
      final granted = await _dataSource.requestNotificationPermission();
      return Right(granted);
    } on NotificationException catch (e) {
      return Left(NotificationFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(NotificationFailure(message: 'Unexpected error: $e'));
    }
  }
}
