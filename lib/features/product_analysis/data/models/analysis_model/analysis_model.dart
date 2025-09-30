import 'package:json_annotation/json_annotation.dart';

part 'analysis_model.g.dart';

@JsonSerializable()
class AnalysisModel {
  final String? summary;
  @JsonKey(name: 'safety_status')
  final String? safetyStatus; // 'green', 'yellow', 'red'
  @JsonKey(name: 'detected_allergens')
  final List<String>? detectedAllergens;
  @JsonKey(name: 'alternative_ingredients')
  final List<String>? alternativeIngredients;
  @JsonKey(name: 'analysis_time')
  final String? analysisTime;
  final List<String>? warnings;

  AnalysisModel({
    this.summary,
    this.safetyStatus,
    this.detectedAllergens,
    this.alternativeIngredients,
    this.analysisTime,
    this.warnings,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$AnalysisModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisModelToJson(this);

  factory AnalysisModel.empty() {
    return AnalysisModel(
      summary: null,
      safetyStatus: 'green',
      detectedAllergens: const [],
      alternativeIngredients: const [],
      analysisTime: null,
      warnings: const [],
    );
  }
}
