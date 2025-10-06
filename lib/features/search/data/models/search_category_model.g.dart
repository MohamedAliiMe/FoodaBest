// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchCategoryModel _$SearchCategoryModelFromJson(Map<String, dynamic> json) =>
    SearchCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      productsCount: (json['productsCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SearchCategoryModelToJson(
        SearchCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'productsCount': instance.productsCount,
    };
