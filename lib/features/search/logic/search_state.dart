part of 'search_cubit.dart';

@freezed
class SearchState with _$SearchState {
  factory SearchState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingCategories,
    String? errorMessage,
    @Default([]) List<ProductModel> searchResults,
    @Default([]) List<SearchCategoryModel> categories,
    @Default(1) int currentPage,
    @Default(false) bool hasMore,
    @Default('') String query,
    String? selectedCategoryId,
  }) = _SearchState;
}
