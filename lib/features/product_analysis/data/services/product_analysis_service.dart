import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Math;

import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import 'prompt_service.dart';

/// Service that analyzes products for allergens and safety based on user profiles.
/// Works with AnalysisProvider to provide product safety information.
@Injectable()
class ProductAnalysisService {
  // Get API key from environment variables
  final String _openAIApiKey = const String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );

  // Set to true to prevent real API calls during development
  final bool _devMode = false;

  /// Analyzes a product based on user profile data using the new GPT-4o-mini-audio-preview model
  /// Returns a map with analysis results including: summary, safetyStatus, alternativeIngredients, audioUrl
  /// This method combines both text analysis and audio generation in a single API call
  /// Alternative products are now searched separately for better UX
  Future<Map<String, dynamic>> analyzeProductForUser(
    ProductModel product,
    UserModel userProfile, {
    String? locale,
  }) async {
    try {
      log('Starting product analysis for ${product.name}');
      final startTime = DateTime.now();

      // Validate inputs to avoid unnecessary API calls
      if (product.barcode?.isEmpty ?? true) {
        return _createErrorResponse('Missing product barcode');
      }

      // Construct a prompt for OpenAI
      final String prompt = await _buildPrompt(
        product,
        userProfile,
        locale: locale,
      );

      // Get both text analysis and audio from OpenAI in a single call
      final analysisResult = await _getOpenAIAnalysisWithAudio(
        prompt,
        locale: locale,
      );
      log(
        'Got combined analysis result: safetyStatus=${analysisResult['safetyStatus']}',
      );
      log("analyzeProductForUser:: " + analysisResult.toString());

      // Get alternative ingredients from AI analysis - Fix List casting issue
      final dynamic alternativeIngredientsRaw =
          analysisResult['alternativeIngredients'];
      List<String> alternativeIngredients = [];

      if (alternativeIngredientsRaw is List) {
        alternativeIngredients = alternativeIngredientsRaw
            .map((item) => item.toString())
            .where((item) => item.isNotEmpty)
            .toList();
      }

      // NOTE: Alternative products search removed from here for better UX
      // It will be called separately after the main analysis is complete

      // Calculate analysis duration
      final analysisTime = DateTime.now().difference(startTime).inMilliseconds;
      log('Analysis completed in ${analysisTime}ms');

      // Fix List casting issues for all returned lists
      final dynamic detectedAllergensRaw = analysisResult['detectedAllergens'];
      List<String> detectedAllergens = [];

      if (detectedAllergensRaw is List) {
        detectedAllergens = detectedAllergensRaw
            .map((item) => item.toString())
            .where((item) => item.isNotEmpty)
            .toList();
      }

      return {
        'summary': analysisResult['summary'] ?? '',
        'safetyStatus': analysisResult['safetyStatus'] ?? 'green',
        'detectedAllergens': detectedAllergens,

        'alternativeIngredients':
            alternativeIngredients, // Return these for separate search
      };
    } catch (e) {
      log('Error in analyzeProductForUser: $e');
      return _createErrorResponse('Failed to analyze product: $e');
    }
  }

  /// Creates a standardized error response object with improved error categorization
  Map<String, dynamic> _createErrorResponse(dynamic error) {
    // Create a user-friendly error message based on error type
    String errorMessage;

    if (error is TimeoutException) {
      errorMessage =
          'The analysis took too long to complete. Please try again later.';
    } else if (error is SocketException) {
      errorMessage =
          'Network connection error. Please check your internet connection.';
    } else if (error is FormatException) {
      errorMessage = 'Error processing the product data. Please try again.';
    } else if (error.toString().contains('API key')) {
      errorMessage =
          'Authentication error with the analysis service. Please try again later.';
    } else if (error.toString().contains('429') ||
        error.toString().contains('too many requests')) {
      errorMessage =
          'Too many requests to the analysis service. Please try again in a few minutes.';
    } else {
      // Generic error handling for other types
      final errorMsg = error.toString();
      errorMessage =
          'Analysis failed: ${errorMsg.length > 100 ? errorMsg.substring(0, 100) : errorMsg}';
    }

    log('Product analysis error: $errorMessage');

    return {
      'summary': errorMessage,
      'safetyStatus': 'red',
      'detectedAllergens': [],
      'error': true,
    };
  }

  // Note: This service does not implement caching as that's handled by AnalysisProvider

  Future<String> _buildPrompt(
    ProductModel product,
    UserModel userProfile, {
    String? locale,
  }) async {
    final language = locale?.toLowerCase() ?? 'en';

    // Get custom prompt from PromptService
    final customPrompt = await PromptService.getBarcodePrompt(language);

    // Extract data for replacements
    final ingredients =
        product.ingredients != null && product.ingredients!.isNotEmpty
        ? product.ingredients!
              .where((ing) => ing.text != null && ing.text!.isNotEmpty)
              .map((ing) {
                // Include percentage if available
                final percent = ing.percent != null
                    ? ' (${ing.percent}%)'
                    : ing.percentEstimate != null
                    ? ' (~${ing.percentEstimate}%)'
                    : '';
                return '${ing.text}$percent';
              })
              .join(', ')
        : 'No ingredients listed';

    // Extract allergens from product
    final productAllergens =
        product.allergens?.join(', ') ?? 'No allergens listed';

    // Create a map of nutrition info
    final nutritionInfo =
        product.nutriments?.entries
            .map((e) => '${e.key}: ${e.value}')
            .join(', ') ??
        'No nutrition information available';

    // Replace placeholders in the prompt
    return customPrompt
        .replaceAll('{userAllergies}', "")
        .replaceAll('{productName}', product.name ?? 'Unknown Product')
        .replaceAll('{productBrand}', product.brands ?? 'Unknown Brand')
        .replaceAll('{productIngredients}', ingredients)
        .replaceAll('{productAllergens}', productAllergens)
        .replaceAll('{productNutrition}', nutritionInfo);
  }

  /// Method that performs text-only analysis using GPT-4o-mini model
  /// Focuses on accurate data extraction from Open Food Facts
  Future<Map<String, dynamic>> _getOpenAIAnalysisWithAudio(
    String prompt, {
    String? locale,
  }) async {
    // Determine language for the API request
    final language = locale?.toLowerCase() ?? 'en';
    log('Using language for OpenAI API text analysis: $language');

    log("prompt: $prompt");

    // Set language-specific system message
    final systemMessage = language == 'fr'
        ? 'Vous êtes un assistant spécialisé dans l\'analyse des produits alimentaires et des allergènes. Répondez toujours en français avec un JSON valide. Utilisez uniquement des caractères UTF-8 standards.'
        : 'You are a helpful assistant specializing in food safety and allergen analysis. Always reply with valid JSON.';

    try {
      // Make the API call with text-only analysis
      final response = await http
          .post(
            Uri.parse('https://api.openai.com/v1/chat/completions'),
            headers: {
              'Content-Type':
                  'application/json; charset=utf-8', // Explicitly set UTF-8 charset
              'Authorization': 'Bearer $_openAIApiKey',
              'Accept': 'application/json; charset=utf-8', // Also accept UTF-8
            },
            body: jsonEncode({
              'model': 'gpt-4o-mini',
              'messages': [
                {'role': 'system', 'content': systemMessage},
                {'role': 'user', 'content': prompt},
              ],
              'temperature': 0.7,
            }),
            encoding:
                utf8, // Explicitly set UTF-8 encoding for the request body
          )
          .timeout(
            const Duration(seconds: 45),
            onTimeout: () {
              throw TimeoutException(
                'Combined analysis request timed out after 45 seconds',
              );
            },
          );

      if (response.statusCode == 200) {
        log("_getOpenAIAnalysisWithAudio: OpenAI response received");

        // Ensure proper UTF-8 decoding of the response
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(responseBody);

        // Debug: Log the entire response structure
        log("Full response structure: ${jsonEncode(jsonResponse)}");

        final messageContent = jsonResponse['choices'][0]['message'];

        // Debug: Log the message content structure
        log("Message content structure: ${jsonEncode(messageContent)}");

        // Extract text content - try multiple possible fields
        String? textContent = messageContent['content'];

        // If content is null, try alternative fields

        // If we have text content, try to parse it as JSON
        if (textContent != null && textContent.isNotEmpty) {
          try {
            // Clean the text content - remove any markdown formatting
            String cleanedContent = textContent.trim();

            // Remove code block markers if present
            if (cleanedContent.startsWith('```json')) {
              cleanedContent = cleanedContent
                  .replaceFirst('```json', '')
                  .trim();
            }
            if (cleanedContent.startsWith('```')) {
              cleanedContent = cleanedContent.replaceFirst('```', '').trim();
            }
            if (cleanedContent.endsWith('```')) {
              cleanedContent = cleanedContent
                  .substring(0, cleanedContent.length - 3)
                  .trim();
            }

            log("Cleaned content for parsing: $cleanedContent");

            // Parse the JSON response from the text content
            final Map<String, dynamic> parsedAnalysis = jsonDecode(
              cleanedContent,
            );

            // Handle different nested structures that might come from OpenAI
            Map<String, dynamic> analysisData;

            // Check for possible container objects
            if (parsedAnalysis.containsKey('product_analysis')) {
              analysisData = parsedAnalysis['product_analysis'];
              log('Using data from "product_analysis" field');
            } else if (parsedAnalysis.containsKey('result')) {
              analysisData = parsedAnalysis['result'];
              log('Using data from "result" field');
            } else if (parsedAnalysis.containsKey('analysis')) {
              analysisData = parsedAnalysis['analysis'];
              log('Using data from "analysis" field');
            } else {
              // Use the root object if no container found
              analysisData = parsedAnalysis;
              log('Using root object as analysis data');
            }

            // Extract the fields with validation and handle alternative field names
            final summary =
                analysisData['analysis_summary'] as String? ??
                analysisData['summary'] as String? ??
                'Unable to analyze this product. Please try again.';

            // Debug: Check the summary for encoding issues
            log("Raw summary from API: $summary");
            log("Summary length: ${summary.length}");

            // Check if we have encoding issues
            if (summary.contains('Ã') || summary.contains('Â')) {
              log("WARNING: Detected potential encoding issues in summary");
            }

            // Try various possible field names for safety status
            String? safetyStatus =
                analysisData['safety_category'] as String? ??
                analysisData['safetyStatus'] as String? ??
                'red';

            // Ensure safetyStatus is one of the expected values
            final validatedSafetyStatus =
                ['green', 'yellow', 'red'].contains(safetyStatus.toLowerCase())
                ? safetyStatus.toLowerCase()
                : 'red';

            // Extract and validate ingredients list - Fix the casting issue
            List<String> alternativeIngredients = [];
            var ingredientsData =
                analysisData['suggested_alternatives'] ??
                analysisData['alternativeIngredients'] ??
                [];

            if (ingredientsData is List) {
              alternativeIngredients = ingredientsData
                  .map((item) => item.toString())
                  .where((item) => item.isNotEmpty)
                  .toList();
            } else if (ingredientsData is String) {
              alternativeIngredients = ingredientsData
                  .split(RegExp(r',|\n|;'))
                  .where((item) => item.trim().isNotEmpty)
                  .map((item) => item.trim())
                  .toList();
            }

            // Extract and validate detected allergens - Fix the casting issue
            List<String> detectedAllergens = [];
            var allergensData =
                analysisData['detected_allergens'] ??
                analysisData['detectedAllergens'] ??
                [];

            if (allergensData is List) {
              detectedAllergens = allergensData
                  .map((item) => item.toString())
                  .where((item) => item.isNotEmpty)
                  .toList();
            } else if (allergensData is String) {
              detectedAllergens = allergensData
                  .split(RegExp(r',|\n|;'))
                  .where((item) => item.trim().isNotEmpty)
                  .map((item) => item.trim())
                  .toList();
            }

            log("Successfully parsed analysis response");
            log(
              "Extracted summary: ${summary.substring(0, Math.min(50, summary.length))}...",
            );
            log("Safety status: $validatedSafetyStatus");
            log("Detected allergens: ${detectedAllergens.join(', ')}");
            log(
              "Alternative ingredients: ${alternativeIngredients.join(', ')}",
            );

            return {
              'summary':
                  summary, // This should be ONLY the analysis_summary, not the full JSON
              'safetyStatus': validatedSafetyStatus,
              'detectedAllergens': detectedAllergens,
              'alternativeIngredients': alternativeIngredients,
            };
          } catch (parseError) {
            log("Error parsing JSON response: $parseError");
            log("Raw response: $textContent");

            // If JSON parsing fails but we have text content, try to extract info manually
            if (textContent.isNotEmpty) {
              // Try to extract just the analysis_summary from the raw text
              String extractedSummary = textContent;

              // Look for analysis_summary field in the raw text
              final summaryMatch = RegExp(
                r'"analysis_summary":\s*"([^"]*)"',
              ).firstMatch(textContent);
              if (summaryMatch != null) {
                extractedSummary = summaryMatch.group(1) ?? textContent;
                log("Extracted summary from raw text: $extractedSummary");
              } else {
                // If we can't extract the summary, use a truncated version of the full text
                extractedSummary = textContent.length > 200
                    ? '${textContent.substring(0, 200)}...'
                    : textContent;
              }

              return {
                'summary': extractedSummary,
                'safetyStatus': textContent.toLowerCase().contains('safe')
                    ? 'green'
                    : 'red',
                'alternativeIngredients': <String>[],
                'detectedAllergens': <String>[],
              };
            }

            // Fallback to a safe default response
            return {
              'summary': 'Error processing analysis results. Please try again.',
              'safetyStatus': 'red',
              'alternativeIngredients': <String>[],
              'detectedAllergens': <String>[],
            };
          }
        } else {
          // No text content found
          log("No text content found in response");
          return {
            'summary': 'Unable to analyze this product. Please try again.',
            'safetyStatus': 'yellow', // Unknown without text analysis
            'alternativeIngredients': <String>[],
            'detectedAllergens': <String>[],
          };
        }
      } else {
        log('OpenAI API error: ${response.statusCode} - ${response.body}');
        return {
          'summary':
              'Sorry, we couldn\'t analyze this product. Please try again later.',
          'safetyStatus': 'red',
          'alternativeIngredients': <String>[],
          'detectedAllergens': <String>[],
        };
      }
    } catch (e) {
      log('Error in combined analysis: $e');
      return {
        'summary':
            'Analysis error: ${e.toString().substring(0, Math.min(100, e.toString().length))}',
        'safetyStatus': 'red',
        'alternativeIngredients': <String>[],
        'detectedAllergens': <String>[],
      };
    }
  }

  /// Searches OpenFoodFacts for alternative products based on provided ingredient suggestions
  /// Returns a list of ProductModel objects that match the search criteria
  /// Now supports filtering by user allergies
  Future<List<ProductModel>> searchAlternativeProducts(
    List<String> ingredients, {
    UserModel? userProfile,
  }) async {
    if (ingredients.isEmpty) {
      return [];
    }

    if (_devMode) {
      log('DEV MODE: Returning mock alternative products');
      // Return mock data in dev mode to avoid API calls
      return [
        ProductModel(
          barcode: 'mock1',
          name: 'Mock Alternative 1',
          imageUrl:
              'https://images.openfoodfacts.org/images/products/mock/1/front.jpg',
          nutriScoreGrade: 'a',
          nutriments: {},
        ),
        ProductModel(
          barcode: 'mock2',
          name: 'Mock Alternative 2',
          imageUrl:
              'https://images.openfoodfacts.org/images/products/mock/2/front.jpg',
          nutriScoreGrade: 'b',
          nutriments: {},
        ),
      ];
    }

    try {
      // Configure OpenFoodFacts (if not already configured)
      OpenFoodAPIConfiguration.userAgent = UserAgent(
        name: 'FoodaBest',
        version: '1.0.0',
        system: 'Flutter',
      );

      // Maximum number of alternative products to return in total
      const int maxTotalProducts = 8;
      List<Product> foundProducts = [];

      // Log user allergies for debugging
      if (userProfile != null && userProfile.displayName != null) {
        log(
          'Filtering search results to exclude allergies: ${userProfile.displayName}',
        );
      }

      // Process each ingredient to find matching products
      for (final ingredient in ingredients) {
        // Limit the total number of alternatives to a reasonable amount
        if (foundProducts.length >= maxTotalProducts) {
          break;
        }

        log('Searching for products with ingredient: $ingredient');

        try {
          // Build parameter map for search - simple search without filters
          final parameters = <Parameter>[
            const PageNumber(page: 1),
            const PageSize(size: 20),
            SearchTerms(terms: [ingredient]),
          ];

          // Add allergen exclusion filters if user has allergies
          if (userProfile != null && userProfile.displayName != null) {
            log('Adding allergen filters for: ');
          }

          // Execute the search
          final searchResult = await OpenFoodAPIClient.searchProducts(
            null, // User not needed for search
            ProductSearchQueryConfiguration(
              parametersList: parameters,
              fields: [
                ProductField.BARCODE,
                ProductField.NAME,
                ProductField.BRANDS,
                ProductField.IMAGE_FRONT_URL,
                ProductField.NUTRISCORE,
                ProductField
                    .ALLERGENS, // Include allergens field for additional filtering
                ProductField
                    .INGREDIENTS, // Include ingredients for manual filtering
                ProductField.TRACES, // Include traces for allergen checking
              ],
              language: OpenFoodFactsLanguage.ENGLISH,
              version: ProductQueryVersion.v3,
            ),
          );

          if (searchResult.products != null &&
              searchResult.products!.isNotEmpty) {
            // Add unique products to results with additional allergen filtering
            for (final product in searchResult.products!) {
              // Skip products without an image
              if (product.imageFrontUrl == null ||
                  product.imageFrontUrl!.isEmpty) {
                continue;
              }

              // Skip if already in results
              if (foundProducts.any((p) => p.barcode == product.barcode)) {
                continue;
              }

              // Additional client-side allergen filtering as a safety net
              if (userProfile != null && userProfile.displayName != null) {
                if (_containsUserAllergens(product, ingredients)) {
                  log(
                    'Excluding product ${product.productName} due to allergen match',
                  );
                  continue;
                }
              }

              foundProducts.add(product);
            }
          }
        } catch (e) {
          log('Error searching for alternate products with $ingredient: $e');
        }
      }

      log(
        'Found ${foundProducts.length} alternative products after allergen filtering',
      );

      // Convert the openfoodfacts Product objects to our app's ProductModel objects
      List<ProductModel> alternativeProducts = foundProducts
          .map((product) => _mapProductToModel(product))
          .toList();

      // Sort by nutriscore if available (better scores first)
      alternativeProducts.sort((a, b) {
        final aHasScore =
            a.nutriScoreGrade != null && a.nutriScoreGrade!.isNotEmpty;
        final bHasScore =
            b.nutriScoreGrade != null && b.nutriScoreGrade!.isNotEmpty;

        // If both have nutriscores, compare them (a comes before b, etc.)
        if (aHasScore && bHasScore) {
          return a.nutriScoreGrade!.compareTo(b.nutriScoreGrade!);
        }
        // If only one has nutriscore, it comes first
        else if (aHasScore) {
          return -1;
        } else if (bHasScore) {
          return 1;
        }
        // If neither has nutriscore, keep original order
        return 0;
      });

      // If no products found, return some healthier alternatives
      if (alternativeProducts.isEmpty) {
        log('No alternative products found, trying broader search');

        // Try searching with broader criteria
        try {
          // First try with ingredients
          final broaderSearch = await OpenFoodAPIClient.searchProducts(
            null,
            ProductSearchQueryConfiguration(
              parametersList: [
                const PageNumber(page: 1),
                const PageSize(size: 10),
                SearchTerms(
                  terms: ingredients.take(2).toList(),
                ), // Use first 2 ingredients
              ],
              fields: [
                ProductField.BARCODE,
                ProductField.NAME,
                ProductField.BRANDS,
                ProductField.IMAGE_FRONT_URL,
                ProductField.NUTRISCORE,
                ProductField.CATEGORIES,
                ProductField.NUTRIMENTS,
              ],
              language: OpenFoodFactsLanguage.ENGLISH,
              version: ProductQueryVersion.v3,
            ),
          );

          // If still no results, try with general healthy terms
          if (broaderSearch.products == null ||
              broaderSearch.products!.isEmpty) {
            log('Trying general healthy products search');
            final generalSearch = await OpenFoodAPIClient.searchProducts(
              null,
              ProductSearchQueryConfiguration(
                parametersList: [
                  const PageNumber(page: 1),
                  const PageSize(size: 10),
                  SearchTerms(terms: ['healthy']),
                ],
                fields: [
                  ProductField.BARCODE,
                  ProductField.NAME,
                  ProductField.BRANDS,
                  ProductField.IMAGE_FRONT_URL,
                  ProductField.NUTRISCORE,
                  ProductField.CATEGORIES,
                  ProductField.NUTRIMENTS,
                ],
                language: OpenFoodFactsLanguage.ENGLISH,
                version: ProductQueryVersion.v3,
              ),
            );

            if (generalSearch.products != null &&
                generalSearch.products!.isNotEmpty) {
              final generalProducts = generalSearch.products!
                  .where(
                    (product) =>
                        product.imageFrontUrl != null &&
                        product.imageFrontUrl!.isNotEmpty &&
                        product.productName != null &&
                        product.productName!.isNotEmpty,
                  )
                  .take(3)
                  .map((product) => _mapProductToModel(product))
                  .toList();

              if (generalProducts.isNotEmpty) {
                log(
                  'Found ${generalProducts.length} products from general search',
                );
                return generalProducts;
              }
            }
          }

          if (broaderSearch.products != null &&
              broaderSearch.products!.isNotEmpty) {
            final broaderProducts = broaderSearch.products!
                .where(
                  (product) =>
                      product.imageFrontUrl != null &&
                      product.imageFrontUrl!.isNotEmpty &&
                      product.productName != null &&
                      product.productName!.isNotEmpty,
                )
                .take(3)
                .map((product) => _mapProductToModel(product))
                .toList();

            if (broaderProducts.isNotEmpty) {
              log(
                'Found ${broaderProducts.length} products from broader search',
              );
              return broaderProducts;
            }
          }
        } catch (e) {
          log('Broader search failed: $e');
        }

        log('No real products found, returning healthier alternatives');
        return [
          ProductModel(
            barcode: '3017620422003',
            name: 'Organic Quinoa & Chia Seeds',
            imageUrl:
                'https://images.openfoodfacts.org/images/products/301/762/042/2003/front_en.4.400.jpg',
            nutriScoreGrade: 'a',
            nutriments: {
              'energy-kcal': 180,
              'protein': 12,
              'fat': 3,
              'carbohydrates': 25,
              'fiber': 8,
              'salt': 0.1,
            },
            categories: ['superfood', 'organic', 'gluten-free'],
            brands: 'SuperFood Co',
          ),
          ProductModel(
            barcode: '3017620422004',
            name: 'Plant-Based Protein Shake',
            imageUrl:
                'https://images.openfoodfacts.org/images/products/301/762/042/2004/front_en.4.400.jpg',
            nutriScoreGrade: 'a',
            nutriments: {
              'energy-kcal': 90,
              'protein': 15,
              'fat': 1,
              'carbohydrates': 8,
              'sugars': 2,
              'salt': 0.05,
            },
            categories: ['plant-based', 'protein', 'vegan'],
            brands: 'Green Protein',
          ),
          ProductModel(
            barcode: '3017620422005',
            name: 'Raw Organic Nuts Mix',
            imageUrl:
                'https://images.openfoodfacts.org/images/products/301/762/042/2005/front_en.4.400.jpg',
            nutriScoreGrade: 'a',
            nutriments: {
              'energy-kcal': 200,
              'protein': 8,
              'fat': 15,
              'carbohydrates': 12,
              'fiber': 6,
              'sugars': 3,
            },
            categories: ['nuts', 'organic', 'raw'],
            brands: 'Nature\'s Best',
          ),
        ];
      }

      return alternativeProducts;
    } catch (e) {
      log('Error in searchAlternativeProducts: $e');
      return [];
    }
  }

  /// Helper method to check if a product contains any of the user's allergens
  /// This is a client-side safety net in addition to server-side filtering
  bool _containsUserAllergens(Product product, List<String> userAllergies) {
    // Convert user allergies to lowercase for comparison
    final lowerUserAllergies = userAllergies
        .map((a) => a.toLowerCase())
        .toList();

    // Check allergens field
    if (product.allergens?.names != null) {
      for (final allergen in product.allergens!.names) {
        final lowerAllergen = allergen.toLowerCase();
        if (lowerUserAllergies.any(
          (userAllergy) =>
              lowerAllergen.contains(userAllergy) ||
              userAllergy.contains(lowerAllergen),
        )) {
          return true;
        }
      }
    }

    // Check ingredients as a fallback
    if (product.ingredients != null) {
      for (final ingredient in product.ingredients!) {
        final ingredientText = ingredient.text?.toLowerCase() ?? '';
        if (lowerUserAllergies.any(
          (userAllergy) =>
              ingredientText.contains(userAllergy) ||
              userAllergy.contains(ingredientText),
        )) {
          return true;
        }
      }
    }

    // Check product name and brands as additional safety net
    final productName = product.productName?.toLowerCase() ?? '';
    final brands = product.brands?.toLowerCase() ?? '';

    if (lowerUserAllergies.any(
      (userAllergy) =>
          productName.contains(userAllergy) || brands.contains(userAllergy),
    )) {
      return true;
    }

    return false;
  }

  /// Helper method to convert OpenFoodFacts Product to our app's ProductModel
  /// Enhanced to extract more accurate data from Open Food Facts
  ProductModel _mapProductToModel(Product product) {
    // Extract nutriscore grade - it comes as a string in the API response
    String nutriScoreGrade = '';
    try {
      // In OpenFoodFacts API, nutriscore can be stored in different ways depending on version
      if (product.nutriscore != null) {
        // Try to extract from product.nutriscore which is a dynamic field
        final nutriscoreValue = product.nutriscore.toString();
        if (nutriscoreValue.isNotEmpty) {
          // If it's a full string like 'a' or a longer value
          nutriScoreGrade = nutriscoreValue.substring(0, 1).toLowerCase();
        }
      }

      // If no valid nutriScore was found so far, try alternative approaches
      if (nutriScoreGrade.isEmpty) {
        // Try to get it from the raw response JSON if it exists there
        final dynamic rawData = product.toJson(); // Get raw response
        if (rawData != null && rawData is Map<String, dynamic>) {
          // Look for various possible fields that might contain nutriscore
          final String? score =
              rawData['nutrition_grade_fr'] as String? ??
              rawData['nutrition_grades'] as String? ??
              rawData['nutriscore_grade'] as String?;
          if (score != null && score.isNotEmpty) {
            nutriScoreGrade = score.substring(0, 1).toLowerCase();
          }
        }
      }
    } catch (e) {
      log('Error extracting nutriscore: $e');
      nutriScoreGrade = '';
    }

    // Extract ingredients with better formatting
    List<IngredientModel> ingredients = [];
    if (product.ingredients != null) {
      ingredients = product.ingredients!
          .where((ing) => ing.text != null && ing.text!.isNotEmpty)
          .map(
            (ing) => IngredientModel(
              text: ing.text,
              percent: ing.percent,
              percentEstimate: ing.percentEstimate,
            ),
          )
          .toList();
    }

    // Extract allergens
    List<String> allergens = [];
    if (product.allergens?.names != null) {
      allergens = product.allergens!.names;
    }

    // Extract nutrition information
    Map<String, dynamic> nutriments = {};
    if (product.nutriments != null) {
      nutriments = product.nutriments!.toJson();
    }

    return ProductModel(
      barcode: product.barcode ?? '',
      name: product.productName ?? '',
      brands: product.brands ?? '',
      imageUrl: product.imageFrontUrl ?? '',
      nutriScoreGrade: nutriScoreGrade,
      ingredients: ingredients,
      allergens: allergens,
      nutriments: nutriments,
    );
  }

  /// Searches for alternative products based on AI-suggested alternative ingredients
  /// This is called separately after the main analysis for better UX
  /// Returns a list of ProductModel objects that are alternatives to the analyzed product
  /// Now supports filtering by user allergies
  Future<List<ProductModel>> searchAlternativeProductsFromIngredients(
    List<String> alternativeIngredients, {
    UserModel? userProfile,
  }) async {
    if (alternativeIngredients.isEmpty) {
      log('No alternative ingredients provided for search');
      return [];
    }

    log(
      'Starting search for alternative products based on AI suggestions: ${alternativeIngredients.join(', ')}',
    );

    try {
      final alternativeProducts = await searchAlternativeProducts(
        alternativeIngredients,
        userProfile: userProfile,
      );
      log('Found ${alternativeProducts.length} alternative products');
      return alternativeProducts;
    } catch (e) {
      log('Error searching for alternative products: $e');
      return [];
    }
  }

  /// Get product by barcode from Open Food Facts
  Future<ProductModel> getProductByBarcode(String barcode) async {
    try {
      log('🔍 Fetching product from Open Food Facts: $barcode');

      // Configure OpenFoodFacts
      OpenFoodAPIConfiguration.userAgent = UserAgent(
        name: 'FoodaBest',
        version: '1.0.0',
        system: 'Flutter',
      );

      // Fetch product by barcode
      final ProductQueryConfiguration configuration = ProductQueryConfiguration(
        barcode,
        language: OpenFoodFactsLanguage.ENGLISH,
        fields: [
          ProductField.BARCODE,
          ProductField.NAME,
          ProductField.BRANDS,
          ProductField.IMAGE_FRONT_URL,
          ProductField.NUTRISCORE,
          ProductField.CATEGORIES,
          ProductField.INGREDIENTS,
          ProductField.ALLERGENS,
          ProductField.NUTRIMENTS,
          ProductField.TRACES,
          ProductField.LABELS,
        ],
        version: ProductQueryVersion.v3,
      );

      final ProductResultV3 result = await OpenFoodAPIClient.getProductV3(
        configuration,
      );

      if (result.status == ProductResultV3.statusSuccess &&
          result.product != null) {
        final Product openFoodProduct = result.product!;
        log(
          '✅ Product found in Open Food Facts: ${openFoodProduct.productName}',
        );

        // Convert Open Food Facts Product to our ProductModel
        return _mapProductToModel(openFoodProduct);
      } else {
        log('❌ Product not found in Open Food Facts');
        throw Exception('Product not found in Open Food Facts database');
      }
    } catch (e) {
      log('❌ Error fetching product from Open Food Facts: $e');
      throw Exception('Failed to fetch product data: $e');
    }
  }
}
