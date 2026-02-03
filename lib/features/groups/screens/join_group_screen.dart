import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/groups_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_title_bar.dart';

/// Join Group Screen with QR Code
class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleJoinGroup() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a group code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final groupsProvider = context.read<GroupsProvider>();
    final group = await groupsProvider.joinGroup(code);

    if (mounted) {
      setState(() => _isLoading = false);

      if (group != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joined "${group.name}"!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else {
        setState(() {
          _errorMessage = groupsProvider.error ?? 'Invalid group code. Please try again.';
        });
      }
    }
  }

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
                      _buildQRScannerArea(),
                      const SizedBox(height: 32),
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
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 16,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      _buildCodeInput(),
                      const SizedBox(height: 24),
                      AppButton(
                        text: 'Join Group',
                        onPressed: _isLoading ? null : _handleJoinGroup,
                        isLoading: _isLoading,
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
              const SizedBox(height: 8),
              Text(
                'Coming soon',
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
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
              controller: _codeController,
              decoration: InputDecoration(
                hintText: 'Enter group code',
                hintStyle: AppTypography.inputHint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTypography.input,
              textCapitalization: TextCapitalization.characters,
              onSubmitted: (_) => _handleJoinGroup(),
            ),
          ),
        ],
      ),
    );
  }
}
