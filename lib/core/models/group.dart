import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String id;
  final String name;
  @JsonKey(name: 'join_code')
  final String? joinCode;
  @JsonKey(name: 'default_currency_code')
  final String? defaultCurrencyCode;
  final List<GroupMember>? members;
  @JsonKey(name: 'total_expenses')
  final double? totalExpenses;
  @JsonKey(name: 'expense_count')
  final int? expenseCount;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  Group({
    required this.id,
    required this.name,
    this.joinCode,
    this.defaultCurrencyCode,
    this.members,
    this.totalExpenses,
    this.expenseCount,
    this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  int get memberCount => members?.length ?? 0;
}

@JsonSerializable()
class GroupMember {
  final String id;
  final String? name;
  final String? email;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String? role;

  GroupMember({
    required this.id,
    this.name,
    this.email,
    this.avatarUrl,
    this.role,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMemberToJson(this);

  String get avatarInitial =>
      name?.isNotEmpty == true ? name![0].toUpperCase() : 'U';

  User toUser() => User(
        id: id,
        email: email ?? '',
        name: name ?? '',
        avatarUrl: avatarUrl,
      );
}
