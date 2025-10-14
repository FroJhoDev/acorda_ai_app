import 'package:get_it/get_it.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Data
import '../../data/datasources/memory_alarm_datasource.dart';
import '../../data/datasources/location_datasource.dart';
import '../../data/datasources/notification_datasource.dart';
import '../../data/repositories/memory_alarm_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';

// Domain
import '../../domain/repositories/alarm_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/create_alarm_usecase.dart';
import '../../domain/usecases/get_alarms_usecase.dart';
import '../../domain/usecases/location_usecases.dart';
import '../../domain/usecases/monitor_alarms_usecase.dart';
import '../../domain/usecases/update_alarm_usecase.dart';

// Services
import '../services/alarm_sound_service.dart';

// Presentation
import '../../presentation/viewmodels/home_viewmodel.dart';
import '../../presentation/viewmodels/alarm_form_viewmodel.dart';
import '../../presentation/viewmodels/alarm_active_viewmodel.dart';

final GetIt sl = GetIt.instance;

/// Configura todas as injeções de dependência (versão simplificada)
Future<void> setupDependencyInjection() async {
  // External dependencies
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  // Data sources
  sl.registerLazySingleton(() => MemoryAlarmDataSource());
  sl.registerLazySingleton(() => LocationDataSource());
  sl.registerLazySingleton(
      () => NotificationDataSource(sl<FlutterLocalNotificationsPlugin>()));

  // Repositories
  sl.registerLazySingleton<AlarmRepository>(
      () => MemoryAlarmRepositoryImpl(sl()));
  sl.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(sl()));
  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl()));

  // Services
  sl.registerLazySingleton(() => AlarmSoundService());

  // Use cases
  sl.registerLazySingleton(() => CreateAlarmUseCase(sl()));
  sl.registerLazySingleton(() => GetAlarmsUseCase(sl()));
  sl.registerLazySingleton(() => GetActiveAlarmsUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentLocationUseCase(sl()));
  sl.registerLazySingleton(() => StartLocationMonitoringUseCase(sl()));
  sl.registerLazySingleton(() => StopLocationMonitoringUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAlarmUseCase(sl()));
  sl.registerLazySingleton(() => MonitorAlarmsUseCase(sl(), sl(), sl()));

  // ViewModels
  sl.registerFactory(() => HomeViewModel(
        getAlarmsUseCase: sl(),
        getCurrentLocationUseCase: sl(),
        monitorAlarmsUseCase: sl(),
      ));

  sl.registerFactory(() => AlarmFormViewModel(
        createAlarmUseCase: sl(),
      ));

  sl.registerFactory(() => AlarmActiveViewModel(sl()));

  // Initialize notification system
  await sl<NotificationRepository>().initialize();
}
