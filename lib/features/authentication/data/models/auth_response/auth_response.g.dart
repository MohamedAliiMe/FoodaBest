// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      verificationId: json['verificationId'] as String?,
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'user': instance.user.toJson(),
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'verificationId': instance.verificationId,
    };

PhoneVerificationResponse _$PhoneVerificationResponseFromJson(
        Map<String, dynamic> json) =>
    PhoneVerificationResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      verificationId: json['verificationId'] as String?,
      resendToken: (json['resendToken'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PhoneVerificationResponseToJson(
        PhoneVerificationResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'verificationId': instance.verificationId,
      'resendToken': instance.resendToken,
    };
