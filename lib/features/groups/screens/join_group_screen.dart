import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_title_bar.dart';

/// Join Group Screen with QR Code
class JoinGroupScreen extends StatelessWidget {
  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Title Bar
              AppTitleBar(
                title: 'Join a Group',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // QR Code Scanner Area
                      _buildQRScannerArea(),
                      const SizedBox(height: 32),
                      // Instructions
                      Text(
                        'Scan the QR code to join',
                        style: AppTypography.heading3,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Ask your crew member to show their group QR code and scan it to join instantly',
                        style: AppTypography.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.border)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('OR', style: AppTypography.caption),
                          ),
                          Expanded(child: Divider(color: AppColors.border)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Enter Code Manually
                      _buildCodeInput(),
                      const SizedBox(height: 24),
                      // Join Button
                      AppButton(
                        text: 'Join Group',
                        onPressed: () {
                          // TODO: Handle join group
                        },
                        width: double.infinity,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRScannerArea() {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // QR Scanner Placeholder
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: 80,
                color: Colors.white.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Camera Preview',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          // Corner Decorations
          Positioned(top: 40, left: 40, child: _buildCorner(true, true)),
          Positioned(top: 40, right: 40, child: _buildCorner(true, false)),
          Positioned(bottom: 40, left: 40, child: _buildCorner(false, true)),
          Positioned(bottom: 40, right: 40, child: _buildCorner(false, false)),
        ],
      ),
    );
  }

  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: AppColors.primaryLight, width: 3)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppColors.primaryLight, width: 3)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: AppColors.primaryLight, width: 3)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppColors.primaryLight, width: 3)
              : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCodeInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.tag, color: AppColors.textHint, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter group code',
                hintStyle: AppTypography.inputHint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTypography.input,
            ),
          ),
        ],
      ),
    );
  }
}
