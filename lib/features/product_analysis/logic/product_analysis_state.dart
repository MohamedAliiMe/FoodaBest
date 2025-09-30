part of 'product_analysis_cubit.dart';

enum ProductAnalysisStatus { initial, loading, loaded, error }

@freezed
class ProductAnalysisState with _$ProductAnalysisState {
  factory ProductAnalysisState({
    @Default(ProductAnalysisStatus.initial) ProductAnalysisStatus status,
    ProductModel? product,
    AnalysisModel? analysis,
    List<ProductModel>? alternativeProducts,
    String? errorMessage,
  }) = _ProductAnalysisState;
}
