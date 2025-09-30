// import 'dart:developer';

// import 'package:fooda_best/core/data/single_item_base_response/single_item_base_response.dart';
// import 'package:fooda_best/core/networking/data_state.dart';
// import 'package:fooda_best/core/networking/network_utils.dart';
// import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
// import 'package:fooda_best/features/product_analysis/data/models/analysis_model.dart';
// import 'package:fooda_best/features/product_analysis/data/models/product_model.dart';
// import 'package:fooda_best/features/product_analysis/data/services/product_analysis_service.dart';
// import 'package:injectable/injectable.dart';

// @Injectable()
// class ProductAnalysisRepository {
//   final ProductAnalysisService _service;

//   // Set to true to prevent real API calls during development
//   final bool _devMode = true;

//   ProductAnalysisRepository(this._service);

//   /// Get product by barcode from OpenFoodFacts
//   Future<DataState<SingleItemBaseResponse<ProductModel>>> getProductByBarcode({
//     required String barcode,
//   }) {
//     final NetworkUtils<SingleItemBaseResponse<ProductModel>> networkUtils =
//         NetworkUtils();
//     return networkUtils.handleApiResponse(
//       _service.getProductByBarcode(barcode),
//     );
//   }

//   /// Mock method for development - will be replaced with real API
//   Future<ProductModel?> getProductByBarcodeForDev(String barcode) async {
//     // Return mock data for development
//     log('DEV MODE: Returning mock product data for barcode: $barcode');
//     await Future.delayed(const Duration(seconds: 1)); // Simulate API delay

//     return ProductModel(
//       barcode: barcode,
//       name: 'Mock Product ${barcode.substring(barcode.length - 4)}',
//       brands: 'Mock Brand',
//       imageUrl: 'https://via.placeholder.com/300x300?text=Product',
//       nutriScoreGrade: 'c',
//       categories: ['Mock Category', 'Test Food'],
//       ingredients: [
//         IngredientModel(
//           id: 'mock-ingredient-1',
//           text: 'Mock Ingredient 1',
//           percent: 45.0,
//           percentEstimate: 45.0,
//           rank: 1,
//         ),
//         IngredientModel(
//           id: 'mock-ingredient-2',
//           text: 'Mock Ingredient 2',
//           percent: 30.0,
//           percentEstimate: 30.0,
//           rank: 2,
//         ),
//       ],
//       allergens: ['Gluten', 'Milk'],
//       nutriments: {
//         'energy': 2000,
//         'fat': 15.0,
//         'saturated-fat': 8.0,
//         'carbohydrates': 60.0,
//         'sugars': 25.0,
//         'proteins': 8.0,
//         'salt': 1.2,
//       },
//       traces: ['Nuts', 'Soy'],
//       labels: ['Organic', 'Fair Trade'],
//     );
//   }

//   /// Analyze product using AI
//   Future<DataState<SingleItemBaseResponse<AnalysisModel>>> analyzeProduct({
//     required ProductModel product,
//     required UserModel userProfile,
//     String? locale,
//   }) {
//     final NetworkUtils<SingleItemBaseResponse<AnalysisModel>> networkUtils =
//         NetworkUtils();

//     final analysisRequest = {
//       'product': product.toJson(),
//       'userProfile': {
//         'firstName': userProfile.firstName,
//         'lastName': userProfile.lastName,
//         // Add other user fields as needed
//       },
//       'locale': locale ?? 'en',
//     };

//     return networkUtils.handleApiResponse(
//       _service.analyzeProduct(analysisRequest),
//     );
//   }

//   /// Mock method for development - will be replaced with real AI API
//   Future<AnalysisModel> analyzeProductForDev(
//     ProductModel product,
//     UserModel userProfile, {
//     String? locale,
//   }) async {
//     if (_devMode) {
//       // Return mock analysis for development
//       log('DEV MODE: Returning mock analysis for product: ${product.name}');
//       await Future.delayed(
//         const Duration(seconds: 2),
//       ); // Simulate AI processing

//       return AnalysisModel(
//         summary:
//             'This is a mock analysis for ${product.name}. The product contains some concerning ingredients but is generally safe for consumption.',
//         safetyStatus: 'yellow',
//         detectedAllergens: product.allergens ?? [],
//         alternativeIngredients: [
//           'Alternative Ingredient 1',
//           'Alternative Ingredient 2',
//         ],
//         analysisTime: DateTime.now().toIso8601String(),
//         warnings: ['High sugar content', 'Contains artificial preservatives'],
//       );
//     }

//     try {
//       log('Repository: Analyzing product with OpenAI: ${product.name}');

//       // TODO: Implement real OpenAI API call
//       // final prompt = _buildAnalysisPrompt(product, userProfile, locale);
//       // final body = {
//       //   'model': 'gpt-3.5-turbo',
//       //   'messages': [
//       //     {'role': 'user', 'content': prompt}
//       //   ],
//       //   'max_tokens': 1000,
//       //   'temperature': 0.7,
//       // };

//       // final response = await _service.analyzeProductWithAI(
//       //   body,
//       //   'Bearer $_openAIApiKey',
//       //   'application/json',
//       // );

//       // return _parseOpenAIResponse(response.data);

//       return AnalysisModel.empty(); // Placeholder for real implementation
//     } catch (e) {
//       log('Repository: Error analyzing product: $e');
//       return AnalysisModel(
//         summary: 'Error analyzing product: $e',
//         safetyStatus: 'red',
//         detectedAllergens: const [],
//         alternativeIngredients: const [],
//         analysisTime: DateTime.now().toIso8601String(),
//         warnings: const ['Analysis failed'],
//       );
//     }
//   }

//   /// Search for alternative products using NetworkUtils pattern
//   Future<DataState<Map<String, dynamic>>> searchAlternativeProducts({
//     required List<String> ingredients,
//     required UserModel userProfile,
//   }) {
//     final NetworkUtils<Map<String, dynamic>> networkUtils = NetworkUtils();

//     final searchTerms = ingredients.join(' ');

//     return networkUtils.handleApiResponse(
//       _service.searchProducts(
//         searchTerms,
//         1, // search_simple
//         'process', // action
//         1, // json
//         20, // page_size
//       ),
//     );
//   }

//   /// Mock method for development
//   Future<List<ProductModel>> searchAlternativeProductsForDev(
//     List<String> ingredients,
//     UserModel userProfile,
//   ) async {
//     if (_devMode) {
//       // Return mock alternatives for development
//       log('DEV MODE: Returning mock alternative products');
//       await Future.delayed(const Duration(seconds: 1)); // Simulate search delay

//       return [
//         ProductModel(
//           barcode: 'ALT001',
//           name: 'Healthy Alternative 1',
//           brands: 'Health Brand',
//           imageUrl: 'https://via.placeholder.com/300x300?text=Alt1',
//           nutriScoreGrade: 'a',
//           categories: const ['Healthy Food'],
//         ),
//         ProductModel(
//           barcode: 'ALT002',
//           name: 'Organic Alternative 2',
//           brands: 'Organic Brand',
//           imageUrl: 'https://via.placeholder.com/300x300?text=Alt2',
//           nutriScoreGrade: 'b',
//           categories: const ['Organic Food'],
//         ),
//       ];
//     }

//     try {
//       log('Repository: Searching for alternative products');

//       // TODO: Implement real alternative search logic
//       // This could involve:
//       // 1. Searching OpenFoodFacts for products without problematic ingredients
//       // 2. Using a recommendation service
//       // 3. Filtering by user preferences

//       return []; // Placeholder for real implementation
//     } catch (e) {
//       log('Repository: Error searching for alternatives: $e');
//       return [];
//     }
//   }
// }

// // import 'dart:developer';

// // import 'package:fooda_best/core/data/single_item_base_response/single_item_base_response.dart';
// // import 'package:fooda_best/core/networking/data_state.dart';
// // import 'package:fooda_best/core/networking/network_utils.dart';
// // import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
// // import 'package:fooda_best/features/product_analysis/data/models/analysis_model.dart';
// // import 'package:fooda_best/features/product_analysis/data/models/product_model.dart';
// // import 'package:fooda_best/features/product_analysis/data/services/product_analysis_service.dart';
// // import 'package:injectable/injectable.dart';

// // @Injectable()
// // class ProductAnalysisRepository {
// //   final ProductAnalysisService _service;

// //   // Set to false to use real OpenFoodFacts API
// //   final bool _devMode = false;

// //   ProductAnalysisRepository(this._service);

// //   /// Get product by barcode from OpenFoodFacts
// //   Future<DataState<SingleItemBaseResponse<ProductModel>>> getProductByBarcode({
// //     required String barcode,
// //   }) {
// //     final NetworkUtils<SingleItemBaseResponse<ProductModel>> networkUtils = NetworkUtils();
// //     return networkUtils.handleApiResponse(
// //       _service.getProductByBarcode(barcode),
// //     );
// //   }

// //   /// Get real product data from OpenFoodFacts API
// //   Future<DataState<ProductModel>?> getProductByBarcodeForDev(
// //     String barcode,
// //   ) async {
// //     log(
// //       '🌐 REAL API: Fetching product data from OpenFoodFacts for barcode: $barcode',
// //     );

// //     try {
// //       // Use real OpenFoodFacts API
// //       log('🌐 REAL API: Making request to OpenFoodFacts for barcode: $barcode');
// //       final response = await _service.getProductByBarcode(barcode);
// //       final data = response.data;

// //       log(
// //         '🌐 REAL API: OpenFoodFacts response received (Status: ${response.response.statusCode})',
// //       );
// //       log('📊 RAW API DATA: ${data.toString()}');

// //       // Check if product exists in OpenFoodFacts
// //       if (data.success == true && data.data != null) {
// //         final productData = data.data;
// //         log('✅ REAL API: Product found in OpenFoodFacts database');

// //         // Parse OpenFoodFacts data to our ProductModel
// //         final product = ProductModel(
// //           barcode: productData.code ?? barcode,
// //           name: productData.productName ?? productData.productNameEn,
// //           brands: productData.brands,
// //           imageUrl: productData.imageUrl ?? productData.imageFrontUrl,
// //           nutriScoreGrade: productData.nutriscoreGrade,
// //           categories: _parseCategories(productData.categories),
// //           ingredients: _parseIngredients(productData['ingredients']),
// //           allergens: _parseAllergens(productData['allergens_tags']),
// //           nutriments: productData['nutriments'],
// //           traces: _parseTraces(productData['traces_tags']),
// //           labels: _parseLabels(productData['labels_tags']),
// //         );

// //         log('📦 REAL PRODUCT DATA:');
// //         log('   Barcode: ${product.barcode}');
// //         log('   Name: ${product.name}');
// //         log('   Brands: ${product.brands}');
// //         log('   NutriScore: ${product.nutriScoreGrade}');
// //         log('   Categories: ${product.categories}');
// //         log('   Allergens: ${product.allergens}');
// //         log(
// //           '   Ingredients: ${product.ingredients?.map((i) => '${i.text} (${i.percent}%)').join(', ')}',
// //         );
// //         log('   Nutriments: ${product.nutriments}');
// //         log('   Traces: ${product.traces}');
// //         log('   Labels: ${product.labels}');

// //         return DataSuccess(product);
// //       } else {
// //         log(
// //           '❌ REAL API: Product not found in OpenFoodFacts database',
// //         );
// //         return DataFailed(
// //           'Product not found in our database. This barcode may not be registered in OpenFoodFacts yet.',
// //         );
// //       }
// //     } catch (e) {
// //       log('❌ REAL API: Error fetching product: $e');
// //       // Fallback to mock data if API fails
// //       log('🔄 FALLBACK: Using mock data due to API error');
// //       return DataFailed('Error fetching product: $e');
// //     }
// //   }

// //   /// Analyze product using AI
// //   Future<DataState<SingleItemBaseResponse<AnalysisModel>>> analyzeProduct({
// //     required ProductModel product,
// //     required UserModel userProfile,
// //     String? locale,
// //   }) {
// //     final NetworkUtils<SingleItemBaseResponse<AnalysisModel>> networkUtils =
// //         NetworkUtils();

// //     final analysisRequest = {
// //       'product': product.toJson(),
// //       'userProfile': {
// //         'firstName': userProfile.firstName,
// //         'lastName': userProfile.lastName,
// //         // Add other user fields as needed
// //       },
// //       'locale': locale ?? 'en',
// //     };

// //     return networkUtils.handleApiResponse(
// //       _service.analyzeProduct(analysisRequest),
// //     );
// //   }

// //   /// Mock method for development - will be replaced with real AI API
// //   Future<AnalysisModel> analyzeProductForDev(
// //     ProductModel product,
// //     UserModel userProfile, {
// //     String? locale,
// //   }) async {
// //     if (_devMode) {
// //       // Return mock analysis for development
// //       log('DEV MODE: Returning mock analysis for product: ${product.name}');
// //       await Future.delayed(
// //         const Duration(seconds: 2),
// //       ); // Simulate AI processing

// //       return AnalysisModel(
// //         summary:
// //             'This is a mock analysis for ${product.name}. The product contains some concerning ingredients but is generally safe for consumption.',
// //         safetyStatus: 'yellow',
// //         detectedAllergens: product.allergens ?? [],
// //         alternativeIngredients: [
// //           'Alternative Ingredient 1',
// //           'Alternative Ingredient 2',
// //         ],
// //         analysisTime: DateTime.now().toIso8601String(),
// //         warnings: ['High sugar content', 'Contains artificial preservatives'],
// //       );
// //     }

// //     try {
// //       log('Repository: Analyzing product with OpenAI: ${product.name}');

// //       // TODO: Implement real OpenAI API call
// //       // final prompt = _buildAnalysisPrompt(product, userProfile, locale);
// //       // final body = {
// //       //   'model': 'gpt-3.5-turbo',
// //       //   'messages': [
// //       //     {'role': 'user', 'content': prompt}
// //       //   ],
// //       //   'max_tokens': 1000,
// //       //   'temperature': 0.7,
// //       // };

// //       // final response = await _service.analyzeProductWithAI(
// //       //   body,
// //       //   'Bearer $_openAIApiKey',
// //       //   'application/json',
// //       // );

// //       // return _parseOpenAIResponse(response.data);

// //       return AnalysisModel.empty(); // Placeholder for real implementation
// //     } catch (e) {
// //       log('Repository: Error analyzing product: $e');
// //       return AnalysisModel(
// //         summary: 'Error analyzing product: $e',
// //         safetyStatus: 'red',
// //         detectedAllergens: const [],
// //         alternativeIngredients: const [],
// //         analysisTime: DateTime.now().toIso8601String(),
// //         warnings: const ['Analysis failed'],
// //       );
// //     }
// //   }

// //   /// Search for alternative products using NetworkUtils pattern
// //   Future<DataState<Map<String, dynamic>>> searchAlternativeProducts({
// //     required List<String> ingredients,
// //     required UserModel userProfile,
// //   }) {
// //     final NetworkUtils<Map<String, dynamic>> networkUtils = NetworkUtils();

// //     final searchTerms = ingredients.join(' ');

// //     return networkUtils.handleApiResponse(
// //       _service.searchProducts(
// //         searchTerms,
// //         1, // search_simple
// //         'process', // action
// //         1, // json
// //         20, // page_size
// //       ),
// //     );
// //   }

// //   /// Mock method for development
// //   Future<List<ProductModel>> searchAlternativeProductsForDev(
// //     List<String> ingredients,
// //     UserModel userProfile,
// //   ) async {
// //     if (_devMode) {
// //       // Return mock alternatives for development
// //       log('DEV MODE: Returning mock alternative products');
// //       await Future.delayed(const Duration(seconds: 1)); // Simulate search delay

// //       return [
// //         ProductModel(
// //           barcode: 'ALT001',
// //           name: 'Healthy Alternative 1',
// //           brands: 'Health Brand',
// //           imageUrl: 'https://via.placeholder.com/300x300?text=Alt1',
// //           nutriScoreGrade: 'a',
// //           categories: const ['Healthy Food'],
// //         ),
// //         ProductModel(
// //           barcode: 'ALT002',
// //           name: 'Organic Alternative 2',
// //           brands: 'Organic Brand',
// //           imageUrl: 'https://via.placeholder.com/300x300?text=Alt2',
// //           nutriScoreGrade: 'b',
// //           categories: const ['Organic Food'],
// //         ),
// //       ];
// //     }

// //     try {
// //       log('Repository: Searching for alternative products');

// //       // TODO: Implement real alternative search logic
// //       // This could involve:
// //       // 1. Searching OpenFoodFacts for products without problematic ingredients
// //       // 2. Using a recommendation service
// //       // 3. Filtering by user preferences

// //       return []; // Placeholder for real implementation
// //     } catch (e) {
// //       log('Repository: Error searching for alternatives: $e');
// //       return [];
// //     }
// //   }

// //   // Helper methods for parsing OpenFoodFacts data
// //   List<String> _parseCategories(dynamic categories) {
// //     if (categories == null) return [];
// //     if (categories is String) {
// //       return categories.split(',').map((e) => e.trim()).toList();
// //     }
// //     if (categories is List) {
// //       return categories.map((e) => e.toString()).toList();
// //     }
// //     return [];
// //   }

// //   List<IngredientModel> _parseIngredients(dynamic ingredients) {
// //     if (ingredients == null || ingredients is! List) return [];

// //     return ingredients.map((ingredient) {
// //       return IngredientModel(
// //         id: ingredient['id']?.toString(),
// //         text: ingredient['text']?.toString(),
// //         percent: ingredient['percent_estimate']?.toDouble(),
// //         percentEstimate: ingredient['percent_estimate']?.toDouble(),
// //         rank: ingredient['rank'],
// //       );
// //     }).toList();
// //   }

// //   List<String> _parseAllergens(dynamic allergens) {
// //     if (allergens == null || allergens is! List) return [];
// //     return allergens
// //         .map((allergen) => allergen.toString().replaceAll('en:', ''))
// //         .toList();
// //   }

// //   List<String> _parseTraces(dynamic traces) {
// //     if (traces == null || traces is! List) return [];
// //     return traces
// //         .map((trace) => trace.toString().replaceAll('en:', ''))
// //         .toList();
// //   }

// //   List<String> _parseLabels(dynamic labels) {
// //     if (labels == null || labels is! List) return [];
// //     return labels
// //         .map((label) => label.toString().replaceAll('en:', ''))
// //         .toList();
// //   }
// // }
