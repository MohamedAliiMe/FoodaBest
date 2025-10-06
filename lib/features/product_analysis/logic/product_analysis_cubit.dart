import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooda_best/core/networking/data_state.dart';
import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/product_analysis/data/models/analysis_model/analysis_model.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';
import 'package:fooda_best/features/product_analysis/data/repositories/product_analysis_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as mlkit;
import 'package:injectable/injectable.dart';

part 'product_analysis_cubit.freezed.dart';
part 'product_analysis_state.dart';

@Injectable()
class ProductAnalysisCubit extends Cubit<ProductAnalysisState> {
  final ProductAnalysisRepository _productAnalysisRepository;

  ProductAnalysisCubit(this._productAnalysisRepository)
    : super(ProductAnalysisState());

  /// Scan product by barcode
  Future<void> scanProduct(String barcode, UserModel userProfile) async {
    // Print the scanned barcode
    log('🔍 SCANNED BARCODE: $barcode');
    print('🔍 SCANNED BARCODE: $barcode');

    emit(
      state.copyWith(isLoading: true, failedState: false, errorMessage: null),
    );

    final DataState<ProductModel> dataState = await _productAnalysisRepository
        .getProductByBarcode(barcode: barcode);

    if (dataState is DataSuccess) {
      final product = dataState.data!;

      // Print product details
      log('📦 PRODUCT FOUND: ${product.name} (${product.barcode})');
      print('📦 PRODUCT FOUND: ${product.name} (${product.barcode})');

      emit(
        state.copyWith(isLoading: false, failedState: false, product: product),
      );

      // Analyze the product
      await analyzeProduct(product, userProfile);
    } else {
      log('❌ PRODUCT NOT FOUND for barcode: $barcode');
      print('❌ PRODUCT NOT FOUND for barcode: $barcode');

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: dataState.error!,
          failedState: true,
        ),
      );
    }
  }

  /// Analyze product for allergens and safety
  Future<void> analyzeProduct(
    ProductModel product,
    UserModel userProfile,
  ) async {
    log('🤖 CUBIT: Starting AI analysis for ${product.name}');
    print('🤖 CUBIT: Starting AI analysis for ${product.name}');

    emit(
      state.copyWith(isLoading: true, failedState: false, errorMessage: null),
    );

    final DataState<AnalysisModel> dataState = await _productAnalysisRepository
        .analyzeProduct(product: product, userProfile: userProfile);

    if (dataState is DataSuccess) {
      final analysis = dataState.data!;

      log('✅ CUBIT: AI analysis completed - ${analysis.summary}');
      print('✅ CUBIT: AI analysis completed - ${analysis.summary}');

      emit(
        state.copyWith(
          isLoading: false,
          failedState: false,
          analysis: analysis,
        ),
      );

      // Search for alternative products
      if (analysis.alternativeIngredients?.isNotEmpty ?? false) {
        log('🔍 CUBIT: Searching for alternative products...');
        print('🔍 CUBIT: Searching for alternative products...');

        await searchAlternativeProducts(
          analysis.alternativeIngredients!,
          userProfile,
        );
      }
    } else {
      log('❌ CUBIT: AI analysis failed - ${dataState.error}');
      print('❌ CUBIT: AI analysis failed - ${dataState.error}');

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: dataState.error!,
          failedState: true,
        ),
      );
    }
  }

  /// Search for alternative products
  Future<void> searchAlternativeProducts(
    List<String> ingredients,
    UserModel userProfile,
  ) async {
    emit(
      state.copyWith(isLoading: true, failedState: false, errorMessage: null),
    );

    final DataState<List<ProductModel>> dataState =
        await _productAnalysisRepository.searchAlternativeProducts(
          ingredients: ingredients,
          userProfile: userProfile,
        );

    if (dataState is DataSuccess) {
      final alternativeProducts = dataState.data!;
      emit(
        state.copyWith(
          isLoading: false,
          failedState: false,
          alternativeProducts: alternativeProducts,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: dataState.error!,
          failedState: true,
        ),
      );
    }
  }

  /// Select an alternative product
  Future<void> selectAlternativeProduct(
    ProductModel alternativeProduct,
    UserModel userProfile,
  ) async {
    await analyzeProduct(alternativeProduct, userProfile);
  }

  /// Capture and analyze image
  Future<void> captureAndAnalyzeImage(
    String imagePath,
    UserModel userProfile,
  ) async {
    emit(
      state.copyWith(isLoading: true, failedState: false, errorMessage: null),
    );

    try {
      // Process image with ML Kit
      final inputImage = mlkit.InputImage.fromFilePath(imagePath);
      final barcodeScanner = mlkit.BarcodeScanner();

      final List<mlkit.Barcode> barcodes = await barcodeScanner.processImage(
        inputImage,
      );
      await barcodeScanner.close();

      if (barcodes.isNotEmpty) {
        final barcode = barcodes.first.displayValue ?? '';
        if (barcode.isNotEmpty) {
          await scanProduct(barcode, userProfile);
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'No barcode detected in the image',
              failedState: true,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'No barcode detected in the image',
            failedState: true,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error processing image: $e',
          failedState: true,
        ),
      );
    }
  }


  void resetScanner() {
    emit(ProductAnalysisState());
  }
}
