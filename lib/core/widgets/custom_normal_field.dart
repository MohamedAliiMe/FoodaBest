import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';

class CustomNormalField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;
  final String? initialValue;
  final BorderRadius? borderRadius;
  final BorderRadius? enabledBorderRadius;
  final BorderRadius? focusedBorderRadius;
  final BorderRadius? errorBorderRadius;
  final BorderRadius? focusedErrorBorderRadius;
  final BorderSide? borderSide;
  final Color? fillColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? focusedErrorBorderColor;
  final Color? hintColor;
  final Color? prefixIconColor;
  final bool useModernLabelStyle;
  final bool isRequired;

  const CustomNormalField({
    super.key,
    this.label,
    this.hint,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
    this.initialValue,
    this.useModernLabelStyle = true,
    this.isRequired = false,
    this.borderRadius,
    this.enabledBorderRadius,
    this.focusedBorderRadius,
    this.errorBorderRadius,
    this.focusedErrorBorderRadius,
    this.borderSide,
    this.fillColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.focusedErrorBorderColor,
    this.hintColor,
    this.prefixIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: useModernLabelStyle
                ? tm14.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AllColors.grey,
                  )
                : tr16.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AllColors.black,
                  ),
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          readOnly: readOnly,
          focusNode: focusNode,
          initialValue: initialValue,
          style: tm16.copyWith(color: AllColors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: tr16.copyWith(color: AllColors.grey),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AllColors.white,
            border: OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AllColors.grayLight, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: enabledBorderRadius ?? BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AllColors.grayLight, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: focusedBorderRadius ?? BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AllColors.grayLight, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: errorBorderRadius ?? BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AllColors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius:
                  focusedErrorBorderRadius ?? BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AllColors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 6.h,
            ),
          ),
        ),
      ],
    );
  }
}
