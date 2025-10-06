// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingCategories => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<ProductModel> get searchResults => throw _privateConstructorUsedError;
  List<SearchCategoryModel> get categories =>
      throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  String? get selectedCategoryId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchStateCopyWith<SearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
          SearchState value, $Res Function(SearchState) then) =
      _$SearchStateCopyWithImpl<$Res, SearchState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isLoadingCategories,
      String? errorMessage,
      List<ProductModel> searchResults,
      List<SearchCategoryModel> categories,
      int currentPage,
      bool hasMore,
      String query,
      String? selectedCategoryId});
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res, $Val extends SearchState>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isLoadingCategories = null,
    Object? errorMessage = freezed,
    Object? searchResults = null,
    Object? categories = null,
    Object? currentPage = null,
    Object? hasMore = null,
    Object? query = null,
    Object? selectedCategoryId = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCategories: null == isLoadingCategories
          ? _value.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      searchResults: null == searchResults
          ? _value.searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<ProductModel>,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<SearchCategoryModel>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategoryId: freezed == selectedCategoryId
          ? _value.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchStateImplCopyWith<$Res>
    implements $SearchStateCopyWith<$Res> {
  factory _$$SearchStateImplCopyWith(
          _$SearchStateImpl value, $Res Function(_$SearchStateImpl) then) =
      __$$SearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isLoadingCategories,
      String? errorMessage,
      List<ProductModel> searchResults,
      List<SearchCategoryModel> categories,
      int currentPage,
      bool hasMore,
      String query,
      String? selectedCategoryId});
}

/// @nodoc
class __$$SearchStateImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchStateImpl>
    implements _$$SearchStateImplCopyWith<$Res> {
  __$$SearchStateImplCopyWithImpl(
      _$SearchStateImpl _value, $Res Function(_$SearchStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isLoadingCategories = null,
    Object? errorMessage = freezed,
    Object? searchResults = null,
    Object? categories = null,
    Object? currentPage = null,
    Object? hasMore = null,
    Object? query = null,
    Object? selectedCategoryId = freezed,
  }) {
    return _then(_$SearchStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingCategories: null == isLoadingCategories
          ? _value.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      searchResults: null == searchResults
          ? _value._searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<ProductModel>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<SearchCategoryModel>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategoryId: freezed == selectedCategoryId
          ? _value.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SearchStateImpl implements _SearchState {
  _$SearchStateImpl(
      {this.isLoading = false,
      this.isLoadingCategories = false,
      this.errorMessage,
      final List<ProductModel> searchResults = const [],
      final List<SearchCategoryModel> categories = const [],
      this.currentPage = 1,
      this.hasMore = false,
      this.query = '',
      this.selectedCategoryId})
      : _searchResults = searchResults,
        _categories = categories;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingCategories;
  @override
  final String? errorMessage;
  final List<ProductModel> _searchResults;
  @override
  @JsonKey()
  List<ProductModel> get searchResults {
    if (_searchResults is EqualUnmodifiableListView) return _searchResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchResults);
  }

  final List<SearchCategoryModel> _categories;
  @override
  @JsonKey()
  List<SearchCategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final String query;
  @override
  final String? selectedCategoryId;

  @override
  String toString() {
    return 'SearchState(isLoading: $isLoading, isLoadingCategories: $isLoadingCategories, errorMessage: $errorMessage, searchResults: $searchResults, categories: $categories, currentPage: $currentPage, hasMore: $hasMore, query: $query, selectedCategoryId: $selectedCategoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingCategories, isLoadingCategories) ||
                other.isLoadingCategories == isLoadingCategories) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._searchResults, _searchResults) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isLoadingCategories,
      errorMessage,
      const DeepCollectionEquality().hash(_searchResults),
      const DeepCollectionEquality().hash(_categories),
      currentPage,
      hasMore,
      query,
      selectedCategoryId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      __$$SearchStateImplCopyWithImpl<_$SearchStateImpl>(this, _$identity);
}

abstract class _SearchState implements SearchState {
  factory _SearchState(
      {final bool isLoading,
      final bool isLoadingCategories,
      final String? errorMessage,
      final List<ProductModel> searchResults,
      final List<SearchCategoryModel> categories,
      final int currentPage,
      final bool hasMore,
      final String query,
      final String? selectedCategoryId}) = _$SearchStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isLoadingCategories;
  @override
  String? get errorMessage;
  @override
  List<ProductModel> get searchResults;
  @override
  List<SearchCategoryModel> get categories;
  @override
  int get currentPage;
  @override
  bool get hasMore;
  @override
  String get query;
  @override
  String? get selectedCategoryId;
  @override
  @JsonKey(ignore: true)
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
