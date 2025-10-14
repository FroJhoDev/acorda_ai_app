import 'package:dartz/dartz.dart';
import '../repositories/location_repository.dart';
import '../entities/location.dart';
import '../../core/error/failures.dart';

/// Caso de uso para obter a localização atual
class GetCurrentLocationUseCase {
  final LocationRepository _repository;

  GetCurrentLocationUseCase(this._repository);

  Future<Either<Failure, Location>> call() async {
    return await _repository.getCurrentLocation();
  }
}

/// Caso de uso para iniciar monitoramento de localização
class StartLocationMonitoringUseCase {
  final LocationRepository _repository;

  StartLocationMonitoringUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.startLocationMonitoring();
  }
}

/// Caso de uso para parar monitoramento de localização
class StopLocationMonitoringUseCase {
  final LocationRepository _repository;

  StopLocationMonitoringUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.stopLocationMonitoring();
  }
}
