// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminCategory {

@JsonKey(fromJson: parseInt) int get id;@JsonKey(fromJson: parseString) String get name;
/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminCategoryCopyWith<AdminCategory> get copyWith => _$AdminCategoryCopyWithImpl<AdminCategory>(this as AdminCategory, _$identity);

  /// Serializes this AdminCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'AdminCategory(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $AdminCategoryCopyWith<$Res>  {
  factory $AdminCategoryCopyWith(AdminCategory value, $Res Function(AdminCategory) _then) = _$AdminCategoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name
});




}
/// @nodoc
class _$AdminCategoryCopyWithImpl<$Res>
    implements $AdminCategoryCopyWith<$Res> {
  _$AdminCategoryCopyWithImpl(this._self, this._then);

  final AdminCategory _self;
  final $Res Function(AdminCategory) _then;

/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminCategory].
extension AdminCategoryPatterns on AdminCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminCategory value)  $default,){
final _that = this;
switch (_that) {
case _AdminCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminCategory value)?  $default,){
final _that = this;
switch (_that) {
case _AdminCategory() when $default != null:
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
case _AdminCategory() when $default != null:
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
case _AdminCategory():
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
case _AdminCategory() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminCategory implements AdminCategory {
  const _AdminCategory({@JsonKey(fromJson: parseInt) required this.id, @JsonKey(fromJson: parseString) required this.name});
  factory _AdminCategory.fromJson(Map<String, dynamic> json) => _$AdminCategoryFromJson(json);

@override@JsonKey(fromJson: parseInt) final  int id;
@override@JsonKey(fromJson: parseString) final  String name;

/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminCategoryCopyWith<_AdminCategory> get copyWith => __$AdminCategoryCopyWithImpl<_AdminCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'AdminCategory(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$AdminCategoryCopyWith<$Res> implements $AdminCategoryCopyWith<$Res> {
  factory _$AdminCategoryCopyWith(_AdminCategory value, $Res Function(_AdminCategory) _then) = __$AdminCategoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name
});




}
/// @nodoc
class __$AdminCategoryCopyWithImpl<$Res>
    implements _$AdminCategoryCopyWith<$Res> {
  __$AdminCategoryCopyWithImpl(this._self, this._then);

  final _AdminCategory _self;
  final $Res Function(_AdminCategory) _then;

/// Create a copy of AdminCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_AdminCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AdminProduct {

@JsonKey(fromJson: parseInt) int get id;@JsonKey(fromJson: parseString) String get name;@JsonKey(name: 'category_id', fromJson: _nullableIntFromJson) int? get categoryId;
/// Create a copy of AdminProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProductCopyWith<AdminProduct> get copyWith => _$AdminProductCopyWithImpl<AdminProduct>(this as AdminProduct, _$identity);

  /// Serializes this AdminProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId);

@override
String toString() {
  return 'AdminProduct(id: $id, name: $name, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $AdminProductCopyWith<$Res>  {
  factory $AdminProductCopyWith(AdminProduct value, $Res Function(AdminProduct) _then) = _$AdminProductCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'category_id', fromJson: _nullableIntFromJson) int? categoryId
});




}
/// @nodoc
class _$AdminProductCopyWithImpl<$Res>
    implements $AdminProductCopyWith<$Res> {
  _$AdminProductCopyWithImpl(this._self, this._then);

  final AdminProduct _self;
  final $Res Function(AdminProduct) _then;

/// Create a copy of AdminProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? categoryId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProduct].
extension AdminProductPatterns on AdminProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProduct value)  $default,){
final _that = this;
switch (_that) {
case _AdminProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProduct value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'category_id', fromJson: _nullableIntFromJson)  int? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProduct() when $default != null:
return $default(_that.id,_that.name,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'category_id', fromJson: _nullableIntFromJson)  int? categoryId)  $default,) {final _that = this;
switch (_that) {
case _AdminProduct():
return $default(_that.id,_that.name,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'category_id', fromJson: _nullableIntFromJson)  int? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _AdminProduct() when $default != null:
return $default(_that.id,_that.name,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminProduct implements AdminProduct {
  const _AdminProduct({@JsonKey(fromJson: parseInt) required this.id, @JsonKey(fromJson: parseString) required this.name, @JsonKey(name: 'category_id', fromJson: _nullableIntFromJson) this.categoryId});
  factory _AdminProduct.fromJson(Map<String, dynamic> json) => _$AdminProductFromJson(json);

@override@JsonKey(fromJson: parseInt) final  int id;
@override@JsonKey(fromJson: parseString) final  String name;
@override@JsonKey(name: 'category_id', fromJson: _nullableIntFromJson) final  int? categoryId;

/// Create a copy of AdminProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProductCopyWith<_AdminProduct> get copyWith => __$AdminProductCopyWithImpl<_AdminProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId);

@override
String toString() {
  return 'AdminProduct(id: $id, name: $name, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$AdminProductCopyWith<$Res> implements $AdminProductCopyWith<$Res> {
  factory _$AdminProductCopyWith(_AdminProduct value, $Res Function(_AdminProduct) _then) = __$AdminProductCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'category_id', fromJson: _nullableIntFromJson) int? categoryId
});




}
/// @nodoc
class __$AdminProductCopyWithImpl<$Res>
    implements _$AdminProductCopyWith<$Res> {
  __$AdminProductCopyWithImpl(this._self, this._then);

  final _AdminProduct _self;
  final $Res Function(_AdminProduct) _then;

/// Create a copy of AdminProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? categoryId = freezed,}) {
  return _then(_AdminProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AdminVariant {

@JsonKey(fromJson: parseInt) int get id;@JsonKey(fromJson: parseString) String get name;@JsonKey(name: 'price', fromJson: _priceToKopecks) int get priceKopecks;@JsonKey(name: 'product_id', fromJson: _nullableIntFromJson) int? get productId;
/// Create a copy of AdminVariant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminVariantCopyWith<AdminVariant> get copyWith => _$AdminVariantCopyWithImpl<AdminVariant>(this as AdminVariant, _$identity);

  /// Serializes this AdminVariant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminVariant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceKopecks, priceKopecks) || other.priceKopecks == priceKopecks)&&(identical(other.productId, productId) || other.productId == productId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,priceKopecks,productId);

@override
String toString() {
  return 'AdminVariant(id: $id, name: $name, priceKopecks: $priceKopecks, productId: $productId)';
}


}

/// @nodoc
abstract mixin class $AdminVariantCopyWith<$Res>  {
  factory $AdminVariantCopyWith(AdminVariant value, $Res Function(AdminVariant) _then) = _$AdminVariantCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'price', fromJson: _priceToKopecks) int priceKopecks,@JsonKey(name: 'product_id', fromJson: _nullableIntFromJson) int? productId
});




}
/// @nodoc
class _$AdminVariantCopyWithImpl<$Res>
    implements $AdminVariantCopyWith<$Res> {
  _$AdminVariantCopyWithImpl(this._self, this._then);

  final AdminVariant _self;
  final $Res Function(AdminVariant) _then;

/// Create a copy of AdminVariant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? priceKopecks = null,Object? productId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceKopecks: null == priceKopecks ? _self.priceKopecks : priceKopecks // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminVariant].
extension AdminVariantPatterns on AdminVariant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminVariant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminVariant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminVariant value)  $default,){
final _that = this;
switch (_that) {
case _AdminVariant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminVariant value)?  $default,){
final _that = this;
switch (_that) {
case _AdminVariant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'price', fromJson: _priceToKopecks)  int priceKopecks, @JsonKey(name: 'product_id', fromJson: _nullableIntFromJson)  int? productId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminVariant() when $default != null:
return $default(_that.id,_that.name,_that.priceKopecks,_that.productId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'price', fromJson: _priceToKopecks)  int priceKopecks, @JsonKey(name: 'product_id', fromJson: _nullableIntFromJson)  int? productId)  $default,) {final _that = this;
switch (_that) {
case _AdminVariant():
return $default(_that.id,_that.name,_that.priceKopecks,_that.productId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'price', fromJson: _priceToKopecks)  int priceKopecks, @JsonKey(name: 'product_id', fromJson: _nullableIntFromJson)  int? productId)?  $default,) {final _that = this;
switch (_that) {
case _AdminVariant() when $default != null:
return $default(_that.id,_that.name,_that.priceKopecks,_that.productId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminVariant implements AdminVariant {
  const _AdminVariant({@JsonKey(fromJson: parseInt) required this.id, @JsonKey(fromJson: parseString) required this.name, @JsonKey(name: 'price', fromJson: _priceToKopecks) required this.priceKopecks, @JsonKey(name: 'product_id', fromJson: _nullableIntFromJson) this.productId});
  factory _AdminVariant.fromJson(Map<String, dynamic> json) => _$AdminVariantFromJson(json);

@override@JsonKey(fromJson: parseInt) final  int id;
@override@JsonKey(fromJson: parseString) final  String name;
@override@JsonKey(name: 'price', fromJson: _priceToKopecks) final  int priceKopecks;
@override@JsonKey(name: 'product_id', fromJson: _nullableIntFromJson) final  int? productId;

/// Create a copy of AdminVariant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminVariantCopyWith<_AdminVariant> get copyWith => __$AdminVariantCopyWithImpl<_AdminVariant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminVariantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminVariant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceKopecks, priceKopecks) || other.priceKopecks == priceKopecks)&&(identical(other.productId, productId) || other.productId == productId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,priceKopecks,productId);

@override
String toString() {
  return 'AdminVariant(id: $id, name: $name, priceKopecks: $priceKopecks, productId: $productId)';
}


}

/// @nodoc
abstract mixin class _$AdminVariantCopyWith<$Res> implements $AdminVariantCopyWith<$Res> {
  factory _$AdminVariantCopyWith(_AdminVariant value, $Res Function(_AdminVariant) _then) = __$AdminVariantCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'price', fromJson: _priceToKopecks) int priceKopecks,@JsonKey(name: 'product_id', fromJson: _nullableIntFromJson) int? productId
});




}
/// @nodoc
class __$AdminVariantCopyWithImpl<$Res>
    implements _$AdminVariantCopyWith<$Res> {
  __$AdminVariantCopyWithImpl(this._self, this._then);

  final _AdminVariant _self;
  final $Res Function(_AdminVariant) _then;

/// Create a copy of AdminVariant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? priceKopecks = null,Object? productId = freezed,}) {
  return _then(_AdminVariant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceKopecks: null == priceKopecks ? _self.priceKopecks : priceKopecks // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$RecipeIngredient {

@JsonKey(name: 'ingredient_id', fromJson: parseInt) int get ingredientId;@JsonKey(fromJson: parseString) String get name;@JsonKey(fromJson: parseDouble) double get quantity;
/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeIngredientCopyWith<RecipeIngredient> get copyWith => _$RecipeIngredientCopyWithImpl<RecipeIngredient>(this as RecipeIngredient, _$identity);

  /// Serializes this RecipeIngredient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeIngredient&&(identical(other.ingredientId, ingredientId) || other.ingredientId == ingredientId)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ingredientId,name,quantity);

@override
String toString() {
  return 'RecipeIngredient(ingredientId: $ingredientId, name: $name, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $RecipeIngredientCopyWith<$Res>  {
  factory $RecipeIngredientCopyWith(RecipeIngredient value, $Res Function(RecipeIngredient) _then) = _$RecipeIngredientCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ingredient_id', fromJson: parseInt) int ingredientId,@JsonKey(fromJson: parseString) String name,@JsonKey(fromJson: parseDouble) double quantity
});




}
/// @nodoc
class _$RecipeIngredientCopyWithImpl<$Res>
    implements $RecipeIngredientCopyWith<$Res> {
  _$RecipeIngredientCopyWithImpl(this._self, this._then);

  final RecipeIngredient _self;
  final $Res Function(RecipeIngredient) _then;

/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ingredientId = null,Object? name = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
ingredientId: null == ingredientId ? _self.ingredientId : ingredientId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeIngredient].
extension RecipeIngredientPatterns on RecipeIngredient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeIngredient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeIngredient value)  $default,){
final _that = this;
switch (_that) {
case _RecipeIngredient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeIngredient value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ingredient_id', fromJson: parseInt)  int ingredientId, @JsonKey(fromJson: parseString)  String name, @JsonKey(fromJson: parseDouble)  double quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
return $default(_that.ingredientId,_that.name,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ingredient_id', fromJson: parseInt)  int ingredientId, @JsonKey(fromJson: parseString)  String name, @JsonKey(fromJson: parseDouble)  double quantity)  $default,) {final _that = this;
switch (_that) {
case _RecipeIngredient():
return $default(_that.ingredientId,_that.name,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ingredient_id', fromJson: parseInt)  int ingredientId, @JsonKey(fromJson: parseString)  String name, @JsonKey(fromJson: parseDouble)  double quantity)?  $default,) {final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
return $default(_that.ingredientId,_that.name,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeIngredient implements RecipeIngredient {
  const _RecipeIngredient({@JsonKey(name: 'ingredient_id', fromJson: parseInt) required this.ingredientId, @JsonKey(fromJson: parseString) required this.name, @JsonKey(fromJson: parseDouble) required this.quantity});
  factory _RecipeIngredient.fromJson(Map<String, dynamic> json) => _$RecipeIngredientFromJson(json);

@override@JsonKey(name: 'ingredient_id', fromJson: parseInt) final  int ingredientId;
@override@JsonKey(fromJson: parseString) final  String name;
@override@JsonKey(fromJson: parseDouble) final  double quantity;

/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeIngredientCopyWith<_RecipeIngredient> get copyWith => __$RecipeIngredientCopyWithImpl<_RecipeIngredient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeIngredientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeIngredient&&(identical(other.ingredientId, ingredientId) || other.ingredientId == ingredientId)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ingredientId,name,quantity);

@override
String toString() {
  return 'RecipeIngredient(ingredientId: $ingredientId, name: $name, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$RecipeIngredientCopyWith<$Res> implements $RecipeIngredientCopyWith<$Res> {
  factory _$RecipeIngredientCopyWith(_RecipeIngredient value, $Res Function(_RecipeIngredient) _then) = __$RecipeIngredientCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ingredient_id', fromJson: parseInt) int ingredientId,@JsonKey(fromJson: parseString) String name,@JsonKey(fromJson: parseDouble) double quantity
});




}
/// @nodoc
class __$RecipeIngredientCopyWithImpl<$Res>
    implements _$RecipeIngredientCopyWith<$Res> {
  __$RecipeIngredientCopyWithImpl(this._self, this._then);

  final _RecipeIngredient _self;
  final $Res Function(_RecipeIngredient) _then;

/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ingredientId = null,Object? name = null,Object? quantity = null,}) {
  return _then(_RecipeIngredient(
ingredientId: null == ingredientId ? _self.ingredientId : ingredientId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$AdminIngredient {

@JsonKey(fromJson: parseInt) int get id;@JsonKey(fromJson: parseString) String get name;@JsonKey(name: 'unit_id', fromJson: _nullableIntFromJson) int? get unitId;
/// Create a copy of AdminIngredient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminIngredientCopyWith<AdminIngredient> get copyWith => _$AdminIngredientCopyWithImpl<AdminIngredient>(this as AdminIngredient, _$identity);

  /// Serializes this AdminIngredient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminIngredient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unitId, unitId) || other.unitId == unitId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,unitId);

@override
String toString() {
  return 'AdminIngredient(id: $id, name: $name, unitId: $unitId)';
}


}

/// @nodoc
abstract mixin class $AdminIngredientCopyWith<$Res>  {
  factory $AdminIngredientCopyWith(AdminIngredient value, $Res Function(AdminIngredient) _then) = _$AdminIngredientCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'unit_id', fromJson: _nullableIntFromJson) int? unitId
});




}
/// @nodoc
class _$AdminIngredientCopyWithImpl<$Res>
    implements $AdminIngredientCopyWith<$Res> {
  _$AdminIngredientCopyWithImpl(this._self, this._then);

  final AdminIngredient _self;
  final $Res Function(AdminIngredient) _then;

/// Create a copy of AdminIngredient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? unitId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminIngredient].
extension AdminIngredientPatterns on AdminIngredient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminIngredient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminIngredient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminIngredient value)  $default,){
final _that = this;
switch (_that) {
case _AdminIngredient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminIngredient value)?  $default,){
final _that = this;
switch (_that) {
case _AdminIngredient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'unit_id', fromJson: _nullableIntFromJson)  int? unitId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminIngredient() when $default != null:
return $default(_that.id,_that.name,_that.unitId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'unit_id', fromJson: _nullableIntFromJson)  int? unitId)  $default,) {final _that = this;
switch (_that) {
case _AdminIngredient():
return $default(_that.id,_that.name,_that.unitId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'unit_id', fromJson: _nullableIntFromJson)  int? unitId)?  $default,) {final _that = this;
switch (_that) {
case _AdminIngredient() when $default != null:
return $default(_that.id,_that.name,_that.unitId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminIngredient implements AdminIngredient {
  const _AdminIngredient({@JsonKey(fromJson: parseInt) required this.id, @JsonKey(fromJson: parseString) required this.name, @JsonKey(name: 'unit_id', fromJson: _nullableIntFromJson) this.unitId});
  factory _AdminIngredient.fromJson(Map<String, dynamic> json) => _$AdminIngredientFromJson(json);

@override@JsonKey(fromJson: parseInt) final  int id;
@override@JsonKey(fromJson: parseString) final  String name;
@override@JsonKey(name: 'unit_id', fromJson: _nullableIntFromJson) final  int? unitId;

/// Create a copy of AdminIngredient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminIngredientCopyWith<_AdminIngredient> get copyWith => __$AdminIngredientCopyWithImpl<_AdminIngredient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminIngredientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminIngredient&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unitId, unitId) || other.unitId == unitId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,unitId);

@override
String toString() {
  return 'AdminIngredient(id: $id, name: $name, unitId: $unitId)';
}


}

/// @nodoc
abstract mixin class _$AdminIngredientCopyWith<$Res> implements $AdminIngredientCopyWith<$Res> {
  factory _$AdminIngredientCopyWith(_AdminIngredient value, $Res Function(_AdminIngredient) _then) = __$AdminIngredientCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'unit_id', fromJson: _nullableIntFromJson) int? unitId
});




}
/// @nodoc
class __$AdminIngredientCopyWithImpl<$Res>
    implements _$AdminIngredientCopyWith<$Res> {
  __$AdminIngredientCopyWithImpl(this._self, this._then);

  final _AdminIngredient _self;
  final $Res Function(_AdminIngredient) _then;

/// Create a copy of AdminIngredient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? unitId = freezed,}) {
  return _then(_AdminIngredient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitId: freezed == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
