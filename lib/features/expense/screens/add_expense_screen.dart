import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/models.dart';
import '../../../core/providers/groups_provider.dart';
import '../../../core/providers/expense_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedGroupId;
  String _splitType = 'equal';
  int _selectedCategoryIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  final List<Map<String, String>> _categories = [
    {'icon': '🍔', 'name': 'food'},
    {'icon': '🚗', 'name': 'transport'},
    {'icon': '🏠', 'name': 'accommodation'},
    {'icon': '🎬', 'name': 'entertainment'},
    {'icon': '🛒', 'name': 'shopping'},
    {'icon': '💊', 'name': 'health'},
    {'icon': '📱', 'name': 'utilities'},
    {'icon': '🎁', 'name': 'other'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final groups = context.read<GroupsProvider>().groups;
      if (groups.isNotEmpty && _selectedGroupId == null) {
        setState(() {
          _selectedGroupId = groups.first.id;
        });
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleAddExpense() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedGroupId == null) {
        setState(() {
          _errorMessage = 'Please select a group';
        });
        return;
      }

      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        setState(() {
          _errorMessage = 'Please enter a valid amount';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final expenseProvider = context.read<ExpenseProvider>();
      final expense = await expenseProvider.createExpense(
        CreateExpenseRequest(
          groupId: _selectedGroupId!,
          description: _descriptionController.text.trim(),
          amount: amount,
          category: _categories[_selectedCategoryIndex]['name']!,
          splitType: _splitType,
        ),
      );

      if (mounted) {
        setState(() => _isLoading = false);

        if (expense != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Expense added!'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        } else {
          setState(() {
            _errorMessage = expenseProvider.error ?? 'Failed to add expense. Please try again.';
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
                title: 'Add Expense',
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
                        _buildAmountInput(),
                        const SizedBox(height: 32),
                        AppTextField(
                          label: 'Description',
                          hintText: 'What was this expense for?',
                          controller: _descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Text('Category', style: AppTypography.label),
                        const SizedBox(height: 12),
                        _buildCategorySelector(),
                        const SizedBox(height: 24),
                        Text('Group', style: AppTypography.label),
                        const SizedBox(height: 12),
                        _buildGroupSelector(),
                        const SizedBox(height: 24),
                        Text('Split Type', style: AppTypography.label),
                        const SizedBox(height: 12),
                        _buildSplitTypeSelector(),
                        const SizedBox(height: 24),
                        _buildSplitPreview(),
                        const SizedBox(height: 32),
                        AppButton(
                          text: 'Add Expense',
                          onPressed: _isLoading ? null : _handleAddExpense,
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
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    category['name']!.substring(0, 1).toUpperCase() +
                        category['name']!.substring(1),
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
    return Consumer<GroupsProvider>(
      builder: (context, groupsProvider, child) {
        final groups = groupsProvider.groups;

        if (groups.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_outlined,
                  size: 20,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No groups available. Create or join a group first.',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButton<String>(
            value: _selectedGroupId,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
            items: groups.map((group) {
              return DropdownMenuItem(
                value: group.id,
                child: Text(group.name, style: AppTypography.input),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedGroupId = value);
              }
            },
          ),
        );
      },
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
    return Consumer<GroupsProvider>(
      builder: (context, groupsProvider, child) {
        final selectedGroup = _selectedGroupId != null
            ? groupsProvider.getGroupById(_selectedGroupId!)
            : null;
        final members = selectedGroup?.members ?? [];
        final amount = double.tryParse(_amountController.text) ?? 0;
        final splitAmount = members.isNotEmpty ? amount / members.length : 0.0;

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
              if (members.isEmpty)
                Text(
                  'Select a group to see split preview',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                )
              else
                ...members.take(5).map((member) {
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
                              member.avatarInitial,
                              style: AppTypography.label.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            member.name ?? 'Member',
                            style: AppTypography.label,
                          ),
                        ),
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
              if (members.length > 5)
                Text(
                  '+${members.length - 5} more members',
                  style: AppTypography.caption,
                ),
            ],
          ),
        );
      },
    );
  }
}
