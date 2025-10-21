import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../domain/entities/location_alarm.dart';
import '../../../core/services/alarm_sound_service.dart';
import '../../../core/injections/dependency_injection_simple.dart';
import '../../../core/theme/app_colors.dart';

class AlarmActivePage extends StatefulWidget {
  final LocationAlarm alarm;

  const AlarmActivePage({
    super.key,
    required this.alarm,
  });

  @override
  State<AlarmActivePage> createState() => _AlarmActivePageState();
}

class _AlarmActivePageState extends State<AlarmActivePage>
    with TickerProviderStateMixin {
  late final AlarmSoundService _alarmSoundService;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  bool _alarmStopped = false;

  @override
  void initState() {
    super.initState();

    _alarmSoundService = sl<AlarmSoundService>();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    _pulseController.repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOut,
      ),
    );
    _rotationController.repeat(reverse: true);

    _playAlarm();
    _startVibration();
  }

  void _startVibration() {
    if (widget.alarm.vibrationEnabled) {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && !_alarmStopped) {
          _startVibration();
        }
      });
    }
  }

  Future<void> _playAlarm() async {
    try {
      await _alarmSoundService.startAlarm(
        enableSound: widget.alarm.soundPath.isNotEmpty,
        enableVibration: widget.alarm.vibrationEnabled,
      );
    } catch (e) {
      debugPrint('Erro ao tocar alarme: $e');
    }
  }

  Future<void> _stopAlarm() async {
    if (_alarmStopped) return;

    setState(() {
      _alarmStopped = true;
    });

    try {
      await _alarmSoundService.stopAlarm();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Erro ao parar alarme: $e');
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
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1E1E1E),
                const Color(0xFF0A0A0A),
                AppColors.error.withOpacity(0.3),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 0.2,
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.error.withOpacity(0.4),
                                    AppColors.error.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.error,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.error.withOpacity(0.5),
                                        blurRadius: 30,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.alarm,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    widget.alarm.title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Você chegou ao destino!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (widget.alarm.description.isNotEmpty) ...[
                        Text(
                          widget.alarm.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.alarm.soundPath.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.accent.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.volume_up,
                                    color: AppColors.accent,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Som',
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (widget.alarm.vibrationEnabled)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.accent.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.vibration,
                                    color: AppColors.accent,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Vibração',
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.98 + (_pulseAnimation.value - 0.95) * 0.2,
                        child: SizedBox(
                          width: double.infinity,
                          height: 70,
                          child: ElevatedButton(
                            onPressed: _alarmStopped ? null : _stopAlarm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.active,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  AppColors.active.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              elevation: 8,
                              shadowColor: AppColors.active.withOpacity(0.5),
                            ),
                            child: _alarmStopped
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.stop_circle, size: 32),
                                      SizedBox(width: 12),
                                      Text(
                                        'PARAR ALARME',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Toque para silenciar o alarme',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
