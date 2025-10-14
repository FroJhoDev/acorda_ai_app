import 'package:flutter/foundation.dart';
import '../../domain/usecases/create_alarm_usecase.dart';

/// ViewModel para o formulário de criação de alarmes
class AlarmFormViewModel extends ChangeNotifier {
  final CreateAlarmUseCase _createAlarmUseCase;

  AlarmFormViewModel({
    required CreateAlarmUseCase createAlarmUseCase,
  }) : _createAlarmUseCase = createAlarmUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  // Form data
  String _title = '';
  String _description = '';
  double? _latitude;
  double? _longitude;
  double _radius = 100.0;
  String _soundPath = '';
  bool _vibrationEnabled = true;
  int _volume = 100;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  String get title => _title;
  String get description => _description;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  double get radius => _radius;
  String get soundPath => _soundPath;
  bool get vibrationEnabled => _vibrationEnabled;
  int get volume => _volume;

  /// Valida se o formulário está completo
  bool get isFormValid {
    return _title.isNotEmpty &&
        _description.isNotEmpty &&
        _latitude != null &&
        _longitude != null &&
        _radius > 0;
  }

  /// Define o título do alarme
  void setTitle(String title) {
    _title = title;
    _clearMessages();
    notifyListeners();
  }

  /// Define a descrição do alarme
  void setDescription(String description) {
    _description = description;
    _clearMessages();
    notifyListeners();
  }

  /// Define a localização do alarme
  void setLocation(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
    _clearMessages();
    notifyListeners();
  }

  /// Define o raio do alarme
  void setRadius(double radius) {
    _radius = radius;
    _clearMessages();
    notifyListeners();
  }

  /// Define o caminho do som
  void setSoundPath(String soundPath) {
    _soundPath = soundPath;
    notifyListeners();
  }

  /// Define se a vibração está habilitada
  void setVibrationEnabled(bool enabled) {
    _vibrationEnabled = enabled;
    notifyListeners();
  }

  /// Define o volume
  void setVolume(int volume) {
    _volume = volume.clamp(0, 100);
    notifyListeners();
  }

  /// Cria o alarme
  Future<void> createAlarm() async {
    if (!isFormValid) {
      _setError('Por favor, preencha todos os campos obrigatórios');
      return;
    }

    _setLoading(true);
    _clearMessages();

    final result = await _createAlarmUseCase(
      title: _title,
      description: _description,
      latitude: _latitude!,
      longitude: _longitude!,
      radius: _radius,
      soundPath: _soundPath,
      vibrationEnabled: _vibrationEnabled,
      volume: _volume,
    );

    result.fold(
      (failure) => _setError(failure.message),
      (alarmId) {
        _isSuccess = true;
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  /// Reseta o formulário
  void resetForm() {
    _title = '';
    _description = '';
    _latitude = null;
    _longitude = null;
    _radius = 100.0;
    _soundPath = '';
    _vibrationEnabled = true;
    _volume = 100;
    _clearMessages();
    _isSuccess = false;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _isSuccess = false;
  }
}
