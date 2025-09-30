import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';

class AlternativeProductsWidget extends StatelessWidget {
  final List<ProductModel> alternatives;
  final bool isLoading;
  final Function(ProductModel) onSelectAlternative;

  const AlternativeProductsWidget({
    super.key,
    required this.alternatives,
    required this.isLoading,
    required this.onSelectAlternative,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            Icon(Icons.lightbulb_outline, color: AllColors.blue, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Alternative Products',
              style: tb16.copyWith(color: AllColors.black),
            ),
          ],
        ),

        SizedBox(height: 12.h),


        if (isLoading) ...[
          _buildLoadingState(),
        ] else if (alternatives.isEmpty) ...[
          _buildEmptyState(),
        ] else ...[
          _buildAlternativesList(),
        ],
      ],
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 200.w,
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AllColors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: AllColors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 120.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AllColors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AllColors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off, color: AllColors.grey, size: 32.sp),
          SizedBox(height: 8.h),
          Text(
            'No alternatives found',
            style: tm14.copyWith(color: AllColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativesList() {
    return SizedBox(
      height: 140.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: alternatives.length,
        itemBuilder: (context, index) {
          final alternative = alternatives[index];
          return GestureDetector(
            onTap: () => onSelectAlternative(alternative),
            child: Container(
              width: 180.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: AllColors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AllColors.grey.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AllColors.black.withValues(alpha: 0.05),
                    blurRadius: 4.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: double.infinity,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: AllColors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(8.r),
                      ),
                      image:
                          alternative.imageUrl != null &&
                              alternative.imageUrl!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(alternative.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child:
                        alternative.imageUrl == null ||
                            alternative.imageUrl!.isEmpty
                        ? Icon(Icons.image, color: AllColors.grey, size: 24.sp)
                        : null,
                  ),


                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            alternative.name ?? 'Unknown Product',
                            style: tm12.copyWith(
                              color: AllColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),


                          if (alternative.nutriScoreGrade != null &&
                              alternative.nutriScoreGrade!.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getNutriScoreColor(
                                  alternative.nutriScoreGrade!,
                                ),
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                              child: Text(
                                'Score ${alternative.nutriScoreGrade!.toUpperCase()}',
                                style: tm10.copyWith(
                                  color: AllColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
