import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../models/models.dart';
import '../storage/secure_storage.dart';

class AuthService {
  final ApiClient _apiClient;
  final SecureStorage _storage;

  AuthService({
    required ApiClient apiClient,
    required SecureStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  /// Unwrap the backend response which has format: {success: bool, data: {...}}
  Map<String, dynamic> _unwrapResponse(Map<String, dynamic> response) {
    if (response['data'] != null) {
      return response['data'] as Map<String, dynamic>;
    }
    return response;
  }

  Future<User> login(String email, String password) async {
    try {
      final rawResponse = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final response = _unwrapResponse(rawResponse);

      // Store tokens from nested tokens object
      final tokens = response['tokens'] as Map<String, dynamic>?;
      if (tokens != null) {
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

      // Return user
      if (response['user'] != null) {
        return User.fromJson(response['user']);
      }

      // If user is not in response, fetch it
      return await getCurrentUser();
    } catch (e) {
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

      final response = _unwrapResponse(rawResponse);

      // Store tokens from nested tokens object
      final tokens = response['tokens'] as Map<String, dynamic>?;
      if (tokens != null) {
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

      // Return user
      if (response['user'] != null) {
        return User.fromJson(response['user']);
      }

      // If user is not in response, fetch it
      return await getCurrentUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final rawResponse = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.me,
      );

      final response = _unwrapResponse(rawResponse);

      if (response['user'] != null) {
        return User.fromJson(response['user']);
      }

      return User.fromJson(response);
    } catch (e) {
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

      final response = _unwrapResponse(rawResponse);

      // Handle nested tokens structure
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
    } catch (e) {
      return false;
    }
  }
}
