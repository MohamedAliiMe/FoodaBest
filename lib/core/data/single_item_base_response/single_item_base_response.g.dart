// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_item_base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleItemBaseResponse<T> _$SingleItemBaseResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    SingleItemBaseResponse<T>(
      success: json['success'] as bool?,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$SingleItemBaseResponseToJson<T>(
  SingleItemBaseResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'message': instance.message,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

ItemBaseOrderResponse<T> _$ItemBaseOrderResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ItemBaseOrderResponse<T>(
      success: json['success'] as bool?,
      order: _$nullableGenericFromJson(json['order'], fromJsonT),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ItemBaseOrderResponseToJson<T>(
  ItemBaseOrderResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'order': _$nullableGenericToJson(instance.order, toJsonT),
      'message': instance.message,
    };
