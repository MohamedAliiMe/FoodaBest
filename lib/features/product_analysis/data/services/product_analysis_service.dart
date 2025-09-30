// import 'package:dio/dio.dart';
// import 'package:fooda_best/core/data/single_item_base_response/single_item_base_response.dart';
// import 'package:fooda_best/features/product_analysis/data/models/analysis_model.dart';
// import 'package:fooda_best/features/product_analysis/data/models/product_model.dart';
// import 'package:injectable/injectable.dart';
// import 'package:retrofit/retrofit.dart';

// part 'product_analysis_service.g.dart';

// @RestApi(baseUrl: 'https://world.openfoodfacts.org')
// @LazySingleton()
// abstract class ProductAnalysisService {
//   @factoryMethod
//   factory ProductAnalysisService(@Named('Dio') Dio dio) =>
//       _ProductAnalysisService(dio);

//   // OpenFoodFacts API
//   @GET('/api/v0/product/{barcode}.json')
//   Future<HttpResponse<SingleItemBaseResponse<ProductModel>>>
//   getProductByBarcode(@Path('barcode') String barcode);

//   // Alternative products search
//   @GET('/cgi/search.pl')
//   Future<HttpResponse<Map<String, dynamic>>> searchProducts(
//     @Query('search_terms') String searchTerms,
//     @Query('search_simple') int searchSimple,
//     @Query('action') String action,
//     @Query('json') int json,
//     @Query('page_size') int pageSize,
//   );

//   // AI Analysis (placeholder for OpenAI integration)
//   @POST('/analyze')
//   Future<HttpResponse<SingleItemBaseResponse<AnalysisModel>>> analyzeProduct(
//     @Body() Map<String, dynamic> analysisRequest,
//   );
// }
