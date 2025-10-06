import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/appKeys.dart';
import 'package:fooda_best/translations/locale_keys.g.dart';

class AppAlertDialog {
  static Future<void> showErrorBarSafe({
    String? errorMessage,
    VoidCallback? onShown,
  }) async {
    if (errorMessage != null) {
      if (errorMessage.isEmpty) {
        errorMessage = LocaleKeys.someThingWentWrong.tr();
      }
    } else {
      errorMessage = LocaleKeys.someThingWentWrong.tr();
    }

    if (AppKeys.materialKey.currentContext != null &&
        (AppKeys.materialKey.currentContext!.mounted)) {
      // Use SnackBar as a safer alternative to Flushbar
      ScaffoldMessenger.of(AppKeys.materialKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );

      if (onShown != null) {
        onShown();
      }
    }
  }

  static Future<void> showSuccessBar({
    String? message,
    //  required successMessage,
    VoidCallback? onShown,
  }) async {
    if (AppKeys.materialKey.currentContext != null &&
        (AppKeys.materialKey.currentContext!.mounted)) {
      Future.microtask(() {
        Flushbar(
          isDismissible: true,
          borderRadius: BorderRadius.circular(8.r),
          padding: EdgeInsets.all(16.sp),
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          message: message ?? LocaleKeys.doneSuccessfully.tr(),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.green,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(AppKeys.materialKey.currentContext!).then((_) {
          if (onShown != null) {
            onShown();
          }
        });
      });
    }
  }

  static Future<void> showErrorBar({
    String? errorMessage,
    bool? autoHide = true,
    bool? isDismissible = true,
    VoidCallback? onShown,
  }) async {
    if (errorMessage != null) {
      if (errorMessage.isEmpty) {
        errorMessage = LocaleKeys.someThingWentWrong.tr();
      }
    } else {
      errorMessage = LocaleKeys.someThingWentWrong.tr();
    }

    if (AppKeys.materialKey.currentContext != null &&
        (AppKeys.materialKey.currentContext!.mounted)) {
      try {
        // Use a safer approach with proper error handling
        final flushbar = Flushbar(
          padding: EdgeInsets.all(16.h),
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          borderRadius: BorderRadius.circular(8.r),
          isDismissible: isDismissible ?? true,
          message: errorMessage,
          flushbarPosition: FlushbarPosition.TOP,
          duration: autoHide ?? true ? const Duration(seconds: 5) : null,
          backgroundColor: Colors.redAccent,
        );

        // Show the flushbar with error handling
        await flushbar.show(AppKeys.materialKey.currentContext!).catchError((
          error,
        ) {
          // Log the error but don't crash the app
          debugPrint('Flushbar error: $error');
        });

        if (onShown != null) {
          onShown();
        }
      } catch (e) {
        // Fallback: show a simple snackbar if flushbar fails
        debugPrint('Flushbar failed, showing snackbar: $e');
        if (AppKeys.materialKey.currentContext!.mounted) {
          ScaffoldMessenger.of(
            AppKeys.materialKey.currentContext!,
          ).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }
}
