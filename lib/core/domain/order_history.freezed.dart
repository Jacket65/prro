// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderListItem {

@JsonKey(readValue: orderIdValue, fromJson: parseInt) int get orderId;@JsonKey(name: 'created_at', fromJson: parseLocalDateTime) DateTime get createdAt;@JsonKey(name: 'total_price', fromJson: kopecksFromJson) int get totalKopecks;
/// Create a copy of OrderListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderListItemCopyWith<OrderListItem> get copyWith => _$OrderListItemCopyWithImpl<OrderListItem>(this as OrderListItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderListItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderListItem&&(identical(other.orderId, _this.orderId) || other.orderId == _this.orderId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.totalKopecks, _this.totalKopecks) || other.totalKopecks == _this.totalKopecks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrderListItem;
  return Object.hash(runtimeType,_this.orderId,_this.createdAt,_this.totalKopecks);
}

@override
String toString() {
  final _this = this as OrderListItem;
  return 'OrderListItem(orderId: ${_this.orderId}, createdAt: ${_this.createdAt}, totalKopecks: ${_this.totalKopecks})';
}


}

/// @nodoc
abstract mixin class $OrderListItemCopyWith<$Res>  {
  factory $OrderListItemCopyWith(OrderListItem value, $Res Function(OrderListItem) _then) = _$OrderListItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: orderIdValue, fromJson: parseInt) int orderId,@JsonKey(name: 'created_at', fromJson: parseLocalDateTime) DateTime createdAt,@JsonKey(name: 'total_price', fromJson: kopecksFromJson) int totalKopecks
});




}
/// @nodoc
class _$OrderListItemCopyWithImpl<$Res>
    implements $OrderListItemCopyWith<$Res> {
  _$OrderListItemCopyWithImpl(this._self, this._then);

  final OrderListItem _self;
  final $Res Function(OrderListItem) _then;

/// Create a copy of OrderListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? createdAt = null,Object? totalKopecks = null,}) {
  return _then(OrderListItem(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalKopecks: null == totalKopecks ? _self.totalKopecks : totalKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderListItem].
extension OrderListItemPatterns on OrderListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderListItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderListItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: orderIdValue, fromJson: parseInt)  int orderId, @JsonKey(name: 'created_at', fromJson: parseLocalDateTime)  DateTime createdAt, @JsonKey(name: 'total_price', fromJson: kopecksFromJson)  int totalKopecks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderListItem() when $default != null:
return $default(_that.orderId,_that.createdAt,_that.totalKopecks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: orderIdValue, fromJson: parseInt)  int orderId, @JsonKey(name: 'created_at', fromJson: parseLocalDateTime)  DateTime createdAt, @JsonKey(name: 'total_price', fromJson: kopecksFromJson)  int totalKopecks)  $default,) {final _that = this;
switch (_that) {
case _OrderListItem():
return $default(_that.orderId,_that.createdAt,_that.totalKopecks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: orderIdValue, fromJson: parseInt)  int orderId, @JsonKey(name: 'created_at', fromJson: parseLocalDateTime)  DateTime createdAt, @JsonKey(name: 'total_price', fromJson: kopecksFromJson)  int totalKopecks)?  $default,) {final _that = this;
switch (_that) {
case _OrderListItem() when $default != null:
return $default(_that.orderId,_that.createdAt,_that.totalKopecks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _OrderListItem implements OrderListItem {
  const _OrderListItem({@JsonKey(readValue: orderIdValue, fromJson: parseInt) required this.orderId, @JsonKey(name: 'created_at', fromJson: parseLocalDateTime) required this.createdAt, @JsonKey(name: 'total_price', fromJson: kopecksFromJson) required this.totalKopecks});
  factory _OrderListItem.fromJson(Map<String, dynamic> json) => _$OrderListItemFromJson(json);

@override@JsonKey(readValue: orderIdValue, fromJson: parseInt) final  int orderId;
@override@JsonKey(name: 'created_at', fromJson: parseLocalDateTime) final  DateTime createdAt;
@override@JsonKey(name: 'total_price', fromJson: kopecksFromJson) final  int totalKopecks;

/// Create a copy of OrderListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderListItemCopyWith<_OrderListItem> get copyWith => __$OrderListItemCopyWithImpl<_OrderListItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderListItem&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.totalKopecks, totalKopecks) || other.totalKopecks == totalKopecks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,orderId,createdAt,totalKopecks);
}

@override
String toString() {
    return 'OrderListItem(orderId: $orderId, createdAt: $createdAt, totalKopecks: $totalKopecks)';
}


}

/// @nodoc
abstract mixin class _$OrderListItemCopyWith<$Res> implements $OrderListItemCopyWith<$Res> {
  factory _$OrderListItemCopyWith(_OrderListItem value, $Res Function(_OrderListItem) _then) = __$OrderListItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: orderIdValue, fromJson: parseInt) int orderId,@JsonKey(name: 'created_at', fromJson: parseLocalDateTime) DateTime createdAt,@JsonKey(name: 'total_price', fromJson: kopecksFromJson) int totalKopecks
});




}
/// @nodoc
class __$OrderListItemCopyWithImpl<$Res>
    implements _$OrderListItemCopyWith<$Res> {
  __$OrderListItemCopyWithImpl(this._self, this._then);

  final _OrderListItem _self;
  final $Res Function(_OrderListItem) _then;

/// Create a copy of OrderListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? createdAt = null,Object? totalKopecks = null,}) {
  return _then(_OrderListItem(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalKopecks: null == totalKopecks ? _self.totalKopecks : totalKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ShiftSummary {

@JsonKey(fromJson: parseInt) int get id;@JsonKey(name: 'outlet_id', fromJson: parseInt) int get outletId;@JsonKey(name: 'opened_by', fromJson: parseInt) int get openedBy;@JsonKey(name: 'opened_at', fromJson: parseLocalDateTime) DateTime get openedAt;@JsonKey(fromJson: parseString) String get status;@JsonKey(name: 'closed_by', fromJson: parseNullableInt) int? get closedBy;@JsonKey(name: 'closed_at', fromJson: parseNullableLocalDateTime) DateTime? get closedAt;/// Decimal text as the backend sent it — not parsed, the history list shows
/// it verbatim.
@JsonKey(name: 'cash_end', fromJson: stringOrNull) String? get cashEnd;
/// Create a copy of ShiftSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftSummaryCopyWith<ShiftSummary> get copyWith => _$ShiftSummaryCopyWithImpl<ShiftSummary>(this as ShiftSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShiftSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.outletId, _this.outletId) || other.outletId == _this.outletId)&&(identical(other.openedBy, _this.openedBy) || other.openedBy == _this.openedBy)&&(identical(other.openedAt, _this.openedAt) || other.openedAt == _this.openedAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.closedBy, _this.closedBy) || other.closedBy == _this.closedBy)&&(identical(other.closedAt, _this.closedAt) || other.closedAt == _this.closedAt)&&(identical(other.cashEnd, _this.cashEnd) || other.cashEnd == _this.cashEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ShiftSummary;
  return Object.hash(runtimeType,_this.id,_this.outletId,_this.openedBy,_this.openedAt,_this.status,_this.closedBy,_this.closedAt,_this.cashEnd);
}

@override
String toString() {
  final _this = this as ShiftSummary;
  return 'ShiftSummary(id: ${_this.id}, outletId: ${_this.outletId}, openedBy: ${_this.openedBy}, openedAt: ${_this.openedAt}, status: ${_this.status}, closedBy: ${_this.closedBy}, closedAt: ${_this.closedAt}, cashEnd: ${_this.cashEnd})';
}


}

/// @nodoc
abstract mixin class $ShiftSummaryCopyWith<$Res>  {
  factory $ShiftSummaryCopyWith(ShiftSummary value, $Res Function(ShiftSummary) _then) = _$ShiftSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(name: 'outlet_id', fromJson: parseInt) int outletId,@JsonKey(name: 'opened_by', fromJson: parseInt) int openedBy,@JsonKey(name: 'opened_at', fromJson: parseLocalDateTime) DateTime openedAt,@JsonKey(fromJson: parseString) String status,@JsonKey(name: 'closed_by', fromJson: parseNullableInt) int? closedBy,@JsonKey(name: 'closed_at', fromJson: parseNullableLocalDateTime) DateTime? closedAt,@JsonKey(name: 'cash_end', fromJson: stringOrNull) String? cashEnd
});




}
/// @nodoc
class _$ShiftSummaryCopyWithImpl<$Res>
    implements $ShiftSummaryCopyWith<$Res> {
  _$ShiftSummaryCopyWithImpl(this._self, this._then);

  final ShiftSummary _self;
  final $Res Function(ShiftSummary) _then;

/// Create a copy of ShiftSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? outletId = null,Object? openedBy = null,Object? openedAt = null,Object? status = null,Object? closedBy = freezed,Object? closedAt = freezed,Object? cashEnd = freezed,}) {
  return _then(ShiftSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,outletId: null == outletId ? _self.outletId : outletId // ignore: cast_nullable_to_non_nullable
as int,openedBy: null == openedBy ? _self.openedBy : openedBy // ignore: cast_nullable_to_non_nullable
as int,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as int?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cashEnd: freezed == cashEnd ? _self.cashEnd : cashEnd // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShiftSummary].
extension ShiftSummaryPatterns on ShiftSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShiftSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShiftSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShiftSummary value)  $default,){
final _that = this;
switch (_that) {
case _ShiftSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShiftSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ShiftSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(name: 'outlet_id', fromJson: parseInt)  int outletId, @JsonKey(name: 'opened_by', fromJson: parseInt)  int openedBy, @JsonKey(name: 'opened_at', fromJson: parseLocalDateTime)  DateTime openedAt, @JsonKey(fromJson: parseString)  String status, @JsonKey(name: 'closed_by', fromJson: parseNullableInt)  int? closedBy, @JsonKey(name: 'closed_at', fromJson: parseNullableLocalDateTime)  DateTime? closedAt, @JsonKey(name: 'cash_end', fromJson: stringOrNull)  String? cashEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShiftSummary() when $default != null:
return $default(_that.id,_that.outletId,_that.openedBy,_that.openedAt,_that.status,_that.closedBy,_that.closedAt,_that.cashEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(name: 'outlet_id', fromJson: parseInt)  int outletId, @JsonKey(name: 'opened_by', fromJson: parseInt)  int openedBy, @JsonKey(name: 'opened_at', fromJson: parseLocalDateTime)  DateTime openedAt, @JsonKey(fromJson: parseString)  String status, @JsonKey(name: 'closed_by', fromJson: parseNullableInt)  int? closedBy, @JsonKey(name: 'closed_at', fromJson: parseNullableLocalDateTime)  DateTime? closedAt, @JsonKey(name: 'cash_end', fromJson: stringOrNull)  String? cashEnd)  $default,) {final _that = this;
switch (_that) {
case _ShiftSummary():
return $default(_that.id,_that.outletId,_that.openedBy,_that.openedAt,_that.status,_that.closedBy,_that.closedAt,_that.cashEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(name: 'outlet_id', fromJson: parseInt)  int outletId, @JsonKey(name: 'opened_by', fromJson: parseInt)  int openedBy, @JsonKey(name: 'opened_at', fromJson: parseLocalDateTime)  DateTime openedAt, @JsonKey(fromJson: parseString)  String status, @JsonKey(name: 'closed_by', fromJson: parseNullableInt)  int? closedBy, @JsonKey(name: 'closed_at', fromJson: parseNullableLocalDateTime)  DateTime? closedAt, @JsonKey(name: 'cash_end', fromJson: stringOrNull)  String? cashEnd)?  $default,) {final _that = this;
switch (_that) {
case _ShiftSummary() when $default != null:
return $default(_that.id,_that.outletId,_that.openedBy,_that.openedAt,_that.status,_that.closedBy,_that.closedAt,_that.cashEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ShiftSummary extends ShiftSummary {
  const _ShiftSummary({@JsonKey(fromJson: parseInt) required this.id, @JsonKey(name: 'outlet_id', fromJson: parseInt) required this.outletId, @JsonKey(name: 'opened_by', fromJson: parseInt) required this.openedBy, @JsonKey(name: 'opened_at', fromJson: parseLocalDateTime) required this.openedAt, @JsonKey(fromJson: parseString) required this.status, @JsonKey(name: 'closed_by', fromJson: parseNullableInt) this.closedBy, @JsonKey(name: 'closed_at', fromJson: parseNullableLocalDateTime) this.closedAt, @JsonKey(name: 'cash_end', fromJson: stringOrNull) this.cashEnd}): super._();
  factory _ShiftSummary.fromJson(Map<String, dynamic> json) => _$ShiftSummaryFromJson(json);

@override@JsonKey(fromJson: parseInt) final  int id;
@override@JsonKey(name: 'outlet_id', fromJson: parseInt) final  int outletId;
@override@JsonKey(name: 'opened_by', fromJson: parseInt) final  int openedBy;
@override@JsonKey(name: 'opened_at', fromJson: parseLocalDateTime) final  DateTime openedAt;
@override@JsonKey(fromJson: parseString) final  String status;
@override@JsonKey(name: 'closed_by', fromJson: parseNullableInt) final  int? closedBy;
@override@JsonKey(name: 'closed_at', fromJson: parseNullableLocalDateTime) final  DateTime? closedAt;
/// Decimal text as the backend sent it — not parsed, the history list shows
/// it verbatim.
@override@JsonKey(name: 'cash_end', fromJson: stringOrNull) final  String? cashEnd;

/// Create a copy of ShiftSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShiftSummaryCopyWith<_ShiftSummary> get copyWith => __$ShiftSummaryCopyWithImpl<_ShiftSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShiftSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.outletId, outletId) || other.outletId == outletId)&&(identical(other.openedBy, openedBy) || other.openedBy == openedBy)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.closedBy, closedBy) || other.closedBy == closedBy)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.cashEnd, cashEnd) || other.cashEnd == cashEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,outletId,openedBy,openedAt,status,closedBy,closedAt,cashEnd);
}

@override
String toString() {
    return 'ShiftSummary(id: $id, outletId: $outletId, openedBy: $openedBy, openedAt: $openedAt, status: $status, closedBy: $closedBy, closedAt: $closedAt, cashEnd: $cashEnd)';
}


}

/// @nodoc
abstract mixin class _$ShiftSummaryCopyWith<$Res> implements $ShiftSummaryCopyWith<$Res> {
  factory _$ShiftSummaryCopyWith(_ShiftSummary value, $Res Function(_ShiftSummary) _then) = __$ShiftSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(name: 'outlet_id', fromJson: parseInt) int outletId,@JsonKey(name: 'opened_by', fromJson: parseInt) int openedBy,@JsonKey(name: 'opened_at', fromJson: parseLocalDateTime) DateTime openedAt,@JsonKey(fromJson: parseString) String status,@JsonKey(name: 'closed_by', fromJson: parseNullableInt) int? closedBy,@JsonKey(name: 'closed_at', fromJson: parseNullableLocalDateTime) DateTime? closedAt,@JsonKey(name: 'cash_end', fromJson: stringOrNull) String? cashEnd
});




}
/// @nodoc
class __$ShiftSummaryCopyWithImpl<$Res>
    implements _$ShiftSummaryCopyWith<$Res> {
  __$ShiftSummaryCopyWithImpl(this._self, this._then);

  final _ShiftSummary _self;
  final $Res Function(_ShiftSummary) _then;

/// Create a copy of ShiftSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? outletId = null,Object? openedBy = null,Object? openedAt = null,Object? status = null,Object? closedBy = freezed,Object? closedAt = freezed,Object? cashEnd = freezed,}) {
  return _then(_ShiftSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,outletId: null == outletId ? _self.outletId : outletId // ignore: cast_nullable_to_non_nullable
as int,openedBy: null == openedBy ? _self.openedBy : openedBy // ignore: cast_nullable_to_non_nullable
as int,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as int?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cashEnd: freezed == cashEnd ? _self.cashEnd : cashEnd // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OrderDetailItem {

@JsonKey(fromJson: parseString) String get name;@JsonKey(fromJson: quantityOrOne) String get quantity;@JsonKey(name: 'unit_price', fromJson: kopecksFromJson) int get unitPriceKopecks;@JsonKey(name: 'line_total', fromJson: kopecksFromJson) int get lineTotalKopecks;@JsonKey(name: 'variant_id', fromJson: parseString) String get variantId;@JsonKey(fromJson: orderDetailOptionsFromJson) List<OrderDetailOption> get options;
/// Create a copy of OrderDetailItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDetailItemCopyWith<OrderDetailItem> get copyWith => _$OrderDetailItemCopyWithImpl<OrderDetailItem>(this as OrderDetailItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderDetailItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDetailItem&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.unitPriceKopecks, _this.unitPriceKopecks) || other.unitPriceKopecks == _this.unitPriceKopecks)&&(identical(other.lineTotalKopecks, _this.lineTotalKopecks) || other.lineTotalKopecks == _this.lineTotalKopecks)&&(identical(other.variantId, _this.variantId) || other.variantId == _this.variantId)&&const DeepCollectionEquality().equals(other.options, _this.options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrderDetailItem;
  return Object.hash(runtimeType,_this.name,_this.quantity,_this.unitPriceKopecks,_this.lineTotalKopecks,_this.variantId,const DeepCollectionEquality().hash(_this.options));
}

@override
String toString() {
  final _this = this as OrderDetailItem;
  return 'OrderDetailItem(name: ${_this.name}, quantity: ${_this.quantity}, unitPriceKopecks: ${_this.unitPriceKopecks}, lineTotalKopecks: ${_this.lineTotalKopecks}, variantId: ${_this.variantId}, options: ${_this.options})';
}


}

/// @nodoc
abstract mixin class $OrderDetailItemCopyWith<$Res>  {
  factory $OrderDetailItemCopyWith(OrderDetailItem value, $Res Function(OrderDetailItem) _then) = _$OrderDetailItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseString) String name,@JsonKey(fromJson: quantityOrOne) String quantity,@JsonKey(name: 'unit_price', fromJson: kopecksFromJson) int unitPriceKopecks,@JsonKey(name: 'line_total', fromJson: kopecksFromJson) int lineTotalKopecks,@JsonKey(name: 'variant_id', fromJson: parseString) String variantId,@JsonKey(fromJson: orderDetailOptionsFromJson) List<OrderDetailOption> options
});




}
/// @nodoc
class _$OrderDetailItemCopyWithImpl<$Res>
    implements $OrderDetailItemCopyWith<$Res> {
  _$OrderDetailItemCopyWithImpl(this._self, this._then);

  final OrderDetailItem _self;
  final $Res Function(OrderDetailItem) _then;

/// Create a copy of OrderDetailItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? quantity = null,Object? unitPriceKopecks = null,Object? lineTotalKopecks = null,Object? variantId = null,Object? options = null,}) {
  return _then(OrderDetailItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitPriceKopecks: null == unitPriceKopecks ? _self.unitPriceKopecks : unitPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,lineTotalKopecks: null == lineTotalKopecks ? _self.lineTotalKopecks : lineTotalKopecks // ignore: cast_nullable_to_non_nullable
as int,variantId: null == variantId ? _self.variantId : variantId // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<OrderDetailOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderDetailItem].
extension OrderDetailItemPatterns on OrderDetailItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderDetailItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderDetailItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderDetailItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderDetailItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderDetailItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderDetailItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseString)  String name, @JsonKey(fromJson: quantityOrOne)  String quantity, @JsonKey(name: 'unit_price', fromJson: kopecksFromJson)  int unitPriceKopecks, @JsonKey(name: 'line_total', fromJson: kopecksFromJson)  int lineTotalKopecks, @JsonKey(name: 'variant_id', fromJson: parseString)  String variantId, @JsonKey(fromJson: orderDetailOptionsFromJson)  List<OrderDetailOption> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderDetailItem() when $default != null:
return $default(_that.name,_that.quantity,_that.unitPriceKopecks,_that.lineTotalKopecks,_that.variantId,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseString)  String name, @JsonKey(fromJson: quantityOrOne)  String quantity, @JsonKey(name: 'unit_price', fromJson: kopecksFromJson)  int unitPriceKopecks, @JsonKey(name: 'line_total', fromJson: kopecksFromJson)  int lineTotalKopecks, @JsonKey(name: 'variant_id', fromJson: parseString)  String variantId, @JsonKey(fromJson: orderDetailOptionsFromJson)  List<OrderDetailOption> options)  $default,) {final _that = this;
switch (_that) {
case _OrderDetailItem():
return $default(_that.name,_that.quantity,_that.unitPriceKopecks,_that.lineTotalKopecks,_that.variantId,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: parseString)  String name, @JsonKey(fromJson: quantityOrOne)  String quantity, @JsonKey(name: 'unit_price', fromJson: kopecksFromJson)  int unitPriceKopecks, @JsonKey(name: 'line_total', fromJson: kopecksFromJson)  int lineTotalKopecks, @JsonKey(name: 'variant_id', fromJson: parseString)  String variantId, @JsonKey(fromJson: orderDetailOptionsFromJson)  List<OrderDetailOption> options)?  $default,) {final _that = this;
switch (_that) {
case _OrderDetailItem() when $default != null:
return $default(_that.name,_that.quantity,_that.unitPriceKopecks,_that.lineTotalKopecks,_that.variantId,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _OrderDetailItem implements OrderDetailItem {
  const _OrderDetailItem({@JsonKey(fromJson: parseString) required this.name, @JsonKey(fromJson: quantityOrOne) required this.quantity, @JsonKey(name: 'unit_price', fromJson: kopecksFromJson) required this.unitPriceKopecks, @JsonKey(name: 'line_total', fromJson: kopecksFromJson) required this.lineTotalKopecks, @JsonKey(name: 'variant_id', fromJson: parseString) required this.variantId, @JsonKey(fromJson: orderDetailOptionsFromJson)  List<OrderDetailOption> options = const <OrderDetailOption>[]}): _options = options;
  factory _OrderDetailItem.fromJson(Map<String, dynamic> json) => _$OrderDetailItemFromJson(json);

@override@JsonKey(fromJson: parseString) final  String name;
@override@JsonKey(fromJson: quantityOrOne) final  String quantity;
@override@JsonKey(name: 'unit_price', fromJson: kopecksFromJson) final  int unitPriceKopecks;
@override@JsonKey(name: 'line_total', fromJson: kopecksFromJson) final  int lineTotalKopecks;
@override@JsonKey(name: 'variant_id', fromJson: parseString) final  String variantId;
 final  List<OrderDetailOption> _options;
@override@JsonKey(fromJson: orderDetailOptionsFromJson) List<OrderDetailOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of OrderDetailItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderDetailItemCopyWith<_OrderDetailItem> get copyWith => __$OrderDetailItemCopyWithImpl<_OrderDetailItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderDetailItem&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceKopecks, unitPriceKopecks) || other.unitPriceKopecks == unitPriceKopecks)&&(identical(other.lineTotalKopecks, lineTotalKopecks) || other.lineTotalKopecks == lineTotalKopecks)&&(identical(other.variantId, variantId) || other.variantId == variantId)&&const DeepCollectionEquality().equals(other.options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,quantity,unitPriceKopecks,lineTotalKopecks,variantId,const DeepCollectionEquality().hash(_options));
}

@override
String toString() {
    return 'OrderDetailItem(name: $name, quantity: $quantity, unitPriceKopecks: $unitPriceKopecks, lineTotalKopecks: $lineTotalKopecks, variantId: $variantId, options: $options)';
}


}

/// @nodoc
abstract mixin class _$OrderDetailItemCopyWith<$Res> implements $OrderDetailItemCopyWith<$Res> {
  factory _$OrderDetailItemCopyWith(_OrderDetailItem value, $Res Function(_OrderDetailItem) _then) = __$OrderDetailItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseString) String name,@JsonKey(fromJson: quantityOrOne) String quantity,@JsonKey(name: 'unit_price', fromJson: kopecksFromJson) int unitPriceKopecks,@JsonKey(name: 'line_total', fromJson: kopecksFromJson) int lineTotalKopecks,@JsonKey(name: 'variant_id', fromJson: parseString) String variantId,@JsonKey(fromJson: orderDetailOptionsFromJson) List<OrderDetailOption> options
});




}
/// @nodoc
class __$OrderDetailItemCopyWithImpl<$Res>
    implements _$OrderDetailItemCopyWith<$Res> {
  __$OrderDetailItemCopyWithImpl(this._self, this._then);

  final _OrderDetailItem _self;
  final $Res Function(_OrderDetailItem) _then;

/// Create a copy of OrderDetailItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? quantity = null,Object? unitPriceKopecks = null,Object? lineTotalKopecks = null,Object? variantId = null,Object? options = null,}) {
  return _then(_OrderDetailItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String,unitPriceKopecks: null == unitPriceKopecks ? _self.unitPriceKopecks : unitPriceKopecks // ignore: cast_nullable_to_non_nullable
as int,lineTotalKopecks: null == lineTotalKopecks ? _self.lineTotalKopecks : lineTotalKopecks // ignore: cast_nullable_to_non_nullable
as int,variantId: null == variantId ? _self.variantId : variantId // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<OrderDetailOption>,
  ));
}


}


/// @nodoc
mixin _$OrderDetailOption {

@JsonKey(fromJson: parseString) String get name;@JsonKey(name: 'price_delta', fromJson: kopecksFromJson) int get priceDeltaKopecks;@JsonKey(fromJson: quantityOrDefaultOne) int get quantity;
/// Create a copy of OrderDetailOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDetailOptionCopyWith<OrderDetailOption> get copyWith => _$OrderDetailOptionCopyWithImpl<OrderDetailOption>(this as OrderDetailOption, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderDetailOption;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDetailOption&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.priceDeltaKopecks, _this.priceDeltaKopecks) || other.priceDeltaKopecks == _this.priceDeltaKopecks)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrderDetailOption;
  return Object.hash(runtimeType,_this.name,_this.priceDeltaKopecks,_this.quantity);
}

@override
String toString() {
  final _this = this as OrderDetailOption;
  return 'OrderDetailOption(name: ${_this.name}, priceDeltaKopecks: ${_this.priceDeltaKopecks}, quantity: ${_this.quantity})';
}


}

/// @nodoc
abstract mixin class $OrderDetailOptionCopyWith<$Res>  {
  factory $OrderDetailOptionCopyWith(OrderDetailOption value, $Res Function(OrderDetailOption) _then) = _$OrderDetailOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'price_delta', fromJson: kopecksFromJson) int priceDeltaKopecks,@JsonKey(fromJson: quantityOrDefaultOne) int quantity
});




}
/// @nodoc
class _$OrderDetailOptionCopyWithImpl<$Res>
    implements $OrderDetailOptionCopyWith<$Res> {
  _$OrderDetailOptionCopyWithImpl(this._self, this._then);

  final OrderDetailOption _self;
  final $Res Function(OrderDetailOption) _then;

/// Create a copy of OrderDetailOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? priceDeltaKopecks = null,Object? quantity = null,}) {
  return _then(OrderDetailOption(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceDeltaKopecks: null == priceDeltaKopecks ? _self.priceDeltaKopecks : priceDeltaKopecks // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderDetailOption].
extension OrderDetailOptionPatterns on OrderDetailOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderDetailOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderDetailOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderDetailOption value)  $default,){
final _that = this;
switch (_that) {
case _OrderDetailOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderDetailOption value)?  $default,){
final _that = this;
switch (_that) {
case _OrderDetailOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'price_delta', fromJson: kopecksFromJson)  int priceDeltaKopecks, @JsonKey(fromJson: quantityOrDefaultOne)  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderDetailOption() when $default != null:
return $default(_that.name,_that.priceDeltaKopecks,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'price_delta', fromJson: kopecksFromJson)  int priceDeltaKopecks, @JsonKey(fromJson: quantityOrDefaultOne)  int quantity)  $default,) {final _that = this;
switch (_that) {
case _OrderDetailOption():
return $default(_that.name,_that.priceDeltaKopecks,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'price_delta', fromJson: kopecksFromJson)  int priceDeltaKopecks, @JsonKey(fromJson: quantityOrDefaultOne)  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _OrderDetailOption() when $default != null:
return $default(_that.name,_that.priceDeltaKopecks,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _OrderDetailOption implements OrderDetailOption {
  const _OrderDetailOption({@JsonKey(fromJson: parseString) required this.name, @JsonKey(name: 'price_delta', fromJson: kopecksFromJson) required this.priceDeltaKopecks, @JsonKey(fromJson: quantityOrDefaultOne) required this.quantity});
  factory _OrderDetailOption.fromJson(Map<String, dynamic> json) => _$OrderDetailOptionFromJson(json);

@override@JsonKey(fromJson: parseString) final  String name;
@override@JsonKey(name: 'price_delta', fromJson: kopecksFromJson) final  int priceDeltaKopecks;
@override@JsonKey(fromJson: quantityOrDefaultOne) final  int quantity;

/// Create a copy of OrderDetailOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderDetailOptionCopyWith<_OrderDetailOption> get copyWith => __$OrderDetailOptionCopyWithImpl<_OrderDetailOption>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderDetailOption&&(identical(other.name, name) || other.name == name)&&(identical(other.priceDeltaKopecks, priceDeltaKopecks) || other.priceDeltaKopecks == priceDeltaKopecks)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,priceDeltaKopecks,quantity);
}

@override
String toString() {
    return 'OrderDetailOption(name: $name, priceDeltaKopecks: $priceDeltaKopecks, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$OrderDetailOptionCopyWith<$Res> implements $OrderDetailOptionCopyWith<$Res> {
  factory _$OrderDetailOptionCopyWith(_OrderDetailOption value, $Res Function(_OrderDetailOption) _then) = __$OrderDetailOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'price_delta', fromJson: kopecksFromJson) int priceDeltaKopecks,@JsonKey(fromJson: quantityOrDefaultOne) int quantity
});




}
/// @nodoc
class __$OrderDetailOptionCopyWithImpl<$Res>
    implements _$OrderDetailOptionCopyWith<$Res> {
  __$OrderDetailOptionCopyWithImpl(this._self, this._then);

  final _OrderDetailOption _self;
  final $Res Function(_OrderDetailOption) _then;

/// Create a copy of OrderDetailOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? priceDeltaKopecks = null,Object? quantity = null,}) {
  return _then(_OrderDetailOption(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceDeltaKopecks: null == priceDeltaKopecks ? _self.priceDeltaKopecks : priceDeltaKopecks // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OrderDetailPayment {

@JsonKey(fromJson: paymentMethodFromJson) PaymentMethod get method;@JsonKey(name: 'tendered', fromJson: kopecksFromJson) int get tenderedKopecks;@JsonKey(name: 'change', fromJson: kopecksFromJson) int get changeKopecks;@JsonKey(name: 'total', fromJson: kopecksFromJson) int get totalKopecks;
/// Create a copy of OrderDetailPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDetailPaymentCopyWith<OrderDetailPayment> get copyWith => _$OrderDetailPaymentCopyWithImpl<OrderDetailPayment>(this as OrderDetailPayment, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderDetailPayment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDetailPayment&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.tenderedKopecks, _this.tenderedKopecks) || other.tenderedKopecks == _this.tenderedKopecks)&&(identical(other.changeKopecks, _this.changeKopecks) || other.changeKopecks == _this.changeKopecks)&&(identical(other.totalKopecks, _this.totalKopecks) || other.totalKopecks == _this.totalKopecks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrderDetailPayment;
  return Object.hash(runtimeType,_this.method,_this.tenderedKopecks,_this.changeKopecks,_this.totalKopecks);
}

@override
String toString() {
  final _this = this as OrderDetailPayment;
  return 'OrderDetailPayment(method: ${_this.method}, tenderedKopecks: ${_this.tenderedKopecks}, changeKopecks: ${_this.changeKopecks}, totalKopecks: ${_this.totalKopecks})';
}


}

/// @nodoc
abstract mixin class $OrderDetailPaymentCopyWith<$Res>  {
  factory $OrderDetailPaymentCopyWith(OrderDetailPayment value, $Res Function(OrderDetailPayment) _then) = _$OrderDetailPaymentCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: paymentMethodFromJson) PaymentMethod method,@JsonKey(name: 'tendered', fromJson: kopecksFromJson) int tenderedKopecks,@JsonKey(name: 'change', fromJson: kopecksFromJson) int changeKopecks,@JsonKey(name: 'total', fromJson: kopecksFromJson) int totalKopecks
});




}
/// @nodoc
class _$OrderDetailPaymentCopyWithImpl<$Res>
    implements $OrderDetailPaymentCopyWith<$Res> {
  _$OrderDetailPaymentCopyWithImpl(this._self, this._then);

  final OrderDetailPayment _self;
  final $Res Function(OrderDetailPayment) _then;

/// Create a copy of OrderDetailPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? tenderedKopecks = null,Object? changeKopecks = null,Object? totalKopecks = null,}) {
  return _then(OrderDetailPayment(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,tenderedKopecks: null == tenderedKopecks ? _self.tenderedKopecks : tenderedKopecks // ignore: cast_nullable_to_non_nullable
as int,changeKopecks: null == changeKopecks ? _self.changeKopecks : changeKopecks // ignore: cast_nullable_to_non_nullable
as int,totalKopecks: null == totalKopecks ? _self.totalKopecks : totalKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderDetailPayment].
extension OrderDetailPaymentPatterns on OrderDetailPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderDetailPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderDetailPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderDetailPayment value)  $default,){
final _that = this;
switch (_that) {
case _OrderDetailPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderDetailPayment value)?  $default,){
final _that = this;
switch (_that) {
case _OrderDetailPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: paymentMethodFromJson)  PaymentMethod method, @JsonKey(name: 'tendered', fromJson: kopecksFromJson)  int tenderedKopecks, @JsonKey(name: 'change', fromJson: kopecksFromJson)  int changeKopecks, @JsonKey(name: 'total', fromJson: kopecksFromJson)  int totalKopecks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderDetailPayment() when $default != null:
return $default(_that.method,_that.tenderedKopecks,_that.changeKopecks,_that.totalKopecks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: paymentMethodFromJson)  PaymentMethod method, @JsonKey(name: 'tendered', fromJson: kopecksFromJson)  int tenderedKopecks, @JsonKey(name: 'change', fromJson: kopecksFromJson)  int changeKopecks, @JsonKey(name: 'total', fromJson: kopecksFromJson)  int totalKopecks)  $default,) {final _that = this;
switch (_that) {
case _OrderDetailPayment():
return $default(_that.method,_that.tenderedKopecks,_that.changeKopecks,_that.totalKopecks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: paymentMethodFromJson)  PaymentMethod method, @JsonKey(name: 'tendered', fromJson: kopecksFromJson)  int tenderedKopecks, @JsonKey(name: 'change', fromJson: kopecksFromJson)  int changeKopecks, @JsonKey(name: 'total', fromJson: kopecksFromJson)  int totalKopecks)?  $default,) {final _that = this;
switch (_that) {
case _OrderDetailPayment() when $default != null:
return $default(_that.method,_that.tenderedKopecks,_that.changeKopecks,_that.totalKopecks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _OrderDetailPayment implements OrderDetailPayment {
  const _OrderDetailPayment({@JsonKey(fromJson: paymentMethodFromJson) required this.method, @JsonKey(name: 'tendered', fromJson: kopecksFromJson) required this.tenderedKopecks, @JsonKey(name: 'change', fromJson: kopecksFromJson) required this.changeKopecks, @JsonKey(name: 'total', fromJson: kopecksFromJson) required this.totalKopecks});
  factory _OrderDetailPayment.fromJson(Map<String, dynamic> json) => _$OrderDetailPaymentFromJson(json);

@override@JsonKey(fromJson: paymentMethodFromJson) final  PaymentMethod method;
@override@JsonKey(name: 'tendered', fromJson: kopecksFromJson) final  int tenderedKopecks;
@override@JsonKey(name: 'change', fromJson: kopecksFromJson) final  int changeKopecks;
@override@JsonKey(name: 'total', fromJson: kopecksFromJson) final  int totalKopecks;

/// Create a copy of OrderDetailPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderDetailPaymentCopyWith<_OrderDetailPayment> get copyWith => __$OrderDetailPaymentCopyWithImpl<_OrderDetailPayment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderDetailPayment&&(identical(other.method, method) || other.method == method)&&(identical(other.tenderedKopecks, tenderedKopecks) || other.tenderedKopecks == tenderedKopecks)&&(identical(other.changeKopecks, changeKopecks) || other.changeKopecks == changeKopecks)&&(identical(other.totalKopecks, totalKopecks) || other.totalKopecks == totalKopecks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,method,tenderedKopecks,changeKopecks,totalKopecks);
}

@override
String toString() {
    return 'OrderDetailPayment(method: $method, tenderedKopecks: $tenderedKopecks, changeKopecks: $changeKopecks, totalKopecks: $totalKopecks)';
}


}

/// @nodoc
abstract mixin class _$OrderDetailPaymentCopyWith<$Res> implements $OrderDetailPaymentCopyWith<$Res> {
  factory _$OrderDetailPaymentCopyWith(_OrderDetailPayment value, $Res Function(_OrderDetailPayment) _then) = __$OrderDetailPaymentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: paymentMethodFromJson) PaymentMethod method,@JsonKey(name: 'tendered', fromJson: kopecksFromJson) int tenderedKopecks,@JsonKey(name: 'change', fromJson: kopecksFromJson) int changeKopecks,@JsonKey(name: 'total', fromJson: kopecksFromJson) int totalKopecks
});




}
/// @nodoc
class __$OrderDetailPaymentCopyWithImpl<$Res>
    implements _$OrderDetailPaymentCopyWith<$Res> {
  __$OrderDetailPaymentCopyWithImpl(this._self, this._then);

  final _OrderDetailPayment _self;
  final $Res Function(_OrderDetailPayment) _then;

/// Create a copy of OrderDetailPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? tenderedKopecks = null,Object? changeKopecks = null,Object? totalKopecks = null,}) {
  return _then(_OrderDetailPayment(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,tenderedKopecks: null == tenderedKopecks ? _self.tenderedKopecks : tenderedKopecks // ignore: cast_nullable_to_non_nullable
as int,changeKopecks: null == changeKopecks ? _self.changeKopecks : changeKopecks // ignore: cast_nullable_to_non_nullable
as int,totalKopecks: null == totalKopecks ? _self.totalKopecks : totalKopecks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OrderDetail {

 int get orderId; int get shiftId; String get status; DateTime get createdAt; int get totalKopecks; List<OrderDetailItem> get items; OrderDetailPayment get payment;
/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDetailCopyWith<OrderDetail> get copyWith => _$OrderDetailCopyWithImpl<OrderDetail>(this as OrderDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrderDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDetail&&(identical(other.orderId, _this.orderId) || other.orderId == _this.orderId)&&(identical(other.shiftId, _this.shiftId) || other.shiftId == _this.shiftId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.totalKopecks, _this.totalKopecks) || other.totalKopecks == _this.totalKopecks)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.payment, _this.payment) || other.payment == _this.payment));
}


@override
int get hashCode {
  final _this = this as OrderDetail;
  return Object.hash(runtimeType,_this.orderId,_this.shiftId,_this.status,_this.createdAt,_this.totalKopecks,const DeepCollectionEquality().hash(_this.items),_this.payment);
}

@override
String toString() {
  final _this = this as OrderDetail;
  return 'OrderDetail(orderId: ${_this.orderId}, shiftId: ${_this.shiftId}, status: ${_this.status}, createdAt: ${_this.createdAt}, totalKopecks: ${_this.totalKopecks}, items: ${_this.items}, payment: ${_this.payment})';
}


}

/// @nodoc
abstract mixin class $OrderDetailCopyWith<$Res>  {
  factory $OrderDetailCopyWith(OrderDetail value, $Res Function(OrderDetail) _then) = _$OrderDetailCopyWithImpl;
@useResult
$Res call({
 int orderId, int shiftId, String status, DateTime createdAt, int totalKopecks, List<OrderDetailItem> items, OrderDetailPayment payment
});


$OrderDetailPaymentCopyWith<$Res> get payment;

}
/// @nodoc
class _$OrderDetailCopyWithImpl<$Res>
    implements $OrderDetailCopyWith<$Res> {
  _$OrderDetailCopyWithImpl(this._self, this._then);

  final OrderDetail _self;
  final $Res Function(OrderDetail) _then;

/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? shiftId = null,Object? status = null,Object? createdAt = null,Object? totalKopecks = null,Object? items = null,Object? payment = null,}) {
  return _then(OrderDetail(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,shiftId: null == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalKopecks: null == totalKopecks ? _self.totalKopecks : totalKopecks // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderDetailItem>,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as OrderDetailPayment,
  ));
}
/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderDetailPaymentCopyWith<$Res> get payment {
  
  return $OrderDetailPaymentCopyWith<$Res>(_self.payment, (value) {
    return _then(_self.copyWith(payment: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderDetail].
extension OrderDetailPatterns on OrderDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderDetail value)  $default,){
final _that = this;
switch (_that) {
case _OrderDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderDetail value)?  $default,){
final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int orderId,  int shiftId,  String status,  DateTime createdAt,  int totalKopecks,  List<OrderDetailItem> items,  OrderDetailPayment payment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
return $default(_that.orderId,_that.shiftId,_that.status,_that.createdAt,_that.totalKopecks,_that.items,_that.payment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int orderId,  int shiftId,  String status,  DateTime createdAt,  int totalKopecks,  List<OrderDetailItem> items,  OrderDetailPayment payment)  $default,) {final _that = this;
switch (_that) {
case _OrderDetail():
return $default(_that.orderId,_that.shiftId,_that.status,_that.createdAt,_that.totalKopecks,_that.items,_that.payment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int orderId,  int shiftId,  String status,  DateTime createdAt,  int totalKopecks,  List<OrderDetailItem> items,  OrderDetailPayment payment)?  $default,) {final _that = this;
switch (_that) {
case _OrderDetail() when $default != null:
return $default(_that.orderId,_that.shiftId,_that.status,_that.createdAt,_that.totalKopecks,_that.items,_that.payment);case _:
  return null;

}
}

}

/// @nodoc


class _OrderDetail implements OrderDetail {
  const _OrderDetail({required this.orderId, required this.shiftId, required this.status, required this.createdAt, required this.totalKopecks, required  List<OrderDetailItem> items, required this.payment}): _items = items;
  

@override final  int orderId;
@override final  int shiftId;
@override final  String status;
@override final  DateTime createdAt;
@override final  int totalKopecks;
 final  List<OrderDetailItem> _items;
@override List<OrderDetailItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  OrderDetailPayment payment;

/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderDetailCopyWith<_OrderDetail> get copyWith => __$OrderDetailCopyWithImpl<_OrderDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderDetail&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.shiftId, shiftId) || other.shiftId == shiftId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.totalKopecks, totalKopecks) || other.totalKopecks == totalKopecks)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.payment, payment) || other.payment == payment));
}


@override
int get hashCode {
    return Object.hash(runtimeType,orderId,shiftId,status,createdAt,totalKopecks,const DeepCollectionEquality().hash(_items),payment);
}

@override
String toString() {
    return 'OrderDetail(orderId: $orderId, shiftId: $shiftId, status: $status, createdAt: $createdAt, totalKopecks: $totalKopecks, items: $items, payment: $payment)';
}


}

/// @nodoc
abstract mixin class _$OrderDetailCopyWith<$Res> implements $OrderDetailCopyWith<$Res> {
  factory _$OrderDetailCopyWith(_OrderDetail value, $Res Function(_OrderDetail) _then) = __$OrderDetailCopyWithImpl;
@override @useResult
$Res call({
 int orderId, int shiftId, String status, DateTime createdAt, int totalKopecks, List<OrderDetailItem> items, OrderDetailPayment payment
});


@override $OrderDetailPaymentCopyWith<$Res> get payment;

}
/// @nodoc
class __$OrderDetailCopyWithImpl<$Res>
    implements _$OrderDetailCopyWith<$Res> {
  __$OrderDetailCopyWithImpl(this._self, this._then);

  final _OrderDetail _self;
  final $Res Function(_OrderDetail) _then;

/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? shiftId = null,Object? status = null,Object? createdAt = null,Object? totalKopecks = null,Object? items = null,Object? payment = null,}) {
  return _then(_OrderDetail(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,shiftId: null == shiftId ? _self.shiftId : shiftId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalKopecks: null == totalKopecks ? _self.totalKopecks : totalKopecks // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderDetailItem>,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as OrderDetailPayment,
  ));
}

/// Create a copy of OrderDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderDetailPaymentCopyWith<$Res> get payment {
  
  return $OrderDetailPaymentCopyWith<$Res>(_self.payment, (value) {
    return _then(_self.copyWith(payment: value));
  });
}
}

// dart format on
