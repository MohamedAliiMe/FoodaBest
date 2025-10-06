import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/core/utilities/routes_navigator/navigator.dart';
import 'package:fooda_best/core/widgets/base_flexiable_image.dart';
import 'package:fooda_best/core/widgets/custom_normal_field.dart';
import 'package:fooda_best/core/widgets/product_card.dart';
import 'package:fooda_best/features/search/data/models/search_category_model.dart';
import 'package:fooda_best/features/search/logic/search_cubit.dart';
import 'package:fooda_best/gen/assets.gen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedFilters = {};
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().loadCategories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = _searchController.text.trim();
      if (query.length >= 2) {
        _performSearch(query);
      } else {
        context.read<SearchCubit>().clear();
      }
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;

    final cubit = context.read<SearchCubit>();
    final searchTerms = [query];

    for (final filter in _selectedFilters) {
      final category = cubit.state.categories.firstWhere(
        (option) => option.name == filter,
        orElse: () => SearchCategoryModel(id: '', name: '', productsCount: 0),
      );
      if (category.id != '') {
        searchTerms.add(category.id);
      }
    }

    cubit.searchProducts(searchTerms);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AllColors.white,
          appBar: _buildAppBar(),
          body: Column(
            children: [
              _buildFiltersSection(state),

              Expanded(child: _buildResultsSection(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFiltersSection(SearchState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50.h,
            child: state.isLoadingCategories
                ? Center(
                    child: CircularProgressIndicator(
                      color: AllColors.blue,
                      strokeWidth: 2,
                    ),
                  )
                : state.categories.isEmpty
                ? Center(
                    child: Text(
                      'No categories available',
                      style: tm12.copyWith(color: AllColors.grey),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final filter = state.categories[index];
                      final isSelected = _selectedFilters.contains(filter.name);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedFilters.remove(filter.name);
                            } else {
                              _selectedFilters.add(filter.name);
                            }
                          });
                          if (_searchController.text.isNotEmpty) {
                            _performSearch(_searchController.text.trim());
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 12.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AllColors.blue
                                : AllColors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isSelected
                                  ? AllColors.blue
                                  : AllColors.grey.withValues(alpha: 0.3),
                              width: 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AllColors.blue.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildCategoryImage(filter, isSelected),
                              SizedBox(width: 8.w),

                              Text(
                                filter.name,
                                style: tm12.copyWith(
                                  color: isSelected
                                      ? AllColors.white
                                      : AllColors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(height: 16.h),

          GestureDetector(
            onTap: () {
              showNutritionFiltersBottomSheet(context, state);

              //*  reDO: Nutrition filters
            },
            child: Row(
              children: [
                Icon(Icons.filter_list, color: AllColors.black, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'Nutrition Filters',
                  style: tm14.copyWith(
                    color: AllColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AllColors.grey,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showNutritionFiltersBottomSheet(
    BuildContext context,
    SearchState state,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CategoryFiltersBottomSheet(state: state),
    );
  }

  Widget _buildResultsSection(SearchState state) {
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator(color: AllColors.blue));
    }

    if (state.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64.sp, color: AllColors.grey),
            SizedBox(height: 16.h),
            Text(
              'No products found',
              style: tb18.copyWith(
                color: AllColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try searching for a different product',
              style: tm14.copyWith(color: AllColors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            children: [
              Text(
                'Found ${state.searchResults.length} products',
                style: tm14.copyWith(
                  color: AllColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              final product = state.searchResults[index];
              return ProductCardStyles.searchResult(
                product: product,
                onTap: () {
                  //^ TODO: Navigate to details
                },
                onFavoriteTap: () {
                  //^ tODO: handle favorite
                },
                onAlternativeTap: () {
                  //^ tODO: handle alternative
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryImage(SearchCategoryModel filter, bool isSelected) {
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: isSelected
            ? AllColors.white
            : AllColors.grey.withValues(alpha: 0.1),
      ),
      child: filter.imageUrl != null && filter.imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: Image.network(
                filter.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildCategoryIcon(isSelected);
                },
              ),
            )
          : _buildCategoryIcon(isSelected),
    );
  }

  Widget _buildCategoryIcon(bool isSelected) {
    return Icon(
      Icons.category,
      color: isSelected ? AllColors.blue : AllColors.grey,
      size: 16.sp,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          context.read<SearchCubit>().clear();
          popScreen(context);
        },
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: 40.w,
                height: 40.h,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  color: AllColors.grayLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: FlexibleImage(
                  source: Assets.images.back,
                  width: 16.w,
                  height: 16.h,
                  fit: BoxFit.contain,
                  color: AllColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      toolbarHeight: 70.h,
      title: SizedBox(
        height: 45.h,
        child: CustomNormalField(
          useModernLabelStyle: false,
          controller: _searchController,
          borderRadius: BorderRadius.circular(20.r),
          enabledBorderRadius: BorderRadius.circular(20.r),
          focusedBorderRadius: BorderRadius.circular(20.r),
          errorBorderRadius: BorderRadius.circular(20.r),
          focusedErrorBorderRadius: BorderRadius.circular(20.r),
          hint: 'Search',
          fillColor: AllColors.blueBackground,
          hintColor: AllColors.grayLight,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            if (value.length >= 2) {
              _performSearch(value);
            } else {
              context.read<SearchCubit>().clear();
            }
          },
          suffixIcon: Icon(Icons.search, color: AllColors.black, size: 24.sp),
        ),
      ),
    );
  }
}

class CategoryFiltersBottomSheet extends StatelessWidget {
  final SearchState state;
  const CategoryFiltersBottomSheet({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: _buildCategoryFilters(state),
    );
  }

  Widget _buildCategoryFilters(SearchState state) {
    return Column(children: [Text('Category Filters')]);
  }
}
