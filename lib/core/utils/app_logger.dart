import 'dart:developer' as developer;
import '../constants/app_config.dart';

/// Lightweight structured logger.
///
/// Uses `dart:developer` log() which integrates with DevTools and is
/// automatically stripped from release builds by the tree-shaker,
/// unlike `print()`.
class AppLogger {
  final String _tag;

  const AppLogger(this._tag);

  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (!AppConfig.isProduction) {
      _log(message, level: 500, error: error, stackTrace: stackTrace);
    }
  }

  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log(message, level: 800, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log(message, level: 900, error: error, stackTrace: stackTrace);
  }

  void error(String message, [Object? err, StackTrace? stackTrace]) {
    _log(message, level: 1000, error: err, stackTrace: stackTrace);
  }

  void _log(
    String message, {
    required int level,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: _tag,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
