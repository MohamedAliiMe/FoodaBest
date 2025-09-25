import 'package:json_annotation/json_annotation.dart';

part 'base_empty_data_response.g.dart';

@JsonSerializable(includeIfNull: false)
class BaseEmptyDataResponse {
  bool? success;
  String? message;

  BaseEmptyDataResponse({
    this.success,
    this.message,
  });

  factory BaseEmptyDataResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseEmptyDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseEmptyDataResponseToJson(this);
}
