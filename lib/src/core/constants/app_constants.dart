/// Constantes numéricas e de configuração do aplicativo
class AppConstants {
  // Default values
  static const double defaultAlarmRadius = 100.0; // metros
  static const int defaultVolume = 100; // 0-100
  static const bool defaultVibrationEnabled = true;

  // Map settings
  static const double defaultMapZoom = 15.0;
  static const double maxMapZoom = 20.0;
  static const double minMapZoom = 5.0;

  // Location settings
  static const int locationUpdateInterval = 10; // segundos
  static const double minimumDistanceForUpdate = 10.0; // metros
  static const int locationTimeoutSeconds = 10;

  // Notification settings
  static const String notificationChannelId = 'alarm_channel';
  static const String notificationChannelName = 'Location Alarms';
  static const String notificationChannelDescription =
      'Notifications for location-based alarms';

  // Alarm settings
  static const double minAlarmRadius = 10.0; // metros
  static const double maxAlarmRadius = 1000.0; // metros
  static const int maxActiveAlarms = 10;

  // UI settings
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;

  // Animation durations
  static const int shortAnimationDuration = 200; // milliseconds
  static const int mediumAnimationDuration = 300; // milliseconds
  static const int longAnimationDuration = 500; // milliseconds

  // Database settings
  static const String databaseName = 'acorda_ai_db';
  static const int databaseVersion = 1;

  // Vibration patterns (in milliseconds)
  static const List<int> alarmVibrationPattern = [
    0,
    1000,
    500,
    1000,
    500,
    1000
  ];
  static const List<int> shortVibrationPattern = [0, 200];
  static const List<int> longVibrationPattern = [0, 500];

  // Background task settings
  static const String locationTaskName = 'locationMonitoringTask';
  static const String alarmCheckTaskName = 'alarmCheckTask';

  // Permission request codes (if needed for native integrations)
  static const int locationPermissionRequestCode = 1001;
  static const int notificationPermissionRequestCode = 1002;
}
