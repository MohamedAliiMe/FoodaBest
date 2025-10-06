import 'package:fooda_best/core/helper/extensions.dart';
import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';
import 'package:fooda_best/features/search/data/models/search_category_model.dart';
import 'package:fooda_best/features/search/data/services/search_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class SearchRepository {
  final SearchService _service;
  SearchRepository(this._service);

  Future<List<SearchCategoryModel>> getCategories({int limit = 50}) async {
    try {
      return await _service.fetchCategories(limit: limit);
    } catch (e) {
      throw const SearchException('Failed to load categories.');
    }
  }

  Future<List<ProductModel>> searchProducts({
    required List<String> searchTerms,
    String? categoryId,
    UserModel? user,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await _service.searchProducts(
        searchTerms: searchTerms,
        categoryId: categoryId,
        user: user,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw const SearchException(
        'Network error while fetching search results.',
      );
    }
  }
}
