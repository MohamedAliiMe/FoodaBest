import 'package:fooda_best/core/networking/data_state.dart';
import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/product_analysis/data/models/analysis_model/analysis_model.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';
import 'package:fooda_best/features/product_analysis/data/services/product_analysis_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ProductAnalysisRepository {
  final ProductAnalysisService _service;

  ProductAnalysisRepository(this._service);

  Future<DataState<ProductModel>> getProductByBarcode({
    required String barcode,
  }) async {
    try {
      final ProductModel? product = await _service.getProductByBarcode(barcode);

      if (product != null) {
        // Convert Open Food Facts Product to our ProductModel
        final ProductModel productModel = ProductModel(
          barcode: product.barcode,
          name: product.name,
          brands: product.brands,
          imageUrl: product.imageUrl,
          nutriScoreGrade: product.nutriScoreGrade,
          categories: product.categories
              ?.map((e) => e.trim())
              .map((e) => e.trim())
              .toList(),
          ingredients: product.ingredients
              ?.map(
                (ingredient) => IngredientModel(
                  id: ingredient.id,
                  text: ingredient.text,
                  percent: ingredient.percent,
                  percentEstimate: ingredient.percentEstimate,
                  rank: ingredient.rank,
                ),
              )
              .toList(),
          allergens: product.allergens,
          nutriments: product.nutriments,
          traces: product.traces?.map((e) => e.trim()).toList(),
          labels: product.labels?.map((e) => e.trim()).toList(),
        );

        return DataSuccess(productModel);
      } else {
        return DataFailed('Product not found');
      }
    } catch (e) {
      return DataFailed('Error fetching product: $e');
    }
  }

  Future<DataState<AnalysisModel>> analyzeProduct({
    required ProductModel product,
    required UserModel userProfile,
    String? locale,
  }) async {
    try {
      // Generate alternative ingredients based on product categories and ingredients
      List<String> alternativeIngredients = [];

      // Add category-based alternatives - search for same product type
      if (product.categories != null) {
        for (final category in product.categories!) {
          if (category.toLowerCase().contains('cheese')) {
            alternativeIngredients.addAll([
              'low fat cheese',
              'organic cheese',
              'goat cheese',
              'feta cheese',
            ]);
          } else if (category.toLowerCase().contains('chocolate')) {
            alternativeIngredients.addAll([
              'dark chocolate',
              'organic chocolate',
              'sugar free chocolate',
              'cacao',
            ]);
          } else if (category.toLowerCase().contains('bread')) {
            alternativeIngredients.addAll([
              'whole grain bread',
              'sourdough bread',
              'gluten free bread',
              'organic bread',
            ]);
          } else if (category.toLowerCase().contains('snack')) {
            alternativeIngredients.addAll([
              'healthy snacks',
              'organic snacks',
              'low calorie',
            ]);
          } else if (category.toLowerCase().contains('drink')) {
            alternativeIngredients.addAll([
              'natural drinks',
              'low sugar',
              'organic',
            ]);
          } else if (category.toLowerCase().contains('cereal')) {
            alternativeIngredients.addAll([
              'whole grain',
              'organic cereal',
              'low sugar',
            ]);
          } else if (category.toLowerCase().contains('milk')) {
            alternativeIngredients.addAll([
              'almond milk',
              'oat milk',
              'coconut milk',
              'organic milk',
            ]);
          } else if (category.toLowerCase().contains('yogurt')) {
            alternativeIngredients.addAll([
              'greek yogurt',
              'organic yogurt',
              'plant based yogurt',
              'low sugar yogurt',
            ]);
          }
        }
      }

      // Add ingredient-based alternatives with health focus
      if (product.ingredients != null) {
        for (final ingredient in product.ingredients!) {
          final ingredientText = ingredient.text?.toLowerCase() ?? '';

          if (ingredientText.contains('sugar')) {
            alternativeIngredients.addAll([
              'stevia',
              'honey',
              'maple syrup',
              'coconut sugar',
            ]);
          }
          if (ingredientText.contains('salt')) {
            alternativeIngredients.addAll([
              'sea salt',
              'himalayan salt',
              'low sodium',
              'herbs',
            ]);
          }
          if (ingredientText.contains('artificial')) {
            alternativeIngredients.addAll([
              'natural',
              'organic',
              'pure',
              'whole food',
            ]);
          }
          if (ingredientText.contains('oil')) {
            alternativeIngredients.addAll([
              'olive oil',
              'coconut oil',
              'avocado oil',
              'cold pressed',
            ]);
          }
          if (ingredientText.contains('flour')) {
            alternativeIngredients.addAll([
              'whole grain',
              'almond flour',
              'coconut flour',
              'quinoa flour',
            ]);
          }
          if (ingredientText.contains('preservative')) {
            alternativeIngredients.addAll([
              'natural preservatives',
              'vitamin e',
              'citric acid',
              'rosemary extract',
            ]);
          }
        }
      }

      // Add product name-based alternatives
      if (product.name != null) {
        final productName = product.name!.toLowerCase();

        if (productName.contains('chocolate') ||
            productName.contains('cocoa') ||
            productName.contains('شوكولاتة')) {
          alternativeIngredients.addAll([
            'dark chocolate',
            'organic chocolate',
            'sugar free chocolate',
            'cacao powder',
          ]);
        } else if (productName.contains('cheese') ||
            productName.contains('جبنة') ||
            productName.contains('جبن')) {
          alternativeIngredients.addAll([
            'low fat cheese',
            'organic cheese',
            'goat cheese',
            'feta cheese',
            'cottage cheese',
            'ricotta cheese',
          ]);
        } else if (productName.contains('bread') ||
            productName.contains('خبز') ||
            productName.contains('عيش')) {
          alternativeIngredients.addAll([
            'whole grain bread',
            'sourdough bread',
            'gluten free bread',
            'organic bread',
          ]);
        } else if (productName.contains('milk') ||
            productName.contains('حليب')) {
          alternativeIngredients.addAll([
            'almond milk',
            'oat milk',
            'coconut milk',
            'organic milk',
          ]);
        } else if (productName.contains('yogurt') ||
            productName.contains('زبادي')) {
          alternativeIngredients.addAll([
            'greek yogurt',
            'organic yogurt',
            'plant based yogurt',
            'low sugar yogurt',
          ]);
        } else if (productName.contains('butter') ||
            productName.contains('زبدة')) {
          alternativeIngredients.addAll([
            'organic butter',
            'plant butter',
            'coconut butter',
            'almond butter',
          ]);
        }
      }

      // Add default alternatives if none found
      if (alternativeIngredients.isEmpty) {
        alternativeIngredients = [
          'organic',
          'natural',
          'healthy',
          'low sugar',
          'low sodium',
          'whole grain',
          'plant-based',
          'superfood',
          'antioxidant',
          'probiotic',
        ];
      }

      final AnalysisModel analysis = AnalysisModel(
        summary: 'Product analysis for ${product.name}',
        safetyStatus: 'green',
        detectedAllergens: [],
        alternativeIngredients: alternativeIngredients,
        analysisTime: DateTime.now().toIso8601String(),
        warnings: [],
      );

      return DataSuccess(analysis);
    } catch (e) {
      return DataFailed('Error analyzing product: $e');
    }
  }

  Future<DataState<List<ProductModel>>> searchAlternativeProducts({
    required List<String> ingredients,
    required UserModel userProfile,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final List<ProductModel> products = await _service
          .searchAlternativeProducts(ingredients, userProfile: userProfile);

      // Convert Open Food Facts Products to our ProductModels
      final List<ProductModel> productModels = products
          .map(
            (product) => ProductModel(
              barcode: product.barcode,
              name: product.name,
              brands: product.brands,
              imageUrl: product.imageUrl,
              nutriScoreGrade: product.nutriScoreGrade,
              categories: product.categories
                  ?.map((e) => e.trim())
                  .map((e) => e.trim())
                  .toList(),
              ingredients: product.ingredients
                  ?.map(
                    (ingredient) => IngredientModel(
                      id: ingredient.id,
                      text: ingredient.text,
                      percent: ingredient.percent,
                      percentEstimate: ingredient.percentEstimate,
                      rank: ingredient.rank,
                    ),
                  )
                  .toList(),
              allergens: product.allergens,
              nutriments: product.nutriments,
              traces: product.traces?.map((e) => e.trim()).toList(),
              labels: product.labels?.map((e) => e.trim()).toList(),
            ),
          )
          .toList();

      return DataSuccess(productModels);
    } catch (e) {
      return DataFailed('Error searching products: $e');
    }
  }
}
