import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/product_analysis/data/models/analysis_model/analysis_model.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';
import 'package:fooda_best/features/product_analysis/data/repositories/product_analysis_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as mlkit;
import 'package:injectable/injectable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

part 'product_analysis_cubit.freezed.dart';
part 'product_analysis_state.dart';

@Injectable()
class ProductAnalysisCubit extends Cubit<ProductAnalysisState> {
  final ProductAnalysisService _productAnalysisService;

  ProductAnalysisCubit(this._productAnalysisService)
    : super(ProductAnalysisState());

  /// Scan product by barcode
  Future<void> scanProduct(String barcode, UserModel userProfile) async {
    try {
      log('Scanning product with barcode: $barcode');

      // Check if barcode is empty
      if (barcode.isEmpty) {
        log('❌ Empty barcode provided');
        emit(
          state.copyWith(
            status: ProductAnalysisStatus.error,
            errorMessage:
                'No barcode provided. Please scan a product or enter a barcode manually.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ProductAnalysisStatus.loading,
          errorMessage: null,
        ),
      );

      // Fetch real product data from Open Food Facts using ProductAnalysisService
      final product = await _productAnalysisService.getProductByBarcode(
        barcode,
      );

      log('Product found: ${product.name}');

      // Start analysis
      await analyzeProduct(product, userProfile);
    } catch (e) {
      log('Error scanning product: $e');
      emit(
        state.copyWith(
          status: ProductAnalysisStatus.error,
          errorMessage: 'Error scanning product: $e',
        ),
      );
    }
  }

  /// Analyze product for allergens and safety
  Future<void> analyzeProduct(
    ProductModel product,
    UserModel userProfile,
  ) async {
    try {
      log('Analyzing product: ${product.name}');
      emit(
        state.copyWith(
          status: ProductAnalysisStatus.loading,
          product: product,
          errorMessage: null,
        ),
      );

      // Get analysis from ProductAnalysisService
      final analysisResult = await _productAnalysisService
          .analyzeProductForUser(product, userProfile);

      // Create AnalysisModel from the result
      final analysis = AnalysisModel(
        summary: analysisResult['summary'] ?? '',
        safetyStatus: analysisResult['safetyStatus'] ?? 'red',
        detectedAllergens: List<String>.from(
          analysisResult['detectedAllergens'] ?? [],
        ),
        alternativeIngredients: List<String>.from(
          analysisResult['alternativeIngredients'] ?? [],
        ),
        analysisTime: DateTime.now().toIso8601String(),
        warnings: [],
      );

      log('Analysis completed: ${analysis.safetyStatus}');

      // Search for alternative products
      List<ProductModel> alternativeProducts = [];
      if (analysis.alternativeIngredients?.isNotEmpty ?? false) {
        log('🔍 CUBIT: Searching for alternative products...');
        alternativeProducts = await _productAnalysisService
            .searchAlternativeProductsFromIngredients(
              analysis.alternativeIngredients ?? [],
              userProfile: userProfile,
            );
        log(
          '✅ CUBIT: Found ${alternativeProducts.length} alternative products',
        );
        for (int i = 0; i < alternativeProducts.length; i++) {
          log(
            '   ${i + 1}. ${alternativeProducts[i].name} (${alternativeProducts[i].brands}) - NutriScore: ${alternativeProducts[i].nutriScoreGrade}',
          );
        }
      }

      emit(
        state.copyWith(
          status: ProductAnalysisStatus.loaded,
          product: product,
          analysis: analysis,
          alternativeProducts: alternativeProducts,
          errorMessage: null,
        ),
      );
    } catch (e) {
      log('Error analyzing product: $e');
      emit(
        state.copyWith(
          status: ProductAnalysisStatus.error,
          errorMessage: 'Error analyzing product: $e',
        ),
      );
    }
  }

  /// Select an alternative product
  Future<void> selectAlternativeProduct(
    ProductModel alternativeProduct,
    UserModel userProfile,
  ) async {
    try {
      log('Selecting alternative product: ${alternativeProduct.name}');
      await analyzeProduct(alternativeProduct, userProfile);
    } catch (e) {
      log('Error selecting alternative product: $e');
      emit(
        state.copyWith(
          status: ProductAnalysisStatus.error,
          errorMessage: 'Error selecting alternative product: $e',
        ),
      );
    }
  }

  /// Capture and analyze image
  Future<void> captureAndAnalyzeImage(
    File imageFile,
    UserModel userProfile,
  ) async {
    try {
      log('Capturing and analyzing image: ${imageFile.path}');
      emit(
        state.copyWith(
          status: ProductAnalysisStatus.loading,
          errorMessage: null,
        ),
      );

      // Try to detect barcode from the image using MobileScanner first
      log('🔍 Analyzing image for barcode with MobileScanner...');
      String? barcode = await _detectBarcodeFromImage(imageFile);

      // If MobileScanner fails, try Google ML Kit
      if (barcode == null) {
        log('🔄 MobileScanner failed, trying Google ML Kit...');
        barcode = await _detectBarcodeWithMLKit(imageFile);
      }

      // If ML Kit also fails, try alternative detection
      if (barcode == null) {
        log('🔄 ML Kit failed, trying alternative detection...');
        barcode = await _detectBarcodeAlternative(imageFile);
      }

      if (barcode != null && barcode.isNotEmpty) {
        log('✅ Barcode detected from image: $barcode');
        // Use the detected barcode to scan the product
        await scanProduct(barcode, userProfile);
      } else {
        log('❌ No barcode detected in image with all methods');
        emit(
          state.copyWith(
            status: ProductAnalysisStatus.error,
            errorMessage:
                'No barcode detected in the image. Please try:\n• A clearer photo with better lighting\n• Camera scanning instead of gallery\n• Manual barcode entry',
          ),
        );
      }
    } catch (e) {
      log('Error analyzing image: $e');
      emit(
        state.copyWith(
          status: ProductAnalysisStatus.error,
          errorMessage: 'Error analyzing image: $e',
        ),
      );
    }
  }

  /// Detect barcode from image file
  Future<String?> _detectBarcodeFromImage(File imageFile) async {
    try {
      log('🔍 Starting barcode detection from image...');

      // Check if we're on iOS Simulator (not supported)
      if (Platform.isIOS) {
        log('📱 iOS detected - trying image analysis anyway...');
        // Continue with analysis attempt
      }

      // Create a temporary scanner controller for image analysis
      final scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: false,
        formats: [
          BarcodeFormat.ean13,
          BarcodeFormat.ean8,
          BarcodeFormat.upcA,
          BarcodeFormat.upcE,
          BarcodeFormat.code128,
          BarcodeFormat.code39,
          BarcodeFormat.qrCode,
          BarcodeFormat.aztec,
          BarcodeFormat.dataMatrix,
        ],
      );

      // Use the scanner to analyze the image
      log('📸 Analyzing image with MobileScanner...');
      final result = await scannerController.analyzeImage(imageFile.path);

      // Dispose the controller
      await scannerController.dispose();

      if (result != null && result.barcodes.isNotEmpty) {
        log('🎯 Found ${result.barcodes.length} barcodes in image');

        // Try all detected barcodes
        for (int i = 0; i < result.barcodes.length; i++) {
          final barcode = result.barcodes[i].rawValue;
          final format = result.barcodes[i].format;
          log('🔍 Barcode ${i + 1}: $barcode (Format: $format)');

          if (barcode != null && barcode.length >= 6 && barcode.length <= 14) {
            log('✅ Valid barcode detected: $barcode');
            return barcode;
          } else {
            log('❌ Invalid barcode length: ${barcode?.length}');
          }
        }
      } else {
        log('❌ No barcodes found in image');
      }

      return null;
    } catch (e) {
      log('❌ Error detecting barcode from image: $e');

      // Check for iOS Simulator error
      if (e.toString().contains('iOS Simulator') ||
          e.toString().contains('not supported')) {
        log('📱 iOS Simulator detected - image analysis not supported');
        log('💡 Please use camera scanning or manual barcode entry instead');
        return null;
      }

      return null;
    }
  }

  /// Detect barcode using Google ML Kit as fallback
  Future<String?> _detectBarcodeWithMLKit(File imageFile) async {
    try {
      log('🔍 Trying Google ML Kit barcode detection...');

      // Don't skip ML Kit on iOS - it should work on real devices
      // Only skip on simulator
      if (Platform.isIOS) {
        log('📱 iOS detected - trying ML Kit anyway...');
      }

      final inputImage = mlkit.InputImage.fromFilePath(imageFile.path);
      final barcodeScanner = mlkit.BarcodeScanner(
        formats: [
          mlkit.BarcodeFormat.ean13,
          mlkit.BarcodeFormat.ean8,
          mlkit.BarcodeFormat.code128,
          mlkit.BarcodeFormat.code39,
          mlkit.BarcodeFormat.qrCode,
          mlkit.BarcodeFormat.aztec,
          mlkit.BarcodeFormat.dataMatrix,
        ],
      );

      final List<mlkit.Barcode> barcodes = await barcodeScanner.processImage(
        inputImage,
      );

      log('🎯 ML Kit found ${barcodes.length} barcodes');

      for (int i = 0; i < barcodes.length; i++) {
        final barcode = barcodes[i].displayValue;
        final format = barcodes[i].format;
        log('🔍 ML Kit Barcode ${i + 1}: $barcode (Format: $format)');

        if (barcode != null && barcode.length >= 6 && barcode.length <= 14) {
          log('✅ ML Kit valid barcode detected: $barcode');
          await barcodeScanner.close();
          return barcode;
        } else {
          log('❌ ML Kit invalid barcode length: ${barcode?.length}');
        }
      }

      await barcodeScanner.close();
      return null;
    } catch (e) {
      log('❌ ML Kit barcode detection error: $e');
      return null;
    }
  }

  /// Alternative barcode detection method
  Future<String?> _detectBarcodeAlternative(File imageFile) async {
    try {
      log('🔍 Trying alternative barcode detection...');

      // For now, return null - we can implement other methods here
      // This could include image preprocessing, different libraries, etc.
      log('❌ Alternative detection not implemented yet');
      return null;
    } catch (e) {
      log('❌ Alternative barcode detection error: $e');
      return null;
    }
  }

  /// Reset the state
  void reset() {
    emit(ProductAnalysisState());
  }
}
