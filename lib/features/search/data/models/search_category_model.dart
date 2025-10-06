import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_category_model.g.dart';

@JsonSerializable()
class SearchCategoryModel {
  final String id;
  final String name;
  final int? productsCount;
  final String? imageUrl;

  SearchCategoryModel({
    required this.id,
    required this.name,
    this.productsCount,
    this.imageUrl,
  });

  factory SearchCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SearchCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchCategoryModelToJson(this);
}
