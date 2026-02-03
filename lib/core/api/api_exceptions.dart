class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message})
      : super(
          message: message ?? 'Unauthorized. Please log in again.',
          statusCode: 401,
        );
}

class ForbiddenException extends ApiException {
  ForbiddenException({String? message})
      : super(
          message: message ?? 'Access forbidden.',
          statusCode: 403,
        );
}

class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(
          message: message ?? 'Resource not found.',
          statusCode: 404,
        );
}

class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;

  ValidationException({
    String? message,
    this.errors,
  }) : super(
          message: message ?? 'Validation failed.',
          statusCode: 422,
        );
}

class NetworkException extends ApiException {
  NetworkException({String? message})
      : super(
          message: message ?? 'Network error. Please check your connection.',
        );
}

class ServerException extends ApiException {
  ServerException({String? message, int? statusCode})
      : super(
          message: message ?? 'Server error. Please try again later.',
          statusCode: statusCode ?? 500,
        );
}
