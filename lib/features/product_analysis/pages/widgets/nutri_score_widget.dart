import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/widgets/base_flexiable_image.dart';
import 'package:fooda_best/gen/assets.gen.dart';

class NutriScoreWidget extends StatelessWidget {
  final String? grade;
  final double? width;
  final double? height;

  const NutriScoreWidget({super.key, this.grade, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final score = grade?.toLowerCase() ?? 'e';
    final widgetWidth = width ?? 200.w;
    final widgetHeight = height ?? 60.h;

    return SizedBox(
      width: widgetWidth,
      height: widgetHeight,
      child: _getNutriScoreImage(score),
    );
  }

  Widget _getNutriScoreImage(String score) {
    switch (score) {
      case 'a':
        return FlexibleImage(
          source: Assets.images.propertyDefault,
          width: width ?? 200.w,
          height: height ?? 60.h,
        );
      case 'b':
        return FlexibleImage(
          source: Assets.images.propertyVariant2,
          width: width ?? 200.w,
          height: height ?? 60.h,
        );
      case 'c':
        return FlexibleImage(
          source: Assets.images.propertyVariant3,
          width: width ?? 200.w,
          height: height ?? 60.h,
        );
      case 'd':
        return FlexibleImage(
          source: Assets.images.propertyVariant4,
          width: width ?? 200.w,
          height: height ?? 60.h,
        );
      case 'e':
        return FlexibleImage(
          source: Assets.images.propertyVariant5,
          width: width ?? 200.w,
          height: height ?? 60.h,
        );
      default:
        return FlexibleImage(
          source: Assets.images.propertyVariant5,
          width: width ?? 200.w,
          height: height ?? 60.h,
        );
    }
  }
}
