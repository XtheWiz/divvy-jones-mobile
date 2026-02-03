// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
  id: json['id'] as String,
  groupId: json['group_id'] as String,
  description: json['description'] as String,
  amount: (json['amount'] as num).toDouble(),
  paidById: json['paid_by'] as String,
  paidByUser: json['paid_by_user'] == null
      ? null
      : User.fromJson(json['paid_by_user'] as Map<String, dynamic>),
  category: json['category'] as String?,
  splitType: json['split_type'] as String?,
  splits: (json['splits'] as List<dynamic>?)
      ?.map((e) => ExpenseSplit.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  status: json['status'] as String?,
);

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
  'id': instance.id,
  'group_id': instance.groupId,
  'description': instance.description,
  'amount': instance.amount,
  'paid_by': instance.paidById,
  'paid_by_user': instance.paidByUser,
  'category': instance.category,
  'split_type': instance.splitType,
  'splits': instance.splits,
  'created_at': instance.createdAt?.toIso8601String(),
  'status': instance.status,
};

ExpenseSplit _$ExpenseSplitFromJson(Map<String, dynamic> json) => ExpenseSplit(
  userId: json['user_id'] as String,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  amount: (json['amount'] as num).toDouble(),
  isSettled: json['is_settled'] as bool?,
);

Map<String, dynamic> _$ExpenseSplitToJson(ExpenseSplit instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user': instance.user,
      'amount': instance.amount,
      'is_settled': instance.isSettled,
    };
