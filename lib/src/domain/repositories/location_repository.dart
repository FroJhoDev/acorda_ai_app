import 'package:dartz/dartz.dart';
import '../entities/location.dart';
import '../../core/error/failures.dart';

/// Interface do repositório de localização
abstract class LocationRepository {
  /// Obtém a localização atual do usuário
  Future<Either<Failure, Location>> getCurrentLocation();

  /// Inicia o monitoramento de localização em background
  Future<Either<Failure, void>> startLocationMonitoring();

  /// Para o monitoramento de localização
  Future<Either<Failure, void>> stopLocationMonitoring();

  /// Verifica se o serviço de localização está habilitado
  Future<Either<Failure, bool>> isLocationServiceEnabled();

  /// Verifica as permissões de localização
  Future<Either<Failure, bool>> hasLocationPermission();

  /// Solicita permissões de localização
  Future<Either<Failure, bool>> requestLocationPermission();

  /// Stream de atualizações de localização
  Stream<Either<Failure, Location>> get locationStream;
}
