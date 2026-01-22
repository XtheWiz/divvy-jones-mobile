import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/app_title_bar.dart';

/// Add Expense Screen
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedGroup = 'South Asia Trip';
  String _splitType = 'equal';
  final List<String> _selectedMembers = ['Wiruj', 'Akane', 'Makoto'];

  final List<String> _groups = [
    'South Asia Trip',
    'Office Lunch Club',
    'Movie Night Gang',
    'Weekend Hikers',
  ];

  final List<Map<String, String>> _categories = [
    {'icon': '🍔', 'name': 'Food'},
    {'icon': '🚗', 'name': 'Transport'},
    {'icon': '🏠', 'name': 'Accommodation'},
    {'icon': '🎬', 'name': 'Entertainment'},
    {'icon': '🛒', 'name': 'Shopping'},
    {'icon': '💊', 'name': 'Health'},
    {'icon': '📱', 'name': 'Utilities'},
    {'icon': '🎁', 'name': 'Other'},
  ];

  int _selectedCategoryIndex = 0;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
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
                title: 'Add Expense',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Amount Input (Big)
                      _buildAmountInput(),
                      const SizedBox(height: 32),
                      // Description
                      AppTextField(
                        label: 'Description',
                        hintText: 'What was this expense for?',
                        controller: _descriptionController,
                      ),
                      const SizedBox(height: 24),
                      // Category Selection
                      Text('Category', style: AppTypography.label),
                      const SizedBox(height: 12),
                      _buildCategorySelector(),
                      const SizedBox(height: 24),
                      // Group Selection
                      Text('Group', style: AppTypography.label),
                      const SizedBox(height: 12),
                      _buildGroupSelector(),
                      const SizedBox(height: 24),
                      // Split Type
                      Text('Split Type', style: AppTypography.label),
                      const SizedBox(height: 12),
                      _buildSplitTypeSelector(),
                      const SizedBox(height: 24),
                      // Split Preview
                      _buildSplitPreview(),
                      const SizedBox(height: 32),
                      // Add Expense Button
                      AppButton(
                        text: 'Add Expense',
                        onPressed: () {
                          // TODO: Handle add expense
                          Navigator.pop(context);
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

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Amount',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$',
                style: AppTypography.heading1.copyWith(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const SizedBox(width: 4),
              IntrinsicWidth(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: AppTypography.heading1.copyWith(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: AppTypography.heading1.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 48,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryPurple.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryPurple
                      : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(category['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    category['name']!,
                    style: AppTypography.caption.copyWith(
                      color: isSelected
                          ? AppColors.primaryPurple
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButton<String>(
        value: _selectedGroup,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
        items: _groups.map((group) {
          return DropdownMenuItem(
            value: group,
            child: Text(group, style: AppTypography.input),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedGroup = value);
          }
        },
      ),
    );
  }

  Widget _buildSplitTypeSelector() {
    return Row(
      children: [
        _buildSplitOption('equal', 'Equal Split', Icons.people),
        const SizedBox(width: 12),
        _buildSplitOption('custom', 'Custom', Icons.tune),
      ],
    );
  }

  Widget _buildSplitOption(String value, String label, IconData icon) {
    final isSelected = _splitType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _splitType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryPurple.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryPurple : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.primaryPurple
                    : AppColors.textHint,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTypography.label.copyWith(
                  color: isSelected
                      ? AppColors.primaryPurple
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSplitPreview() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final splitAmount = _selectedMembers.isNotEmpty
        ? amount / _selectedMembers.length
        : 0.0;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Split Preview', style: AppTypography.label),
          const SizedBox(height: 16),
          ..._selectedMembers.map((member) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        member[0],
                        style: AppTypography.label.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(member, style: AppTypography.label)),
                  Text(
                    '\$${splitAmount.toStringAsFixed(2)}',
                    style: AppTypography.label.copyWith(
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
