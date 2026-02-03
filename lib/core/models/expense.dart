import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense {
  final String id;
  @JsonKey(name: 'group_id')
  final String groupId;
  final String description;
  final double amount;
  @JsonKey(name: 'paid_by')
  final String paidById;
  @JsonKey(name: 'paid_by_user')
  final User? paidByUser;
  final String? category;
  @JsonKey(name: 'split_type')
  final String? splitType;
  final List<ExpenseSplit>? splits;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  final String? status;

  Expense({
    required this.id,
    required this.groupId,
    required this.description,
    required this.amount,
    required this.paidById,
    this.paidByUser,
    this.category,
    this.splitType,
    this.splits,
    this.createdAt,
    this.status,
  });

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';

  String get formattedDate {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(createdAt!);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${createdAt!.month}/${createdAt!.day}/${createdAt!.year}';
  }
}

@JsonSerializable()
class ExpenseSplit {
  @JsonKey(name: 'user_id')
  final String userId;
  final User? user;
  final double amount;
  @JsonKey(name: 'is_settled')
  final bool? isSettled;

  ExpenseSplit({
    required this.userId,
    this.user,
    required this.amount,
    this.isSettled,
  });

  factory ExpenseSplit.fromJson(Map<String, dynamic> json) =>
      _$ExpenseSplitFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseSplitToJson(this);
}

class CreateExpenseRequest {
  final String groupId;
  final String description;
  final double amount;
  final String category;
  final String splitType;
  final List<String>? splitWith;

  CreateExpenseRequest({
    required this.groupId,
    required this.description,
    required this.amount,
    required this.category,
    this.splitType = 'equal',
    this.splitWith,
  });

  Map<String, dynamic> toJson() => {
        'group_id': groupId,
        'description': description,
        'amount': amount,
        'category': category,
        'split_type': splitType,
        if (splitWith != null) 'split_with': splitWith,
      };
}
