import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/api/api_client.dart';
import 'core/storage/secure_storage.dart';
import 'core/services/auth_service.dart';
import 'core/services/group_service.dart';
import 'core/services/expense_service.dart';
import 'core/providers/providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
