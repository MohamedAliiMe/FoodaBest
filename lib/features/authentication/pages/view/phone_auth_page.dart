import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/dependencies/dependency_init.dart';
import 'package:fooda_best/core/functions/app_alert_dialog.dart';
import 'package:fooda_best/core/utilities/app_validator.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/core/utilities/routes_navigator/navigator.dart';
import 'package:fooda_best/core/widgets/base_flexiable_image.dart';
import 'package:fooda_best/core/widgets/custom_continue_button.dart';
import 'package:fooda_best/core/widgets/custom_phone_input.dart';
import 'package:fooda_best/features/authentication/logic/authentication_cubit.dart';
import 'package:fooda_best/features/authentication/pages/view/otp_verification_page.dart';
import 'package:fooda_best/gen/assets.gen.dart';
import 'package:fooda_best/translations/locale_keys.g.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final AuthenticationCubit _authenticationCubit = getIt<AuthenticationCubit>();
  bool _isPhoneValid = false;
  bool _hasNavigated = false;
  String _selectedCountryCode = '+20';

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  void _validatePhone() {
    String phone = _phoneController.text.trim();

    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }

    final fullPhone = _selectedCountryCode + phone;
    setState(() {
      _isPhoneValid =
          AppValidator.validatorPhoneNumber(fullPhone, context) == null;
    });
  }

  String _smartCleanPhoneNumber(String input) {
    String cleaned = input.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.startsWith('+')) {
      return cleaned;
    }
    if (cleaned.startsWith('00')) {
      return '+${cleaned.substring(2)}';
    }
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
      return _selectedCountryCode + cleaned;
    }
    if (cleaned.length < 8) {
      return _selectedCountryCode + cleaned;
    }
    return _selectedCountryCode + cleaned;
  }

  void _sendOTP() {
    if (_formKey.currentState!.validate()) {
      final input = _phoneController.text.trim();
      final cleanedPhone = _smartCleanPhoneNumber(input);

      log('📱 Original input: $input');
      log('📱 Cleaned phone: $cleanedPhone');

      _authenticationCubit.sendOTP(cleanedPhone);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        bloc: _authenticationCubit,
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppAlertDialog.showErrorBarSafe(errorMessage: state.errorMessage);
            _hasNavigated = false;
          }
          if (state.verificationId != null &&
              state.phoneNumber != null &&
              !_hasNavigated) {
            _hasNavigated = true;
            // Add a small delay to ensure any ongoing operations complete
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted) {
                pushPage(
                  context,
                  OTPVerificationPage(
                    phoneNumber: state.phoneNumber!,
                    verificationId: state.verificationId!,
                  ),
                );
              }
            });
          }
        },
        child: Column(
          children: [
            FlexibleImage(
              height: 180.h,
              source: Assets.images.pattern,
              width: double.infinity.w,
              fit: BoxFit.fill,
              color: AllColors.green.withValues(alpha: 0.5),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 26.h),
                    _buildPhoneForm(),
                  ],
                ),
              ),
            ),
            _buildContinueButton(),
            SizedBox(height: 32.h),
            _buildFooter(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.welcomeTo.tr(),
          style: tb32.copyWith(color: AllColors.black),
        ),
        Text(
          '${LocaleKeys.enterYourPhoneNumberToSignIn.tr()} ${LocaleKeys.orCreateAnAccountIfYouDontHaveOneYet.tr()}',
          textAlign: TextAlign.start,
          style: tr16.copyWith(color: AllColors.grey),
        ),
      ],
    );
  }

  Widget _buildPhoneForm() {
    return Form(key: _formKey, child: _buildCountryCodeSelector());
  }

  Widget _buildCountryCodeSelector() {
    return CustomPhoneInput(
      controller: _phoneController,
      initialCountryCode: 'EG',
      onPhoneNumberChanged: (value) {
        _validatePhone();
      },
      onCountryChanged: (country) {
        setState(() {
          _selectedCountryCode = country.dialCode;
        });
        _validatePhone();
      },
    );
  }

  Widget _buildContinueButton() {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      bloc: _authenticationCubit,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomContinueButton(
            text: LocaleKeys.continueText.tr(),
            onPressed: _isPhoneValid ? _sendOTP : null,
            isLoading: state.isLoading,
            isEnabled: _isPhoneValid && !state.isLoading,
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: RichText(
        softWrap: false,
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '${LocaleKeys.byContinuingYouAcceptOur.tr()} ',
          style: tr14.copyWith(color: AllColors.black),
          children: [
            TextSpan(
              text: LocaleKeys.terms.tr(),
              style: tb16.copyWith(color: AllColors.blue),
            ),
            TextSpan(
              text: LocaleKeys.andSign.tr(),
              style: tb16.copyWith(color: AllColors.black),
            ),
            TextSpan(
              text: LocaleKeys.privacy.tr(),
              style: tb16.copyWith(color: AllColors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
