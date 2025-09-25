// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_data_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListBaseResponse<T> _$ListBaseResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ListBaseResponse<T>(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
    );

Map<String, dynamic> _$ListBaseResponseToJson<T>(
  ListBaseResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.map(toJsonT).toList(),
    };
