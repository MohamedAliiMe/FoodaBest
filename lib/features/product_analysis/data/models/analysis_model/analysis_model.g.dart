// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalysisModel _$AnalysisModelFromJson(Map<String, dynamic> json) =>
    AnalysisModel(
      summary: json['summary'] as String?,
      safetyStatus: json['safety_status'] as String?,
      detectedAllergens: (json['detected_allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      alternativeIngredients:
          (json['alternative_ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      analysisTime: json['analysis_time'] as String?,
      warnings: (json['warnings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AnalysisModelToJson(AnalysisModel instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'safety_status': instance.safetyStatus,
      'detected_allergens': instance.detectedAllergens,
      'alternative_ingredients': instance.alternativeIngredients,
      'analysis_time': instance.analysisTime,
      'warnings': instance.warnings,
    };
