import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/entities/location.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/location_datasource.dart';

/// Implementação do repositório de localização
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _dataSource;
  StreamController<Either<Failure, Location>>? _locationController;

  LocationRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Location>> getCurrentLocation() async {
    try {
      final location = await _dataSource.getCurrentLocation();
      return Right(location);
    } on LocationException catch (e) {
      return Left(LocationFailure(message: e.message, code: e.code));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(LocationFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> startLocationMonitoring() async {
    try {
      _locationController ??=
          StreamController<Either<Failure, Location>>.broadcast();

      final locationStream = _dataSource.startLocationMonitoring();

      locationStream.listen(
        (location) {
          _locationController?.add(Right(location));
        },
        onError: (error) {
          if (error is LocationException) {
            _locationController?.add(Left(
                LocationFailure(message: error.message, code: error.code)));
          } else {
            _locationController?.add(Left(
                LocationFailure(message: 'Unexpected location error: $error')));
          }
        },
      );

      return const Right(null);
    } catch (e) {
      return Left(
          LocationFailure(message: 'Failed to start location monitoring: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> stopLocationMonitoring() async {
    try {
      await _dataSource.stopLocationMonitoring();
      await _locationController?.close();
      _locationController = null;
      return const Right(null);
    } catch (e) {
      return Left(
          LocationFailure(message: 'Failed to stop location monitoring: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLocationServiceEnabled() async {
    try {
      final isEnabled = await _dataSource.isLocationServiceEnabled();
      return Right(isEnabled);
    } catch (e) {
      return Left(
          LocationFailure(message: 'Failed to check location service: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasLocationPermission() async {
    try {
      final hasPermission = await _dataSource.hasLocationPermission();
      return Right(hasPermission);
    } catch (e) {
      return Left(PermissionFailure(
          message: 'Failed to check location permission: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      final granted = await _dataSource.requestLocationPermission();
      return Right(granted);
    } catch (e) {
      return Left(PermissionFailure(
          message: 'Failed to request location permission: $e'));
    }
  }

  @override
  Stream<Either<Failure, Location>> get locationStream {
    return _locationController?.stream ?? const Stream.empty();
  }
}
