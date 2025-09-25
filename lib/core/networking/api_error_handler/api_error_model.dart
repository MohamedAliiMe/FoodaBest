import 'package:fooda_best/core/helper/extensions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  final String? message;
  @JsonKey(name: 'data')
  final Map<String, dynamic>? errors;

  ApiErrorModel({this.message, this.errors});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);

  /// Returns a String containing all error messages.
  String getAllErrorMessages() {
    if (errors.isNullOrEmpty()) return message ?? "Unknown error occurred";

    final errorMessages = errors!.entries
        .map((entry) {
          final value = entry.value;
          return "${value.join(', ')}";
        })
        .join('\n');

    return errorMessages;
  }
}
