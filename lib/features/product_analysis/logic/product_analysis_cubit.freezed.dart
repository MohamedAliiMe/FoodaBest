// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_analysis_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProductAnalysisState {
  ProductAnalysisStatus get status => throw _privateConstructorUsedError;
  ProductModel? get product => throw _privateConstructorUsedError;
  AnalysisModel? get analysis => throw _privateConstructorUsedError;
  List<ProductModel>? get alternativeProducts =>
      throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProductAnalysisStateCopyWith<ProductAnalysisState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductAnalysisStateCopyWith<$Res> {
  factory $ProductAnalysisStateCopyWith(ProductAnalysisState value,
          $Res Function(ProductAnalysisState) then) =
      _$ProductAnalysisStateCopyWithImpl<$Res, ProductAnalysisState>;
  @useResult
  $Res call(
      {ProductAnalysisStatus status,
      ProductModel? product,
      AnalysisModel? analysis,
      List<ProductModel>? alternativeProducts,
      String? errorMessage});
}

/// @nodoc
class _$ProductAnalysisStateCopyWithImpl<$Res,
        $Val extends ProductAnalysisState>
    implements $ProductAnalysisStateCopyWith<$Res> {
  _$ProductAnalysisStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? product = freezed,
    Object? analysis = freezed,
    Object? alternativeProducts = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProductAnalysisStatus,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductModel?,
      analysis: freezed == analysis
          ? _value.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as AnalysisModel?,
      alternativeProducts: freezed == alternativeProducts
          ? _value.alternativeProducts
          : alternativeProducts // ignore: cast_nullable_to_non_nullable
              as List<ProductModel>?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductAnalysisStateImplCopyWith<$Res>
    implements $ProductAnalysisStateCopyWith<$Res> {
  factory _$$ProductAnalysisStateImplCopyWith(_$ProductAnalysisStateImpl value,
          $Res Function(_$ProductAnalysisStateImpl) then) =
      __$$ProductAnalysisStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ProductAnalysisStatus status,
      ProductModel? product,
      AnalysisModel? analysis,
      List<ProductModel>? alternativeProducts,
      String? errorMessage});
}

/// @nodoc
class __$$ProductAnalysisStateImplCopyWithImpl<$Res>
    extends _$ProductAnalysisStateCopyWithImpl<$Res, _$ProductAnalysisStateImpl>
    implements _$$ProductAnalysisStateImplCopyWith<$Res> {
  __$$ProductAnalysisStateImplCopyWithImpl(_$ProductAnalysisStateImpl _value,
      $Res Function(_$ProductAnalysisStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? product = freezed,
    Object? analysis = freezed,
    Object? alternativeProducts = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ProductAnalysisStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProductAnalysisStatus,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductModel?,
      analysis: freezed == analysis
          ? _value.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as AnalysisModel?,
      alternativeProducts: freezed == alternativeProducts
          ? _value._alternativeProducts
          : alternativeProducts // ignore: cast_nullable_to_non_nullable
              as List<ProductModel>?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ProductAnalysisStateImpl implements _ProductAnalysisState {
  _$ProductAnalysisStateImpl(
      {this.status = ProductAnalysisStatus.initial,
      this.product,
      this.analysis,
      final List<ProductModel>? alternativeProducts,
      this.errorMessage})
      : _alternativeProducts = alternativeProducts;

  @override
  @JsonKey()
  final ProductAnalysisStatus status;
  @override
  final ProductModel? product;
  @override
  final AnalysisModel? analysis;
  final List<ProductModel>? _alternativeProducts;
  @override
  List<ProductModel>? get alternativeProducts {
    final value = _alternativeProducts;
    if (value == null) return null;
    if (_alternativeProducts is EqualUnmodifiableListView)
      return _alternativeProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ProductAnalysisState(status: $status, product: $product, analysis: $analysis, alternativeProducts: $alternativeProducts, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductAnalysisStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            const DeepCollectionEquality()
                .equals(other._alternativeProducts, _alternativeProducts) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, product, analysis,
      const DeepCollectionEquality().hash(_alternativeProducts), errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductAnalysisStateImplCopyWith<_$ProductAnalysisStateImpl>
      get copyWith =>
          __$$ProductAnalysisStateImplCopyWithImpl<_$ProductAnalysisStateImpl>(
              this, _$identity);
}

abstract class _ProductAnalysisState implements ProductAnalysisState {
  factory _ProductAnalysisState(
      {final ProductAnalysisStatus status,
      final ProductModel? product,
      final AnalysisModel? analysis,
      final List<ProductModel>? alternativeProducts,
      final String? errorMessage}) = _$ProductAnalysisStateImpl;

  @override
  ProductAnalysisStatus get status;
  @override
  ProductModel? get product;
  @override
  AnalysisModel? get analysis;
  @override
  List<ProductModel>? get alternativeProducts;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$ProductAnalysisStateImplCopyWith<_$ProductAnalysisStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
