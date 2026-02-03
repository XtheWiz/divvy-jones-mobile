// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
  id: json['id'] as String,
  name: json['name'] as String,
  joinCode: json['join_code'] as String?,
  defaultCurrencyCode: json['default_currency_code'] as String?,
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => GroupMember.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalExpenses: (json['total_expenses'] as num?)?.toDouble(),
  expenseCount: (json['expense_count'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'join_code': instance.joinCode,
  'default_currency_code': instance.defaultCurrencyCode,
  'members': instance.members,
  'total_expenses': instance.totalExpenses,
  'expense_count': instance.expenseCount,
  'created_at': instance.createdAt?.toIso8601String(),
};

GroupMember _$GroupMemberFromJson(Map<String, dynamic> json) => GroupMember(
  id: json['id'] as String,
  name: json['name'] as String?,
  email: json['email'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$GroupMemberToJson(GroupMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
      'role': instance.role,
    };
