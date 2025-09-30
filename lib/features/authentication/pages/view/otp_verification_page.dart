import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/functions/app_alert_dialog.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/core/utilities/routes_navigator/navigator.dart';
import 'package:fooda_best/core/widgets/base_flexiable_image.dart';
import 'package:fooda_best/core/widgets/custom_continue_button.dart';
import 'package:fooda_best/core/widgets/custom_otp_field.dart';
import 'package:fooda_best/features/authentication/logic/authentication_cubit.dart';
import 'package:fooda_best/features/authentication/pages/view/profile_setup_page.dart';
import 'package:fooda_best/features/product_analysis/pages/view/product_analysis_page.dart';
import 'package:fooda_best/gen/assets.gen.dart';
import 'package:fooda_best/translations/locale_keys.g.dart';

class OTPVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OTPVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  late final AuthenticationCubit _authenticationCubit;

  bool _isOTPValid = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _authenticationCubit = context.read<AuthenticationCubit>();
    _otpController.addListener(_validateOTP);

    log('📱 OTP Screen - Passed verificationId: ${widget.verificationId}');
    log(
      '📱 OTP Screen - Cubit verificationId: ${_authenticationCubit.state.verificationId}',
    );
  }

  void _validateOTP() {
    setState(() {
      _isOTPValid = _otpController.text.length == 6;
    });
  }

  void _verifyOTP() {
    if (_isOTPValid) {
      final verificationId =
          _authenticationCubit.state.verificationId ?? widget.verificationId;
      log('📱 OTP Verify - Using verificationId: $verificationId');

      if (verificationId.isNotEmpty) {
        _authenticationCubit.verifyOTPWithId(
          verificationId,
          _otpController.text,
        );
      } else {
        log('❌ No verificationId available for OTP verification');
        _authenticationCubit.verifyOTP(_otpController.text);
      }
    }
  }

  void _resendOTP() {
    _authenticationCubit.sendOTP(widget.phoneNumber);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        bloc: _authenticationCubit,
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppAlertDialog.showErrorBar(errorMessage: state.errorMessage);
            _hasNavigated = false;
          }
          if (!_hasNavigated && state.isAuthenticated && state.user != null) {
            final user = state.user!;
            final hasCompleteProfile =
                user.firstName != null &&
                user.firstName!.isNotEmpty &&
                user.lastName != null &&
                user.lastName!.isNotEmpty;
            _hasNavigated = true;
            log(
              '🧭 User authenticated - Navigating to ${hasCompleteProfile ? "ProfilePage" : "ProfileSetupPage"}',
            );
            log(
              '👤 User data: firstName=${user.firstName}, lastName=${user.lastName}',
            );

            if (hasCompleteProfile) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductAnalysisPage(),
                ),
                (route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileSetupPage(),
                ),
                (route) => false,
              );
            }
          }
        },
        child: Column(
          children: [
            Stack(
              children: [
                FlexibleImage(
                  source: Assets.images.pattern,
                  width: double.infinity.w,
                  height: 180.h,
                  fit: BoxFit.fill,
                  color: AllColors.green.withValues(alpha: 0.3),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 16.h),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: AllColors.black),
                          onPressed: () {
                            popScreen(context);
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            popScreen(context);
                          },
                          child: Text(
                            LocaleKeys.changeNumber.tr(),
                            style: tr18.copyWith(color: AllColors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    _buildHeader(),
                    SizedBox(height: 40.h),
                    _buildOTPField(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  _buildContinueButton(),
                  SizedBox(height: 45.h),
                  _buildResendButton(),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Column _buildHeader() {
    return Column(
      children: [
        Text(LocaleKeys.enterAuthenticationCode.tr(), style: tb24),
        SizedBox(height: 12.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys
                    .enterThe6DigitCodeThatWeHaveSentViaThePhoneNumber
                    .tr(),
                style: tr16,
              ),
              TextSpan(text: widget.phoneNumber, style: tb18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOTPField() {
    return CustomOTPField(
      controller: _otpController,
      onChanged: (value) {
        if (value.length == 6) {
          _verifyOTP();
        }
      },
      validator: (value) {
        if (value == null || value.length != 6) {
          return LocaleKeys.pleaseEnterAValid6DigitCode.tr();
        }
        return null;
      },
    );
  }

  BlocBuilder<AuthenticationCubit, AuthenticationState> _buildResendButton() {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      bloc: _authenticationCubit,
      builder: (context, state) {
        return TextButton(
          onPressed: state.isLoading ? null : _resendOTP,
          child: Text(
            LocaleKeys.resendCode.tr(),
            style: tr16.copyWith(color: AllColors.blue),
          ),
        );
      },
    );
  }

  BlocBuilder<AuthenticationCubit, AuthenticationState> _buildContinueButton() {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      bloc: _authenticationCubit,
      builder: (context, state) {
        return CustomContinueButton(
          text: LocaleKeys.continueText.tr(),
          onPressed: _isOTPValid ? _verifyOTP : null,
          isLoading: state.isLoading,
          isEnabled: _isOTPValid && !state.isLoading,
        );
      },
    );
  }
}
