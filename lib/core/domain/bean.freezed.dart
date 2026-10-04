// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bean.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Bean {

@JsonKey(fromJson: parseInt) int get id;@JsonKey(fromJson: parseString) String get name;
/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeanCopyWith<Bean> get copyWith => _$BeanCopyWithImpl<Bean>(this as Bean, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Bean;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bean&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Bean;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as Bean;
  return 'Bean(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $BeanCopyWith<$Res>  {
  factory $BeanCopyWith(Bean value, $Res Function(Bean) _then) = _$BeanCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name
});




}
/// @nodoc
class _$BeanCopyWithImpl<$Res>
    implements $BeanCopyWith<$Res> {
  _$BeanCopyWithImpl(this._self, this._then);

  final Bean _self;
  final $Res Function(Bean) _then;

/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(Bean(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Bean].
extension BeanPatterns on Bean {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bean value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bean() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bean value)  $default,){
final _that = this;
switch (_that) {
case _Bean():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bean value)?  $default,){
final _that = this;
switch (_that) {
case _Bean() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bean() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name)  $default,) {final _that = this;
switch (_that) {
case _Bean():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name)?  $default,) {final _that = this;
switch (_that) {
case _Bean() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _Bean implements Bean {
  const _Bean({@JsonKey(fromJson: parseInt) required this.id, @JsonKey(fromJson: parseString) required this.name});
  factory _Bean.fromJson(Map<String, dynamic> json) => _$BeanFromJson(json);

@override@JsonKey(fromJson: parseInt) final  int id;
@override@JsonKey(fromJson: parseString) final  String name;

/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeanCopyWith<_Bean> get copyWith => __$BeanCopyWithImpl<_Bean>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bean&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'Bean(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$BeanCopyWith<$Res> implements $BeanCopyWith<$Res> {
  factory _$BeanCopyWith(_Bean value, $Res Function(_Bean) _then) = __$BeanCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name
});




}
/// @nodoc
class __$BeanCopyWithImpl<$Res>
    implements _$BeanCopyWith<$Res> {
  __$BeanCopyWithImpl(this._self, this._then);

  final _Bean _self;
  final $Res Function(_Bean) _then;

/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_Bean(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BeanGroup {

@JsonKey(fromJson: parseInt) int get id;@JsonKey(fromJson: parseString) String get name;@JsonKey(fromJson: beansFromJson) List<Bean> get beans;
/// Create a copy of BeanGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeanGroupCopyWith<BeanGroup> get copyWith => _$BeanGroupCopyWithImpl<BeanGroup>(this as BeanGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BeanGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BeanGroup&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.beans, _this.beans));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BeanGroup;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.beans));
}

@override
String toString() {
  final _this = this as BeanGroup;
  return 'BeanGroup(id: ${_this.id}, name: ${_this.name}, beans: ${_this.beans})';
}


}

/// @nodoc
abstract mixin class $BeanGroupCopyWith<$Res>  {
  factory $BeanGroupCopyWith(BeanGroup value, $Res Function(BeanGroup) _then) = _$BeanGroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(fromJson: beansFromJson) List<Bean> beans
});




}
/// @nodoc
class _$BeanGroupCopyWithImpl<$Res>
    implements $BeanGroupCopyWith<$Res> {
  _$BeanGroupCopyWithImpl(this._self, this._then);

  final BeanGroup _self;
  final $Res Function(BeanGroup) _then;

/// Create a copy of BeanGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? beans = null,}) {
  return _then(BeanGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,beans: null == beans ? _self.beans : beans // ignore: cast_nullable_to_non_nullable
as List<Bean>,
  ));
}

}


/// Adds pattern-matching-related methods to [BeanGroup].
extension BeanGroupPatterns on BeanGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BeanGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BeanGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BeanGroup value)  $default,){
final _that = this;
switch (_that) {
case _BeanGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BeanGroup value)?  $default,){
final _that = this;
switch (_that) {
case _BeanGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(fromJson: beansFromJson)  List<Bean> beans)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BeanGroup() when $default != null:
return $default(_that.id,_that.name,_that.beans);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(fromJson: beansFromJson)  List<Bean> beans)  $default,) {final _that = this;
switch (_that) {
case _BeanGroup():
return $default(_that.id,_that.name,_that.beans);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(fromJson: beansFromJson)  List<Bean> beans)?  $default,) {final _that = this;
switch (_that) {
case _BeanGroup() when $default != null:
return $default(_that.id,_that.name,_that.beans);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _BeanGroup implements BeanGroup {
  const _BeanGroup({@JsonKey(fromJson: parseInt) required this.id, @JsonKey(fromJson: parseString) required this.name, @JsonKey(fromJson: beansFromJson)  List<Bean> beans = const <Bean>[]}): _beans = beans;
  factory _BeanGroup.fromJson(Map<String, dynamic> json) => _$BeanGroupFromJson(json);

@override@JsonKey(fromJson: parseInt) final  int id;
@override@JsonKey(fromJson: parseString) final  String name;
 final  List<Bean> _beans;
@override@JsonKey(fromJson: beansFromJson) List<Bean> get beans {
  if (_beans is EqualUnmodifiableListView) return _beans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_beans);
}


/// Create a copy of BeanGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeanGroupCopyWith<_BeanGroup> get copyWith => __$BeanGroupCopyWithImpl<_BeanGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BeanGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.beans, _beans));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_beans));
}

@override
String toString() {
    return 'BeanGroup(id: $id, name: $name, beans: $beans)';
}


}

/// @nodoc
abstract mixin class _$BeanGroupCopyWith<$Res> implements $BeanGroupCopyWith<$Res> {
  factory _$BeanGroupCopyWith(_BeanGroup value, $Res Function(_BeanGroup) _then) = __$BeanGroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(fromJson: beansFromJson) List<Bean> beans
});




}
/// @nodoc
class __$BeanGroupCopyWithImpl<$Res>
    implements _$BeanGroupCopyWith<$Res> {
  __$BeanGroupCopyWithImpl(this._self, this._then);

  final _BeanGroup _self;
  final $Res Function(_BeanGroup) _then;

/// Create a copy of BeanGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? beans = null,}) {
  return _then(_BeanGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,beans: null == beans ? _self._beans : beans // ignore: cast_nullable_to_non_nullable
as List<Bean>,
  ));
}


}

// dart format on
