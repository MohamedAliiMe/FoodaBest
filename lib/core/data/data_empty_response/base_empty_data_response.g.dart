// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_empty_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseEmptyDataResponse _$BaseEmptyDataResponseFromJson(
        Map<String, dynamic> json) =>
    BaseEmptyDataResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$BaseEmptyDataResponseToJson(
    BaseEmptyDataResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('success', instance.success);
  writeNotNull('message', instance.message);
  return val;
}
