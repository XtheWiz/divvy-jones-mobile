import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/sign_in_screen.dart';
import 'features/auth/screens/sign_up_screen.dart';
import 'features/home/screens/main_shell.dart';
import 'features/groups/screens/join_group_screen.dart';
import 'features/groups/screens/create_group_screen.dart';
import 'features/groups/screens/group_details_screen.dart';
import 'features/expense/screens/add_expense_screen.dart';

/// Custom page transition for smooth animations
CustomTransitionPage<void> _buildPageWithSlideTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

/// Fade transition for main navigation
CustomTransitionPage<void> _buildPageWithFadeTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}

/// App Router Configuration
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Auth Routes
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          _buildPageWithFadeTransition(context, state, const SignInScreen()),
    ),
    GoRoute(
      path: '/sign-up',
      pageBuilder: (context, state) =>
          _buildPageWithSlideTransition(context, state, const SignUpScreen()),
    ),
    // Main App Routes
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) =>
          _buildPageWithFadeTransition(context, state, const MainShell()),
    ),
    // Feature Routes
    GoRoute(
      path: '/join-group',
      pageBuilder: (context, state) => _buildPageWithSlideTransition(
        context,
        state,
        const JoinGroupScreen(),
      ),
    ),
    GoRoute(
      path: '/create-group',
      pageBuilder: (context, state) => _buildPageWithSlideTransition(
        context,
        state,
        const CreateGroupScreen(),
      ),
    ),
    GoRoute(
      path: '/group/:id',
      pageBuilder: (context, state) {
        final groupId = state.pathParameters['id'] ?? '';
        final groupName = state.uri.queryParameters['name'] ?? 'Group Details';
        return _buildPageWithSlideTransition(
          context,
          state,
          GroupDetailsScreen(groupId: groupId, groupName: groupName),
        );
      },
    ),
    GoRoute(
      path: '/add-expense',
      pageBuilder: (context, state) => _buildPageWithSlideTransition(
        context,
        state,
        const AddExpenseScreen(),
      ),
    ),
  ],
);

/// Main App Widget
class DivvyJonesApp extends StatelessWidget {
  const DivvyJonesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Divvy Jones',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
