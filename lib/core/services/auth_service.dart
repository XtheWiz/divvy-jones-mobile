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

  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      // Store tokens
      if (response['access_token'] != null) {
        await _storage.setAccessToken(response['access_token']);
      }
      if (response['refresh_token'] != null) {
        await _storage.setRefreshToken(response['refresh_token']);
      }
      if (response['expires_in'] != null) {
        final expiry = DateTime.now().add(
          Duration(seconds: response['expires_in']),
        );
        await _storage.setTokenExpiry(expiry);
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
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      // Store tokens
      if (response['access_token'] != null) {
        await _storage.setAccessToken(response['access_token']);
      }
      if (response['refresh_token'] != null) {
        await _storage.setRefreshToken(response['refresh_token']);
      }
      if (response['expires_in'] != null) {
        final expiry = DateTime.now().add(
          Duration(seconds: response['expires_in']),
        );
        await _storage.setTokenExpiry(expiry);
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
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.me,
      );

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
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
      );

      if (response['access_token'] != null) {
        await _storage.setAccessToken(response['access_token']);
      }
      if (response['refresh_token'] != null) {
        await _storage.setRefreshToken(response['refresh_token']);
      }
      if (response['expires_in'] != null) {
        final expiry = DateTime.now().add(
          Duration(seconds: response['expires_in']),
        );
        await _storage.setTokenExpiry(expiry);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
