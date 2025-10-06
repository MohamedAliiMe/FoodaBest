import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/authentication/pages/view/otp_verification_page.dart';
import 'package:fooda_best/features/authentication/pages/view/phone_auth_page.dart';
import 'package:fooda_best/features/authentication/pages/view/profile_setup_page.dart';
import 'package:fooda_best/features/profile/pages/view/profile_page.dart';
import 'package:fooda_best/features/profile/pages/view/profile_settings.dart';
import 'package:fooda_best/features/search/pages/view/search_page.dart';
import 'package:fooda_best/features/splash/view/splash_screen.dart';
import 'package:fooda_best/translations/locale_keys.g.dart';

import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    switch (settings.name) {
      case AppRoute.splashPage:
        return _screenInit(const SplashScreen(), settings);
      case AppRoute.phoneAuthPage:
        return _screenInit(const PhoneAuthPage(), settings);
      case AppRoute.otpVerificationPage:
        final arguments = settings.arguments as Map<String, dynamic>?;
        if (arguments != null) {
          final String phoneNumber = arguments['phoneNumber'] as String;
          final String verificationId = arguments['verificationId'] as String;
          return _screenInit(
            OTPVerificationPage(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
            ),
            settings,
          );
        }
        return _errorRoute();
      case AppRoute.profileSetupPage:
        return _screenInit(const ProfileSetupPage(), settings);
      case AppRoute.profilePage:
        return _screenInit(const ProfilePage(), settings);
      case AppRoute.profileSettingsPage:
        final arguments = settings.arguments as Map<String, dynamic>?;
        if (arguments != null) {
          final UserModel user = arguments['user'] as UserModel;
          return _screenInit(ProfileSettingsPage(user: user), settings);
        }
        return _errorRoute();
      case AppRoute.searchPage:
        return _screenInit(const SearchPage(), settings);
      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute<dynamic> _screenInit(
    Widget screen,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => screen,
      settings: settings,
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AllColors.white,
            title: Text(LocaleKeys.error.tr()),
          ),
          body: Center(child: Text(LocaleKeys.someThingWentWrong.tr())),
        );
      },
    );
  }
}
