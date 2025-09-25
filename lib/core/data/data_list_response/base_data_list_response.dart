import 'package:json_annotation/json_annotation.dart';

part 'base_data_list_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ListBaseResponse<T> {
  bool? status;
  String? message;
  List<T>? data;

  ListBaseResponse({
    this.status,
    this.message,
    this.data,
  });

  ListBaseResponse.fromJson(
      Map<String, dynamic>? json, Function(Map<String, dynamic>) create) {
    if (json != null) {
      status = json['status'] as bool?;
      message = json['message'] as String?;
      data = [];
      json['data']?.forEach((v) {
        data!.add(create(v as Map<String, dynamic>) as T);
      });
    }
  }
}
