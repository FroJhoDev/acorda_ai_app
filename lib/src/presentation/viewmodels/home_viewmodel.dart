import 'package:flutter/foundation.dart';
import '../../domain/entities/location_alarm.dart';
import '../../domain/entities/location.dart';
import '../../domain/usecases/get_alarms_usecase.dart';
import '../../domain/usecases/location_usecases.dart';
import '../../domain/usecases/monitor_alarms_usecase.dart';

/// ViewModel principal da tela inicial
class HomeViewModel extends ChangeNotifier {
  final GetAlarmsUseCase _getAlarmsUseCase;
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final MonitorAlarmsUseCase _monitorAlarmsUseCase;

  /// Callback para quando um alarme dispara (navega para página de alarme)
  Function(LocationAlarm alarm)? onAlarmTriggered;

  HomeViewModel({
    required GetAlarmsUseCase getAlarmsUseCase,
    required GetCurrentLocationUseCase getCurrentLocationUseCase,
    required MonitorAlarmsUseCase monitorAlarmsUseCase,
  })  : _getAlarmsUseCase = getAlarmsUseCase,
        _getCurrentLocationUseCase = getCurrentLocationUseCase,
        _monitorAlarmsUseCase = monitorAlarmsUseCase;

  /// Configura os callbacks (deve ser chamado antes de initialize)
  void setupCallbacks() {
    debugPrint('🔗 Configurando callback de alarme disparado no UseCase');
    _monitorAlarmsUseCase.onAlarmTriggered = (alarm) {
      debugPrint('📢 UseCase → ViewModel: Alarme disparado: ${alarm.title}');
      if (onAlarmTriggered != null) {
        debugPrint('📢 ViewModel → UI: Chamando callback da UI');
        onAlarmTriggered?.call(alarm);
      } else {
        debugPrint('⚠️ Callback onAlarmTriggered é null na UI!');
      }
    };
  }

  List<LocationAlarm> _alarms = [];
  Location? _currentLocation;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isMonitoring = false;

  // Getters
  List<LocationAlarm> get alarms => _alarms;
  Location? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isMonitoring => _isMonitoring;

  /// Inicializa o ViewModel
  Future<void> initialize() async {
    await loadAlarms();
    await getCurrentLocation();
    await startMonitoring();
  }

  /// Carrega todos os alarmes
  Future<void> loadAlarms() async {
    _setLoading(true);
    _clearError();

    final result = await _getAlarmsUseCase();

    result.fold(
      (failure) => _setError(failure.message),
      (alarms) {
        _alarms = alarms;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  /// Obtém a localização atual
  Future<void> getCurrentLocation() async {
    final result = await _getCurrentLocationUseCase();

    result.fold(
      (failure) => _setError(failure.message),
      (location) {
        _currentLocation = location;
        notifyListeners();
      },
    );
  }

  /// Inicia o monitoramento de alarmes
  Future<void> startMonitoring() async {
    if (_isMonitoring) return;

    final result = await _monitorAlarmsUseCase.startMonitoring();

    result.fold(
      (failure) => _setError(failure.message),
      (_) {
        _isMonitoring = true;
        notifyListeners();
      },
    );
  }

  /// Para o monitoramento (se necessário)
  void stopMonitoring() {
    _isMonitoring = false;
    notifyListeners();
  }

  /// Recarrega os dados
  Future<void> refresh() async {
    await loadAlarms();
    await getCurrentLocation();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}
