import 'package:flutter/material.dart';
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
  final _groupNameController = TextEditingController();
  int _selectedThemeIndex = 0;
  final List<String> _selectedMembers = [];

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

  final List<Map<String, String>> _suggestedMembers = [
    {'name': 'Wiruj', 'initial': 'W'},
    {'name': 'Akane', 'initial': 'A'},
    {'name': 'Makoto', 'initial': 'M'},
    {'name': 'Sakura', 'initial': 'S'},
    {'name': 'Kenji', 'initial': 'K'},
    {'name': 'Yuki', 'initial': 'Y'},
  ];

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _toggleMember(String name) {
    setState(() {
      if (_selectedMembers.contains(name)) {
        _selectedMembers.remove(name);
      } else {
        _selectedMembers.add(name);
      }
    });
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
              // Title Bar
              AppTitleBar(
                title: 'Create a Group',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Group Name Input
                      AppTextField(
                        label: 'Group Name',
                        hintText: 'Enter group name',
                        controller: _groupNameController,
                      ),
                      const SizedBox(height: 32),
                      // Theme Color Selection
                      Text('Choose Theme', style: AppTypography.label),
                      const SizedBox(height: 16),
                      _buildThemeSelector(),
                      const SizedBox(height: 32),
                      // Add Members
                      Text('Add Members', style: AppTypography.label),
                      const SizedBox(height: 16),
                      _buildMemberSelector(),
                      const SizedBox(height: 16),
                      // Selected Members
                      if (_selectedMembers.isNotEmpty) ...[
                        Text(
                          '${_selectedMembers.length} members selected',
                          style: AppTypography.caption,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedMembers.map((name) {
                            return Chip(
                              label: Text(name),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () => _toggleMember(name),
                              backgroundColor: AppColors.primaryLight
                                  .withValues(alpha: 0.2),
                              labelStyle: AppTypography.caption.copyWith(
                                color: AppColors.primaryPurple,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 40),
                      // Create Button
                      AppButton(
                        text: 'Create Group',
                        onPressed: () {
                          // TODO: Handle create group
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

  Widget _buildMemberSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          // Search Members
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.textHint, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Search contacts...',
                    style: AppTypography.inputHint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Member List
          ...List.generate(_suggestedMembers.length, (index) {
            final member = _suggestedMembers[index];
            final isSelected = _selectedMembers.contains(member['name']);
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    member['initial']!,
                    style: AppTypography.label.copyWith(color: Colors.white),
                  ),
                ),
              ),
              title: Text(member['name']!, style: AppTypography.label),
              trailing: Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleMember(member['name']!),
                activeColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onTap: () => _toggleMember(member['name']!),
            );
          }),
        ],
      ),
    );
  }
}
