// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptLine {

 String get productId; String get name;/// Quantity as the backend returned it (decimal string, e.g. "0.250" / "2");
/// kept as text since it may be fractional for weight goods.
 String get quantity; int get unitPriceKopecks; int get subtotalKopecks;
/// Create a copy of ReceiptLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptLineCopyWith<ReceiptLine> get copyWith => _$ReceiptLineCopyWithImpl<ReceiptLine>(this as ReceiptLine, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReceiptLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptLine&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.unitPriceKopecks, _this.unitPriceKopecks) || other.unitPriceKopecks == _this.unitPriceKopecks)&&(identical(other.subtotalKopecks, _this.subtotalKopecks) || other.subtotalKopecks == _this.subtotalKopecks));
}


@override
int get hashCode {
  final _this = this as ReceiptLine;
  return Object.hash(runtimeType,_this.productId,_this.name,_this.quantity,_this.unitPriceKopecks,_this.subtotalKopecks);
}

@override
String toString() {
  final _this = this as ReceiptLine;
  return 'ReceiptLine(productId: ${_this.productId}, name: ${_this.name}, quantity: ${_this.quantity}, unitPriceKopecks: ${_this.unitPriceKopecks}, subtotalKopecks: ${_this.subtotalKopecks})';
}


}

/// @nodoc
abstract mixin class $ReceiptLineCopyWith<$Res>  {
  factory $ReceiptLineCopyWith(ReceiptLine value, $Res Function(ReceiptLine) _then) = _$ReceiptLineCopyWithImpl;
@useResult
$Res call({
 String productId, String name, String quantity, int unitPriceKopecks, int subtotalKopecks
});




}
/// @nodoc
class _$ReceiptLineCopyWithImpl<$Res>
    implements $ReceiptLineCopyWith<$Res> {
  _$ReceiptLineCopyWithImpl(this._self, this._then);

  final ReceiptLine _self;
  final $Res Function(ReceiptLine) _then;

/// Create a copy of ReceiptLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? name = null,Object? quantity = null,Object? unitPriceKopecks = null,Object? subtotalKopecks = null,}) {
  return _then(ReceiptLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitPriceKopecks: null == unitPriceKopecks ? _self.unitPriceKopecks : unitPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,subtotalKopecks: null == subtotalKopecks ? _self.subtotalKopecks : subtotalKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptLine].
extension ReceiptLinePatterns on ReceiptLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptLine() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptLine value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptLine():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptLine value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptLine() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String name,  String quantity,  int unitPriceKopecks,  int subtotalKopecks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptLine() when $default != null:
return $default(_that.productId,_that.name,_that.quantity,_that.unitPriceKopecks,_that.subtotalKopecks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String name,  String quantity,  int unitPriceKopecks,  int subtotalKopecks)  $default,) {final _that = this;
switch (_that) {
case _ReceiptLine():
return $default(_that.productId,_that.name,_that.quantity,_that.unitPriceKopecks,_that.subtotalKopecks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String name,  String quantity,  int unitPriceKopecks,  int subtotalKopecks)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptLine() when $default != null:
return $default(_that.productId,_that.name,_that.quantity,_that.unitPriceKopecks,_that.subtotalKopecks);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptLine implements ReceiptLine {
  const _ReceiptLine({required this.productId, required this.name, required this.quantity, required this.unitPriceKopecks, required this.subtotalKopecks});
  

@override final  String productId;
@override final  String name;
/// Quantity as the backend returned it (decimal string, e.g. "0.250" / "2");
/// kept as text since it may be fractional for weight goods.
@override final  String quantity;
@override final  int unitPriceKopecks;
@override final  int subtotalKopecks;

/// Create a copy of ReceiptLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptLineCopyWith<_ReceiptLine> get copyWith => __$ReceiptLineCopyWithImpl<_ReceiptLine>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptLine&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceKopecks, unitPriceKopecks) || other.unitPriceKopecks == unitPriceKopecks)&&(identical(other.subtotalKopecks, subtotalKopecks) || other.subtotalKopecks == subtotalKopecks));
}


@override
int get hashCode {
    return Object.hash(runtimeType,productId,name,quantity,unitPriceKopecks,subtotalKopecks);
}

@override
String toString() {
    return 'ReceiptLine(productId: $productId, name: $name, quantity: $quantity, unitPriceKopecks: $unitPriceKopecks, subtotalKopecks: $subtotalKopecks)';
}


}

/// @nodoc
abstract mixin class _$ReceiptLineCopyWith<$Res> implements $ReceiptLineCopyWith<$Res> {
  factory _$ReceiptLineCopyWith(_ReceiptLine value, $Res Function(_ReceiptLine) _then) = __$ReceiptLineCopyWithImpl;
@override @useResult
$Res call({
 String productId, String name, String quantity, int unitPriceKopecks, int subtotalKopecks
});




}
/// @nodoc
class __$ReceiptLineCopyWithImpl<$Res>
    implements _$ReceiptLineCopyWith<$Res> {
  __$ReceiptLineCopyWithImpl(this._self, this._then);

  final _ReceiptLine _self;
  final $Res Function(_ReceiptLine) _then;

/// Create a copy of ReceiptLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? quantity = null,Object? unitPriceKopecks = null,Object? subtotalKopecks = null,}) {
  return _then(_ReceiptLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitPriceKopecks: null == unitPriceKopecks ? _self.unitPriceKopecks : unitPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,subtotalKopecks: null == subtotalKopecks ? _self.subtotalKopecks : subtotalKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OrderReceipt {

 String get orderId; List<ReceiptLine> get lines; int get totalKopecks; int get tenderedKopecks; int get changeKopecks; PaymentMethod get method; String get status; DateTime get issuedAt;/// Header info for the printout. The order response carries neither, so the
/// caller supplies them (store from config, cashier from the session).
 String get storeName; String get cashierName;
/// Create a copy of OrderReceipt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderReceiptCopyWith<OrderReceipt> get copyWith => _$OrderReceiptCopyWithImpl<OrderReceipt>(this as OrderReceipt, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderReceipt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderReceipt&&(identical(other.orderId, _this.orderId) || other.orderId == _this.orderId)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.totalKopecks, _this.totalKopecks) || other.totalKopecks == _this.totalKopecks)&&(identical(other.tenderedKopecks, _this.tenderedKopecks) || other.tenderedKopecks == _this.tenderedKopecks)&&(identical(other.changeKopecks, _this.changeKopecks) || other.changeKopecks == _this.changeKopecks)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.issuedAt, _this.issuedAt) || other.issuedAt == _this.issuedAt)&&(identical(other.storeName, _this.storeName) || other.storeName == _this.storeName)&&(identical(other.cashierName, _this.cashierName) || other.cashierName == _this.cashierName));
}


@override
int get hashCode {
  final _this = this as OrderReceipt;
  return Object.hash(runtimeType,_this.orderId,const DeepCollectionEquality().hash(_this.lines),_this.totalKopecks,_this.tenderedKopecks,_this.changeKopecks,_this.method,_this.status,_this.issuedAt,_this.storeName,_this.cashierName);
}

@override
String toString() {
  final _this = this as OrderReceipt;
  return 'OrderReceipt(orderId: ${_this.orderId}, lines: ${_this.lines}, totalKopecks: ${_this.totalKopecks}, tenderedKopecks: ${_this.tenderedKopecks}, changeKopecks: ${_this.changeKopecks}, method: ${_this.method}, status: ${_this.status}, issuedAt: ${_this.issuedAt}, storeName: ${_this.storeName}, cashierName: ${_this.cashierName})';
}


}

/// @nodoc
abstract mixin class $OrderReceiptCopyWith<$Res>  {
  factory $OrderReceiptCopyWith(OrderReceipt value, $Res Function(OrderReceipt) _then) = _$OrderReceiptCopyWithImpl;
@useResult
$Res call({
 String orderId, List<ReceiptLine> lines, int totalKopecks, int tenderedKopecks, int changeKopecks, PaymentMethod method, String status, DateTime issuedAt, String storeName, String cashierName
});




}
/// @nodoc
class _$OrderReceiptCopyWithImpl<$Res>
    implements $OrderReceiptCopyWith<$Res> {
  _$OrderReceiptCopyWithImpl(this._self, this._then);

  final OrderReceipt _self;
  final $Res Function(OrderReceipt) _then;

/// Create a copy of OrderReceipt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? lines = null,Object? totalKopecks = null,Object? tenderedKopecks = null,Object? changeKopecks = null,Object? method = null,Object? status = null,Object? issuedAt = null,Object? storeName = null,Object? cashierName = null,}) {
  return _then(OrderReceipt(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<ReceiptLine>,totalKopecks: null == totalKopecks ? _self.totalKopecks : totalKopecks // ignore: cast_nullable_to_non_nullable
as int,tenderedKopecks: null == tenderedKopecks ? _self.tenderedKopecks : tenderedKopecks // ignore: cast_nullable_to_non_nullable
as int,changeKopecks: null == changeKopecks ? _self.changeKopecks : changeKopecks // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,cashierName: null == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderReceipt].
extension OrderReceiptPatterns on OrderReceipt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderReceipt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderReceipt() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderReceipt value)  $default,){
final _that = this;
switch (_that) {
case _OrderReceipt():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderReceipt value)?  $default,){
final _that = this;
switch (_that) {
case _OrderReceipt() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  List<ReceiptLine> lines,  int totalKopecks,  int tenderedKopecks,  int changeKopecks,  PaymentMethod method,  String status,  DateTime issuedAt,  String storeName,  String cashierName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderReceipt() when $default != null:
return $default(_that.orderId,_that.lines,_that.totalKopecks,_that.tenderedKopecks,_that.changeKopecks,_that.method,_that.status,_that.issuedAt,_that.storeName,_that.cashierName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  List<ReceiptLine> lines,  int totalKopecks,  int tenderedKopecks,  int changeKopecks,  PaymentMethod method,  String status,  DateTime issuedAt,  String storeName,  String cashierName)  $default,) {final _that = this;
switch (_that) {
case _OrderReceipt():
return $default(_that.orderId,_that.lines,_that.totalKopecks,_that.tenderedKopecks,_that.changeKopecks,_that.method,_that.status,_that.issuedAt,_that.storeName,_that.cashierName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  List<ReceiptLine> lines,  int totalKopecks,  int tenderedKopecks,  int changeKopecks,  PaymentMethod method,  String status,  DateTime issuedAt,  String storeName,  String cashierName)?  $default,) {final _that = this;
switch (_that) {
case _OrderReceipt() when $default != null:
return $default(_that.orderId,_that.lines,_that.totalKopecks,_that.tenderedKopecks,_that.changeKopecks,_that.method,_that.status,_that.issuedAt,_that.storeName,_that.cashierName);case _:
  return null;

}
}

}

/// @nodoc


class _OrderReceipt implements OrderReceipt {
  const _OrderReceipt({required this.orderId, required  List<ReceiptLine> lines, required this.totalKopecks, required this.tenderedKopecks, required this.changeKopecks, required this.method, required this.status, required this.issuedAt, required this.storeName, required this.cashierName}): _lines = lines;
  

@override final  String orderId;
 final  List<ReceiptLine> _lines;
@override List<ReceiptLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  int totalKopecks;
@override final  int tenderedKopecks;
@override final  int changeKopecks;
@override final  PaymentMethod method;
@override final  String status;
@override final  DateTime issuedAt;
/// Header info for the printout. The order response carries neither, so the
/// caller supplies them (store from config, cashier from the session).
@override final  String storeName;
@override final  String cashierName;

/// Create a copy of OrderReceipt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderReceiptCopyWith<_OrderReceipt> get copyWith => __$OrderReceiptCopyWithImpl<_OrderReceipt>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderReceipt&&(identical(other.orderId, orderId) || other.orderId == orderId)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.totalKopecks, totalKopecks) || other.totalKopecks == totalKopecks)&&(identical(other.tenderedKopecks, tenderedKopecks) || other.tenderedKopecks == tenderedKopecks)&&(identical(other.changeKopecks, changeKopecks) || other.changeKopecks == changeKopecks)&&(identical(other.method, method) || other.method == method)&&(identical(other.status, status) || other.status == status)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.cashierName, cashierName) || other.cashierName == cashierName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,orderId,const DeepCollectionEquality().hash(_lines),totalKopecks,tenderedKopecks,changeKopecks,method,status,issuedAt,storeName,cashierName);
}

@override
String toString() {
    return 'OrderReceipt(orderId: $orderId, lines: $lines, totalKopecks: $totalKopecks, tenderedKopecks: $tenderedKopecks, changeKopecks: $changeKopecks, method: $method, status: $status, issuedAt: $issuedAt, storeName: $storeName, cashierName: $cashierName)';
}


}

/// @nodoc
abstract mixin class _$OrderReceiptCopyWith<$Res> implements $OrderReceiptCopyWith<$Res> {
  factory _$OrderReceiptCopyWith(_OrderReceipt value, $Res Function(_OrderReceipt) _then) = __$OrderReceiptCopyWithImpl;
@override @useResult
$Res call({
 String orderId, List<ReceiptLine> lines, int totalKopecks, int tenderedKopecks, int changeKopecks, PaymentMethod method, String status, DateTime issuedAt, String storeName, String cashierName
});




}
/// @nodoc
class __$OrderReceiptCopyWithImpl<$Res>
    implements _$OrderReceiptCopyWith<$Res> {
  __$OrderReceiptCopyWithImpl(this._self, this._then);

  final _OrderReceipt _self;
  final $Res Function(_OrderReceipt) _then;

/// Create a copy of OrderReceipt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? lines = null,Object? totalKopecks = null,Object? tenderedKopecks = null,Object? changeKopecks = null,Object? method = null,Object? status = null,Object? issuedAt = null,Object? storeName = null,Object? cashierName = null,}) {
  return _then(_OrderReceipt(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<ReceiptLine>,totalKopecks: null == totalKopecks ? _self.totalKopecks : totalKopecks // ignore: cast_nullable_to_non_nullable
as int,tenderedKopecks: null == tenderedKopecks ? _self.tenderedKopecks : tenderedKopecks // ignore: cast_nullable_to_non_nullable
as int,changeKopecks: null == changeKopecks ? _self.changeKopecks : changeKopecks // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,cashierName: null == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
