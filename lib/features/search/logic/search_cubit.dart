import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fooda_best/core/dependencies/dependency_init.dart';
import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';
import 'package:fooda_best/features/search/data/models/search_category_model.dart';
import 'package:fooda_best/features/search/data/repositories/search_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'search_cubit.freezed.dart';
part 'search_state.dart';

@Injectable()
class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _repo = getIt<SearchRepository>();
  final Map<String, List<ProductModel>> _cache = {};
  Timer? _debounce;

  SearchCubit() : super(SearchState());

  void onQueryChanged(String q, {UserModel? user}) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      searchProducts(
        [q],
        userProfile: user,
        categoryFilters: state.selectedCategoryId != null
            ? [state.selectedCategoryId!]
            : null,
      );
    });
    emit(state.copyWith(query: q));
  }

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoadingCategories: true, errorMessage: null));
    try {
      final categories = await _repo.getCategories(limit: 50);
      emit(state.copyWith(categories: categories, isLoadingCategories: false));
    } catch (e) {
      emit(
        state.copyWith(isLoadingCategories: false, errorMessage: e.toString()),
      );
    }
  }

  Future<void> searchProducts(
    List<String> searchTerms, {
    UserModel? userProfile,
    List<String>? categoryFilters,
    int page = 1,
  }) async {
    final categoryId = (categoryFilters != null && categoryFilters.isNotEmpty)
        ? categoryFilters.first
        : state.selectedCategoryId;

    final key = '${searchTerms.join(",")}_cat:${categoryId ?? ''}_page:$page';

    if (page == 1 && _cache.containsKey(key)) {
      emit(state.copyWith(searchResults: _cache[key]!, isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final results = await _repo.searchProducts(
        searchTerms: searchTerms,
        categoryId: categoryId,
        user: userProfile,
        page: page,
      );

      final combined = page == 1
          ? results
          : [...state.searchResults, ...results];

      if (page == 1) {
        _cache['${searchTerms.join(",")}_cat:${categoryId ?? ''}_page:1'] =
            results;
      }

      emit(
        state.copyWith(
          searchResults: combined,
          isLoading: false,
          currentPage: page,
          hasMore: results.length >= 20,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    final next = state.currentPage + 1;
    await searchProducts(
      [state.query],
      page: next,
      categoryFilters: state.selectedCategoryId != null
          ? [state.selectedCategoryId!]
          : null,
    );
  }

  void selectCategory(String? categoryId) {
    emit(state.copyWith(selectedCategoryId: categoryId));
    searchProducts([
      state.query,
    ], categoryFilters: categoryId != null ? [categoryId] : null);
  }

  void clear() {
    emit(SearchState());
    _cache.clear();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
