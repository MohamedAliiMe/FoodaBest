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
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get failedState => throw _privateConstructorUsedError;
  ProductModel? get product => throw _privateConstructorUsedError;
  AnalysisModel? get analysis => throw _privateConstructorUsedError;
  List<ProductModel>? get alternativeProducts =>
      throw _privateConstructorUsedError;

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
      {bool isLoading,
      String? errorMessage,
      bool failedState,
      ProductModel? product,
      AnalysisModel? analysis,
      List<ProductModel>? alternativeProducts});
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
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? failedState = null,
    Object? product = freezed,
    Object? analysis = freezed,
    Object? alternativeProducts = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      failedState: null == failedState
          ? _value.failedState
          : failedState // ignore: cast_nullable_to_non_nullable
              as bool,
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
      {bool isLoading,
      String? errorMessage,
      bool failedState,
      ProductModel? product,
      AnalysisModel? analysis,
      List<ProductModel>? alternativeProducts});
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
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? failedState = null,
    Object? product = freezed,
    Object? analysis = freezed,
    Object? alternativeProducts = freezed,
  }) {
    return _then(_$ProductAnalysisStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      failedState: null == failedState
          ? _value.failedState
          : failedState // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ));
  }
}

/// @nodoc

class _$ProductAnalysisStateImpl implements _ProductAnalysisState {
  _$ProductAnalysisStateImpl(
      {this.isLoading = false,
      this.errorMessage,
      this.failedState = false,
      this.product,
      this.analysis,
      final List<ProductModel>? alternativeProducts})
      : _alternativeProducts = alternativeProducts;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool failedState;
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
  String toString() {
    return 'ProductAnalysisState(isLoading: $isLoading, errorMessage: $errorMessage, failedState: $failedState, product: $product, analysis: $analysis, alternativeProducts: $alternativeProducts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductAnalysisStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.failedState, failedState) ||
                other.failedState == failedState) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            const DeepCollectionEquality()
                .equals(other._alternativeProducts, _alternativeProducts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      errorMessage,
      failedState,
      product,
      analysis,
      const DeepCollectionEquality().hash(_alternativeProducts));

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
          {final bool isLoading,
          final String? errorMessage,
          final bool failedState,
          final ProductModel? product,
          final AnalysisModel? analysis,
          final List<ProductModel>? alternativeProducts}) =
      _$ProductAnalysisStateImpl;

  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  bool get failedState;
  @override
  ProductModel? get product;
  @override
  AnalysisModel? get analysis;
  @override
  List<ProductModel>? get alternativeProducts;
  @override
  @JsonKey(ignore: true)
  _$$ProductAnalysisStateImplCopyWith<_$ProductAnalysisStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
