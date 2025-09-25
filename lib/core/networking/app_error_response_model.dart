import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error_response_model.g.dart';

@JsonSerializable(includeIfNull: false)
class ErrorResponseModel {
  String? message;

  ErrorResponseModel({
    this.message,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseModelToJson(this);
}
