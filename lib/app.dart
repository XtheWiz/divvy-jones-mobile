import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/auth_provider.dart';
import 'shared/widgets/error_boundary.dart';
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

/// Main App Widget
class DivvyJonesApp extends StatefulWidget {
  const DivvyJonesApp({super.key});

  @override
  State<DivvyJonesApp> createState() => _DivvyJonesAppState();
}

class _DivvyJonesAppState extends State<DivvyJonesApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = _createRouter();
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: context.read<AuthProvider>(),
      redirect: (context, state) {
        final authProvider = context.read<AuthProvider>();
        final isLoggedIn = authProvider.isLoggedIn;
        final isAuthRoute = state.matchedLocation == '/' ||
            state.matchedLocation == '/sign-up';

        // If user is logged in and trying to access auth routes, redirect to home
        if (isLoggedIn && isAuthRoute) {
          return '/home';
        }

        // If user is not logged in and trying to access protected routes
        if (!isLoggedIn && !isAuthRoute) {
          // Check if auth status is still being determined
          if (authProvider.status == AuthStatus.initial ||
              authProvider.status == AuthStatus.loading) {
            return null; // Don't redirect yet
          }
          return '/';
        }

        return null;
      },
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
  }

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: MaterialApp.router(
        title: 'Divvy Jones',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
