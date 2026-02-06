import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/api/api_client.dart';
import 'core/storage/secure_storage.dart';
import 'core/services/auth_service.dart';
import 'core/services/group_service.dart';
import 'core/services/expense_service.dart';
import 'core/providers/providers.dart';
import 'core/utils/app_logger.dart';
import 'shared/widgets/error_boundary.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const log = AppLogger('Main');

  // Catch Flutter framework errors (widget build, layout, painting)
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log.error(
      'Flutter framework error: ${details.exceptionAsString()}',
      details.exception,
      details.stack,
    );
    // Signal the ErrorBoundary to show fallback UI
    fatalErrorNotifier.value = true;
  };

  // Catch unhandled async errors and platform errors
  PlatformDispatcher.instance.onError = (error, stack) {
    log.error('Unhandled platform error', error, stack);
    return true;
  };

  // Initialize core dependencies
  final secureStorage = SecureStorage();
  final apiClient = ApiClient(storage: secureStorage);

  // Initialize services
  final authService = AuthService(
    apiClient: apiClient,
    storage: secureStorage,
  );
  final groupService = GroupService(apiClient: apiClient);
  final expenseService = ExpenseService(apiClient: apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService),
        ),
        ChangeNotifierProvider(
          create: (_) => GroupsProvider(groupService: groupService),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(expenseService: expenseService),
        ),
      ],
      child: const DivvyJonesApp(),
    ),
  );
}
