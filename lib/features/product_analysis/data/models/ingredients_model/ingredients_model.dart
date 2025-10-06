import 'package:json_annotation/json_annotation.dart';

part 'ingredients_model.g.dart';

/// Model class to store the ingredients analysis results from the AI API
@JsonSerializable(explicitToJson: true)
class IngredientsModel {
  /// Summary of the analysis - overall safety assessment
  final String? summary;

  /// List of potential allergens found in the ingredients
  final List<String>? allergens;

  /// List of all identified ingredients
  final List<String>? ingredients;

  /// Safety status: green (safe), yellow (caution), red (unsafe)
  final String? safetyStatus;

  /// Any warnings or cautions about the ingredients
  final List<String>? warnings;

  IngredientsModel({
    this.summary,
    this.allergens,
    this.ingredients,
    this.safetyStatus,
    this.warnings,
  });

  factory IngredientsModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientsModelFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientsModelToJson(this);

  /// Helper method to create an empty model
  factory IngredientsModel.empty() {
    return IngredientsModel(
      summary: null,
      allergens: [],
      ingredients: [],
      safetyStatus: null,
      warnings: [],
    );
  }
}
