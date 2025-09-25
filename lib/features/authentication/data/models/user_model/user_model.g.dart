// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      email: json['email'] as String?,
      photoURL: json['photoURL'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastSignIn: json['lastSignIn'] == null
          ? null
          : DateTime.parse(json['lastSignIn'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'phoneNumber': instance.phoneNumber,
      'displayName': instance.displayName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'email': instance.email,
      'photoURL': instance.photoURL,
      'isEmailVerified': instance.isEmailVerified,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastSignIn': instance.lastSignIn?.toIso8601String(),
    };
