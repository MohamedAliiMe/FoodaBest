import 'package:flutter/material.dart';
import 'package:fooda_best/core/widgets/product_card.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ProductCardStyles.analysisResult(
      product: product,
      onTap: () {
        // Handle product tap
      },
      onFavoriteTap: () {
        // Handle favorite tap
      },
    );
  }
}
