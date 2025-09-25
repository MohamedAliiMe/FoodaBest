import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fooda_best/core/bloc_observer/bloc_observer.dart';
import 'package:fooda_best/core/constants/app_string_constants.dart';
import 'package:fooda_best/core/dependencies/dependency_init.dart';
import 'package:fooda_best/core/utilities/appKeys.dart';
import 'package:fooda_best/features/authentication/logic/authentication_cubit.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiInterceptors extends Interceptor {
  final Dio _dio;

  late Box box;

  ApiInterceptors(this._dio) {
    initHive();
    _addDioInterceptor();
  }

  Future<void> initHive() async {
    box = await Hive.openBox(AppStringConstants.appName);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    super.onRequest(options, handler);

    options.headers.addAll({
      AppStringConstants.platform: AppStringConstants.mobilePlatform,
    });

    // get tokens from local storage, you can use Hive or flutter_secure_storage
    final customerAccessToken = await box.get(
      AppStringConstants.userAccessToken,
    );
    var accessToken = customerAccessToken;

    log("accessToken $accessToken");
    options.headers["Authorization"] = "Bearer $accessToken";
    options.headers["Accept"] = "application/json";
    options.headers["Accept-Language"] = _getCurrentPathLanguage();
  }

  static String _getCurrentPathLanguage() {
    return AppKeys.materialKey.currentContext!.locale.languageCode;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _performLogout(_dio);
    }
    handler.next(err);
  }

  void _performLogout(Dio dio) async {
    getIt<AuthenticationCubit>().signOut();
  }

  void _addDioInterceptor() {
    _dio.interceptors.add(
      PrettyDioLogger(
        compact: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        enabled: true,
        request: true,
        maxWidth: 90,
        logPrint: (Object object) {
          logger.t(object.toString());
          logger.log(Logger.level, object.toString());
        },
      ),
    );
  }
}
