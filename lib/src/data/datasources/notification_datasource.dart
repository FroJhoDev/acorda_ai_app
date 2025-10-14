import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/error/exceptions.dart';

/// DataSource para notificações
class NotificationDataSource {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  bool _isInitialized = false;

  NotificationDataSource(this._notificationsPlugin);

  /// Inicializa o sistema de notificações
  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final result = await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    if (result != true) {
      throw const NotificationException(
          message: 'Failed to initialize notifications');
    }

    _isInitialized = true;
  }

  /// Mostra uma notificação de alarme
  Future<void> showAlarmNotification({
    required String title,
    required String body,
    required String alarmId,
  }) async {
    await _ensureInitialized();

    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Location Alarms',
      channelDescription: 'Notifications for location-based alarms',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notificationId = alarmId.hashCode;

    await _notificationsPlugin.show(
      notificationId,
      title,
      body,
      details,
      payload: alarmId,
    );

    // Vibração será tratada pelo próprio sistema de notificações
    // quando enableVibration: true está configurado
  }

  /// Cancela uma notificação específica
  Future<void> cancelNotification(int notificationId) async {
    await _ensureInitialized();
    await _notificationsPlugin.cancel(notificationId);
  }

  /// Cancela todas as notificações
  Future<void> cancelAllNotifications() async {
    await _ensureInitialized();
    await _notificationsPlugin.cancelAll();
  }

  /// Verifica se tem permissão para notificações
  Future<bool> hasNotificationPermission() async {
    await _ensureInitialized();

    final result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();

    return result ?? true; // iOS geralmente permite por padrão
  }

  /// Solicita permissão para notificações
  Future<bool> requestNotificationPermission() async {
    await _ensureInitialized();

    final result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    return result ?? true; // iOS geralmente permite por padrão
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Aqui poderia abrir a tela do alarme específico
    debugPrint('Notification tapped: ${response.payload}');
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}
