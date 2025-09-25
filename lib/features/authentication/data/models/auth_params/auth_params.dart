import 'package:json_annotation/json_annotation.dart';

part 'auth_params.g.dart';

@JsonSerializable()
class PhoneAuthParams {
  final String phoneNumber;
  final String? verificationId;
  final String? smsCode;

  const PhoneAuthParams({
    required this.phoneNumber,
    this.verificationId,
    this.smsCode,
  });

  factory PhoneAuthParams.fromJson(Map<String, dynamic> json) =>
      _$PhoneAuthParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneAuthParamsToJson(this);
}

@JsonSerializable()
class ProfileSetupParams {
  final String firstName;
  final String lastName;
  final String? gender;
  final DateTime? dateOfBirth;

  const ProfileSetupParams({
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dateOfBirth,
  });

  factory ProfileSetupParams.fromJson(Map<String, dynamic> json) =>
      _$ProfileSetupParamsFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileSetupParamsToJson(this);
}
