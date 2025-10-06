import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooda_best/core/app_authentication_state/app_authentication_state.dart';
import 'package:fooda_best/core/constants/app_string_constants.dart';
import 'package:fooda_best/core/networking/data_state.dart';
import 'package:fooda_best/core/utilities/app_data_storage.dart';
import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/authentication/data/services/authentication_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'authentication_cubit.freezed.dart';
part 'authentication_state.dart';

@Injectable()
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationService _authService;
  final DataStorage _dataStorage;

  AuthenticationCubit(this._authService, this._dataStorage)
    : super(AuthenticationState()) {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    emit(state.copyWith(isLoading: true));

    try {
      final isSignedIn = _authService.isSignedIn();
      final user = _authService.getCurrentUser();

      if (isSignedIn && user != null) {
        final savedUserData = await _dataStorage.getData(
          AppStringConstants.userProfile,
        );
        UserModel completeUser = user;

        if (savedUserData != null) {
          try {
            final userData = Map<String, dynamic>.from(savedUserData);
            final savedUser = UserModel.fromJson(userData);
            log(
              '🔄 Loaded saved user: ${savedUser.firstName} ${savedUser.lastName}',
            );
            completeUser = savedUser.copyWith(
              uid: user.uid,
              phoneNumber: user.phoneNumber,
              email: user.email,
              photoURL: user.photoURL,
              isEmailVerified: user.isEmailVerified,
              lastSignIn: user.lastSignIn,
              displayName: user.displayName,
            );
            log(
              '✅ Merged user data - Profile complete: ${completeUser.firstName != null}',
            );
          } catch (e) {
            log('💥 Error loading saved user data: $e');
          }
        } else {
          log('⚠️ No saved user data found - checking displayName');
          String? firstName;
          String? lastName;
          if (user.displayName != null && user.displayName!.isNotEmpty) {
            final nameParts = user.displayName!.trim().split(' ');
            if (nameParts.isNotEmpty) {
              firstName = nameParts.first;
              if (nameParts.length > 1) {
                lastName = nameParts.sublist(1).join(' ');
              }
            }
            log('🔄 Extracted from displayName: $firstName $lastName');
          }

          completeUser = user.copyWith(
            firstName: firstName,
            lastName: lastName,
          );
          log(
            '✅ Used Firebase user with extracted name: ${completeUser.firstName} ${completeUser.lastName}',
          );
        }

        await _saveUserData(completeUser);
        emit(
          state.copyWith(
            isLoading: false,
            user: completeUser,
            isAuthenticated: true,
          ),
        );
      } else {
        await _clearUserData();
        emit(state.copyWith(isLoading: false, isAuthenticated: false));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          isAuthenticated: false,
        ),
      );
    }
  }

  Future<void> sendOTP(String phoneNumber) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    log('📱 Sending OTP to: $phoneNumber');

    try {
      final result = await _authService.sendOTP(phoneNumber);
      log('📱 OTP Result: ${result.runtimeType}');
      if (result is DataSuccess) {
        log(
          '✅ OTP sent successfully. VerificationId: ${result.data?.verificationId}',
        );
        emit(
          state.copyWith(
            isLoading: false,
            verificationId: result.data?.verificationId,
            phoneNumber: phoneNumber,
          ),
        );
      } else {
        log('❌ OTP failed: ${(result as DataFailed).error}');
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: (result as DataFailed).error,
          ),
        );
      }
    } catch (e) {
      log('💥 OTP Exception: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> verifyOTP(String smsCode) async {
    if (state.verificationId == null) {
      emit(state.copyWith(errorMessage: 'Verification ID not found'));
      return;
    }

    return verifyOTPWithId(state.verificationId!, smsCode);
  }

  Future<void> verifyOTPWithId(String verificationId, String smsCode) async {
    log('📱 Verifying OTP with ID: $verificationId, Code: $smsCode');
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await _authService.verifyOTP(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      if (result is DataSuccess) {
        final authResponse = result.data;
        if (authResponse?.user != null) {
          log('📱 OTP Verified. User: ${authResponse!.user.phoneNumber}');
          log(
            '👤 Firebase User profile: ${authResponse.user.firstName} ${authResponse.user.lastName}',
          );

          final savedUserData = await _dataStorage.getData(
            AppStringConstants.userProfile,
          );
          UserModel? completeUser = authResponse.user;

          if (savedUserData != null) {
            try {
              final userData = Map<String, dynamic>.from(savedUserData);
              final savedUser = UserModel.fromJson(userData);
              log(
                '🔄 Found saved profile: ${savedUser.firstName} ${savedUser.lastName}',
              );
              completeUser = savedUser.copyWith(
                uid: authResponse.user.uid,
                phoneNumber: authResponse.user.phoneNumber,
                email: authResponse.user.email,
                photoURL: authResponse.user.photoURL,
                isEmailVerified: authResponse.user.isEmailVerified,
                lastSignIn: authResponse.user.lastSignIn,
                displayName: authResponse.user.displayName,
              );
              log(
                '✅ Merged OTP user data - Final profile: ${completeUser.firstName} ${completeUser.lastName}',
              );
            } catch (e) {
              log('💥 Error loading saved user data in OTP: $e');
            }
          } else {
            // Try to extract name from displayName if available
            String? firstName;
            String? lastName;
            if (authResponse.user.displayName != null &&
                authResponse.user.displayName!.isNotEmpty) {
              final nameParts = authResponse.user.displayName!.trim().split(
                ' ',
              );
              if (nameParts.isNotEmpty) {
                firstName = nameParts.first;
                if (nameParts.length > 1) {
                  lastName = nameParts.sublist(1).join(' ');
                }
              }
              log('🔄 Extracted from displayName: $firstName $lastName');
            }

            completeUser = authResponse.user.copyWith(
              firstName: firstName,
              lastName: lastName,
            );
            log(
              '✅ Used Firebase user with extracted name: ${completeUser.firstName} ${completeUser.lastName}',
            );
          }

          await _saveUserData(completeUser!);
          await _saveToken(authResponse.accessToken);

          emit(
            state.copyWith(
              isLoading: false,
              user: completeUser,
              isAuthenticated: true,
              accessToken: authResponse.accessToken,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: (result as DataFailed).error,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await _authService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
        dateOfBirth: dateOfBirth,
      );

      if (result is DataSuccess) {
        await _saveUserData(result.data!);
        emit(state.copyWith(isLoading: false, user: result.data));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: (result as DataFailed).error,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await _authService.signOut();

      if (result is DataSuccess) {
        await _clearUserData();
        emit(AuthenticationState());
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: (result as DataFailed).error,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _saveUserData(UserModel user) async {
    await _dataStorage.saveData(AppStringConstants.userProfile, user.toJson());
    await _dataStorage.saveData(
      AppStringConstants.appAuthenticationState,
      AppAuthenticationStateEnum.customerState.name,
    );
  }

  Future<void> _saveToken(String? token) async {
    if (token != null) {
      await _dataStorage.saveData(AppStringConstants.userAccessToken, token);
    }
  }

  Future<void> _clearUserData() async {
    await _dataStorage.removeData(AppStringConstants.userProfile);
    await _dataStorage.removeData(AppStringConstants.userAccessToken);
    await _dataStorage.saveData(
      AppStringConstants.appAuthenticationState,
      AppAuthenticationStateEnum.unauthorizedState.name,
    );
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
