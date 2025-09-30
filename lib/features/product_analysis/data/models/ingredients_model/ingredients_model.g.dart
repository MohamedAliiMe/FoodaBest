// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredients_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientsModel _$IngredientsModelFromJson(Map<String, dynamic> json) =>
    IngredientsModel(
      summary: json['summary'] as String?,
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      safetyStatus: json['safetyStatus'] as String?,
      warnings: (json['warnings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$IngredientsModelToJson(IngredientsModel instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'allergens': instance.allergens,
      'ingredients': instance.ingredients,
      'safetyStatus': instance.safetyStatus,
      'warnings': instance.warnings,
    };
