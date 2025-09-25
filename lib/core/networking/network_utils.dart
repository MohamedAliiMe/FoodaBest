import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooda_best/core/networking/api_error_handler/api_error_handler.dart';
import 'package:fooda_best/core/networking/app_error_response_model.dart';
import 'package:retrofit/dio.dart';


import 'data_state.dart';

class NetworkUtils<T> {
  Future<DataState<T>> handleApiResponse(Future<HttpResponse<T>> function,
      {bool? ignoreResponse}) async {
    try {
      final httpResponse = await function;
      if ((httpResponse.response.statusCode == HttpStatus.ok) ||
          (httpResponse.response.statusCode == HttpStatus.created)) {
        if (ignoreResponse != null && ignoreResponse) {
          return DataSuccess(httpResponse.data);
        } else {
          if (httpResponse.response.data != null) {
            return DataSuccess(httpResponse.data);
          }
        }
      }
      return DataFailed(
        ApiErrorHandler.getMessage(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            requestOptions: RequestOptions(),
          ),
        ),
      );
    } on DioException catch (dioError) {
      if (dioError.response?.data != null) {
        ErrorResponseModel? errorRes;
        final responseData = dioError.response!.data!;
        if (responseData is String) {
          errorRes = ErrorResponseModel.fromJson(jsonDecode(responseData));
        } else if (responseData is Map<String, dynamic>) {
          errorRes = ErrorResponseModel.fromJson(responseData);
        }

        if (errorRes?.message != null) {}
      }
      return DataFailed(ApiErrorHandler.getMessage(dioError));
    } catch (e, stack) {
      debugPrint(stack.toString());
      return DataFailed(ApiErrorHandler.getMessage(e));
    }
  }
}

class VoidResponse {
  VoidResponse();

  factory VoidResponse.fromJson(Map<String, dynamic>? json) => VoidResponse();
}
