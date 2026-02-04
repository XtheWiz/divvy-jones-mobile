import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String id;
  final String name;
  final String? joinCode;
  final String? defaultCurrencyCode;
  final List<GroupMember>? members;
  final double? totalExpenses;
  final int? memberCount;
  final String? role;
  final DateTime? createdAt;

  Group({
    required this.id,
    required this.name,
    this.joinCode,
    this.defaultCurrencyCode,
    this.members,
    this.totalExpenses,
    this.memberCount,
    this.role,
    this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  int get membersCount => memberCount ?? members?.length ?? 0;
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
