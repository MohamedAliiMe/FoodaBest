import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? uid;
  final String? imageUrl;
  final String? phoneNumber;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? email;
  final String? photoURL;
  final bool? isEmailVerified;
  final DateTime? createdAt;
  final DateTime? lastSignIn;

  const UserModel({
    this.uid,
    this.imageUrl,
    this.phoneNumber,
    this.displayName,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.email,
    this.photoURL,
    this.isEmailVerified,
    this.createdAt,
    this.lastSignIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? uid,
    String? imageUrl,
    String? phoneNumber,
    String? displayName,
    String? firstName,
    String? lastName,
    String? gender,
    DateTime? dateOfBirth,
    String? email,
    String? photoURL,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? lastSignIn,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastSignIn: lastSignIn ?? this.lastSignIn,
    );
  }
}
