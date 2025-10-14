/// Exceções customizadas para o domínio
class LocationException implements Exception {
  final String message;
  final String? code;

  const LocationException({
    required this.message,
    this.code,
  });

  @override
  String toString() =>
      'LocationException: $message${code != null ? ' (Code: $code)' : ''}';
}

class PermissionException implements Exception {
  final String message;
  final String? code;

  const PermissionException({
    required this.message,
    this.code,
  });

  @override
  String toString() =>
      'PermissionException: $message${code != null ? ' (Code: $code)' : ''}';
}

class DatabaseException implements Exception {
  final String message;
  final String? code;

  const DatabaseException({
    required this.message,
    this.code,
  });

  @override
  String toString() =>
      'DatabaseException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NotificationException implements Exception {
  final String message;
  final String? code;

  const NotificationException({
    required this.message,
    this.code,
  });

  @override
  String toString() =>
      'NotificationException: $message${code != null ? ' (Code: $code)' : ''}';
}
