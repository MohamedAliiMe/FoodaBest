// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_request_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationRequestParams _$PaginationRequestParamsFromJson(
        Map<String, dynamic> json) =>
    PaginationRequestParams(
      limit: (json['limit'] as num).toInt(),
      page: (json['page'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationRequestParamsToJson(
        PaginationRequestParams instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'page': instance.page,
    };
