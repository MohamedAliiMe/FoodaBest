import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/core/widgets/custom_country_picker_bottom_sheet.dart';
import 'package:fooda_best/translations/locale_keys.g.dart';

class CustomPhoneInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onPhoneNumberChanged;
  final ValueChanged<CountryModel> onCountryChanged;
  final String? initialCountryCode;

  const CustomPhoneInput({
    super.key,
    required this.controller,
    required this.onPhoneNumberChanged,
    required this.onCountryChanged,
    this.initialCountryCode,
  });

  @override
  State<CustomPhoneInput> createState() => _CustomPhoneInputState();
}

class _CustomPhoneInputState extends State<CustomPhoneInput> {
  List<CountryModel>? _countries;
  CountryModel? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => CustomCountryPickerBottomSheet.show(
            context,
            countries: _countries,
            initialCountryCode: widget.initialCountryCode,
            onCountryChanged: (country) {
              setState(() {
                _selectedCountry = country;
              });
              widget.onCountryChanged(country);
            },
            onCountriesLoaded: (countries) {
              setState(() {
                _countries = countries;
              });
            },
          ),
          child: Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AllColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AllColors.grayLight, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_selectedCountry?.flag ?? '🇪🇬', style: tm16),
                SizedBox(width: 4.w),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AllColors.black,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: 16.w),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            onChanged: widget.onPhoneNumberChanged,
            style: tm16.copyWith(color: AllColors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.phoneNumberIsRequired.tr();
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: LocaleKeys.mobileNumber.tr(),
              hintStyle: tm16.copyWith(color: AllColors.grey),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 8.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedCountry?.dialCode ?? '+20',
                      style: tm16.copyWith(color: AllColors.black),
                    ),
                  ],
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0),
              filled: true,
              fillColor: AllColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AllColors.grayLight, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AllColors.grayLight, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AllColors.grayLight, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AllColors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AllColors.red, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
