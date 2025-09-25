import 'package:dio/dio.dart';

import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(message: "Connection to server failed");
        case DioExceptionType.cancel:
          return ApiErrorModel(message: "Request to the server was cancelled");
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(message: "Connection timeout with the server");
        case DioExceptionType.unknown:
          return ApiErrorModel(
            message:
                "Connection to the server failed due to internet connection",
          );
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            message: "Receive timeout in connection with the server",
          );
        case DioExceptionType.badResponse:
          return _handleError(error.response?.statusCode, error.response?.data);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
            message: "Send timeout in connection with the server",
          );
        default:
          return ApiErrorModel(message: "Something went wrong");
      }
    } else {
      return ApiErrorModel(message: "Unexpected error occurred");
    }
  }

  static ApiErrorModel _handleError(int? statusCode, dynamic error) {
    return ApiErrorModel(
      message: error['message'] ?? "Unknown error occurred",
      errors: error['data'],
    );
  }

  static String getMessage(dynamic error) {
    // log("Api Error Handler");
    String errorDescription = "Unexpected error occurred";
    // print("ApiErrorHandler " + " error " + error.toString() + " " + error.runtimeType.toString());
    if (error is Exception) {
      try {
        if (error is DioException &&
            error.response?.data is Map<String, dynamic>) {
          final errorRes = ApiErrorModel.fromJson(
            error.response!.data! as Map<String, dynamic>,
          );
          if (errorRes.message != null) {
            errorDescription = errorRes.message!;
          }
        }
      } catch (e) {
        errorDescription = e.toString();
      }
    }
    return errorDescription;
  }
}
