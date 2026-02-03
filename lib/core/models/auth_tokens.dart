import 'package:json_annotation/json_annotation.dart';

part 'auth_tokens.g.dart';

@JsonSerializable()
class AuthTokens {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);
  Map<String, dynamic> toJson() => _$AuthTokensToJson(this);

  DateTime get expiryDate =>
      DateTime.now().add(Duration(seconds: expiresIn));
}
