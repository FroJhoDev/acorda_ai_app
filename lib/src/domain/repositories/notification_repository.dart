import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

/// Interface do repositório de notificações
abstract class NotificationRepository {
  /// Inicializa o sistema de notificações
  Future<Either<Failure, void>> initialize();

  /// Mostra uma notificação de alarme
  Future<Either<Failure, void>> showAlarmNotification({
    required String title,
    required String body,
    required String alarmId,
  });

  /// Cancela uma notificação específica
  Future<Either<Failure, void>> cancelNotification(int notificationId);

  /// Cancela todas as notificações
  Future<Either<Failure, void>> cancelAllNotifications();

  /// Verifica se tem permissão para notificações
  Future<Either<Failure, bool>> hasNotificationPermission();

  /// Solicita permissão para notificações
  Future<Either<Failure, bool>> requestNotificationPermission();
}
