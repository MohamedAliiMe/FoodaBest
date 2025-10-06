import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
  final String? barcode;
  final String? name;
  final String? brands;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'nutriscore_grade')
  final String? nutriScoreGrade;
  final List<String>? categories;
  final List<IngredientModel>? ingredients;
  final List<String>? allergens;
  final Map<String, dynamic>? nutriments;
  final List<String>? traces;
  final List<String>? labels;
  
  final String? errorMessage;

  ProductModel({
    this.barcode,
    this.name,
    this.brands,
    this.imageUrl,
    this.nutriScoreGrade,
    this.categories,
    this.ingredients,
    this.allergens,
    this.nutriments,
    this.traces,
    this.labels,
    this.errorMessage,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class IngredientModel {
  final String? id;
  final String? text;
  final double? percent;
  @JsonKey(name: 'percent_estimate')
  final double? percentEstimate;
  final int? rank;

  IngredientModel({
    this.id,
    this.text,
    this.percent,
    this.percentEstimate,
    this.rank,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientModelFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientModelToJson(this);
}
