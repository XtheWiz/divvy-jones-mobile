import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'balance.g.dart';

@JsonSerializable()
class Balance {
  @JsonKey(name: 'user_id')
  final String userId;
  final User? user;
  final double balance;

  Balance({
    required this.userId,
    this.user,
    required this.balance,
  });

  factory Balance.fromJson(Map<String, dynamic> json) =>
      _$BalanceFromJson(json);
  Map<String, dynamic> toJson() => _$BalanceToJson(this);

  bool get isOwed => balance > 0;
  bool get owes => balance < 0;
  bool get isSettled => balance.abs() < 0.01;

  String get formattedBalance {
    final absBalance = balance.abs();
    return '\$${absBalance.toStringAsFixed(2)}';
  }

  String get statusText {
    if (isSettled) return 'Settled';
    if (isOwed) return 'is owed ${formattedBalance}';
    return 'owes ${formattedBalance}';
  }
}

@JsonSerializable()
class UserBalance {
  @JsonKey(name: 'total_owed')
  final double totalOwed;
  @JsonKey(name: 'total_owing')
  final double totalOwing;
  @JsonKey(name: 'net_balance')
  final double netBalance;
  final List<GroupBalance>? groups;

  UserBalance({
    required this.totalOwed,
    required this.totalOwing,
    required this.netBalance,
    this.groups,
  });

  factory UserBalance.fromJson(Map<String, dynamic> json) =>
      _$UserBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$UserBalanceToJson(this);
}

@JsonSerializable()
class GroupBalance {
  @JsonKey(name: 'group_id')
  final String groupId;
  @JsonKey(name: 'group_name')
  final String? groupName;
  final double balance;

  GroupBalance({
    required this.groupId,
    this.groupName,
    required this.balance,
  });

  factory GroupBalance.fromJson(Map<String, dynamic> json) =>
      _$GroupBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$GroupBalanceToJson(this);
}
