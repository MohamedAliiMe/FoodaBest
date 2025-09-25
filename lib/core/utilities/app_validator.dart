import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:fooda_best/translations/locale_keys.g.dart';


class AppValidator {
  static String? validatorRequired(String? value, BuildContext context,
      {String? errorMessage}) {
    if (value == null || value.isEmpty) {
      return errorMessage ?? LocaleKeys.required.tr();
    }
    return null;
  }

  static String? validatorEmail(String? value, BuildContext context) {
    const String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return LocaleKeys.required.tr();
    }
    if (!regExp.hasMatch(value)) {
      return LocaleKeys.emailNotValid.tr();
    }
    return null;
  }

  static String? validatorName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.required.tr();
    }
    // range 3-50
    if (value.length < 3 || value.length > 50) {
      return LocaleKeys.nameLengthError.tr();
    }
    // only english letters
    // if (!RegExp(r'[a-zA-Z]+$').hasMatch(value)) {
    //   return LocaleKeys.onlyLetters.tr();
    // }
    return null;
  }

  static String? validatorUsername(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.required.tr();
    }
    // range 3-50
    if (value.length < 3 || value.length > 50) {
      return LocaleKeys.nameLengthError.tr();
    }

    if (value.contains(' ')) {
      return LocaleKeys.invalidUsername.tr();
    }
    // only english letters
    // if (!RegExp(r'[a-zA-Z]+$').hasMatch(value)) {
    //   return LocaleKeys.onlyLetters.tr();
    // }
    return null;
  }

  static String? validatorPhoneNumber(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.required.tr();
    }
    const String pattern =
        r'\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{5,14}$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return LocaleKeys.notValidMobile.tr();
    }
    return null;
  }

  static String? validateMobile(
      String? value, String? dialNumber, BuildContext context) {
    if (value != null && dialNumber != null && value.isNotEmpty) {
      final String number = dialNumber + value;
      if (number.length >= 9 && number.length <= 15) {
        return null;
      } else {
        return LocaleKeys.notValidMobile.tr();
      }
    } else {
      return LocaleKeys.notValidMobile.tr();
    }
  }

  static String? validatorMinLength(
    String? value,
    BuildContext context,
    int minLength,
  ) {
    if (value == null || value.length < minLength) {
      return "${LocaleKeys.minLengthShouldBe.tr()} $minLength";
    }
    return null;
  }

  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
