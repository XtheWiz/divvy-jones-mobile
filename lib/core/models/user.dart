import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  @JsonKey(name: 'displayName')
  final String name;
  final String? avatarUrl;
  final DateTime? createdAt;
  final bool? emailVerified;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.createdAt,
    this.emailVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get avatarInitial => name.isNotEmpty ? name[0].toUpperCase() : 'U';
}
