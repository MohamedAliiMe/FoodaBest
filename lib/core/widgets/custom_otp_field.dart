import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:pinput/pinput.dart';

class CustomOTPField extends StatelessWidget {
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;
  final TextEditingController? controller;
  final int length;
  final bool enabled;
  final bool autofocus;

  const CustomOTPField({
    super.key,
    this.validator,
    this.onChanged,
    this.onCompleted,
    this.controller,
    this.length = 6,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: tm20.copyWith(
        fontWeight: FontWeight.w600,
        color: AllColors.black,
      ),
      decoration: BoxDecoration(
        color: AllColors.white,
        border: Border.all(color: AllColors.grayLight, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AllColors.blue, width: 2),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AllColors.blue, width: 2),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AllColors.red, width: 1),
    );

    return Pinput(
      length: length,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onCompleted: onCompleted,
      enabled: enabled,
      autofocus: autofocus,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      errorPinTheme: errorPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      cursor: Container(
        width: 2,
        height: 20.h,
        decoration: BoxDecoration(
          color: AllColors.blue,
          borderRadius: BorderRadius.circular(1.r),
        ),
      ),
    );
  }
}
