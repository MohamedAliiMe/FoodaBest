// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneAuthParams _$PhoneAuthParamsFromJson(Map<String, dynamic> json) =>
    PhoneAuthParams(
      phoneNumber: json['phoneNumber'] as String,
      verificationId: json['verificationId'] as String?,
      smsCode: json['smsCode'] as String?,
    );

Map<String, dynamic> _$PhoneAuthParamsToJson(PhoneAuthParams instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'verificationId': instance.verificationId,
      'smsCode': instance.smsCode,
    };

ProfileSetupParams _$ProfileSetupParamsFromJson(Map<String, dynamic> json) =>
    ProfileSetupParams(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
    );

Map<String, dynamic> _$ProfileSetupParamsToJson(ProfileSetupParams instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
    };
