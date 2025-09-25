// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationResponseModel _$PaginationResponseModelFromJson(
        Map<String, dynamic> json) =>
    PaginationResponseModel(
      currentPage: (json['current_page'] as num?)?.toInt(),
      nextPage: (json['next_page_url'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      itemsPerPage: (json['per_page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      prevPage: (json['prev_page_url'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationResponseModelToJson(
        PaginationResponseModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'next_page_url': instance.nextPage,
      'prev_page_url': instance.prevPage,
      'last_page': instance.lastPage,
      'per_page': instance.itemsPerPage,
      'total': instance.total,
    };

TransactionPaginationResponseModel _$TransactionPaginationResponseModelFromJson(
        Map<String, dynamic> json) =>
    TransactionPaginationResponseModel(
      currentPage: (json['currentPage'] as num?)?.toInt(),
      nextPage: (json['nextPage'] as num?)?.toInt(),
      perPage: (json['perPage'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      totalItems: (json['totalItems'] as num?)?.toInt(),
      prevPage: (json['prevPage'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionPaginationResponseModelToJson(
        TransactionPaginationResponseModel instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'nextPage': instance.nextPage,
      'prevPage': instance.prevPage,
      'totalPages': instance.totalPages,
      'perPage': instance.perPage,
      'totalItems': instance.totalItems,
    };
