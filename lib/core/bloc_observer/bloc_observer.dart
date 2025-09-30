import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooda_best/features/authentication/logic/authentication_cubit.dart';
import 'package:fooda_best/features/product_analysis/logic/product_analysis_cubit.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.none,
    noBoxingByDefault: false,
    levelColors: {for (var level in Level.values) level: AnsiColor.fg(0)},
    levelEmojis: {for (var level in Level.values) level: '👻'},
  ),
);

// final dio = Dio()
//   ..interceptors.add(
//     PrettyDioLogger(
//       requestHeader: true,
//       requestBody: true,
//       responseBody: true,
//       responseHeader: false,
//       error: true,
//       compact: true,
//       maxWidth: 90,
//     ),
//   );

Future<void> logBigText(String text) async {
  final String border = '👻' * 20;
  final String header = '💻 Mahmoud Ali Dev 💻';

  final formattedMessage =
      '''
🥷💻🎶😜😎🥳🤯🤬😴😈👻☠️🙄🤫🤑🫣🧐😡😤🥺🥺😵😉🤨😏🥷🫵
🥷 🤯 $border
🥷 🤯 $header
🥷 🤯 $border
🥷 🤯 $text
🥷 🤯 $border
''';

  logger.i(formattedMessage);
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    //  logger.log(Level.error, 'onCreate -- ${bloc.runtimeType}');
    logBigText('onCreate -- ${bloc.runtimeType}');
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    // logger.log(Level.error, 'onChange -- ${bloc.state}, $change');

    String logMessage = 'onChange -- ${bloc.state}, ${change.toString()}';

    // Check if state has any model and show its JSON
    final nextState = change.nextState;

    // Try to extract JSON from any state that has models
    try {
      String jsonInfo = _extractJsonFromObject(nextState, 'State');
      if (jsonInfo.isNotEmpty) {
        logMessage += '\n$jsonInfo';
      }
    } catch (e) {
      // Silently ignore extraction errors
    }

    logBigText(logMessage);
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logBigText('onError -- ${bloc.runtimeType}, $error');
    //  logger.e('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    logBigText('Bloc Closed: ${bloc.runtimeType}');
    super.onClose(bloc);

    //  logger.w('onClose -- ${bloc.runtimeType}');
  }

  /// Extract JSON from any object that has toJson() method
  String _extractJsonFromObject(dynamic obj, String objName) {
    if (obj == null) return '';

    String result = '';

    try {
      // Handle different common state types
      if (obj is AuthenticationState && obj.user != null) {
        final json = obj.user!.toJson();
        result += '\n📱 User JSON: ${json.toString()}';
      }

      // Handle ProductAnalysisState
      if (obj is ProductAnalysisState) {
        try {
          // Extract product data
          if (obj.product != null) {
            final productJson = obj.product!.toJson();
            result += '\n🛍️ REAL PRODUCT JSON: ${productJson.toString()}';
            result += '\n📊 Product Name: ${obj.product!.name}';
            result += '\n🏷️ Product Brand: ${obj.product!.brands}';
            result += '\n⭐ NutriScore: ${obj.product!.nutriScoreGrade}';
          }

          // Extract analysis data
          if (obj.analysis != null) {
            final analysisJson = obj.analysis!.toJson();
            result += '\n🤖 ANALYSIS JSON: ${analysisJson.toString()}';
          }

          // Extract alternative products
          if (obj.alternativeProducts != null &&
              obj.alternativeProducts!.isNotEmpty) {
            result += '\n🔄 ALTERNATIVES JSON: [';
            for (int i = 0; i < obj.alternativeProducts!.length; i++) {
              final altJson = obj.alternativeProducts![i].toJson();
              result += '\n  ${i + 1}. ${altJson.toString()}';
            }
            result += '\n]';
          }
        } catch (e) {
          result += '\n❌ Error extracting ProductAnalysisState data: $e';
        }
      }

      // Try direct toJson() call on the object itself
      try {
        final json = obj.toJson();
        result += '\n📱 $objName JSON: ${json.toString()}';
      } catch (e) {
        // Object doesn't have toJson, that's fine
      }

      // Try to access common model properties using dynamic access
      try {
        final List<String> commonModelProps = [
          'user',
          'profile',
          'data',
          'model',
          'item',
          'entity',
          'barcode',
          'analysis',
          'product',
          'alternativeProducts',
        ];

        for (final prop in commonModelProps) {
          try {
            final dynamic propValue = _getProperty(obj, prop);
            if (propValue != null && propValue.toString() != 'null') {
              final json = propValue.toJson();
              result += '\n📱 $objName.$prop JSON: ${json.toString()}';
            }
          } catch (e) {
            // Property doesn't exist or doesn't have toJson
          }
        }
      } catch (e) {
        // Dynamic access failed
      }
    } catch (e) {
      // All attempts failed, that's ok
    }

    return result;
  }

  /// Try to get a property value from an object dynamically
  dynamic _getProperty(dynamic obj, String propertyName) {
    try {
      switch (propertyName) {
        case 'user':
          return obj?.user;
        case 'profile':
          return obj?.profile;
        case 'data':
          return obj?.data;
        case 'model':
          return obj?.model;
        case 'item':
          return obj?.item;
        case 'entity':
          return obj?.entity;
        case 'barcode':
          return obj?.barcode;
        case 'analysis':
          return obj?.analysis;
        case 'product':
          return obj?.product;
        case 'alternativeProducts':
          return obj?.alternativeProducts;
      }
    } catch (e) {
      return null;
    }
  }
}
