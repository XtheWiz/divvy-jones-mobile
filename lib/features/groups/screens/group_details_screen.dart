import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/groups_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_title_bar.dart';
import '../../../shared/widgets/error_display.dart';

/// Group Details Screen
class GroupDetailsScreen extends StatefulWidget {
  final String groupName;
  final String groupId;

  const GroupDetailsScreen({
    super.key,
    required this.groupName,
    required this.groupId,
  });

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGroupDetails();
    });
  }

  Future<void> _loadGroupDetails() async {
    await context.read<GroupsProvider>().loadGroupDetails(widget.groupId);
  }

  @override
  void dispose() {
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
              AppTitleBar(
                title: widget.groupName,
                onBackPressed: () => Navigator.pop(context),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings coming soon!')),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: Consumer<GroupsProvider>(
                  builder: (context, groupsProvider, child) {
                    if (groupsProvider.isLoadingDetails) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryPurple,
                          ),
                        ),
                      );
                    }

                    if (groupsProvider.error != null) {
                      return ErrorDisplay(
                        message: groupsProvider.error!,
                        onRetry: _loadGroupDetails,
                      );
                    }

                    final group = groupsProvider.selectedGroup;
                    final balances = groupsProvider.selectedGroupBalances;
                    final expenses = groupsProvider.selectedGroupExpenses;

                    if (group == null) {
                      return const Center(
                        child: Text('Group not found'),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _loadGroupDetails,
                      color: AppColors.primaryPurple,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildGroupSummaryCard(
                              totalExpenses: group.totalExpenses ?? 0,
                              expenseCount: expenses.length,
                              memberCount: group.membersCount,
                            ),
                            const SizedBox(height: 24),
                            _buildMembersSection(
                              members: group.members ?? [],
                            ),
                            const SizedBox(height: 24),
                            _buildBalancesSection(balances),
                            const SizedBox(height: 24),
                            _buildExpensesSection(expenses),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-expense'),
        backgroundColor: AppColors.primaryPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Expense', style: AppTypography.button),
      ),
    );
  }

  Widget _buildGroupSummaryCard({
    required double totalExpenses,
    required int expenseCount,
    required int memberCount,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.group, size: 32, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'Total Expenses',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${totalExpenses.toStringAsFixed(2)}',
            style: AppTypography.heading1.copyWith(
              color: Colors.white,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSummaryStat('Expenses', expenseCount.toString()),
              Container(
                width: 1,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _buildSummaryStat('Members', memberCount.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.heading3.copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersSection({
    required List members,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Members', style: AppTypography.heading3),
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invite feature coming soon!')),
                );
              },
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Invite'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryPurple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (members.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'No members yet',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(24),
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
                      const SizedBox(height: 8),
                      Text(
                        member.name ?? 'Member',
                        style: AppTypography.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBalancesSection(List balances) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Balances', style: AppTypography.heading3),
        const SizedBox(height: 12),
        if (balances.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'No balances yet',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          ...balances.map((balance) => _buildBalanceItem(
                balance.user?.name ?? 'Unknown',
                balance.statusText,
                balance.formattedBalance,
                balance.isOwed ? true : (balance.owes ? false : null),
              )),
        const SizedBox(height: 8),
        AppButton(
          text: 'Settle Up',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settle up feature coming soon!')),
            );
          },
          isOutlined: true,
          width: double.infinity,
          height: 48,
        ),
      ],
    );
  }

  Widget _buildBalanceItem(
    String name,
    String status,
    String amount,
    bool? isPositive,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0] : 'U',
                style: AppTypography.label.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.label),
                Text(status, style: AppTypography.caption),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTypography.label.copyWith(
              color: isPositive == null
                  ? AppColors.textSecondary
                  : isPositive
                      ? AppColors.success
                      : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesSection(List expenses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Expenses', style: AppTypography.heading3),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('View all expenses')),
                );
              },
              child: Text('See All', style: AppTypography.linkSmall),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (expenses.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 48,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 12),
                Text(
                  'No expenses yet',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add an expense to get started',
                  style: AppTypography.caption,
                ),
              ],
            ),
          )
        else
          ...expenses.take(5).map((expense) => _buildExpenseItem(
                icon: _getCategoryIcon(expense.category ?? 'other'),
                title: expense.description,
                paidBy: expense.paidByUser?.name ?? 'Someone',
                amount: expense.formattedAmount,
                date: expense.formattedDate,
              )),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.local_taxi;
      case 'entertainment':
        return Icons.movie;
      case 'accommodation':
        return Icons.hotel;
      case 'shopping':
        return Icons.shopping_bag;
      case 'health':
        return Icons.medical_services;
      case 'utilities':
        return Icons.power;
      default:
        return Icons.receipt;
    }
  }

  Widget _buildExpenseItem({
    required IconData icon,
    required String title,
    required String paidBy,
    required String amount,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryPurple, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.label),
                const SizedBox(height: 2),
                Text('Paid by $paidBy • $date', style: AppTypography.caption),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTypography.label.copyWith(color: AppColors.primaryPurple),
          ),
        ],
      ),
    );
  }
}
