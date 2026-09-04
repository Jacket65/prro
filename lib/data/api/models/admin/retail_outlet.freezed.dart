// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'retail_outlet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RetailOutlet {

 int get id; String get name; String? get address; String? get city; bool? get isActive;
/// Create a copy of RetailOutlet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RetailOutletCopyWith<RetailOutlet> get copyWith => _$RetailOutletCopyWithImpl<RetailOutlet>(this as RetailOutlet, _$identity);

  /// Serializes this RetailOutlet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RetailOutlet&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,city,isActive);

@override
String toString() {
  return 'RetailOutlet(id: $id, name: $name, address: $address, city: $city, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $RetailOutletCopyWith<$Res>  {
  factory $RetailOutletCopyWith(RetailOutlet value, $Res Function(RetailOutlet) _then) = _$RetailOutletCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? address, String? city, bool? isActive
});




}
/// @nodoc
class _$RetailOutletCopyWithImpl<$Res>
    implements $RetailOutletCopyWith<$Res> {
  _$RetailOutletCopyWithImpl(this._self, this._then);

  final RetailOutlet _self;
  final $Res Function(RetailOutlet) _then;

/// Create a copy of RetailOutlet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? city = freezed,Object? isActive = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [RetailOutlet].
extension RetailOutletPatterns on RetailOutlet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RetailOutlet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RetailOutlet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RetailOutlet value)  $default,){
final _that = this;
switch (_that) {
case _RetailOutlet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RetailOutlet value)?  $default,){
final _that = this;
switch (_that) {
case _RetailOutlet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? address,  String? city,  bool? isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RetailOutlet() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.city,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? address,  String? city,  bool? isActive)  $default,) {final _that = this;
switch (_that) {
case _RetailOutlet():
return $default(_that.id,_that.name,_that.address,_that.city,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? address,  String? city,  bool? isActive)?  $default,) {final _that = this;
switch (_that) {
case _RetailOutlet() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.city,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RetailOutlet implements RetailOutlet {
  const _RetailOutlet({required this.id, required this.name, this.address, this.city, this.isActive});
  factory _RetailOutlet.fromJson(Map<String, dynamic> json) => _$RetailOutletFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? address;
@override final  String? city;
@override final  bool? isActive;

/// Create a copy of RetailOutlet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RetailOutletCopyWith<_RetailOutlet> get copyWith => __$RetailOutletCopyWithImpl<_RetailOutlet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RetailOutletToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RetailOutlet&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,city,isActive);

@override
String toString() {
  return 'RetailOutlet(id: $id, name: $name, address: $address, city: $city, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$RetailOutletCopyWith<$Res> implements $RetailOutletCopyWith<$Res> {
  factory _$RetailOutletCopyWith(_RetailOutlet value, $Res Function(_RetailOutlet) _then) = __$RetailOutletCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? address, String? city, bool? isActive
});




}
/// @nodoc
class __$RetailOutletCopyWithImpl<$Res>
    implements _$RetailOutletCopyWith<$Res> {
  __$RetailOutletCopyWithImpl(this._self, this._then);

  final _RetailOutlet _self;
  final $Res Function(_RetailOutlet) _then;

/// Create a copy of RetailOutlet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? city = freezed,Object? isActive = freezed,}) {
  return _then(_RetailOutlet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
