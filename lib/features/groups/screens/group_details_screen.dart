import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_title_bar.dart';

/// Group Details Screen
class GroupDetailsScreen extends StatelessWidget {
  final String groupName;
  final String groupId;

  const GroupDetailsScreen({
    super.key,
    required this.groupName,
    required this.groupId,
  });

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
                title: groupName,
                onBackPressed: () => Navigator.pop(context),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Group Summary Card
                      _buildGroupSummaryCard(),
                      const SizedBox(height: 24),
                      // Members Section
                      _buildMembersSection(),
                      const SizedBox(height: 24),
                      // Balances Section
                      _buildBalancesSection(),
                      const SizedBox(height: 24),
                      // Expenses List
                      _buildExpensesSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add-expense');
        },
        backgroundColor: AppColors.primaryPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Expense', style: AppTypography.button),
      ),
    );
  }

  Widget _buildGroupSummaryCard() {
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
          // Group Icon
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
            '\$2,450.00',
            style: AppTypography.heading1.copyWith(
              color: Colors.white,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSummaryStat('Expenses', '12'),
              Container(
                width: 1,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _buildSummaryStat('Members', '5'),
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

  Widget _buildMembersSection() {
    final members = [
      {'name': 'Wiruj', 'initial': 'W'},
      {'name': 'Akane', 'initial': 'A'},
      {'name': 'Makoto', 'initial': 'M'},
      {'name': 'Sakura', 'initial': 'S'},
      {'name': 'Kenji', 'initial': 'K'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Members', style: AppTypography.heading3),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Invite'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryPurple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
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
                          member['initial']!,
                          style: AppTypography.label.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      member['name']!,
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

  Widget _buildBalancesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Balances', style: AppTypography.heading3),
        const SizedBox(height: 12),
        _buildBalanceItem('Wiruj', 'owes you', '\$45.00', true),
        _buildBalanceItem('Akane', 'you owe', '\$23.50', false),
        _buildBalanceItem('Makoto', 'settled up', '\$0.00', null),
        AppButton(
          text: 'Settle Up',
          onPressed: () {},
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
                name[0],
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

  Widget _buildExpensesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Expenses', style: AppTypography.heading3),
            Text('See All', style: AppTypography.linkSmall),
          ],
        ),
        const SizedBox(height: 12),
        _buildExpenseItem(
          icon: Icons.restaurant,
          title: 'Dinner at Local Restaurant',
          paidBy: 'Wiruj',
          amount: '\$85.00',
          date: 'Today',
        ),
        _buildExpenseItem(
          icon: Icons.local_taxi,
          title: 'Taxi to Airport',
          paidBy: 'Akane',
          amount: '\$45.50',
          date: 'Yesterday',
        ),
        _buildExpenseItem(
          icon: Icons.hotel,
          title: 'Hotel Booking',
          paidBy: 'Makoto',
          amount: '\$320.00',
          date: 'Jan 20',
        ),
      ],
    );
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
