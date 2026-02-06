import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../api/response_unwrapper.dart';
import '../models/models.dart';
import '../storage/secure_storage.dart';
import '../utils/app_logger.dart';

class AuthService {
  static const _log = AppLogger('AuthService');
  final ApiClient _apiClient;
  final SecureStorage _storage;

  AuthService({
    required ApiClient apiClient,
    required SecureStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  Future<User> login(String email, String password) async {
    try {
      final rawResponse = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final response = ResponseUnwrapper.unwrapMap(rawResponse);
      await _storeTokens(response);

      // Return user
      if (response['user'] != null) {
        return User.fromJson(response['user']);
      }

      // If user is not in response, fetch it
      return await getCurrentUser();
    } catch (e, st) {
      _log.error('Login failed for $email', e, st);
      rethrow;
    }
  }

  Future<User> register(String email, String password, String name) async {
    try {
      final rawResponse = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'displayName': name,
        },
      );

      final response = ResponseUnwrapper.unwrapMap(rawResponse);
      await _storeTokens(response);

      // Return user
      if (response['user'] != null) {
        return User.fromJson(response['user']);
      }

      // If user is not in response, fetch it
      return await getCurrentUser();
    } catch (e, st) {
      _log.error('Registration failed for $email', e, st);
      rethrow;
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final rawResponse = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.me,
      );

      final response = ResponseUnwrapper.unwrapMap(rawResponse);

      if (response['user'] != null) {
        return User.fromJson(response['user']);
      }

      return User.fromJson(response);
    } catch (e, st) {
      _log.error('Failed to fetch current user', e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.clearTokens();
  }

  Future<bool> isLoggedIn() async {
    final hasTokens = await _storage.hasTokens();
    if (!hasTokens) return false;

    final isExpired = await _storage.isTokenExpired();
    return !isExpired;
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final rawResponse = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
      );

      final response = ResponseUnwrapper.unwrapMap(rawResponse);
      final tokens = response['tokens'] as Map<String, dynamic>? ?? response;

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
    } catch (e, st) {
      _log.error('Token refresh failed', e, st);
      return false;
    }
  }

  /// Extracts and stores tokens from a login/register response.
  Future<void> _storeTokens(Map<String, dynamic> response) async {
    final tokens = response['tokens'] as Map<String, dynamic>?;
    if (tokens == null) return;

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
  }
}
