// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddProduct {


/// Create a copy of AddProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddProductCopyWith<AddProduct> get copyWith => _$AddProductCopyWithImpl<AddProduct>(this as AddProduct, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AddProduct;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddProduct&&(identical(other.product, _this.product) || other.product == _this.product));
}


@override
int get hashCode {
  final _this = this as AddProduct;
  return Object.hash(runtimeType,_this.product);
}

@override
String toString() {
  final _this = this as AddProduct;
  return 'AddProduct(product: ${_this.product})';
}


}

/// @nodoc
abstract mixin class $AddProductCopyWith<$Res>  {
  factory $AddProductCopyWith(AddProduct value, $Res Function(AddProduct) _then) = _$AddProductCopyWithImpl;
@useResult
$Res call({
 Product product
});




}
/// @nodoc
class _$AddProductCopyWithImpl<$Res>
    implements $AddProductCopyWith<$Res> {
  _$AddProductCopyWithImpl(this._self, this._then);

  final AddProduct _self;
  final $Res Function(AddProduct) _then;

/// Create a copy of AddProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,}) {
  return _then(AddProduct(
null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,
  ));
}

}


/// Adds pattern-matching-related methods to [AddProduct].
extension AddProductPatterns on AddProduct {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$RemoveProduct {


/// Create a copy of RemoveProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveProductCopyWith<RemoveProduct> get copyWith => _$RemoveProductCopyWithImpl<RemoveProduct>(this as RemoveProduct, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RemoveProduct;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveProduct&&(identical(other.product, _this.product) || other.product == _this.product));
}


@override
int get hashCode {
  final _this = this as RemoveProduct;
  return Object.hash(runtimeType,_this.product);
}

@override
String toString() {
  final _this = this as RemoveProduct;
  return 'RemoveProduct(product: ${_this.product})';
}


}

/// @nodoc
abstract mixin class $RemoveProductCopyWith<$Res>  {
  factory $RemoveProductCopyWith(RemoveProduct value, $Res Function(RemoveProduct) _then) = _$RemoveProductCopyWithImpl;
@useResult
$Res call({
 Product product
});




}
/// @nodoc
class _$RemoveProductCopyWithImpl<$Res>
    implements $RemoveProductCopyWith<$Res> {
  _$RemoveProductCopyWithImpl(this._self, this._then);

  final RemoveProduct _self;
  final $Res Function(RemoveProduct) _then;

/// Create a copy of RemoveProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,}) {
  return _then(RemoveProduct(
null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,
  ));
}

}


/// Adds pattern-matching-related methods to [RemoveProduct].
extension RemoveProductPatterns on RemoveProduct {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$DeleteProductLine {


/// Create a copy of DeleteProductLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteProductLineCopyWith<DeleteProductLine> get copyWith => _$DeleteProductLineCopyWithImpl<DeleteProductLine>(this as DeleteProductLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeleteProductLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteProductLine&&(identical(other.product, _this.product) || other.product == _this.product));
}


@override
int get hashCode {
  final _this = this as DeleteProductLine;
  return Object.hash(runtimeType,_this.product);
}

@override
String toString() {
  final _this = this as DeleteProductLine;
  return 'DeleteProductLine(product: ${_this.product})';
}


}

/// @nodoc
abstract mixin class $DeleteProductLineCopyWith<$Res>  {
  factory $DeleteProductLineCopyWith(DeleteProductLine value, $Res Function(DeleteProductLine) _then) = _$DeleteProductLineCopyWithImpl;
@useResult
$Res call({
 Product product
});




}
/// @nodoc
class _$DeleteProductLineCopyWithImpl<$Res>
    implements $DeleteProductLineCopyWith<$Res> {
  _$DeleteProductLineCopyWithImpl(this._self, this._then);

  final DeleteProductLine _self;
  final $Res Function(DeleteProductLine) _then;

/// Create a copy of DeleteProductLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,}) {
  return _then(DeleteProductLine(
null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteProductLine].
extension DeleteProductLinePatterns on DeleteProductLine {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$ClearProducts {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearProducts);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ClearProducts()';
}


}

/// @nodoc
class $ClearProductsCopyWith<$Res>  {
$ClearProductsCopyWith(ClearProducts _, $Res Function(ClearProducts) __);
}


/// Adds pattern-matching-related methods to [ClearProducts].
extension ClearProductsPatterns on ClearProducts {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$PayOrder {


/// Create a copy of PayOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayOrderCopyWith<PayOrder> get copyWith => _$PayOrderCopyWithImpl<PayOrder>(this as PayOrder, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PayOrder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayOrder&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.tenderedKopecks, _this.tenderedKopecks) || other.tenderedKopecks == _this.tenderedKopecks)&&(identical(other.idempotencyKey, _this.idempotencyKey) || other.idempotencyKey == _this.idempotencyKey));
}


@override
int get hashCode {
  final _this = this as PayOrder;
  return Object.hash(runtimeType,_this.method,_this.tenderedKopecks,_this.idempotencyKey);
}

@override
String toString() {
  final _this = this as PayOrder;
  return 'PayOrder(method: ${_this.method}, tenderedKopecks: ${_this.tenderedKopecks}, idempotencyKey: ${_this.idempotencyKey})';
}


}

/// @nodoc
abstract mixin class $PayOrderCopyWith<$Res>  {
  factory $PayOrderCopyWith(PayOrder value, $Res Function(PayOrder) _then) = _$PayOrderCopyWithImpl;
@useResult
$Res call({
 PaymentMethod method, int tenderedKopecks, String idempotencyKey
});




}
/// @nodoc
class _$PayOrderCopyWithImpl<$Res>
    implements $PayOrderCopyWith<$Res> {
  _$PayOrderCopyWithImpl(this._self, this._then);

  final PayOrder _self;
  final $Res Function(PayOrder) _then;

/// Create a copy of PayOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? tenderedKopecks = null,Object? idempotencyKey = null,}) {
  return _then(PayOrder(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,tenderedKopecks: null == tenderedKopecks ? _self.tenderedKopecks : tenderedKopecks // ignore: cast_nullable_to_non_nullable
as int,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PayOrder].
extension PayOrderPatterns on PayOrder {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$AcknowledgePayment {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AcknowledgePayment);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AcknowledgePayment()';
}


}

/// @nodoc
class $AcknowledgePaymentCopyWith<$Res>  {
$AcknowledgePaymentCopyWith(AcknowledgePayment _, $Res Function(AcknowledgePayment) __);
}


/// Adds pattern-matching-related methods to [AcknowledgePayment].
extension AcknowledgePaymentPatterns on AcknowledgePayment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$CancelPayment {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CancelPayment);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CancelPayment()';
}


}

/// @nodoc
class $CancelPaymentCopyWith<$Res>  {
$CancelPaymentCopyWith(CancelPayment _, $Res Function(CancelPayment) __);
}


/// Adds pattern-matching-related methods to [CancelPayment].
extension CancelPaymentPatterns on CancelPayment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$UpdateOptions {


/// Create a copy of UpdateOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateOptionsCopyWith<UpdateOptions> get copyWith => _$UpdateOptionsCopyWithImpl<UpdateOptions>(this as UpdateOptions, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UpdateOptions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateOptions&&(identical(other.lineId, _this.lineId) || other.lineId == _this.lineId)&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.bean, _this.bean) || other.bean == _this.bean)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity));
}


@override
int get hashCode {
  final _this = this as UpdateOptions;
  return Object.hash(runtimeType,_this.lineId,const DeepCollectionEquality().hash(_this.options),_this.bean,_this.quantity);
}

@override
String toString() {
  final _this = this as UpdateOptions;
  return 'UpdateOptions(lineId: ${_this.lineId}, options: ${_this.options}, bean: ${_this.bean}, quantity: ${_this.quantity})';
}


}

/// @nodoc
abstract mixin class $UpdateOptionsCopyWith<$Res>  {
  factory $UpdateOptionsCopyWith(UpdateOptions value, $Res Function(UpdateOptions) _then) = _$UpdateOptionsCopyWithImpl;
@useResult
$Res call({
 String lineId, List<SelectedOption> options, Bean? bean, Decimal? quantity
});




}
/// @nodoc
class _$UpdateOptionsCopyWithImpl<$Res>
    implements $UpdateOptionsCopyWith<$Res> {
  _$UpdateOptionsCopyWithImpl(this._self, this._then);

  final UpdateOptions _self;
  final $Res Function(UpdateOptions) _then;

/// Create a copy of UpdateOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lineId = null,Object? options = null,Object? bean = freezed,Object? quantity = freezed,}) {
  return _then(UpdateOptions(
lineId: null == lineId ? _self.lineId : lineId // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<SelectedOption>,bean: freezed == bean ? _self.bean : bean // ignore: cast_nullable_to_non_nullable
as Bean?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Decimal?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateOptions].
extension UpdateOptionsPatterns on UpdateOptions {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$OrdersInitial {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'OrdersInitial()';
}


}

/// @nodoc
class $OrdersInitialCopyWith<$Res>  {
$OrdersInitialCopyWith(OrdersInitial _, $Res Function(OrdersInitial) __);
}


/// Adds pattern-matching-related methods to [OrdersInitial].
extension OrdersInitialPatterns on OrdersInitial {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$OrdersLoading {


/// Create a copy of OrdersLoading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersLoadingCopyWith<OrdersLoading> get copyWith => _$OrdersLoadingCopyWithImpl<OrdersLoading>(this as OrdersLoading, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrdersLoading;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersLoading&&const DeepCollectionEquality().equals(other.products, _this.products));
}


@override
int get hashCode {
  final _this = this as OrdersLoading;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.products));
}

@override
String toString() {
  final _this = this as OrdersLoading;
  return 'OrdersLoading(products: ${_this.products})';
}


}

/// @nodoc
abstract mixin class $OrdersLoadingCopyWith<$Res>  {
  factory $OrdersLoadingCopyWith(OrdersLoading value, $Res Function(OrdersLoading) _then) = _$OrdersLoadingCopyWithImpl;
@useResult
$Res call({
 List<Product> products
});




}
/// @nodoc
class _$OrdersLoadingCopyWithImpl<$Res>
    implements $OrdersLoadingCopyWith<$Res> {
  _$OrdersLoadingCopyWithImpl(this._self, this._then);

  final OrdersLoading _self;
  final $Res Function(OrdersLoading) _then;

/// Create a copy of OrdersLoading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? products = null,}) {
  return _then(OrdersLoading(
products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrdersLoading].
extension OrdersLoadingPatterns on OrdersLoading {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$OrdersUpdated {


/// Create a copy of OrdersUpdated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersUpdatedCopyWith<OrdersUpdated> get copyWith => _$OrdersUpdatedCopyWithImpl<OrdersUpdated>(this as OrdersUpdated, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrdersUpdated;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersUpdated&&const DeepCollectionEquality().equals(other.products, _this.products)&&(identical(other.total, _this.total) || other.total == _this.total));
}


@override
int get hashCode {
  final _this = this as OrdersUpdated;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.products),_this.total);
}

@override
String toString() {
  final _this = this as OrdersUpdated;
  return 'OrdersUpdated(products: ${_this.products}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $OrdersUpdatedCopyWith<$Res>  {
  factory $OrdersUpdatedCopyWith(OrdersUpdated value, $Res Function(OrdersUpdated) _then) = _$OrdersUpdatedCopyWithImpl;
@useResult
$Res call({
 List<Product> products, double total
});




}
/// @nodoc
class _$OrdersUpdatedCopyWithImpl<$Res>
    implements $OrdersUpdatedCopyWith<$Res> {
  _$OrdersUpdatedCopyWithImpl(this._self, this._then);

  final OrdersUpdated _self;
  final $Res Function(OrdersUpdated) _then;

/// Create a copy of OrdersUpdated
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? products = null,Object? total = null,}) {
  return _then(OrdersUpdated(
products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OrdersUpdated].
extension OrdersUpdatedPatterns on OrdersUpdated {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$OrdersPaymentSuccess {


/// Create a copy of OrdersPaymentSuccess
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersPaymentSuccessCopyWith<OrdersPaymentSuccess> get copyWith => _$OrdersPaymentSuccessCopyWithImpl<OrdersPaymentSuccess>(this as OrdersPaymentSuccess, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrdersPaymentSuccess;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersPaymentSuccess&&(identical(other.receipt, _this.receipt) || other.receipt == _this.receipt));
}


@override
int get hashCode {
  final _this = this as OrdersPaymentSuccess;
  return Object.hash(runtimeType,_this.receipt);
}

@override
String toString() {
  final _this = this as OrdersPaymentSuccess;
  return 'OrdersPaymentSuccess(receipt: ${_this.receipt})';
}


}

/// @nodoc
abstract mixin class $OrdersPaymentSuccessCopyWith<$Res>  {
  factory $OrdersPaymentSuccessCopyWith(OrdersPaymentSuccess value, $Res Function(OrdersPaymentSuccess) _then) = _$OrdersPaymentSuccessCopyWithImpl;
@useResult
$Res call({
 OrderReceipt receipt
});




}
/// @nodoc
class _$OrdersPaymentSuccessCopyWithImpl<$Res>
    implements $OrdersPaymentSuccessCopyWith<$Res> {
  _$OrdersPaymentSuccessCopyWithImpl(this._self, this._then);

  final OrdersPaymentSuccess _self;
  final $Res Function(OrdersPaymentSuccess) _then;

/// Create a copy of OrdersPaymentSuccess
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? receipt = null,}) {
  return _then(OrdersPaymentSuccess(
null == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as OrderReceipt,
  ));
}

}


/// Adds pattern-matching-related methods to [OrdersPaymentSuccess].
extension OrdersPaymentSuccessPatterns on OrdersPaymentSuccess {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$OrdersPaymentProcessing {


/// Create a copy of OrdersPaymentProcessing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersPaymentProcessingCopyWith<OrdersPaymentProcessing> get copyWith => _$OrdersPaymentProcessingCopyWithImpl<OrdersPaymentProcessing>(this as OrdersPaymentProcessing, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrdersPaymentProcessing;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersPaymentProcessing&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.total, _this.total) || other.total == _this.total));
}


@override
int get hashCode {
  final _this = this as OrdersPaymentProcessing;
  return Object.hash(runtimeType,_this.method,_this.total);
}

@override
String toString() {
  final _this = this as OrdersPaymentProcessing;
  return 'OrdersPaymentProcessing(method: ${_this.method}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $OrdersPaymentProcessingCopyWith<$Res>  {
  factory $OrdersPaymentProcessingCopyWith(OrdersPaymentProcessing value, $Res Function(OrdersPaymentProcessing) _then) = _$OrdersPaymentProcessingCopyWithImpl;
@useResult
$Res call({
 PaymentMethod method, double total
});




}
/// @nodoc
class _$OrdersPaymentProcessingCopyWithImpl<$Res>
    implements $OrdersPaymentProcessingCopyWith<$Res> {
  _$OrdersPaymentProcessingCopyWithImpl(this._self, this._then);

  final OrdersPaymentProcessing _self;
  final $Res Function(OrdersPaymentProcessing) _then;

/// Create a copy of OrdersPaymentProcessing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? total = null,}) {
  return _then(OrdersPaymentProcessing(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OrdersPaymentProcessing].
extension OrdersPaymentProcessingPatterns on OrdersPaymentProcessing {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

/// @nodoc
mixin _$OrdersError {


/// Create a copy of OrdersError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersErrorCopyWith<OrdersError> get copyWith => _$OrdersErrorCopyWithImpl<OrdersError>(this as OrdersError, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrdersError;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersError&&(identical(other.message, _this.message) || other.message == _this.message)&&const DeepCollectionEquality().equals(other.products, _this.products)&&(identical(other.total, _this.total) || other.total == _this.total));
}


@override
int get hashCode {
  final _this = this as OrdersError;
  return Object.hash(runtimeType,_this.message,const DeepCollectionEquality().hash(_this.products),_this.total);
}

@override
String toString() {
  final _this = this as OrdersError;
  return 'OrdersError(message: ${_this.message}, products: ${_this.products}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $OrdersErrorCopyWith<$Res>  {
  factory $OrdersErrorCopyWith(OrdersError value, $Res Function(OrdersError) _then) = _$OrdersErrorCopyWithImpl;
@useResult
$Res call({
 String message, List<Product> products, double total
});




}
/// @nodoc
class _$OrdersErrorCopyWithImpl<$Res>
    implements $OrdersErrorCopyWith<$Res> {
  _$OrdersErrorCopyWithImpl(this._self, this._then);

  final OrdersError _self;
  final $Res Function(OrdersError) _then;

/// Create a copy of OrdersError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? products = null,Object? total = null,}) {
  return _then(OrdersError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OrdersError].
extension OrdersErrorPatterns on OrdersError {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
