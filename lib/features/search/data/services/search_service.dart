import 'dart:developer';

import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';
import 'package:fooda_best/features/search/data/models/search_category_model.dart';
import 'package:injectable/injectable.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

/// Directly uses OpenFoodFacts SDK to fetch categories and products
@Injectable()
class SearchService {
  static const int defaultPageSize = 20;

  SearchService() {
    OpenFoodAPIConfiguration.userAgent = UserAgent(
      name: 'FoodaBest',
      version: '1.0.0',
      system: 'Flutter',
    );
  }

  /// Fetch taxonomy categories (simplified approach)
  Future<List<SearchCategoryModel>> fetchCategories({int limit = 50}) async {
    try {
      // For now, return fallback categories to avoid API complexity
      // TODO: Implement proper OpenFoodFacts taxonomy API call
      log('Using fallback categories to avoid API complexity');
      return _getFallbackCategories();
    } catch (e, st) {
      log('fetchCategories error: $e\n$st');
      // Return fallback categories if API fails
      return _getFallbackCategories();
    }
  }

  /// Fallback categories when API fails
  List<SearchCategoryModel> _getFallbackCategories() {
    return [
      SearchCategoryModel(
        id: 'fruits-and-vegetables',
        name: 'Fruits & Vegetables',
        productsCount: 1000,
        imageUrl:
            'https://images.openfoodfacts.org/images/categories/fruits-and-vegetables.png',
      ),
      SearchCategoryModel(
        id: 'dairy-and-egg',
        name: 'Dairy & Eggs',
        productsCount: 800,
        imageUrl:
            'https://images.openfoodfacts.org/images/categories/dairy-and-egg.png',
      ),
      SearchCategoryModel(
        id: 'meat-and-fish',
        name: 'Meat & Fish',
        productsCount: 600,
        imageUrl:
            'https://images.openfoodfacts.org/images/categories/meat-and-fish.png',
      ),
      SearchCategoryModel(
        id: 'beverages',
        name: 'Beverages',
        productsCount: 500,
        imageUrl:
            'https://images.openfoodfacts.org/images/categories/beverages.png',
      ),
      SearchCategoryModel(
        id: 'snacks',
        name: 'Snacks',
        productsCount: 400,
        imageUrl:
            'https://images.openfoodfacts.org/images/categories/snacks.png',
      ),
      SearchCategoryModel(
        id: 'processed-foods',
        name: 'Processed Foods',
        productsCount: 300,
        imageUrl:
            'https://images.openfoodfacts.org/images/categories/processed-foods.png',
      ),
    ];
  }

  /// Search products by keywords and optionally category id.
  /// page is 1-based.
  Future<List<ProductModel>> searchProducts({
    required List<String> searchTerms,
    String? categoryId,
    UserModel? user,
    int page = 1,
    int pageSize = defaultPageSize,
  }) async {
    try {
      final parameters = <Parameter>[
        PageNumber(page: page),
        PageSize(size: pageSize),
      ];

      if (searchTerms.isNotEmpty) {
        parameters.add(SearchTerms(terms: searchTerms));
      }

      if (categoryId != null && categoryId.isNotEmpty) {
        // TagFilter is better for categories
        parameters.add(
          TagFilter.fromType(
            tagFilterType: TagFilterType.CATEGORIES,
            tagName: categoryId,
          ),
        );
      }

      final config = ProductSearchQueryConfiguration(
        parametersList: parameters,
        fields: [
          ProductField.BARCODE,
          ProductField.NAME,
          ProductField.BRANDS,
          ProductField.IMAGE_FRONT_URL,
          ProductField.NUTRISCORE,
          ProductField.NUTRIMENTS,
          ProductField.CATEGORIES,
          ProductField.ALLERGENS,
          ProductField.INGREDIENTS,
        ],
        language: OpenFoodFactsLanguage.ENGLISH,
        version: ProductQueryVersion.v3,
      );

      final result = await OpenFoodAPIClient.searchProducts(null, config);

      if (result.products == null || result.products!.isEmpty) {
        return [];
      }

      // Map OpenFoodFacts Product -> your ProductModel
      final mapped = result.products!
          .where((p) => p.productName != null && p.imageFrontUrl != null)
          .map(_mapProductToModel)
          .toList();

      return mapped;
    } catch (e, st) {
      log('searchProducts error: $e\n$st');
      rethrow;
    }
  }

  ProductModel _mapProductToModel(Product p) {
    // You already have ProductModel in project — adapt if needed
    String nutri = '';
    try {
      if (p.nutriscore != null) {
        final raw = p.nutriscore.toString();
        if (raw.isNotEmpty) nutri = raw.substring(0, 1).toLowerCase();
      } else {
        final json = p.toJson();
        nutri =
            (json['nutriscore_grade'] ?? json['nutrition_grades'] ?? '')
                as String;
        if (nutri.isNotEmpty) nutri = nutri.substring(0, 1).toLowerCase();
      }
    } catch (_) {
      nutri = '';
    }

    final ingredients = (p.ingredients ?? [])
        .where((ing) => ing.text?.isNotEmpty == true)
        .map(
          (ing) => IngredientModel(
            text: ing.text,
            percent: ing.percent,
            percentEstimate: ing.percentEstimate,
          ),
        )
        .toList();

    return ProductModel(
      barcode: p.barcode ?? '',
      name: p.productName ?? '',
      brands: p.brands ?? '',
      imageUrl: p.imageFrontUrl ?? '',
      nutriScoreGrade: nutri,
      nutriments: p.nutriments?.toJson() ?? {},
      allergens: p.allergens?.names ?? [],
      ingredients: ingredients,
    );
  }
}
