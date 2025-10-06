import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fooda_best/core/networking/data_state.dart';
import 'package:fooda_best/features/authentication/data/models/auth_response/auth_response.dart';
import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<DataState<PhoneVerificationResponse>> sendOTP(
    String phoneNumber,
  ) async {
    try {
      final completer = Completer<DataState<PhoneVerificationResponse>>();

      _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          if (!completer.isCompleted) {
            completer.complete(
              DataSuccess(
                PhoneVerificationResponse(
                  success: true,
                  message: 'Phone number auto-verified',
                  verificationId: 'auto-verified',
                ),
              ),
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          log('💥 Firebase Error: ${e.code} - ${e.message}');
          if (!completer.isCompleted) {
            String errorMessage = 'Failed to send OTP';
            switch (e.code) {
              case 'invalid-phone-number':
                errorMessage = 'رقم الهاتف غير صالح';
                break;
              case 'too-many-requests':
                errorMessage =
                    'تم إرسال الكثير من الطلبات. حاول مرة أخرى لاحقاً';
                break;
              case 'network-request-failed':
                errorMessage = 'تحقق من اتصال الإنترنت';
                break;
              default:
                errorMessage = e.message ?? 'حدث خطأ غير متوقع';
            }
            completer.complete(DataFailed(errorMessage));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          log('📱 Code sent! VerificationId: $verificationId');
          if (!completer.isCompleted) {
            completer.complete(
              DataSuccess(
                PhoneVerificationResponse(
                  success: true,
                  message: 'OTP sent successfully',
                  verificationId: verificationId,
                  resendToken: resendToken,
                ),
              ),
            );
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) {
            completer.complete(
              DataSuccess(
                PhoneVerificationResponse(
                  success: true,
                  message: 'OTP sent successfully',
                  verificationId: verificationId,
                ),
              ),
            );
          }
        },
        timeout: const Duration(seconds: 30),
      );

      return await completer.future.timeout(
        const Duration(seconds: 35),
        onTimeout: () => DataFailed('انتهت مهلة إرسال الرسالة. حاول مرة أخرى'),
      );
    } catch (e) {
      return DataFailed('Failed to send OTP: ${e.toString()}');
    }
  }

  Future<DataState<AuthResponse>> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null) {
        final userModel = UserModel(
          uid: user.uid,
          phoneNumber: user.phoneNumber,
          displayName: user.displayName,
          email: user.email,
          photoURL: user.photoURL,
          isEmailVerified: user.emailVerified,
          createdAt: user.metadata.creationTime,
          lastSignIn: user.metadata.lastSignInTime,
        );

        return DataSuccess(
          AuthResponse(
            success: true,
            user: userModel,
            accessToken: await user.getIdToken(),
            message: 'Login successful',
          ),
        );
      } else {
        return DataFailed('User not found');
      }
    } catch (e) {
      return DataFailed('Failed to verify OTP: ${e.toString()}');
    }
  }

  Future<DataState<UserModel>> updateProfile({
    required String name,
    required String email,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return DataFailed('User not authenticated');
      }

      await user.updateDisplayName(name);

      final updatedUser = UserModel(
        uid: user.uid,
        phoneNumber: user.phoneNumber,
        displayName: user.displayName,
        firstName: name,
        lastName: null,
        gender: gender,
        dateOfBirth: dateOfBirth,
        email: user.email,
        photoURL: user.photoURL,
        isEmailVerified: user.emailVerified,
        createdAt: user.metadata.creationTime,
        lastSignIn: user.metadata.lastSignInTime,
      );

      return DataSuccess(updatedUser);
    } catch (e) {
      return DataFailed('Failed to update profile: ${e.toString()}');
    }
  }

  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return UserModel(
      uid: user.uid,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      email: user.email,
      photoURL: user.photoURL,
      isEmailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
      lastSignIn: user.metadata.lastSignInTime,
    );
  }

  Future<DataState<bool>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return DataSuccess(true);
    } catch (e) {
      return DataFailed('Failed to sign out: ${e.toString()}');
    }
  }

  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
