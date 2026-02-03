import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/groups_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_title_bar.dart';

/// Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              const AppTitleBar(title: 'Profile', showBackButton: false),
              Expanded(
                child: Consumer2<AuthProvider, GroupsProvider>(
                  builder: (context, authProvider, groupsProvider, child) {
                    final user = authProvider.currentUser;
                    final groups = groupsProvider.groups;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildProfileAvatar(user?.avatarInitial ?? 'U'),
                          const SizedBox(height: 16),
                          Text(
                            user?.name ?? 'Captain',
                            style: AppTypography.heading2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'captain@divvyjones.com',
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Pirate Captain',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildStatsRow(groups.length),
                          const SizedBox(height: 32),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.person_outline,
                            title: 'Edit Profile',
                            onTap: () => _showDemoSnackBar(context, 'Edit Profile'),
                          ),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            trailing: _buildBadge('3'),
                            onTap: () =>
                                _showDemoSnackBar(context, 'Notifications'),
                          ),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.payment_outlined,
                            title: 'Payment Methods',
                            onTap: () =>
                                _showDemoSnackBar(context, 'Payment Methods'),
                          ),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.history,
                            title: 'Transaction History',
                            onTap: () =>
                                _showDemoSnackBar(context, 'Transaction History'),
                          ),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.help_outline,
                            title: 'Help & Support',
                            onTap: () =>
                                _showDemoSnackBar(context, 'Help & Support'),
                          ),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            onTap: () => _showDemoSnackBar(context, 'Settings'),
                          ),
                          const SizedBox(height: 16),
                          _buildMenuItem(
                            context: context,
                            icon: Icons.logout,
                            title: 'Log Out',
                            iconColor: AppColors.error,
                            titleColor: AppColors.error,
                            showArrow: false,
                            onTap: () => _handleLogout(context),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            'Divvy Jones v1.0.0',
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDemoSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: AppColors.primaryPurple,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out, Captain?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                context.go('/');
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(String initial) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(alpha: 0.3),
                offset: const Offset(0, 8),
                blurRadius: 20,
              ),
            ],
          ),
          child: Center(
            child: Text(
              initial,
              style: AppTypography.heading1.copyWith(color: Colors.white),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 18,
              color: AppColors.primaryPurple,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(int groupCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem('Groups', groupCount.toString()),
          _buildDivider(),
          _buildStatItem('Friends', '-'),
          _buildDivider(),
          _buildStatItem('Settled', '-'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTypography.heading3),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 40, color: AppColors.border);
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    Color? iconColor,
    Color? titleColor,
    bool showArrow = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? AppColors.textPrimary,
          size: 24,
        ),
        title: Text(
          title,
          style: AppTypography.label.copyWith(
            color: titleColor ?? AppColors.textPrimary,
          ),
        ),
        trailing:
            trailing ??
            (showArrow
                ? const Icon(Icons.chevron_right, color: AppColors.textHint)
                : null),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildBadge(String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count,
            style: AppTypography.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, color: AppColors.textHint),
      ],
    );
  }
}
