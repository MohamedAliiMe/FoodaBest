// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthenticationState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get failedState => throw _privateConstructorUsedError;
  bool get isAuthenticated => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;
  String? get accessToken => throw _privateConstructorUsedError;
  String? get verificationId => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthenticationStateCopyWith<AuthenticationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticationStateCopyWith<$Res> {
  factory $AuthenticationStateCopyWith(
          AuthenticationState value, $Res Function(AuthenticationState) then) =
      _$AuthenticationStateCopyWithImpl<$Res, AuthenticationState>;
  @useResult
  $Res call(
      {bool isLoading,
      String? errorMessage,
      bool failedState,
      bool isAuthenticated,
      UserModel? user,
      String? accessToken,
      String? verificationId,
      String? phoneNumber});
}

/// @nodoc
class _$AuthenticationStateCopyWithImpl<$Res, $Val extends AuthenticationState>
    implements $AuthenticationStateCopyWith<$Res> {
  _$AuthenticationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? failedState = null,
    Object? isAuthenticated = null,
    Object? user = freezed,
    Object? accessToken = freezed,
    Object? verificationId = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      failedState: null == failedState
          ? _value.failedState
          : failedState // ignore: cast_nullable_to_non_nullable
              as bool,
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationId: freezed == verificationId
          ? _value.verificationId
          : verificationId // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthenticationStateImplCopyWith<$Res>
    implements $AuthenticationStateCopyWith<$Res> {
  factory _$$AuthenticationStateImplCopyWith(_$AuthenticationStateImpl value,
          $Res Function(_$AuthenticationStateImpl) then) =
      __$$AuthenticationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      String? errorMessage,
      bool failedState,
      bool isAuthenticated,
      UserModel? user,
      String? accessToken,
      String? verificationId,
      String? phoneNumber});
}

/// @nodoc
class __$$AuthenticationStateImplCopyWithImpl<$Res>
    extends _$AuthenticationStateCopyWithImpl<$Res, _$AuthenticationStateImpl>
    implements _$$AuthenticationStateImplCopyWith<$Res> {
  __$$AuthenticationStateImplCopyWithImpl(_$AuthenticationStateImpl _value,
      $Res Function(_$AuthenticationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? failedState = null,
    Object? isAuthenticated = null,
    Object? user = freezed,
    Object? accessToken = freezed,
    Object? verificationId = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(_$AuthenticationStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      failedState: null == failedState
          ? _value.failedState
          : failedState // ignore: cast_nullable_to_non_nullable
              as bool,
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationId: freezed == verificationId
          ? _value.verificationId
          : verificationId // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AuthenticationStateImpl implements _AuthenticationState {
  _$AuthenticationStateImpl(
      {this.isLoading = false,
      this.errorMessage,
      this.failedState = false,
      this.isAuthenticated = false,
      this.user,
      this.accessToken,
      this.verificationId,
      this.phoneNumber});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool failedState;
  @override
  @JsonKey()
  final bool isAuthenticated;
  @override
  final UserModel? user;
  @override
  final String? accessToken;
  @override
  final String? verificationId;
  @override
  final String? phoneNumber;

  @override
  String toString() {
    return 'AuthenticationState(isLoading: $isLoading, errorMessage: $errorMessage, failedState: $failedState, isAuthenticated: $isAuthenticated, user: $user, accessToken: $accessToken, verificationId: $verificationId, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticationStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.failedState, failedState) ||
                other.failedState == failedState) &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.verificationId, verificationId) ||
                other.verificationId == verificationId) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      errorMessage,
      failedState,
      isAuthenticated,
      user,
      accessToken,
      verificationId,
      phoneNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticationStateImplCopyWith<_$AuthenticationStateImpl> get copyWith =>
      __$$AuthenticationStateImplCopyWithImpl<_$AuthenticationStateImpl>(
          this, _$identity);
}

abstract class _AuthenticationState implements AuthenticationState {
  factory _AuthenticationState(
      {final bool isLoading,
      final String? errorMessage,
      final bool failedState,
      final bool isAuthenticated,
      final UserModel? user,
      final String? accessToken,
      final String? verificationId,
      final String? phoneNumber}) = _$AuthenticationStateImpl;

  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  bool get failedState;
  @override
  bool get isAuthenticated;
  @override
  UserModel? get user;
  @override
  String? get accessToken;
  @override
  String? get verificationId;
  @override
  String? get phoneNumber;
  @override
  @JsonKey(ignore: true)
  _$$AuthenticationStateImplCopyWith<_$AuthenticationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
