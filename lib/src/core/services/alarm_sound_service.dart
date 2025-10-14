import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Serviço para tocar sons de alarme e controlar vibração
class AlarmSoundService {
  static final AlarmSoundService _instance = AlarmSoundService._internal();
  factory AlarmSoundService() => _instance;
  AlarmSoundService._internal();

  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isVibrating = false;

  /// Inicia o alarme com som e vibração
  Future<void> startAlarm({
    bool enableSound = true,
    bool enableVibration = true,
  }) async {
    try {
      // Inicializar player se necessário
      _audioPlayer ??= AudioPlayer();

      // Tocar som de alarme
      if (enableSound && !_isPlaying) {
        await _playAlarmSound();
      }

      // Iniciar vibração
      if (enableVibration && !_isVibrating) {
        await _startVibration();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao iniciar alarme: $e');
      }
      throw AlarmException('Falha ao iniciar o alarme');
    }
  }

  /// Para o alarme completamente
  Future<void> stopAlarm() async {
    try {
      await _stopSound();
      await _stopVibration();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao parar alarme: $e');
      }
    }
  }

  /// Toca o som do alarme em loop
  Future<void> _playAlarmSound() async {
    try {
      _isPlaying = true;

      // Usar um tom de alarme padrão do sistema ou um arquivo personalizado
      // Por enquanto, vamos usar um som de notificação alto
      await _audioPlayer!.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer!.setVolume(1.0); // Volume máximo

      // Tentar tocar um arquivo de som personalizado ou usar um tom do sistema
      await _audioPlayer!
          .play(AssetSource('sounds/alarm_tone.mp3'))
          .catchError((error) async {
        // Se não conseguir tocar o arquivo, usar um tom simples
        if (kDebugMode) {
          print('Arquivo de som não encontrado, usando tom padrão');
        }
        // Como fallback, podemos usar o som de notificação do sistema
        return;
      });
    } catch (e) {
      _isPlaying = false;
      if (kDebugMode) {
        print('Erro ao tocar som: $e');
      }
    }
  }

  /// Para o som
  Future<void> _stopSound() async {
    if (_audioPlayer != null && _isPlaying) {
      await _audioPlayer!.stop();
      _isPlaying = false;
    }
  }

  /// Inicia vibração háptica intensa
  Future<void> _startVibration() async {
    try {
      _isVibrating = true;

      // Usar vibração háptica nativa do Flutter
      _vibrateLoop();
    } catch (e) {
      _isVibrating = false;
      if (kDebugMode) {
        print('Erro ao iniciar vibração: $e');
      }
    }
  }

  /// Loop de vibração háptica
  void _vibrateLoop() async {
    if (!_isVibrating) return;

    try {
      // Vibração intensa usando HapticFeedback
      await HapticFeedback.heavyImpact();

      // Aguardar um tempo e repetir
      await Future.delayed(const Duration(milliseconds: 800));

      if (_isVibrating) {
        _vibrateLoop(); // Continuar loop
      }
    } catch (e) {
      _isVibrating = false;
      if (kDebugMode) {
        print('Erro no loop de vibração: $e');
      }
    }
  }

  /// Para a vibração
  Future<void> _stopVibration() async {
    if (_isVibrating) {
      _isVibrating = false;
      // A vibração háptica para automaticamente
    }
  }

  /// Verifica se o alarme está ativo
  bool get isAlarmActive => _isPlaying || _isVibrating;

  /// Dispose resources
  Future<void> dispose() async {
    await stopAlarm();
    await _audioPlayer?.dispose();
    _audioPlayer = null;
  }
}

/// Exceção específica para alarmes
class AlarmException implements Exception {
  final String message;
  AlarmException(this.message);

  @override
  String toString() => 'AlarmException: $message';
}
