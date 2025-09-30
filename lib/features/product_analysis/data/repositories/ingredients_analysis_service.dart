import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/product_analysis/data/models/ingredients_model/ingredients_model.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import 'prompt_service.dart';

/// Service that analyzes food ingredients from images using AI
/// Similar to ProductAnalysisService but specifically for image-based ingredient analysis
@Injectable()
class IngredientsAnalysisService {
  // Get API key from environment variables
  final String _openAIApiKey = const String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );

  // Set to true to prevent real API calls during development
  final bool _devMode = false;

  /// Analyzes ingredients from an image based on user profile data
  /// Returns an IngredientsModel with analysis results
  Future<IngredientsModel> analyzeIngredientsImage(
    File imageFile,
    UserModel userProfile, {
    String? locale,
  }) async {
    try {
      log('Starting ingredients analysis from image');
      final startTime = DateTime.now();

      // Validate inputs
      if (imageFile == null || !await imageFile.exists()) {
        return _createErrorResponse('Missing or invalid image file');
      }

      // Step 1: Get image analysis from OpenAI Vision API (gpt-4o)
      IngredientsModel analysisResult = await _getOpenAIVisionAnalysis(
        imageFile,
        userProfile,
        locale: locale,
      );
      log(
        'Got ingredients analysis result: safetyStatus=${analysisResult.safetyStatus}',
      );

      // Step 2: Generate audio from the summary if available
      if (analysisResult.summary != null &&
          analysisResult.summary!.length > 10) {
        try {
          // Update the model with the audio URL
          analysisResult = IngredientsModel(
            summary: analysisResult.summary,
            allergens: analysisResult.allergens,
            ingredients: analysisResult.ingredients,
            safetyStatus: analysisResult.safetyStatus,
          );
        } catch (e) {
          log('Audio generation failed: $e');
          // Continue even if audio fails - we still have the analysis
        }
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      log('Ingredients analysis completed in ${duration.inSeconds} seconds');

      return analysisResult;
    } catch (e) {
      log('Ingredients analysis error in service: $e');
      return _createErrorResponse(e.toString());
    }
  }

  /// Creates a standardized error response object
  /// Creates a standardized error response object with improved error categorization
  IngredientsModel _createErrorResponse(dynamic error) {
    // Create a user-friendly error message based on error type
    String errorMessage;

    if (error is TimeoutException) {
      errorMessage =
          'The analysis took too long to complete. Please try again.';
    } else if (error is SocketException) {
      errorMessage =
          'Network connection error. Please check your internet connection.';
    } else if (error is FormatException) {
      errorMessage =
          'Error processing the ingredient data. Please try again with a clearer image.';
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

    debugPrint('Ingredients analysis error: $errorMessage');

    return IngredientsModel(
      summary: errorMessage,
      safetyStatus: 'red',
      allergens: [],
      ingredients: [],
    );
  }

  /// Uses OpenAI's Vision API (gpt-4o) to analyze ingredients in an image
  Future<IngredientsModel> _getOpenAIVisionAnalysis(
    File imageFile,
    UserModel userProfile, {
    String? locale,
  }) async {
    try {
      // Use dev mode to prevent actual API calls during development
      if (_devMode) {
        log('DEV MODE: Returning mock ingredients analysis data');
        return IngredientsModel(
          summary:
              'This is a development mode placeholder analysis. The ingredients appear to be safe based on your profile.',
          safetyStatus: 'green',
          warnings: [],
          allergens: ['(Dev) Gluten', '(Dev) Soy'],
          ingredients: [
            '(Dev) Water',
            '(Dev) Wheat flour',
            '(Dev) Soy lecithin',
            '(Dev) Salt',
          ],
        );
      }

      // Prepare the image file for base64 encoding
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Extract allergens from user profile for the prompt

      // Determine language for the API request
      final language = locale?.toLowerCase() ?? 'en';
      log('Using language for OpenAI Vision API: $language');

      // Get custom prompt from PromptService
      final customPrompt = await PromptService.getIngredientsPrompt(language);

      // Replace placeholders in the prompt
      final prompt = customPrompt.replaceAll('{userAllergies}', '');

      // Set language-specific system message
      final systemMessage = language == 'fr'
          ? 'Vous êtes un assistant spécialisé dans la sécurité alimentaire et l\'analyse des allergènes. Répondez en français avec un JSON valide.'
          : 'You are a helpful assistant specializing in food safety and allergen analysis. Always reply with valid JSON.';

      // Make the API call to the Vision model (gpt-4o)
      final response = await http
          .post(
            Uri.parse('https://api.openai.com/v1/chat/completions'),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': 'Bearer $_openAIApiKey',
              'Accept': 'application/json; charset=utf-8',
            },
            body: jsonEncode({
              'model': 'gpt-4o', // Use regular gpt-4o for vision
              'messages': [
                {'role': 'system', 'content': systemMessage},
                {
                  'role': 'user',
                  'content': [
                    {'type': 'text', 'text': prompt},
                    {
                      'type': 'image_url',
                      'image_url': {
                        'url': 'data:image/jpeg;base64,$base64Image',
                        'detail': 'high',
                      },
                    },
                  ],
                },
              ],
              'response_format': {'type': 'json_object'},
              'max_tokens': 800,
              'temperature': 0.7,
            }),
            encoding: utf8,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              log('Vision analysis request timed out after 30 seconds');
              throw TimeoutException(
                'Vision analysis request timed out after 30 seconds. Please try again later.',
              );
            },
          );

      if (response.statusCode == 200) {
        log("OpenAI vision analysis response received");

        final responseBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(responseBody);
        final contentJson = jsonResponse['choices'][0]['message']['content'];

        // Parse the structured JSON response
        final analysisData = jsonDecode(contentJson);

        return IngredientsModel.fromJson(analysisData);
      } else {
        log('OpenAI API error: ${response.statusCode} - ${response.body}');
        throw Exception(
          'Failed to analyze ingredients image: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Vision analysis error: $e');
      throw Exception('Vision analysis failed: $e');
    }
  }

  /// Generates audio from text using OpenAI's audio preview model
  Future<String> _generateAudioFromText(String text, {String? locale}) async {
    try {
      // Return empty string if in dev mode
      if (_devMode) {
        return '';
      }

      // Determine language for the API request
      final language = locale?.toLowerCase() ?? 'en';
      log('Generating audio in language: $language');

      // Make the API call to audio preview model
      final response = await http
          .post(
            Uri.parse('https://api.openai.com/v1/chat/completions'),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Authorization': 'Bearer $_openAIApiKey',
              'Accept': 'application/json; charset=utf-8',
            },
            body: jsonEncode({
              'model': 'gpt-4o-mini-audio-preview',
              'modalities': ['text', 'audio'],
              'audio': {
                'voice': language == 'fr' ? 'alloy' : 'nova',
                'format': 'mp3',
              },
              'messages': [
                {
                  'role': 'user',
                  'content': 'Please read the following text aloud: $text',
                },
              ],
              'temperature': 0.3,
            }),
            encoding: utf8,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Audio generation request timed out');
            },
          );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(responseBody);
        final messageContent = jsonResponse['choices'][0]['message'];

        // Extract audio data if available
        if (messageContent['audio'] != null &&
            messageContent['audio']['data'] != null) {
          final audioData = messageContent['audio']['data'];
          final Directory tempDir = await getTemporaryDirectory();
          final String filePath =
              '${tempDir.path}/ingredients_analysis_${DateTime.now().millisecondsSinceEpoch}.mp3';
          final File file = File(filePath);

          // Decode base64 audio data and write to file
          final bytes = base64Decode(audioData);
          await file.writeAsBytes(bytes);
          log('Audio file saved at: $filePath');
          return filePath;
        } else {
          log('No audio data received from API');
          return '';
        }
      } else {
        log('Audio API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to generate audio: ${response.statusCode}');
      }
    } catch (e) {
      log('Audio generation error: $e');
      throw Exception('Audio generation failed: $e');
    }
  }
}
