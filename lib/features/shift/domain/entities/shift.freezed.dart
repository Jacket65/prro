// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShiftResponse {

@JsonKey(fromJson: parseInt) int get id;@JsonKey(name: 'outlet_id', fromJson: parseInt) int get outletId;@JsonKey(name: 'opened_by', fromJson: parseInt) int get openedBy;@JsonKey(name: 'opened_at', fromJson: stringOrEmpty) String get openedAt;@JsonKey(name: 'cash_start', fromJson: cashStartOrZero) String get cashStart;@JsonKey(fromJson: parseString) String get status;@JsonKey(name: 'closed_by', fromJson: parseNullableInt) int? get closedBy;@JsonKey(name: 'closed_at', fromJson: stringOrNull) String? get closedAt;@JsonKey(name: 'cash_end', fromJson: stringOrNull) String? get cashEnd;
/// Create a copy of ShiftResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftResponseCopyWith<ShiftResponse> get copyWith => _$ShiftResponseCopyWithImpl<ShiftResponse>(this as ShiftResponse, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShiftResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftResponse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.outletId, _this.outletId) || other.outletId == _this.outletId)&&(identical(other.openedBy, _this.openedBy) || other.openedBy == _this.openedBy)&&(identical(other.openedAt, _this.openedAt) || other.openedAt == _this.openedAt)&&(identical(other.cashStart, _this.cashStart) || other.cashStart == _this.cashStart)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.closedBy, _this.closedBy) || other.closedBy == _this.closedBy)&&(identical(other.closedAt, _this.closedAt) || other.closedAt == _this.closedAt)&&(identical(other.cashEnd, _this.cashEnd) || other.cashEnd == _this.cashEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ShiftResponse;
  return Object.hash(runtimeType,_this.id,_this.outletId,_this.openedBy,_this.openedAt,_this.cashStart,_this.status,_this.closedBy,_this.closedAt,_this.cashEnd);
}

@override
String toString() {
  final _this = this as ShiftResponse;
  return 'ShiftResponse(id: ${_this.id}, outletId: ${_this.outletId}, openedBy: ${_this.openedBy}, openedAt: ${_this.openedAt}, cashStart: ${_this.cashStart}, status: ${_this.status}, closedBy: ${_this.closedBy}, closedAt: ${_this.closedAt}, cashEnd: ${_this.cashEnd})';
}


}

/// @nodoc
abstract mixin class $ShiftResponseCopyWith<$Res>  {
  factory $ShiftResponseCopyWith(ShiftResponse value, $Res Function(ShiftResponse) _then) = _$ShiftResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(name: 'outlet_id', fromJson: parseInt) int outletId,@JsonKey(name: 'opened_by', fromJson: parseInt) int openedBy,@JsonKey(name: 'opened_at', fromJson: stringOrEmpty) String openedAt,@JsonKey(name: 'cash_start', fromJson: cashStartOrZero) String cashStart,@JsonKey(fromJson: parseString) String status,@JsonKey(name: 'closed_by', fromJson: parseNullableInt) int? closedBy,@JsonKey(name: 'closed_at', fromJson: stringOrNull) String? closedAt,@JsonKey(name: 'cash_end', fromJson: stringOrNull) String? cashEnd
});




}
/// @nodoc
class _$ShiftResponseCopyWithImpl<$Res>
    implements $ShiftResponseCopyWith<$Res> {
  _$ShiftResponseCopyWithImpl(this._self, this._then);

  final ShiftResponse _self;
  final $Res Function(ShiftResponse) _then;

/// Create a copy of ShiftResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? outletId = null,Object? openedBy = null,Object? openedAt = null,Object? cashStart = null,Object? status = null,Object? closedBy = freezed,Object? closedAt = freezed,Object? cashEnd = freezed,}) {
  return _then(ShiftResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,outletId: null == outletId ? _self.outletId : outletId // ignore: cast_nullable_to_non_nullable
as int,openedBy: null == openedBy ? _self.openedBy : openedBy // ignore: cast_nullable_to_non_nullable
as int,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as String,cashStart: null == cashStart ? _self.cashStart : cashStart // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as int?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String?,cashEnd: freezed == cashEnd ? _self.cashEnd : cashEnd // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShiftResponse].
extension ShiftResponsePatterns on ShiftResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShiftResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShiftResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShiftResponse value)  $default,){
final _that = this;
switch (_that) {
case _ShiftResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShiftResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ShiftResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(name: 'outlet_id', fromJson: parseInt)  int outletId, @JsonKey(name: 'opened_by', fromJson: parseInt)  int openedBy, @JsonKey(name: 'opened_at', fromJson: stringOrEmpty)  String openedAt, @JsonKey(name: 'cash_start', fromJson: cashStartOrZero)  String cashStart, @JsonKey(fromJson: parseString)  String status, @JsonKey(name: 'closed_by', fromJson: parseNullableInt)  int? closedBy, @JsonKey(name: 'closed_at', fromJson: stringOrNull)  String? closedAt, @JsonKey(name: 'cash_end', fromJson: stringOrNull)  String? cashEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShiftResponse() when $default != null:
return $default(_that.id,_that.outletId,_that.openedBy,_that.openedAt,_that.cashStart,_that.status,_that.closedBy,_that.closedAt,_that.cashEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(name: 'outlet_id', fromJson: parseInt)  int outletId, @JsonKey(name: 'opened_by', fromJson: parseInt)  int openedBy, @JsonKey(name: 'opened_at', fromJson: stringOrEmpty)  String openedAt, @JsonKey(name: 'cash_start', fromJson: cashStartOrZero)  String cashStart, @JsonKey(fromJson: parseString)  String status, @JsonKey(name: 'closed_by', fromJson: parseNullableInt)  int? closedBy, @JsonKey(name: 'closed_at', fromJson: stringOrNull)  String? closedAt, @JsonKey(name: 'cash_end', fromJson: stringOrNull)  String? cashEnd)  $default,) {final _that = this;
switch (_that) {
case _ShiftResponse():
return $default(_that.id,_that.outletId,_that.openedBy,_that.openedAt,_that.cashStart,_that.status,_that.closedBy,_that.closedAt,_that.cashEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(name: 'outlet_id', fromJson: parseInt)  int outletId, @JsonKey(name: 'opened_by', fromJson: parseInt)  int openedBy, @JsonKey(name: 'opened_at', fromJson: stringOrEmpty)  String openedAt, @JsonKey(name: 'cash_start', fromJson: cashStartOrZero)  String cashStart, @JsonKey(fromJson: parseString)  String status, @JsonKey(name: 'closed_by', fromJson: parseNullableInt)  int? closedBy, @JsonKey(name: 'closed_at', fromJson: stringOrNull)  String? closedAt, @JsonKey(name: 'cash_end', fromJson: stringOrNull)  String? cashEnd)?  $default,) {final _that = this;
switch (_that) {
case _ShiftResponse() when $default != null:
return $default(_that.id,_that.outletId,_that.openedBy,_that.openedAt,_that.cashStart,_that.status,_that.closedBy,_that.closedAt,_that.cashEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _ShiftResponse extends ShiftResponse {
  const _ShiftResponse({@JsonKey(fromJson: parseInt) required this.id, @JsonKey(name: 'outlet_id', fromJson: parseInt) required this.outletId, @JsonKey(name: 'opened_by', fromJson: parseInt) required this.openedBy, @JsonKey(name: 'opened_at', fromJson: stringOrEmpty) required this.openedAt, @JsonKey(name: 'cash_start', fromJson: cashStartOrZero) required this.cashStart, @JsonKey(fromJson: parseString) required this.status, @JsonKey(name: 'closed_by', fromJson: parseNullableInt) this.closedBy, @JsonKey(name: 'closed_at', fromJson: stringOrNull) this.closedAt, @JsonKey(name: 'cash_end', fromJson: stringOrNull) this.cashEnd}): super._();
  factory _ShiftResponse.fromJson(Map<String, dynamic> json) => _$ShiftResponseFromJson(json);

@override@JsonKey(fromJson: parseInt) final  int id;
@override@JsonKey(name: 'outlet_id', fromJson: parseInt) final  int outletId;
@override@JsonKey(name: 'opened_by', fromJson: parseInt) final  int openedBy;
@override@JsonKey(name: 'opened_at', fromJson: stringOrEmpty) final  String openedAt;
@override@JsonKey(name: 'cash_start', fromJson: cashStartOrZero) final  String cashStart;
@override@JsonKey(fromJson: parseString) final  String status;
@override@JsonKey(name: 'closed_by', fromJson: parseNullableInt) final  int? closedBy;
@override@JsonKey(name: 'closed_at', fromJson: stringOrNull) final  String? closedAt;
@override@JsonKey(name: 'cash_end', fromJson: stringOrNull) final  String? cashEnd;

/// Create a copy of ShiftResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShiftResponseCopyWith<_ShiftResponse> get copyWith => __$ShiftResponseCopyWithImpl<_ShiftResponse>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShiftResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.outletId, outletId) || other.outletId == outletId)&&(identical(other.openedBy, openedBy) || other.openedBy == openedBy)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.cashStart, cashStart) || other.cashStart == cashStart)&&(identical(other.status, status) || other.status == status)&&(identical(other.closedBy, closedBy) || other.closedBy == closedBy)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.cashEnd, cashEnd) || other.cashEnd == cashEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,outletId,openedBy,openedAt,cashStart,status,closedBy,closedAt,cashEnd);
}

@override
String toString() {
    return 'ShiftResponse(id: $id, outletId: $outletId, openedBy: $openedBy, openedAt: $openedAt, cashStart: $cashStart, status: $status, closedBy: $closedBy, closedAt: $closedAt, cashEnd: $cashEnd)';
}


}

/// @nodoc
abstract mixin class _$ShiftResponseCopyWith<$Res> implements $ShiftResponseCopyWith<$Res> {
  factory _$ShiftResponseCopyWith(_ShiftResponse value, $Res Function(_ShiftResponse) _then) = __$ShiftResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(name: 'outlet_id', fromJson: parseInt) int outletId,@JsonKey(name: 'opened_by', fromJson: parseInt) int openedBy,@JsonKey(name: 'opened_at', fromJson: stringOrEmpty) String openedAt,@JsonKey(name: 'cash_start', fromJson: cashStartOrZero) String cashStart,@JsonKey(fromJson: parseString) String status,@JsonKey(name: 'closed_by', fromJson: parseNullableInt) int? closedBy,@JsonKey(name: 'closed_at', fromJson: stringOrNull) String? closedAt,@JsonKey(name: 'cash_end', fromJson: stringOrNull) String? cashEnd
});




}
/// @nodoc
class __$ShiftResponseCopyWithImpl<$Res>
    implements _$ShiftResponseCopyWith<$Res> {
  __$ShiftResponseCopyWithImpl(this._self, this._then);

  final _ShiftResponse _self;
  final $Res Function(_ShiftResponse) _then;

/// Create a copy of ShiftResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? outletId = null,Object? openedBy = null,Object? openedAt = null,Object? cashStart = null,Object? status = null,Object? closedBy = freezed,Object? closedAt = freezed,Object? cashEnd = freezed,}) {
  return _then(_ShiftResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,outletId: null == outletId ? _self.outletId : outletId // ignore: cast_nullable_to_non_nullable
as int,openedBy: null == openedBy ? _self.openedBy : openedBy // ignore: cast_nullable_to_non_nullable
as int,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as String,cashStart: null == cashStart ? _self.cashStart : cashStart // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as int?,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as String?,cashEnd: freezed == cashEnd ? _self.cashEnd : cashEnd // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
