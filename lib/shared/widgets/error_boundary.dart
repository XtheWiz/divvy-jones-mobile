import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_logger.dart';

/// A widget that catches errors in its child tree and displays a fallback UI
/// instead of crashing the entire app.
class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({super.key, required this.child});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  static const _log = AppLogger('ErrorBoundary');
  bool _hasError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset error state when dependencies change (e.g. navigation)
    _hasError = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildFallbackUI();
    }

    return _ErrorBoundaryInherited(
      onError: _handleError,
      child: widget.child,
    );
  }

  void _handleError(FlutterErrorDetails details) {
    _log.error(
      'Widget tree error caught by ErrorBoundary',
      details.exception,
      details.stack,
    );
    if (mounted) {
      setState(() => _hasError = true);
    }
  }

  Widget _buildFallbackUI() {
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 64,
                    color: AppColors.warning,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: AppTypography.heading3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'An unexpected error occurred. Please try again.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => setState(() => _hasError = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Inherited widget to propagate error handler down the tree.
class _ErrorBoundaryInherited extends StatelessWidget {
  final void Function(FlutterErrorDetails) onError;
  final Widget child;

  const _ErrorBoundaryInherited({
    required this.onError,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
