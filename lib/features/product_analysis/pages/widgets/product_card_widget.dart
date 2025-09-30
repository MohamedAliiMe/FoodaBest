import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/core/widgets/base_flexiable_image.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AllColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AllColors.black.withValues(alpha: 0.1),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              color: AllColors.grayLight.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: FlexibleImage(
                source: product.imageUrl,
                width: double.infinity,
                height: 200.h,
                borderRadius: 0,
                fit: BoxFit.cover,
                placeholder: _buildImagePlaceholder(),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? 'Unknown Product',
                  style: tb20.copyWith(
                    color: AllColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 8.h),

                if (product.brands != null && product.brands!.isNotEmpty) ...[
                  Text(
                    product.brands!,
                    style: tm16.copyWith(
                      color: AllColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                ],

                Row(
                  children: [
                    if (product.nutriScoreGrade != null &&
                        product.nutriScoreGrade!.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getNutriScoreColor(product.nutriScoreGrade!),
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: _getNutriScoreColor(
                                product.nutriScoreGrade!,
                              ).withValues(alpha: 0.3),
                              blurRadius: 4.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Text(
                          'Nutri-Score ${product.nutriScoreGrade!.toUpperCase()}',
                          style: tm14.copyWith(
                            color: AllColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                    SizedBox(width: 12.w),

                    if (product.categories != null &&
                        product.categories!.isNotEmpty)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AllColors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AllColors.blue.withValues(alpha: 0.3),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            product.categories!.first,
                            style: tm12.copyWith(
                              color: AllColors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: AllColors.grayLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48.sp,
            color: AllColors.grey.withValues(alpha: 0.5),
          ),
          SizedBox(height: 8.h),
          Text(
            'Product Image',
            style: tm14.copyWith(
              color: AllColors.grey.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getNutriScoreColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'a':
        return AllColors.green;
      case 'b':
        return Colors.lightGreen;
      case 'c':
        return Colors.yellow[700]!;
      case 'd':
        return Colors.orange;
      case 'e':
        return AllColors.red;
      default:
        return AllColors.grey;
    }
  }
}
