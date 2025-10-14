/// Classe base para todos os failures do domínio
abstract class Failure {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });
}

/// Failure para erros relacionados à localização
class LocationFailure extends Failure {
  const LocationFailure({
    required super.message,
    super.code,
  });
}

/// Failure para erros de permissão
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
  });
}

/// Failure para erros de banco de dados
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
  });
}

/// Failure para erros de notificação
class NotificationFailure extends Failure {
  const NotificationFailure({
    required super.message,
    super.code,
  });
}

/// Failure genérico do servidor/rede
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

/// Failure para erros de validação
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}
