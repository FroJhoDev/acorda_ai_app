import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../domain/entities/location_alarm.dart';
import '../../../core/services/alarm_sound_service.dart';

/// Página exibida quando um alarme dispara
class AlarmActivePage extends StatefulWidget {
  final LocationAlarm alarm;
  final VoidCallback onStopAlarm;

  const AlarmActivePage({
    Key? key,
    required this.alarm,
    required this.onStopAlarm,
  }) : super(key: key);

  @override
  State<AlarmActivePage> createState() => _AlarmActivePageState();
}

class _AlarmActivePageState extends State<AlarmActivePage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  final AlarmSoundService _alarmSoundService = AlarmSoundService();
  bool _alarmStopped = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAlarm();
  }

  void _setupAnimations() {
    // Animação de pulsação
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Animação de rotação
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rotationController);

    // Iniciar animações em loop
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  Future<void> _startAlarm() async {
    try {
      await _alarmSoundService.startAlarm(
        enableSound: widget.alarm.soundPath.isNotEmpty,
        enableVibration: widget.alarm.vibrationEnabled,
      );

      // Vibração háptica adicional
      HapticFeedback.vibrate();
    } catch (e) {
      // Continue mesmo se houver erro no som/vibração
      debugPrint('Erro ao iniciar alarme: $e');
    }
  }

  Future<void> _stopAlarm() async {
    if (_alarmStopped) return;

    setState(() {
      _alarmStopped = true;
    });

    try {
      await _alarmSoundService.stopAlarm();
      HapticFeedback.lightImpact();

      // Chamar callback para notificar que o alarme foi parado
      widget.onStopAlarm();

      // Voltar para a tela anterior
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Erro ao parar alarme: $e');
      // Mesmo com erro, voltar para a tela anterior
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    if (!_alarmStopped) {
      _alarmSoundService.stopAlarm();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Impedir que o usuário saia sem parar o alarme
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.red[900],
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.red[900]!,
                  Colors.red[700]!,
                  Colors.orange[600]!,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Ícone de alarme animado
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 2.0 * 3.141592653589793,
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.alarm,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Título do alarme
                const Text(
                  '🚨 ALARME ATIVO! 🚨',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Informações do alarme
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Você chegou ao destino:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.alarm.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (widget.alarm.soundPath.isNotEmpty)
                            Row(
                              children: [
                                Icon(
                                  Icons.volume_up,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Som',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          if (widget.alarm.vibrationEnabled)
                            Row(
                              children: [
                                Icon(
                                  Icons.vibration,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Vibração',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Botão para parar o alarme
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.8 + (_pulseAnimation.value - 0.8) * 0.5,
                        child: Container(
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.green, Colors.lightGreen],
                            ),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(40),
                              onTap: _alarmStopped ? null : _stopAlarm,
                              child: Center(
                                child: _alarmStopped
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.stop,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'PARAR ALARME',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Instruções adicionais
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Toque no botão acima para parar o alarme',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
