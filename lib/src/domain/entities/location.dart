import 'dart:math';
import 'package:equatable/equatable.dart';

/// Entidade que representa uma coordenada geográfica
class Location extends Equatable {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final DateTime timestamp;

  const Location({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    required this.timestamp,
  });

  /// Calcula a distância em metros entre esta localização e outra
  double distanceTo(Location other) {
    const double earthRadius = 6371000; // Raio da Terra em metros

    double dLat = _degreesToRadians(other.latitude - latitude);
    double dLon = _degreesToRadians(other.longitude - longitude);

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_degreesToRadians(latitude)) *
            cos(_degreesToRadians(other.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2));

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  List<Object?> get props =>
      [latitude, longitude, altitude, accuracy, timestamp];
}
