part of 'authentication_cubit.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  factory AuthenticationState({
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool failedState,
    @Default(false) bool isAuthenticated,
    UserModel? user,
    String? accessToken,
    String? verificationId,
    String? phoneNumber,
  }) = _AuthenticationState;
}
