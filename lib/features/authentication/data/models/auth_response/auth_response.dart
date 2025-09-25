import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthResponse {
  final bool success;
  final String? message;
  final UserModel user;
  final String? accessToken;
  final String? refreshToken;
  final String? verificationId;

  const AuthResponse({
    required this.success,
    this.message,
    required this.user,
    this.accessToken,
    this.refreshToken,
    this.verificationId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class PhoneVerificationResponse {
  final bool success;
  final String? message;
  final String? verificationId;
  final int? resendToken;

  const PhoneVerificationResponse({
    required this.success,
    this.message,
    this.verificationId,
    this.resendToken,
  });

  factory PhoneVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$PhoneVerificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneVerificationResponseToJson(this);
}
