// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fooda_best/core/utilities/configs/app_typography.dart';
// import 'package:fooda_best/core/utilities/configs/colors.dart';
// import 'package:fooda_best/features/product_analysis/data/models/product_model/product_model.dart';
// import 'package:fooda_best/features/search/logic/search_cubit.dart';
// import 'package:get_it/get_it.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   Set<String> _selectedFilters = {};

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//     // Load categories when the page initializes
//     context.read<SearchCubit>().loadCategories();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     if (_searchController.text.length >= 2) {
//       _performSearch();
//     } else {
//       context.read<SearchCubit>().clearSearch();
//     }
//   }

//   void _performSearch() async {
//     if (_searchController.text.trim().isEmpty) {
//       context.read<SearchCubit>().clearSearch();
//       return;
//     }

//     // Prepare search terms
//     List<String> searchTerms = [_searchController.text.trim()];

//     // Add selected category filters to search terms
//     for (String filter in _selectedFilters) {
//       final category = context.read<SearchCubit>().state.categories.firstWhere(
//         (option) => option['name'] == filter,
//         orElse: () => {'category': ''},
//       );
//       if (category['category'] != '') {
//         searchTerms.add(category['category']);
//       }
//     }

//     // Perform search using the cubit
//     context.read<SearchCubit>().searchProducts(searchTerms);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => GetIt.instance<SearchCubit>(),
//       child: BlocConsumer<SearchCubit, SearchState>(
//         listener: (context, state) {
//           // Handle any side effects if needed
//         },
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor: AllColors.white,
//             appBar: _buildAppBar(),
//             body: Column(
//               children: [
//                 // Filter Section
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 20.w,
//                     vertical: 16.h,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Filter Buttons
//                       SizedBox(
//                         height: 50.h,
//                         child: state.isLoadingCategories
//                             ? Center(
//                                 child: CircularProgressIndicator(
//                                   color: AllColors.blue,
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                             : ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: state.categories.length,
//                                 itemBuilder: (context, index) {
//                                   final filter = state.categories[index];
//                                   final isSelected = _selectedFilters.contains(
//                                     filter['name'],
//                                   );

//                                   return GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         if (isSelected) {
//                                           _selectedFilters.remove(
//                                             filter['name'],
//                                           );
//                                         } else {
//                                           _selectedFilters.add(filter['name']);
//                                         }
//                                       });
//                                       if (_searchController.text.isNotEmpty) {
//                                         _performSearch();
//                                       }
//                                     },
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 12.w),
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 16.w,
//                                         vertical: 8.h,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: isSelected
//                                             ? AllColors.blue
//                                             : AllColors.white,
//                                         borderRadius: BorderRadius.circular(
//                                           20.r,
//                                         ),
//                                         border: Border.all(
//                                           color: isSelected
//                                               ? AllColors.blue
//                                               : AllColors.grey.withValues(
//                                                   alpha: 0.3,
//                                                 ),
//                                           width: 1,
//                                         ),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Container(
//                                             width: 24.w,
//                                             height: 24.h,
//                                             decoration: BoxDecoration(
//                                               color: isSelected
//                                                   ? AllColors.white
//                                                   : Color(filter['color']),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: Icon(
//                                               filter['icon'],
//                                               color: isSelected
//                                                   ? AllColors.blue
//                                                   : AllColors.white,
//                                               size: 12.sp,
//                                             ),
//                                           ),
//                                           SizedBox(width: 8.w),
//                                           Text(
//                                             filter['name'],
//                                             style: tm12.copyWith(
//                                               color: isSelected
//                                                   ? AllColors.white
//                                                   : AllColors.black,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                       ),

//                       SizedBox(height: 16.h),

//                       // Nutrition Filters
//                       GestureDetector(
//                         onTap: () {
//                           // Toggle nutrition filters
//                         },
//                         child: Row(
//                           children: [
//                             Text(
//                               'Nutrition Filters',
//                               style: tm14.copyWith(
//                                 color: AllColors.black,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             SizedBox(width: 8.w),
//                             Icon(
//                               Icons.keyboard_arrow_down,
//                               color: AllColors.black,
//                               size: 16.sp,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Search Results
//                 Expanded(
//                   child: state.isLoading
//                       ? Center(
//                           child: CircularProgressIndicator(
//                             color: AllColors.blue,
//                           ),
//                         )
//                       : state.searchResults.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.search_off,
//                                 size: 64.sp,
//                                 color: AllColors.grey,
//                               ),
//                               SizedBox(height: 16.h),
//                               Text(
//                                 'No products found',
//                                 style: tb18.copyWith(
//                                   color: AllColors.grey,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               SizedBox(height: 8.h),
//                               Text(
//                                 'Try searching for a different product',
//                                 style: tm14.copyWith(color: AllColors.grey),
//                               ),
//                             ],
//                           ),
//                         )
//                       : ListView.builder(
//                           padding: EdgeInsets.symmetric(horizontal: 20.w),
//                           itemCount: state.searchResults.length,
//                           itemBuilder: (context, index) {
//                             final product = state.searchResults[index];
//                             return _buildProductCard(product);
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: AllColors.white,
//       elevation: 0,
//       leading: IconButton(
//         icon: Container(
//           width: 32.w,
//           height: 32.h,
//           decoration: BoxDecoration(
//             color: AllColors.grey.withValues(alpha: 0.2),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(Icons.arrow_back, color: AllColors.black, size: 16.sp),
//         ),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: Container(
//         height: 40.h,
//         decoration: BoxDecoration(
//           color: AllColors.grey.withValues(alpha: 0.1),
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         child: TextField(
//           controller: _searchController,
//           decoration: InputDecoration(
//             hintText: 'Search',
//             hintStyle: tm14.copyWith(color: AllColors.grey),
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.symmetric(
//               horizontal: 16.w,
//               vertical: 8.h,
//             ),
//             suffixIcon: Icon(Icons.search, color: AllColors.black, size: 20.sp),
//           ),
//           style: tm14.copyWith(color: AllColors.black),
//           onChanged: (value) {
//             if (value.length >= 2) {
//               _performSearch();
//             } else {
//               context.read<SearchCubit>().clearSearch();
//             }
//           },
//         ),
//       ),
//       centerTitle: false,
//       titleSpacing: 16.w,
//     );
//   }

//   Widget _buildProductCard(ProductModel product) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16.h),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: AllColors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: AllColors.black.withValues(alpha: 0.05),
//             blurRadius: 10.r,
//             offset: Offset(0, 2.h),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Product Image
//           Container(
//             width: 80.w,
//             height: 80.h,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.r),
//               color: AllColors.grey.withValues(alpha: 0.1),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8.r),
//               child: product.imageUrl != null
//                   ? Image.network(
//                       product.imageUrl!,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Icon(
//                           Icons.image,
//                           color: AllColors.grey,
//                           size: 32.sp,
//                         );
//                       },
//                     )
//                   : Icon(Icons.image, color: AllColors.grey, size: 32.sp),
//             ),
//           ),

//           SizedBox(width: 16.w),

//           // Product Info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Product Name with Checkmark
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         product.name ?? '',
//                         style: tm16.copyWith(
//                           color: AllColors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(width: 8.w),
//                     Icon(
//                       Icons.check_circle,
//                       color: AllColors.blue,
//                       size: 16.sp,
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 4.h),

//                 // Brand
//                 Text(
//                   product.brands ?? 'Unknown Brand',
//                   style: tm12.copyWith(
//                     color: AllColors.grey,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),

//                 SizedBox(height: 8.h),

//                 // Nutri-Score
//                 _buildNutriScore(product.nutriScoreGrade ?? 'C'),
//               ],
//             ),
//           ),

//           SizedBox(width: 16.w),

//           // Actions
//           Column(
//             children: [
//               // Heart Icon
//               Container(
//                 width: 32.w,
//                 height: 32.h,
//                 decoration: BoxDecoration(
//                   color: AllColors.grey.withValues(alpha: 0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.favorite_border,
//                   color: AllColors.grey,
//                   size: 16.sp,
//                 ),
//               ),

//               SizedBox(height: 8.h),

//               // Alternative Icon
//               Container(
//                 width: 32.w,
//                 height: 32.h,
//                 decoration: BoxDecoration(
//                   color: AllColors.grey.withValues(alpha: 0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.refresh, color: AllColors.grey, size: 16.sp),
//               ),

//               SizedBox(height: 4.h),

//               // Alternative Text
//               Text(
//                 'Alternative',
//                 style: tm10.copyWith(
//                   color: AllColors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               SizedBox(height: 4.h),

//               // Rating
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     '4.5',
//                     style: tm12.copyWith(
//                       color: AllColors.black,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(width: 2.w),
//                   Icon(Icons.star, color: AllColors.yellow, size: 12.sp),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNutriScore(String grade) {
//     return Container(
//       width: 120.w,
//       height: 20.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10.r),
//         border: Border.all(color: AllColors.grey.withValues(alpha: 0.3)),
//       ),
//       child: Row(
//         children: [
//           _buildNutriScoreSegment('A', AllColors.green, grade == 'A'),
//           _buildNutriScoreSegment('B', Color(0xFF90EE90), grade == 'B'),
//           _buildNutriScoreSegment('C', AllColors.yellow, grade == 'C'),
//           _buildNutriScoreSegment('D', Color(0xFFFFA500), grade == 'D'),
//           _buildNutriScoreSegment('E', AllColors.red, grade == 'E'),
//         ],
//       ),
//     );
//   }

//   Widget _buildNutriScoreSegment(String letter, Color color, bool isSelected) {
//     return Expanded(
//       child: Container(
//         height: 20.h,
//         decoration: BoxDecoration(
//           color: isSelected ? color : AllColors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: letter == 'A' ? Radius.circular(10.r) : Radius.zero,
//             bottomLeft: letter == 'A' ? Radius.circular(10.r) : Radius.zero,
//             topRight: letter == 'E' ? Radius.circular(10.r) : Radius.zero,
//             bottomRight: letter == 'E' ? Radius.circular(10.r) : Radius.zero,
//           ),
//         ),
//         child: Center(
//           child: Text(
//             letter,
//             style: tm10.copyWith(
//               color: isSelected ? AllColors.white : AllColors.black,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
