import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';
import '../api_endpoints.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  final Dio _dio;
  bool _isRefreshing = false;

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
      if (_isRefreshing) {
        return handler.next(err);
      }

      _isRefreshing = true;

      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          _isRefreshing = false;
          // Retry the original request
          final token = await _storage.getAccessToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $token';

          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed, clear tokens
        await _storage.clearTokens();
      }

      _isRefreshing = false;
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': ''},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _storage.setAccessToken(data['access_token']);
        if (data['refresh_token'] != null) {
          await _storage.setRefreshToken(data['refresh_token']);
        }
        if (data['expires_in'] != null) {
          final expiry = DateTime.now().add(
            Duration(seconds: data['expires_in']),
          );
          await _storage.setTokenExpiry(expiry);
        }
        return true;
      }
    } catch (e) {
      // Refresh failed
    }

    return false;
  }

  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh');
  }
}
