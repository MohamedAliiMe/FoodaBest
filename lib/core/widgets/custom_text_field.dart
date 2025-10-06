import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';

class CustomTextField extends StatelessWidget {
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
  final bool useModernLabelStyle;

  const CustomTextField({
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
    this.useModernLabelStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AllColors.grayLight.withOpacity(0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.r),
        color: AllColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Padding(
              padding: EdgeInsets.only(left: 12.w, top: 5.h, right: 12.w),
              child: Text(
                label!,
                style: tr12.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AllColors.black,
                ),
              ),
            ),
          ],

          // Hidden TextFormField for input functionality
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
              hintStyle: tr16.copyWith(color: AllColors.grey),
              hintText: hint,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 8.h,
                horizontal: 12.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
