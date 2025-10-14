import 'package:equatable/equatable.dart';

/// Entidade que representa um alarme baseado em localização
class LocationAlarm extends Equatable {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final double radius; // Em metros
  final bool isActive;
  final bool isTriggered;
  final String soundPath;
  final bool vibrationEnabled;
  final int volume;
  final DateTime createdAt;
  final DateTime? triggeredAt;

  const LocationAlarm({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.radius = 100.0,
    this.isActive = true,
    this.isTriggered = false,
    this.soundPath = '',
    this.vibrationEnabled = true,
    this.volume = 100,
    required this.createdAt,
    this.triggeredAt,
  });

  LocationAlarm copyWith({
    String? id,
    String? title,
    String? description,
    double? latitude,
    double? longitude,
    double? radius,
    bool? isActive,
    bool? isTriggered,
    String? soundPath,
    bool? vibrationEnabled,
    int? volume,
    DateTime? createdAt,
    DateTime? triggeredAt,
  }) {
    return LocationAlarm(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      isActive: isActive ?? this.isActive,
      isTriggered: isTriggered ?? this.isTriggered,
      soundPath: soundPath ?? this.soundPath,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      volume: volume ?? this.volume,
      createdAt: createdAt ?? this.createdAt,
      triggeredAt: triggeredAt ?? this.triggeredAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        latitude,
        longitude,
        radius,
        isActive,
        isTriggered,
        soundPath,
        vibrationEnabled,
        volume,
        createdAt,
        triggeredAt,
      ];
}
