/// App-wide configuration sourced from compile-time `--dart-define` values.
///
/// Usage:
///   flutter run --dart-define=API_BASE_URL=http://localhost:3000
///   flutter build apk --dart-define=API_BASE_URL=https://staging.example.com
///
/// Defaults to the production URL when no override is provided.
class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://divvy-jones-backend-production.up.railway.app',
  );

  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'production',
  );

  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
}
