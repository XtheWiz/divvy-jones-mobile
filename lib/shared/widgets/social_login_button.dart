import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Social login button (Google, Facebook, Apple)
class SocialLoginButton extends StatelessWidget {
  final String? iconAsset;
  final String? iconUrl;
  final VoidCallback? onPressed;
  final double size;

  const SocialLoginButton({
    super.key,
    this.iconAsset,
    this.iconUrl,
    this.onPressed,
    this.size = 60,
  });

  /// Google login button factory
  factory SocialLoginButton.google({VoidCallback? onPressed}) {
    return SocialLoginButton(
      iconAsset: 'assets/icons/google.png',
      onPressed: onPressed,
    );
  }

  /// Facebook login button factory
  factory SocialLoginButton.facebook({VoidCallback? onPressed}) {
    return SocialLoginButton(
      iconAsset: 'assets/icons/facebook.png',
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(child: _buildIcon()),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (iconAsset != null) {
      return Image.asset(
        iconAsset!,
        width: 32,
        height: 32,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.error_outline,
            size: 24,
            color: AppColors.textHint,
          );
        },
      );
    } else if (iconUrl != null) {
      return Image.network(
        iconUrl!,
        width: 32,
        height: 32,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.error_outline,
            size: 24,
            color: AppColors.textHint,
          );
        },
      );
    }
    return const Icon(Icons.error_outline, size: 24, color: AppColors.textHint);
  }
}
