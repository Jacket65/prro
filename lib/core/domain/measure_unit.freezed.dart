// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measure_unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeasureUnit {

 int get id; String get name; Decimal get step; int get scale;
/// Create a copy of MeasureUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasureUnitCopyWith<MeasureUnit> get copyWith => _$MeasureUnitCopyWithImpl<MeasureUnit>(this as MeasureUnit, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MeasureUnit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasureUnit&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.scale, _this.scale) || other.scale == _this.scale));
}


@override
int get hashCode {
  final _this = this as MeasureUnit;
  return Object.hash(runtimeType,_this.id,_this.name,_this.step,_this.scale);
}

@override
String toString() {
  final _this = this as MeasureUnit;
  return 'MeasureUnit(id: ${_this.id}, name: ${_this.name}, step: ${_this.step}, scale: ${_this.scale})';
}


}

/// @nodoc
abstract mixin class $MeasureUnitCopyWith<$Res>  {
  factory $MeasureUnitCopyWith(MeasureUnit value, $Res Function(MeasureUnit) _then) = _$MeasureUnitCopyWithImpl;
@useResult
$Res call({
 int id, String name, Decimal step, int scale
});




}
/// @nodoc
class _$MeasureUnitCopyWithImpl<$Res>
    implements $MeasureUnitCopyWith<$Res> {
  _$MeasureUnitCopyWithImpl(this._self, this._then);

  final MeasureUnit _self;
  final $Res Function(MeasureUnit) _then;

/// Create a copy of MeasureUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? step = null,Object? scale = null,}) {
  return _then(MeasureUnit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as Decimal,scale: null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MeasureUnit].
extension MeasureUnitPatterns on MeasureUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasureUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasureUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasureUnit value)  $default,){
final _that = this;
switch (_that) {
case _MeasureUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasureUnit value)?  $default,){
final _that = this;
switch (_that) {
case _MeasureUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  Decimal step,  int scale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasureUnit() when $default != null:
return $default(_that.id,_that.name,_that.step,_that.scale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  Decimal step,  int scale)  $default,) {final _that = this;
switch (_that) {
case _MeasureUnit():
return $default(_that.id,_that.name,_that.step,_that.scale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  Decimal step,  int scale)?  $default,) {final _that = this;
switch (_that) {
case _MeasureUnit() when $default != null:
return $default(_that.id,_that.name,_that.step,_that.scale);case _:
  return null;

}
}

}

/// @nodoc


class _MeasureUnit implements MeasureUnit {
  const _MeasureUnit({required this.id, required this.name, required this.step, this.scale = 0});
  

@override final  int id;
@override final  String name;
@override final  Decimal step;
@override@JsonKey() final  int scale;

/// Create a copy of MeasureUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasureUnitCopyWith<_MeasureUnit> get copyWith => __$MeasureUnitCopyWithImpl<_MeasureUnit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeasureUnit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.step, step) || other.step == step)&&(identical(other.scale, scale) || other.scale == scale));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,step,scale);
}

@override
String toString() {
    return 'MeasureUnit(id: $id, name: $name, step: $step, scale: $scale)';
}


}

/// @nodoc
abstract mixin class _$MeasureUnitCopyWith<$Res> implements $MeasureUnitCopyWith<$Res> {
  factory _$MeasureUnitCopyWith(_MeasureUnit value, $Res Function(_MeasureUnit) _then) = __$MeasureUnitCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, Decimal step, int scale
});




}
/// @nodoc
class __$MeasureUnitCopyWithImpl<$Res>
    implements _$MeasureUnitCopyWith<$Res> {
  __$MeasureUnitCopyWithImpl(this._self, this._then);

  final _MeasureUnit _self;
  final $Res Function(_MeasureUnit) _then;

/// Create a copy of MeasureUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? step = null,Object? scale = null,}) {
  return _then(_MeasureUnit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as Decimal,scale: null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
