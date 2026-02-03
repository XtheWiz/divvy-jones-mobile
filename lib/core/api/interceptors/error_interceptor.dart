import 'dart:io';
import 'package:dio/dio.dart';
import '../api_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapException(err);
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }

  ApiException _mapException(DioException err) {
    // Network errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return NetworkException(message: 'Connection timed out. Please try again.');
    }

    if (err.type == DioExceptionType.connectionError ||
        err.error is SocketException) {
      return NetworkException();
    }

    // HTTP errors
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    String? message;

    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? data['error'] as String?;
    }

    switch (statusCode) {
      case 400:
        return ApiException(
          message: message ?? 'Bad request.',
          statusCode: 400,
          data: data,
        );
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 422:
        Map<String, List<String>>? errors;
        if (data is Map<String, dynamic> && data['errors'] != null) {
          errors = (data['errors'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
              key,
              (value as List).cast<String>(),
            ),
          );
        }
        return ValidationException(message: message, errors: errors);
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(message: message, statusCode: statusCode);
      default:
        return ApiException(
          message: message ?? 'An unexpected error occurred.',
          statusCode: statusCode,
          data: data,
        );
    }
  }
}
