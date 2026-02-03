import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/groups_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/app_title_bar.dart';

/// Create Group Screen
class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  int _selectedThemeIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  final List<Color> _themeColors = [
    AppColors.primaryPurple,
    AppColors.primaryLight,
    const Color(0xFFFF6B6B),
    const Color(0xFF4ECDC4),
    const Color(0xFFFFE66D),
    const Color(0xFF95E1D3),
    const Color(0xFFF38181),
    const Color(0xFFAA96DA),
  ];

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateGroup() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final groupsProvider = context.read<GroupsProvider>();
      final group = await groupsProvider.createGroup(
        _groupNameController.text.trim(),
      );

      if (mounted) {
        setState(() => _isLoading = false);

        if (group != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Group "${group.name}" created!'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else {
          setState(() {
            _errorMessage = groupsProvider.error ?? 'Failed to create group. Please try again.';
          });
        }
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
                title: 'Create a Group',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        AppTextField(
                          label: 'Group Name',
                          hintText: 'Enter group name',
                          controller: _groupNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a group name';
                            }
                            if (value.length < 2) {
                              return 'Group name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        Text('Choose Theme', style: AppTypography.label),
                        const SizedBox(height: 16),
                        _buildThemeSelector(),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 20,
                                color: AppColors.primaryPurple,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'You can invite members after creating the group using the join code.',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        AppButton(
                          text: 'Create Group',
                          onPressed: _isLoading ? null : _handleCreateGroup,
                          isLoading: _isLoading,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(_themeColors.length, (index) {
        final isSelected = _selectedThemeIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedThemeIndex = index),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _themeColors[index],
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: _themeColors[index].withValues(alpha: 0.5),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 24)
                : null,
          ),
        );
      }),
    );
  }
}
