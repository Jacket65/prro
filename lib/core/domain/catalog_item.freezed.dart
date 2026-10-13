// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Product {

 String get id; String get name;/// Quantity on the order line. Decimal because weight goods sell
/// fractionally (e.g. `0.250` kg). Stepped by [MeasureUnit.step]; minimum
/// is one step.
 Decimal get quantity;/// Backend ships the price as a decimal STRING ("45.50"); some legacy
/// paths still ship a number, so the factory accepts both. Kept as a
/// [Decimal]: a catalog price multiplied by a weight-goods quantity must
/// not round twice (once in the unit price, once in the line total)
/// before the cart is billed at kopecks.
 Decimal get price; String get imageUrl;/// Measure unit of the variant (id/name/step). `null` → piece (step 1).
 MeasureUnit? get unit;/// Options the cashier picked for this cart line (empty for catalog tiles).
 List<SelectedOption> get selectedOptions;/// Coffee bean picked for this line, if the drink supports bean selection.
 Bean? get selectedBean;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Product;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&const DeepCollectionEquality().equals(other.selectedOptions, _this.selectedOptions)&&(identical(other.selectedBean, _this.selectedBean) || other.selectedBean == _this.selectedBean));
}


@override
int get hashCode {
  final _this = this as Product;
  return Object.hash(runtimeType,_this.id,_this.name,_this.quantity,_this.price,_this.imageUrl,_this.unit,const DeepCollectionEquality().hash(_this.selectedOptions),_this.selectedBean);
}

@override
String toString() {
  final _this = this as Product;
  return 'Product(id: ${_this.id}, name: ${_this.name}, quantity: ${_this.quantity}, price: ${_this.price}, imageUrl: ${_this.imageUrl}, unit: ${_this.unit}, selectedOptions: ${_this.selectedOptions}, selectedBean: ${_this.selectedBean})';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, Decimal quantity, Decimal price, String imageUrl, MeasureUnit? unit, List<SelectedOption> selectedOptions, Bean? selectedBean
});


$MeasureUnitCopyWith<$Res>? get unit;$BeanCopyWith<$Res>? get selectedBean;

}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? quantity = null,Object? price = null,Object? imageUrl = null,Object? unit = freezed,Object? selectedOptions = null,Object? selectedBean = freezed,}) {
  return _then(Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Decimal,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Decimal,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as MeasureUnit?,selectedOptions: null == selectedOptions ? _self.selectedOptions : selectedOptions // ignore: cast_nullable_to_non_nullable
as List<SelectedOption>,selectedBean: freezed == selectedBean ? _self.selectedBean : selectedBean // ignore: cast_nullable_to_non_nullable
as Bean?,
  ));
}
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasureUnitCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $MeasureUnitCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BeanCopyWith<$Res>? get selectedBean {
    if (_self.selectedBean == null) {
    return null;
  }

  return $BeanCopyWith<$Res>(_self.selectedBean!, (value) {
    return _then(_self.copyWith(selectedBean: value));
  });
}
}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  Decimal quantity,  Decimal price,  String imageUrl,  MeasureUnit? unit,  List<SelectedOption> selectedOptions,  Bean? selectedBean)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.quantity,_that.price,_that.imageUrl,_that.unit,_that.selectedOptions,_that.selectedBean);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  Decimal quantity,  Decimal price,  String imageUrl,  MeasureUnit? unit,  List<SelectedOption> selectedOptions,  Bean? selectedBean)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.quantity,_that.price,_that.imageUrl,_that.unit,_that.selectedOptions,_that.selectedBean);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  Decimal quantity,  Decimal price,  String imageUrl,  MeasureUnit? unit,  List<SelectedOption> selectedOptions,  Bean? selectedBean)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.quantity,_that.price,_that.imageUrl,_that.unit,_that.selectedOptions,_that.selectedBean);case _:
  return null;

}
}

}

/// @nodoc


class _Product extends Product {
  const _Product({required this.id, required this.name, required this.quantity, required this.price, required this.imageUrl, this.unit,  List<SelectedOption> selectedOptions = const <SelectedOption>[], this.selectedBean}): _selectedOptions = selectedOptions,super._();
  

@override final  String id;
@override final  String name;
/// Quantity on the order line. Decimal because weight goods sell
/// fractionally (e.g. `0.250` kg). Stepped by [MeasureUnit.step]; minimum
/// is one step.
@override final  Decimal quantity;
/// Backend ships the price as a decimal STRING ("45.50"); some legacy
/// paths still ship a number, so the factory accepts both. Kept as a
/// [Decimal]: a catalog price multiplied by a weight-goods quantity must
/// not round twice (once in the unit price, once in the line total)
/// before the cart is billed at kopecks.
@override final  Decimal price;
@override final  String imageUrl;
/// Measure unit of the variant (id/name/step). `null` → piece (step 1).
@override final  MeasureUnit? unit;
/// Options the cashier picked for this cart line (empty for catalog tiles).
 final  List<SelectedOption> _selectedOptions;
/// Options the cashier picked for this cart line (empty for catalog tiles).
@override@JsonKey() List<SelectedOption> get selectedOptions {
  if (_selectedOptions is EqualUnmodifiableListView) return _selectedOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedOptions);
}

/// Coffee bean picked for this line, if the drink supports bean selection.
@override final  Bean? selectedBean;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.unit, unit) || other.unit == unit)&&const DeepCollectionEquality().equals(other.selectedOptions, _selectedOptions)&&(identical(other.selectedBean, selectedBean) || other.selectedBean == selectedBean));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,quantity,price,imageUrl,unit,const DeepCollectionEquality().hash(_selectedOptions),selectedBean);
}

@override
String toString() {
    return 'Product(id: $id, name: $name, quantity: $quantity, price: $price, imageUrl: $imageUrl, unit: $unit, selectedOptions: $selectedOptions, selectedBean: $selectedBean)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, Decimal quantity, Decimal price, String imageUrl, MeasureUnit? unit, List<SelectedOption> selectedOptions, Bean? selectedBean
});


@override $MeasureUnitCopyWith<$Res>? get unit;@override $BeanCopyWith<$Res>? get selectedBean;

}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? quantity = null,Object? price = null,Object? imageUrl = null,Object? unit = freezed,Object? selectedOptions = null,Object? selectedBean = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Decimal,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Decimal,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as MeasureUnit?,selectedOptions: null == selectedOptions ? _self._selectedOptions : selectedOptions // ignore: cast_nullable_to_non_nullable
as List<SelectedOption>,selectedBean: freezed == selectedBean ? _self.selectedBean : selectedBean // ignore: cast_nullable_to_non_nullable
as Bean?,
  ));
}

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasureUnitCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $MeasureUnitCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BeanCopyWith<$Res>? get selectedBean {
    if (_self.selectedBean == null) {
    return null;
  }

  return $BeanCopyWith<$Res>(_self.selectedBean!, (value) {
    return _then(_self.copyWith(selectedBean: value));
  });
}
}

/// @nodoc
mixin _$ProductGroup {

 int get id; String get name; List<Product> get variants;
/// Create a copy of ProductGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductGroupCopyWith<ProductGroup> get copyWith => _$ProductGroupCopyWithImpl<ProductGroup>(this as ProductGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductGroup&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.variants, _this.variants));
}


@override
int get hashCode {
  final _this = this as ProductGroup;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.variants));
}

@override
String toString() {
  final _this = this as ProductGroup;
  return 'ProductGroup(id: ${_this.id}, name: ${_this.name}, variants: ${_this.variants})';
}


}

/// @nodoc
abstract mixin class $ProductGroupCopyWith<$Res>  {
  factory $ProductGroupCopyWith(ProductGroup value, $Res Function(ProductGroup) _then) = _$ProductGroupCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<Product> variants
});




}
/// @nodoc
class _$ProductGroupCopyWithImpl<$Res>
    implements $ProductGroupCopyWith<$Res> {
  _$ProductGroupCopyWithImpl(this._self, this._then);

  final ProductGroup _self;
  final $Res Function(ProductGroup) _then;

/// Create a copy of ProductGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? variants = null,}) {
  return _then(ProductGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,variants: null == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductGroup].
extension ProductGroupPatterns on ProductGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductGroup value)  $default,){
final _that = this;
switch (_that) {
case _ProductGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductGroup value)?  $default,){
final _that = this;
switch (_that) {
case _ProductGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<Product> variants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductGroup() when $default != null:
return $default(_that.id,_that.name,_that.variants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<Product> variants)  $default,) {final _that = this;
switch (_that) {
case _ProductGroup():
return $default(_that.id,_that.name,_that.variants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<Product> variants)?  $default,) {final _that = this;
switch (_that) {
case _ProductGroup() when $default != null:
return $default(_that.id,_that.name,_that.variants);case _:
  return null;

}
}

}

/// @nodoc


class _ProductGroup extends ProductGroup {
  const _ProductGroup({required this.id, required this.name,  List<Product> variants = const <Product>[]}): _variants = variants,super._();
  

@override final  int id;
@override final  String name;
 final  List<Product> _variants;
@override@JsonKey() List<Product> get variants {
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variants);
}


/// Create a copy of ProductGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductGroupCopyWith<_ProductGroup> get copyWith => __$ProductGroupCopyWithImpl<_ProductGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.variants, _variants));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_variants));
}

@override
String toString() {
    return 'ProductGroup(id: $id, name: $name, variants: $variants)';
}


}

/// @nodoc
abstract mixin class _$ProductGroupCopyWith<$Res> implements $ProductGroupCopyWith<$Res> {
  factory _$ProductGroupCopyWith(_ProductGroup value, $Res Function(_ProductGroup) _then) = __$ProductGroupCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<Product> variants
});




}
/// @nodoc
class __$ProductGroupCopyWithImpl<$Res>
    implements _$ProductGroupCopyWith<$Res> {
  __$ProductGroupCopyWithImpl(this._self, this._then);

  final _ProductGroup _self;
  final $Res Function(_ProductGroup) _then;

/// Create a copy of ProductGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? variants = null,}) {
  return _then(_ProductGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,variants: null == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}


}

/// @nodoc
mixin _$Category {

 int get id; String get name; List<Item> get items;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Category;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as Category;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as Category;
  return 'Category(id: ${_this.id}, name: ${_this.name}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<Item> items
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? items = null,}) {
  return _then(Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}

}


/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Category value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Category() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Category value)  $default,){
final _that = this;
switch (_that) {
case _Category():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Category value)?  $default,){
final _that = this;
switch (_that) {
case _Category() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<Item> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<Item> items)  $default,) {final _that = this;
switch (_that) {
case _Category():
return $default(_that.id,_that.name,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<Item> items)?  $default,) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _Category extends Category {
  const _Category({required this.id, required this.name,  List<Item> items = const <Item>[]}): _items = items,super._();
  

@override final  int id;
@override final  String name;
 final  List<Item> _items;
@override@JsonKey() List<Item> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCopyWith<_Category> get copyWith => __$CategoryCopyWithImpl<_Category>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Category&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'Category(id: $id, name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) = __$CategoryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<Item> items
});




}
/// @nodoc
class __$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? items = null,}) {
  return _then(_Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

// dart format on
