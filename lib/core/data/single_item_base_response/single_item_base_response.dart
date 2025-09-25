import 'package:json_annotation/json_annotation.dart';

part 'single_item_base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
@JsonSerializable(includeIfNull: false)
class SingleItemBaseResponse<T> {
  bool? success;
  T? data;
  String? message;

  SingleItemBaseResponse({
    this.success,
    this.data,
    this.message,
  });

  SingleItemBaseResponse.fromJson(
      Map<String, dynamic>? json, Function(Map<String, dynamic>) create) {
    if (json != null) {
      success = json['success'] as bool?;
      data = create(json['data'] as Map<String, dynamic>) as T?;
      message = json['message'] as String?;
    }
  }
}

@JsonSerializable(genericArgumentFactories: true)
@JsonSerializable(includeIfNull: false)
class ItemBaseOrderResponse<T> {
  bool? success;
  T? order;
  String? message;

  ItemBaseOrderResponse({
    this.success,
    this.order,
    this.message,
  });

  ItemBaseOrderResponse.fromJson(
      Map<String, dynamic>? json, Function(Map<String, dynamic>) create) {
    if (json != null) {
      success = json['success'] as bool?;
      order = create(json['order'] as Map<String, dynamic>) as T?;
      message = json['message'] as String?;
    }
  }
}
