import 'package:json_annotation/json_annotation.dart';

part 'pagination_request_params.g.dart';

@JsonSerializable(includeIfNull: false)
class PaginationRequestParams {
  int limit;
  int page;

  PaginationRequestParams({
    required this.limit,
    required this.page,
  });

  Map<String, dynamic> toJson() => _$PaginationRequestParamsToJson(this);

  factory PaginationRequestParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationRequestParamsFromJson(json);
}
