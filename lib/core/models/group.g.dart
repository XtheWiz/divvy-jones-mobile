// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
  id: json['id'] as String,
  name: json['name'] as String,
  joinCode: json['joinCode'] as String?,
  defaultCurrencyCode: json['defaultCurrencyCode'] as String?,
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => GroupMember.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalExpenses: (json['totalExpenses'] as num?)?.toDouble(),
  memberCount: (json['memberCount'] as num?)?.toInt(),
  role: json['role'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'joinCode': instance.joinCode,
  'defaultCurrencyCode': instance.defaultCurrencyCode,
  'members': instance.members,
  'totalExpenses': instance.totalExpenses,
  'memberCount': instance.memberCount,
  'role': instance.role,
  'createdAt': instance.createdAt?.toIso8601String(),
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
