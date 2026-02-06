import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../api/api_exceptions.dart';
import '../utils/app_logger.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  static const _log = AppLogger('AuthProvider');
  final AuthService _authService;

  AuthProvider({required AuthService authService}) : _authService = authService;

  User? _currentUser;
  AuthStatus _status = AuthStatus.initial;
  String? _error;

  User? get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get error => _error;
  bool get isLoggedIn => _status == AuthStatus.authenticated && _currentUser != null;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await _authService.getCurrentUser();
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e, st) {
      _log.warning('Auth status check failed, treating as unauthenticated', e, st);
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.login(email, password);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred. Please try again.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.register(email, password, name);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred. Please try again.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();

    await _authService.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    _error = null;

    notifyListeners();
  }

  Future<void> refreshUser() async {
    if (_status != AuthStatus.authenticated) return;

    try {
      _currentUser = await _authService.getCurrentUser();
      notifyListeners();
    } catch (e, st) {
      _log.warning('Failed to refresh user profile, data may be stale', e, st);
    }
  }

  void clearError() {
    _error = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}
