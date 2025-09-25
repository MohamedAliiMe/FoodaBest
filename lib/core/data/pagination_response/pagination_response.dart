import 'package:json_annotation/json_annotation.dart';

part 'pagination_response.g.dart';

@JsonSerializable()
class PaginationResponseModel {
  @JsonKey(name: 'current_page')
  int? currentPage;
  @JsonKey(name: 'next_page_url')
  int? nextPage;
  @JsonKey(name: 'prev_page_url')
  int? prevPage;
  @JsonKey(name: 'last_page')
  int? lastPage;
  @JsonKey(name: 'per_page')
  int? itemsPerPage;
  int? total;

  PaginationResponseModel(
      {this.currentPage,
      this.nextPage,
      this.lastPage,
      this.itemsPerPage,
      this.total,
      this.prevPage});

  factory PaginationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationResponseModelToJson(this);
}

@JsonSerializable()
class TransactionPaginationResponseModel {
  int? currentPage;
  int? nextPage;
  int? prevPage;
  int? totalPages;
  int? perPage;
  int? totalItems;

  TransactionPaginationResponseModel(
      {this.currentPage,
      this.nextPage,
      this.perPage,
      this.totalPages,
      this.totalItems,
      this.prevPage});

  factory TransactionPaginationResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$TransactionPaginationResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TransactionPaginationResponseModelToJson(this);
}
