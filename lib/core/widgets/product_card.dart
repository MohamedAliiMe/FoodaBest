import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/core/widgets/base_flexiable_image.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';
import 'package:fooda_best/gen/assets.gen.dart';

/// A unified, customizable product card widget for use throughout the app
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAlternativeTap;
  final bool showFavoriteIcon;
  final bool showAlternativeIcon;
  final bool showRating;
  final bool showNutriScore;
  final bool showBrand;
  final double? rating;
  final String? alternativeText;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? imageWidth;
  final double? imageHeight;
  final double? cardHeight;
  final bool showCheckmark;
  final Color? checkmarkColor;
  final Widget? customTrailing;
  final Widget? customLeading;
  final TextStyle? productNameStyle;
  final TextStyle? brandStyle;
  final TextStyle? ratingStyle;
  final TextStyle? alternativeTextStyle;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.onAlternativeTap,
    this.showFavoriteIcon = true,
    this.showAlternativeIcon = true,
    this.showRating = true,
    this.showNutriScore = true,
    this.showBrand = true,
    this.rating,
    this.alternativeText,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.imageWidth,
    this.imageHeight,
    this.cardHeight,
    this.showCheckmark = true,
    this.checkmarkColor,
    this.customTrailing,
    this.customLeading,
    this.productNameStyle,
    this.brandStyle,
    this.ratingStyle,
    this.alternativeTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.only(bottom: 16.h),
        padding: padding ?? EdgeInsets.all(16.w),
        height: cardHeight,
        decoration: BoxDecoration(
          color: backgroundColor ?? AllColors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(12.r),
          boxShadow:
              boxShadow ??
              [
                BoxShadow(
                  color: AllColors.black.withValues(alpha: 0.05),
                  blurRadius: 10.r,
                  offset: Offset(0, 2.h),
                ),
              ],
        ),
        child: Row(
          children: [
            // Product Image
            if (customLeading != null) customLeading! else _buildProductImage(),

            SizedBox(width: 16.w),

            // Product Info
            Expanded(child: _buildProductInfo()),

            SizedBox(width: 16.w),

            // Actions
            if (customTrailing != null) customTrailing! else _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: imageWidth ?? 80.w,
      height: imageHeight ?? 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AllColors.grey.withValues(alpha: 0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: product.imageUrl != null && product.imageUrl!.isNotEmpty
            ? Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Icon(Icons.image, color: AllColors.grey, size: 32.sp);
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Product Name with Checkmark
        Row(
          children: [
            Expanded(
              child: Text(
                product.name ?? 'Unknown Product',
                style:
                    productNameStyle ??
                    tm16.copyWith(
                      color: AllColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showCheckmark) ...[
              SizedBox(width: 8.w),
              Icon(
                Icons.check_circle,
                color: checkmarkColor ?? AllColors.blue,
                size: 16.sp,
              ),
            ],
          ],
        ),

        SizedBox(height: 4.h),

        // Brand
        if (showBrand)
          Text(
            product.brands?.isNotEmpty == true
                ? product.brands!
                : 'Unknown Brand',
            style:
                brandStyle ??
                tm12.copyWith(
                  color: AllColors.grey,
                  fontWeight: FontWeight.w400,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        SizedBox(height: 8.h),

        // Nutri-Score
        if (showNutriScore) _buildNutriScore(),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        // Favorite Icon
        if (showFavoriteIcon)
          GestureDetector(
            onTap: onFavoriteTap,
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AllColors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                color: AllColors.grey,
                size: 16.sp,
              ),
            ),
          ),

        if (showFavoriteIcon) SizedBox(height: 8.h),

        // Alternative Icon
        if (showAlternativeIcon)
          GestureDetector(
            onTap: onAlternativeTap,
            child: Column(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: AllColors.grey.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.refresh,
                    color: AllColors.grey,
                    size: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  alternativeText ?? 'Alternative',
                  style:
                      alternativeTextStyle ??
                      tm10.copyWith(
                        color: AllColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),

        if (showAlternativeIcon) SizedBox(height: 4.h),

        // Rating
        if (showRating)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rating?.toString() ?? '4.5',
                style:
                    ratingStyle ??
                    tm12.copyWith(
                      color: AllColors.black,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(width: 2.w),
              Icon(Icons.star, color: AllColors.yellow, size: 12.sp),
            ],
          ),
      ],
    );
  }

  Widget _buildNutriScore() {
    final grade = product.nutriScoreGrade?.toUpperCase() ?? 'C';
    return Container(
      width: 120.w,
      height: 20.h,
      child: _getNutriScoreImage(grade),
    );
  }

  Widget _getNutriScoreImage(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return FlexibleImage(
          source: Assets.images.propertyDefault,
          width: 120.w,
          height: 20.h,
        );
      case 'B':
        return FlexibleImage(
          source: Assets.images.propertyVariant2,
          width: 120.w,
          height: 20.h,
        );
      case 'C':
        return FlexibleImage(
          source: Assets.images.propertyVariant3,
          width: 120.w,
          height: 20.h,
        );
      case 'D':
        return FlexibleImage(
          source: Assets.images.propertyVariant4,
          width: 120.w,
          height: 20.h,
        );
      case 'E':
        return FlexibleImage(
          source: Assets.images.propertyVariant5,
          width: 120.w,
          height: 20.h,
        );
      default:
        return FlexibleImage(
          source: Assets.images.propertyVariant3, // Default to C
          width: 120.w,
          height: 20.h,
        );
    }
  }
}

/// Predefined styles for different use cases
class ProductCardStyles {
  static ProductCard searchResult({
    required ProductModel product,
    VoidCallback? onTap,
    VoidCallback? onFavoriteTap,
    VoidCallback? onAlternativeTap,
  }) {
    return ProductCard(
      product: product,
      onTap: onTap,
      onFavoriteTap: onFavoriteTap,
      onAlternativeTap: onAlternativeTap,
      showFavoriteIcon: true,
      showAlternativeIcon: true,
      showRating: true,
      showNutriScore: true,
      showBrand: true,
      showCheckmark: true,
      alternativeText: 'Alternative',
      rating: 4.5,
    );
  }

  static ProductCard analysisResult({
    required ProductModel product,
    VoidCallback? onTap,
    VoidCallback? onFavoriteTap,
    VoidCallback? onAlternativeTap,
  }) {
    return ProductCard(
      product: product,
      onTap: onTap,
      onFavoriteTap: onFavoriteTap,
      onAlternativeTap: onAlternativeTap,
      showFavoriteIcon: true,
      showAlternativeIcon: false,
      showRating: false,
      showNutriScore: true,
      showBrand: true,
      showCheckmark: true,
    );
  }

  static ProductCard alternativeProduct({
    required ProductModel product,
    VoidCallback? onTap,
    VoidCallback? onFavoriteTap,
    int? alternativeNumber,
  }) {
    return ProductCard(
      product: product,
      onTap: onTap,
      onFavoriteTap: onFavoriteTap,
      showFavoriteIcon: true,
      showAlternativeIcon: false,
      showRating: true,
      showNutriScore: true,
      showBrand: true,
      showCheckmark: true,
      customTrailing: alternativeNumber != null
          ? Column(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: AllColors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      alternativeNumber.toString(),
                      style: tm12.copyWith(
                        color: AllColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Alternative',
                  style: tm10.copyWith(
                    color: AllColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : null,
    );
  }

  static ProductCard compact({
    required ProductModel product,
    VoidCallback? onTap,
    double? height,
  }) {
    return ProductCard(
      product: product,
      onTap: onTap,
      cardHeight: height ?? 60.h,
      imageWidth: 50.w,
      imageHeight: 50.h,
      showFavoriteIcon: false,
      showAlternativeIcon: false,
      showRating: false,
      showNutriScore: false,
      showBrand: false,
      showCheckmark: false,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    );
  }
}
