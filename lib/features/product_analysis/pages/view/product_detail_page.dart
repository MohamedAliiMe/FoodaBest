import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/core/utilities/routes_navigator/navigator.dart';
import 'package:fooda_best/core/widgets/base_flexiable_image.dart';
import 'package:fooda_best/core/widgets/product_card.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';
import 'package:fooda_best/features/product_analysis/pages/widgets/nutri_score_widget.dart';
import 'package:fooda_best/translations/locale_keys.g.dart';

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
          _buildHandleBar(context),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  _buildMainProductCard(),

                  SizedBox(height: 20.h),

                  _buildFoodScoreSection(),

                  SizedBox(height: 20.h),

                  if (alternativeProducts != null &&
                      alternativeProducts!.isNotEmpty)
                    ..._buildBetterAlternativeSection(),

                  SizedBox(height: 20.h),

                  _buildCountryRatingsSection(),

                  SizedBox(height: 20.h),

                  if (aiSummary != null && aiSummary!.isNotEmpty)
                    _buildAISummarySection(),

                  SizedBox(height: 20.h),

                  _buildNutritionSection(),

                  SizedBox(height: 20.h),

                  _buildIngredientsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildHandleBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AllColors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          SizedBox(height: 16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.productDetails.tr(),
                  style: tb20.copyWith(
                    color: AllColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => popScreen(context),
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

  Container _buildMainProductCard() {
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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? LocaleKeys.unknownProduct.tr(),
                  style: tb18.copyWith(
                    color: AllColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 4.h),

                Text(
                  product.categories?.join(', ') ?? LocaleKeys.food.tr(),
                  style: tm14.copyWith(
                    color: AllColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 12.h),

                _buildNutriScore(),
              ],
            ),
          ),

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

  Row _buildNutriScore() {
    return Row(
      children: [
        Text(
          LocaleKeys.nutriScore.tr(),
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

  NutriScoreWidget _buildNutriScoreBar() {
    return NutriScoreWidget(
      grade: product.nutriScoreGrade ?? 'e',
      width: 100.w,
      height: 30.h,
    );
  }

  Container _buildFoodScoreSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Color(0xFFE8F4FD),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.foodScore.tr(),
                    style: tb16.copyWith(
                      color: AllColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    LocaleKeys.overallFoodHealthRatingSystem.tr(),
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

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.nutriScore.tr(),
                      style: tb16.copyWith(
                        color: AllColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      LocaleKeys.highNutritionalValueLowNutritionalValue.tr(),
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
                        LocaleKeys.nova.tr(),
                        style: tb16.copyWith(
                          color: AllColors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        LocaleKeys.processed.tr(),
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
              Icon(Icons.eco, color: AllColors.green, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Healthier Alternatives',
                style: tb16.copyWith(
                  color: AllColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            LocaleKeys.viewMore.tr(),
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
          height: 110.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: alternativeProducts!.take(9).length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final altProduct = alternativeProducts![index];
              return SizedBox(
                width: 250.w,
                child: ProductCardStyles.alternativeProduct(
                  product: altProduct,
                  alternativeNumber: index + 1,
                  onTap: () {
                    // Navigate to product detail
                  },
                  onFavoriteTap: () {
                    // Handle favorite
                  },
                ),
              );
            },
          ),
        )
      else
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Text(
            'No healthier alternatives found',
            style: tm14.copyWith(color: AllColors.grey),
          ),
        ),
    ];
  }

  Container _buildCountryRatingsSection() {
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

  Row _buildCountryRating(String country, String grade, String flag) {
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

  Container _buildAISummarySection() {
    return Container(
      width: double.infinity,
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
            aiSummary ?? 'No AI summary available for this product',
            style: tm14.copyWith(color: AllColors.black, height: 1.5),
          ),
        ],
      ),
    );
  }

  Container _buildImagePlaceholder() {
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

          _buildNutritionGrid(),
        ],
      ),
    );
  }

  Widget _buildNutritionGrid() {
    final nutriments = product.nutriments ?? {};
    final nutritionItems = <Map<String, dynamic>>[];

    // Display ALL available nutrition data from the product
    if (nutriments.isNotEmpty) {
      // Priority nutrients to show first
      final priorityNutrients = [
        'energy-kcal',
        'energy-kj',
        'proteins',
        'protein',
        'carbohydrates',
        'sugars',
        'fat',
        'saturated-fat',
        'fiber',
        'salt',
        'sodium',
      ];

      // Add priority nutrients first
      for (final key in priorityNutrients) {
        if (nutriments.containsKey(key)) {
          final value = nutriments[key];
          if (value != null) {
            nutritionItems.add({
              'name': _getNutrientDisplayName(key),
              'value': value.toString(),
              'unit': _getNutrientUnit(key),
              'color': _getNutrientColor(key, value),
            });
          }
        }
      }

      // Add any remaining nutrients
      for (final entry in nutriments.entries) {
        if (!priorityNutrients.contains(entry.key) && entry.value != null) {
          nutritionItems.add({
            'name': _getNutrientDisplayName(entry.key),
            'value': entry.value.toString(),
            'unit': _getNutrientUnit(entry.key),
            'color': AllColors.blue,
          });
        }
      }
    }

    if (nutritionItems.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Text(
            'No nutrition data available',
            style: tm14.copyWith(color: AllColors.grey),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.7,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: nutritionItems.length,
      itemBuilder: (context, index) {
        final item = nutritionItems[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item['name'],
                      style: tm12.copyWith(color: AllColors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant, color: AllColors.green, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                LocaleKeys.ingredients.tr(),
                style: tb16.copyWith(
                  color: AllColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          if (product.ingredients != null && product.ingredients!.isNotEmpty)
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
                              ingredient.text ??
                                  LocaleKeys.unknownIngredient.tr(),
                              style: tm14.copyWith(color: AllColors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )
          else
            Text(
              'No ingredients available',
              style: tm14.copyWith(color: AllColors.grey),
            ),
        ],
      ),
    );
  }

  String _getNutrientDisplayName(String nutrient) {
    // Convert API nutrient keys to display names
    final nameMap = {
      'energy-kcal': 'Energy',
      'energy-kj': 'Energy',
      'proteins': 'Protein',
      'protein': 'Protein',
      'carbohydrates': 'Carbs',
      'sugars': 'Sugars',
      'fat': 'Fat',
      'saturated-fat': 'Saturated Fat',
      'fiber': 'Fiber',
      'salt': 'Salt',
      'sodium': 'Sodium',
      'cholesterol': 'Cholesterol',
      'calcium': 'Calcium',
      'iron': 'Iron',
      'vitamin-a': 'Vitamin A',
      'vitamin-c': 'Vitamin C',
      'vitamin-d': 'Vitamin D',
      'vitamin-e': 'Vitamin E',
      'vitamin-b1': 'Vitamin B1',
      'vitamin-b2': 'Vitamin B2',
      'vitamin-b6': 'Vitamin B6',
      'vitamin-b12': 'Vitamin B12',
    };

    return nameMap[nutrient] ??
        nutrient.replaceAll('-', ' ').replaceAll('_', ' ');
  }

  String _getNutrientUnit(String nutrient) {
    switch (nutrient) {
      case 'protein':
      case 'proteins':
      case 'carbohydrates':
      case 'sugars':
      case 'fat':
      case 'saturated-fat':
      case 'fiber':
      case 'salt':
      case 'sodium':
        return 'g';
      case 'energy-kcal':
        return 'kcal';
      case 'energy-kj':
        return 'kJ';
      case 'cholesterol':
      case 'calcium':
      case 'iron':
        return 'mg';
      case 'vitamin-a':
      case 'vitamin-c':
      case 'vitamin-d':
      case 'vitamin-e':
        return 'IU';
      case 'vitamin-b1':
      case 'vitamin-b2':
      case 'vitamin-b6':
      case 'vitamin-b12':
        return 'mg';
      default:
        return '';
    }
  }

  Color _getNutrientColor(String nutrient, dynamic value) {
    final numValue = double.tryParse(value.toString()) ?? 0;

    switch (nutrient) {
      case 'protein':
      case 'proteins':
        return numValue > 10
            ? AllColors.green
            : numValue > 5
            ? Colors.orange
            : AllColors.red;
      case 'salt':
      case 'sodium':
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
      case 'saturated-fat':
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
      case 'fiber':
        return numValue > 3
            ? AllColors.green
            : numValue > 1
            ? Colors.orange
            : AllColors.red;
      default:
        return AllColors.blue;
    }
  }
}
