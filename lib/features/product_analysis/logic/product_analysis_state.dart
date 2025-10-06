part of 'product_analysis_cubit.dart';

@freezed
class ProductAnalysisState with _$ProductAnalysisState {
  factory ProductAnalysisState({
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool failedState,
    ProductModel? product,
    AnalysisModel? analysis,
    List<ProductModel>? alternativeProducts,
  }) = _ProductAnalysisState;
}
