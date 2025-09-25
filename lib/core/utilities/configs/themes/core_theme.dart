import 'package:flutter/material.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';

final themeLight = ThemeData.light().copyWith(
  brightness: Brightness.light,
  primaryColor: AllColors.blue,
  colorScheme: const ColorScheme.light(
    surface: AllColors.white,
    secondary: AllColors.blue,
    primary: AllColors.blue,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AllColors.blue,
  ),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  bottomAppBarTheme: const BottomAppBarThemeData(color: AllColors.white),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: AllColors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: AllColors.white,
    foregroundColor: AllColors.black,
    surfaceTintColor: AllColors.white,
    iconTheme: const IconThemeData(color: AllColors.blue),
    titleTextStyle: tm20,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: AllColors.blue,
    backgroundColor: AllColors.grayLight,
  ),
  hintColor: AllColors.grey,
  iconTheme: const IconThemeData(color: AllColors.white),
);

final themeDark = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  primaryColor: AllColors.black,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AllColors.blue,
  ),
  bottomAppBarTheme: const BottomAppBarThemeData(color: AllColors.black),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: AllColors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: AllColors.black,
    foregroundColor: AllColors.white,
    surfaceTintColor: AllColors.white,
    titleTextStyle: tm20.copyWith(color: Colors.white),
    iconTheme: const IconThemeData(color: AllColors.blue),
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: AllColors.black,
    backgroundColor: AllColors.white,
  ),
  hintColor: AllColors.grey,
  iconTheme: const IconThemeData(color: AllColors.white),
);
