// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      barcode: json['barcode'] as String?,
      name: json['name'] as String?,
      brands: json['brands'] as String?,
      imageUrl: json['image_url'] as String?,
      nutriScoreGrade: json['nutriscore_grade'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      nutriments: json['nutriments'] as Map<String, dynamic>?,
      traces:
          (json['traces'] as List<dynamic>?)?.map((e) => e as String).toList(),
      labels:
          (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'barcode': instance.barcode,
      'name': instance.name,
      'brands': instance.brands,
      'image_url': instance.imageUrl,
      'nutriscore_grade': instance.nutriScoreGrade,
      'categories': instance.categories,
      'ingredients': instance.ingredients?.map((e) => e.toJson()).toList(),
      'allergens': instance.allergens,
      'nutriments': instance.nutriments,
      'traces': instance.traces,
      'labels': instance.labels,
      'errorMessage': instance.errorMessage,
    };

IngredientModel _$IngredientModelFromJson(Map<String, dynamic> json) =>
    IngredientModel(
      id: json['id'] as String?,
      text: json['text'] as String?,
      percent: (json['percent'] as num?)?.toDouble(),
      percentEstimate: (json['percent_estimate'] as num?)?.toDouble(),
      rank: (json['rank'] as num?)?.toInt(),
    );

Map<String, dynamic> _$IngredientModelToJson(IngredientModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'percent': instance.percent,
      'percent_estimate': instance.percentEstimate,
      'rank': instance.rank,
    };
