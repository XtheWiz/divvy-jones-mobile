import 'dart:async';
import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';
import '../api_endpoints.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  final Dio _dio;
  Completer<bool>? _refreshCompleter;

  AuthInterceptor({
    required SecureStorage storage,
    required Dio dio,
  })  : _storage = storage,
        _dio = dio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for login and register
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isAuthEndpoint(err.requestOptions.path)) {
      final refreshed = await _serializedRefresh();
      if (refreshed) {
        // Retry the original request with the new token
        final token = await _storage.getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $token';

        try {
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (retryErr) {
          return handler.next(retryErr);
        }
      }
    }

    handler.next(err);
  }

  /// Ensures only one refresh happens at a time. Concurrent callers wait on
  /// the same Completer and all receive the same result.
  Future<bool> _serializedRefresh() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final result = await _refreshToken();
      _refreshCompleter!.complete(result);
      return result;
    } catch (e) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Authorization': ''},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Unwrap {success, data} wrapper if present
        final tokenData = data is Map<String, dynamic> && data['data'] != null
            ? data['data'] as Map<String, dynamic>
            : data as Map<String, dynamic>;

        // Handle nested tokens structure or flat structure
        final tokens = tokenData['tokens'] as Map<String, dynamic>? ?? tokenData;

        if (tokens['accessToken'] != null) {
          await _storage.setAccessToken(tokens['accessToken']);
        }
        if (tokens['refreshToken'] != null) {
          await _storage.setRefreshToken(tokens['refreshToken']);
        }
        if (tokens['expiresIn'] != null) {
          final expiry = DateTime.now().add(
            Duration(seconds: tokens['expiresIn']),
          );
          await _storage.setTokenExpiry(expiry);
        }
        return true;
      }
    } catch (e) {
      await _storage.clearTokens();
    }

    return false;
  }

  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh');
  }
}
