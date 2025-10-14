import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/location.dart';
import '../../core/error/exceptions.dart';

/// DataSource para localização usando Geolocator
class LocationDataSource {
  StreamController<Location>? _locationController;
  StreamSubscription<Position>? _positionSubscription;

  /// Obtém a localização atual
  Future<Location> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const LocationException(
            message: 'Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const LocationException(
              message: 'Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const LocationException(
            message: 'Location permissions are permanently denied');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return Location(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
      );
    } catch (e) {
      if (e is LocationException) rethrow;
      throw LocationException(message: 'Failed to get current location: $e');
    }
  }

  /// Inicia o monitoramento de localização
  Stream<Location> startLocationMonitoring() {
    _locationController ??= StreamController<Location>.broadcast();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Apenas atualiza se mover 10 metros
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        final location = Location(
          latitude: position.latitude,
          longitude: position.longitude,
          altitude: position.altitude,
          accuracy: position.accuracy,
          timestamp: position.timestamp,
        );

        _locationController?.add(location);
      },
      onError: (error) {
        _locationController?.addError(
          LocationException(message: 'Location monitoring error: $error'),
        );
      },
    );

    return _locationController!.stream;
  }

  /// Para o monitoramento de localização
  Future<void> stopLocationMonitoring() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    await _locationController?.close();
    _locationController = null;
  }

  /// Verifica se o serviço de localização está habilitado
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Verifica as permissões de localização
  Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Solicita permissões de localização
  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}
