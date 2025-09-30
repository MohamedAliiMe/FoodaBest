import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/core/widgets/base_flexiable_image.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';
import 'package:fooda_best/features/product_analysis/pages/widgets/nutri_score_widget.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;
  final String? aiSummary;
  final List<ProductModel>? alternativeProducts;

  const ProductDetailPage({
    super.key,
    required this.product,
    this.aiSummary,
    this.alternativeProducts,
  });

  static void show(
    BuildContext context, {
    required ProductModel product,
    String? aiSummary,
    List<ProductModel>? alternativeProducts,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailPage(
        product: product,
        aiSummary: aiSummary,
        alternativeProducts: alternativeProducts,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AllColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          _buildHandleBar(context),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // Main product card
                  _buildMainProductCard(),

                  SizedBox(height: 20.h),

                  // Food-Score and NOVA section
                  _buildFoodScoreSection(),

                  SizedBox(height: 20.h),

                  // Better Alternative section
                  if (alternativeProducts != null &&
                      alternativeProducts!.isNotEmpty)
                    ..._buildBetterAlternativeSection(),

                  SizedBox(height: 20.h),

                  // Country-specific ratings
                  _buildCountryRatingsSection(),

                  SizedBox(height: 20.h),

                  // AI Summary section
                  if (aiSummary != null && aiSummary!.isNotEmpty)
                    _buildAISummarySection(),

                  SizedBox(height: 20.h),

                  // Nutrition Information section
                  _buildNutritionSection(),

                  SizedBox(height: 20.h),

                  // Ingredients section
                  _buildIngredientsSection(),

                  SizedBox(height: 20.h),

                  // Where to Find section
                  _buildWhereToFindSection(),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandleBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AllColors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          SizedBox(height: 16.h),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Product Details',
                  style: tb20.copyWith(
                    color: AllColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AllColors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      Icons.close,
                      color: AllColors.black,
                      size: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainProductCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AllColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AllColors.black.withValues(alpha: 0.1),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AllColors.grayLight.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: FlexibleImage(
                source: product.imageUrl,
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
                placeholder: _buildImagePlaceholder(),
              ),
            ),
          ),

          SizedBox(width: 16.w),

          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? 'Unknown Product',
                  style: tb18.copyWith(
                    color: AllColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 4.h),

                Text(
                  product.categories?.join(', ') ?? 'Food',
                  style: tm14.copyWith(
                    color: AllColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 12.h),

                // Nutri-Score
                _buildNutriScore(),
              ],
            ),
          ),

          // Action buttons
          Column(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AllColors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.favorite_border,
                  color: AllColors.grey,
                  size: 20.sp,
                ),
              ),

              SizedBox(height: 8.h),

              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AllColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: AllColors.blue, size: 16.sp),
                    Text(
                      '${alternativeProducts?.length ?? 0}',
                      style: tm10.copyWith(
                        color: AllColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              Row(
                children: [
                  Icon(Icons.star, color: AllColors.green, size: 16.sp),
                  SizedBox(width: 4.w),
                  Text(
                    '4.5',
                    style: tm12.copyWith(
                      color: AllColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutriScore() {
    return Row(
      children: [
        Text(
          'NUTRI-SCORE',
          style: tm12.copyWith(
            color: AllColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(child: _buildNutriScoreBar()),
      ],
    );
  }

  Widget _buildNutriScoreBar() {
    return NutriScoreWidget(
      grade: product.nutriScoreGrade,
      width: 70.w,
      height: 20.h,
    );
  }

  Widget _buildFoodScoreSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Color(0xFFE8F4FD), // Light blue background like in the image
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AllColors.black.withValues(alpha: 0.1),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food-Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FOOD-SCORE',
                    style: tb16.copyWith(
                      color: AllColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Overall food health rating system',
                    style: tm12.copyWith(color: AllColors.grey),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${_calculateFoodScore()}/100',
                  style: tb16.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Nutri-Score detailed
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NUTRI-SCORE',
                      style: tb16.copyWith(
                        color: AllColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '(A) High nutritional Value, (E) Low nutritional value',
                      style: tm12.copyWith(color: AllColors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              _buildNutriScoreBar(),
            ],
          ),

          SizedBox(height: 20.h),

          // NOVA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.factory, color: AllColors.grey, size: 20.sp),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NOVA',
                        style: tb16.copyWith(
                          color: AllColors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'processed',
                        style: tm12.copyWith(color: AllColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: AllColors.yellow,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${_calculateNovaRating()}',
                    style: tb14.copyWith(
                      color: AllColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBetterAlternativeSection() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.refresh, color: AllColors.blue, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Better Alternative',
                style: tb16.copyWith(
                  color: AllColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            'View more',
            style: tm14.copyWith(
              color: AllColors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      SizedBox(height: 16.h),
      if (alternativeProducts != null && alternativeProducts!.isNotEmpty)
        SizedBox(
          height: 110.h, // Adjust height as needed for your card
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: alternativeProducts!.take(9).length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final altProduct = alternativeProducts![index];
              return SizedBox(
                width: 250.w, // Adjust width as needed for your card
                child: _buildAlternativeProductCard(altProduct),
              );
            },
          ),
        ),
    ];
  }

  Widget _buildAlternativeProductCard(ProductModel product) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AllColors.blueBackground.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AllColors.grayLight.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: FlexibleImage(
                source: product.imageUrl,
                width: 60.w,
                height: 60.h,
                fit: BoxFit.cover,
                placeholder: _buildImagePlaceholder(),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Product info
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? 'Unknown Product',
                  style: tm14.copyWith(
                    color: AllColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 2.h),

                Text(
                  product.categories?.join(', ') ?? 'Food',
                  style: tm12.copyWith(color: AllColors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                _buildNutriScoreBar(),
              ],
            ),
          ),

          // Action buttons
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: AllColors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.favorite_border,
                  color: AllColors.grey,
                  size: 16.sp,
                ),
              ),

              SizedBox(height: 4.h),

              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: AllColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: AllColors.blue, size: 12.sp),
                    Text(
                      '4',
                      style: tm10.copyWith(
                        color: AllColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: AllColors.green, size: 12.sp),
                  SizedBox(width: 2.w),
                  Text(
                    '4.5',
                    style: tm10.copyWith(
                      color: AllColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountryRatingsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AllColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AllColors.black.withValues(alpha: 0.1),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This product is rated as',
            style: tb16.copyWith(
              color: AllColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 16.h),

          // Country ratings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCountryRating('EU', product.nutriScoreGrade ?? '', '🇪🇺'),
              _buildCountryRating('UAE', product.nutriScoreGrade ?? '', '🇦🇪'),
              _buildCountryRating('US', product.nutriScoreGrade ?? '', '🇺🇸'),
            ],
          ),

          SizedBox(height: 16.h),

          Text(
            'The rating differs by country because some ingredients such as E171 (Titanium dioxide) are banned in Europe but still allowed in other regions.',
            style: tm12.copyWith(color: AllColors.grey, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryRating(String country, String grade, String flag) {
    return Row(
      children: [
        Text(flag, style: TextStyle(fontSize: 24.sp)),
        SizedBox(height: 4.h),
        Text(
          country,
          style: tm12.copyWith(
            color: AllColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          ": $grade",
          style: tb14.copyWith(
            color: AllColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildAISummarySection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AllColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AllColors.black.withValues(alpha: 0.1),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary generated by AI',
            style: tb16.copyWith(
              color: AllColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 12.h),

          Text(
            aiSummary ?? 'No summary available',
            style: tm14.copyWith(color: AllColors.black, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AllColors.grayLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 24.sp,
            color: AllColors.grey.withValues(alpha: 0.5),
          ),
          SizedBox(height: 4.h),
          Text(
            'Product',
            style: tm10.copyWith(
              color: AllColors.grey.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateFoodScore() {
    int score = 50;

    final nutriScore = product.nutriScoreGrade?.toLowerCase();
    switch (nutriScore) {
      case 'a':
        score += 30;
        break;
      case 'b':
        score += 20;
        break;
      case 'c':
        score += 10;
        break;
      case 'd':
        score -= 10;
        break;
      case 'e':
        score -= 20;
        break;
    }

    final ingredientsCount = product.ingredients?.length ?? 0;
    if (ingredientsCount > 20) {
      score -= 15;
    } else if (ingredientsCount < 5) {
      score += 10;
    }

    final allergensCount = product.allergens?.length ?? 0;
    score -= allergensCount * 5;

    return score.clamp(0, 100);
  }

  int _calculateNovaRating() {
    final ingredients = product.ingredients ?? [];
    final categories = product.categories ?? [];

    final ultraProcessedKeywords = [
      'preservatives',
      'artificial',
      'flavor',
      'color',
      'sweetener',
      'emulsifier',
      'stabilizer',
      'thickener',
      'anti-caking',
    ];

    int ultraProcessedCount = 0;
    for (final ingredient in ingredients) {
      final text = ingredient.text?.toLowerCase() ?? '';
      for (final keyword in ultraProcessedKeywords) {
        if (text.contains(keyword)) {
          ultraProcessedCount++;
          break;
        }
      }
    }

    for (final category in categories) {
      final cat = category.toLowerCase();
      if (cat.contains('snack') ||
          cat.contains('candy') ||
          cat.contains('soda')) {
        return 4;
      }
    }

    if (ultraProcessedCount >= 3) {
      return 4;
    } else if (ultraProcessedCount >= 1) {
      return 3;
    } else if (ingredients.length > 5) {
      return 2;
    } else {
      return 1;
    }
  }

  Widget _buildNutritionSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AllColors.blueBackground.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        // boxShadow: [
        //   BoxShadow(
        //     color: AllColors.black.withValues(alpha: 0.1),
        //     blurRadius: 20.r,
        //     offset: Offset(0, 8.h),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: AllColors.blue, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Nutrition Information',
                style: tb16.copyWith(
                  color: AllColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          //  if (product.nutriments != null && product.nutriments!.isNotEmpty)
          _buildNutritionGrid(),
          // else
          //   Text(
          //     'No nutrition information available',
          //     style: tm14.copyWith(color: AllColors.grey),
          //   ),
        ],
      ),
    );
  }

  Widget _buildNutritionGrid() {
    final nutriments = product.nutriments ?? {};
    final nutritionItems = <Map<String, dynamic>>[];

    // Extract key nutrients
    final nutrients = {
      'protein': 'Protein',
      'salt': 'Salt',
      'carbohydrates': 'Carbs',
      'sugars': 'Sugars',
      'fat': 'Fats',
      'energy-kcal': 'kcal',
    };

    for (final entry in nutrients.entries) {
      final value = nutriments[entry.key];
      if (value != null) {
        nutritionItems.add({
          'name': entry.value,
          'value': value.toString(),
          'unit': _getNutrientUnit(entry.key),
          'color': _getNutrientColor(entry.key, value),
        });
      }
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: nutritionItems.length,
      itemBuilder: (context, index) {
        final item = nutritionItems[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AllColors.grayLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: item['color'].withValues(alpha: 0.3),
              width: 1.w,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: item['color'],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${item['value']}${item['unit']}',
                      style: tm14.copyWith(
                        color: AllColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      item['name'],
                      style: tm12.copyWith(color: AllColors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIngredientsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AllColors.blueBackground.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        // boxShadow: [
        //   BoxShadow(
        //     color: AllColors.black.withValues(alpha: 0.1),
        //     blurRadius: 20.r,
        //     offset: Offset(0, 8.h),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.restaurant, color: AllColors.green, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Ingredients',
                    style: tb16.copyWith(
                      color: AllColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                'Add photo',
                style: tm14.copyWith(
                  color: AllColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          //  if (product.ingredients != null && product.ingredients!.isNotEmpty)
          Column(
            children: product.ingredients!
                .map(
                  (ingredient) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: AllColors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            ingredient.text ?? 'Unknown ingredient',
                            style: tm14.copyWith(color: AllColors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          //   else
          // Text(
          //      'No ingredients information available',
          //      style: tm14.copyWith(color: AllColors.grey),
          //    ),
        ],
      ),
    );
  }

  Widget _buildWhereToFindSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AllColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AllColors.black.withValues(alpha: 0.1),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.store, color: AllColors.blue, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Where to Find',
                style: tb16.copyWith(
                  color: AllColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // _buildStoreListings(),
        ],
      ),
    );
  }

  String _getNutrientUnit(String nutrient) {
    switch (nutrient) {
      case 'protein':
      case 'carbohydrates':
      case 'sugars':
      case 'fat':
        return 'g';
      case 'salt':
        return 'g';
      case 'energy-kcal':
        return ' kcal';
      default:
        return '';
    }
  }

  Color _getNutrientColor(String nutrient, dynamic value) {
    final numValue = double.tryParse(value.toString()) ?? 0;

    switch (nutrient) {
      case 'protein':
        return numValue > 10
            ? AllColors.green
            : numValue > 5
            ? Colors.orange
            : AllColors.red;
      case 'salt':
        return numValue < 1
            ? AllColors.green
            : numValue < 2
            ? Colors.orange
            : AllColors.red;
      case 'sugars':
        return numValue < 5
            ? AllColors.green
            : numValue < 15
            ? Colors.orange
            : AllColors.red;
      case 'fat':
        return numValue < 10
            ? AllColors.green
            : numValue < 20
            ? Colors.orange
            : AllColors.red;
      case 'energy-kcal':
        return numValue < 200
            ? AllColors.green
            : numValue < 400
            ? Colors.orange
            : AllColors.red;
      default:
        return AllColors.grey;
    }
  }
}
