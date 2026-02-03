// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Balance _$BalanceFromJson(Map<String, dynamic> json) => Balance(
  userId: json['user_id'] as String,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  balance: (json['balance'] as num).toDouble(),
);

Map<String, dynamic> _$BalanceToJson(Balance instance) => <String, dynamic>{
  'user_id': instance.userId,
  'user': instance.user,
  'balance': instance.balance,
};

UserBalance _$UserBalanceFromJson(Map<String, dynamic> json) => UserBalance(
  totalOwed: (json['total_owed'] as num).toDouble(),
  totalOwing: (json['total_owing'] as num).toDouble(),
  netBalance: (json['net_balance'] as num).toDouble(),
  groups: (json['groups'] as List<dynamic>?)
      ?.map((e) => GroupBalance.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserBalanceToJson(UserBalance instance) =>
    <String, dynamic>{
      'total_owed': instance.totalOwed,
      'total_owing': instance.totalOwing,
      'net_balance': instance.netBalance,
      'groups': instance.groups,
    };

GroupBalance _$GroupBalanceFromJson(Map<String, dynamic> json) => GroupBalance(
  groupId: json['group_id'] as String,
  groupName: json['group_name'] as String?,
  balance: (json['balance'] as num).toDouble(),
);

Map<String, dynamic> _$GroupBalanceToJson(GroupBalance instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'group_name': instance.groupName,
      'balance': instance.balance,
    };
