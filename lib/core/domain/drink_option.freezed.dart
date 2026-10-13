// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OptionGroup {

@JsonKey(readValue: groupIdValue, fromJson: parseInt) int get id;@JsonKey(fromJson: parseString) String get name;@JsonKey(name: 'selection_type', fromJson: OptionSelectionType.fromJson) OptionSelectionType get selectionType;@JsonKey(name: 'is_required', fromJson: boolOrFalse) bool get isRequired;@JsonKey(fromJson: drinkOptionsFromJson) List<DrinkOption> get options;
/// Create a copy of OptionGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionGroupCopyWith<OptionGroup> get copyWith => _$OptionGroupCopyWithImpl<OptionGroup>(this as OptionGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OptionGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptionGroup&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.selectionType, _this.selectionType) || other.selectionType == _this.selectionType)&&(identical(other.isRequired, _this.isRequired) || other.isRequired == _this.isRequired)&&const DeepCollectionEquality().equals(other.options, _this.options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OptionGroup;
  return Object.hash(runtimeType,_this.id,_this.name,_this.selectionType,_this.isRequired,const DeepCollectionEquality().hash(_this.options));
}

@override
String toString() {
  final _this = this as OptionGroup;
  return 'OptionGroup(id: ${_this.id}, name: ${_this.name}, selectionType: ${_this.selectionType}, isRequired: ${_this.isRequired}, options: ${_this.options})';
}


}

/// @nodoc
abstract mixin class $OptionGroupCopyWith<$Res>  {
  factory $OptionGroupCopyWith(OptionGroup value, $Res Function(OptionGroup) _then) = _$OptionGroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: groupIdValue, fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'selection_type', fromJson: OptionSelectionType.fromJson) OptionSelectionType selectionType,@JsonKey(name: 'is_required', fromJson: boolOrFalse) bool isRequired,@JsonKey(fromJson: drinkOptionsFromJson) List<DrinkOption> options
});




}
/// @nodoc
class _$OptionGroupCopyWithImpl<$Res>
    implements $OptionGroupCopyWith<$Res> {
  _$OptionGroupCopyWithImpl(this._self, this._then);

  final OptionGroup _self;
  final $Res Function(OptionGroup) _then;

/// Create a copy of OptionGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? selectionType = null,Object? isRequired = null,Object? options = null,}) {
  return _then(OptionGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,selectionType: null == selectionType ? _self.selectionType : selectionType // ignore: cast_nullable_to_non_nullable
as OptionSelectionType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<DrinkOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [OptionGroup].
extension OptionGroupPatterns on OptionGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OptionGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OptionGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OptionGroup value)  $default,){
final _that = this;
switch (_that) {
case _OptionGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OptionGroup value)?  $default,){
final _that = this;
switch (_that) {
case _OptionGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: groupIdValue, fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'selection_type', fromJson: OptionSelectionType.fromJson)  OptionSelectionType selectionType, @JsonKey(name: 'is_required', fromJson: boolOrFalse)  bool isRequired, @JsonKey(fromJson: drinkOptionsFromJson)  List<DrinkOption> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OptionGroup() when $default != null:
return $default(_that.id,_that.name,_that.selectionType,_that.isRequired,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: groupIdValue, fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'selection_type', fromJson: OptionSelectionType.fromJson)  OptionSelectionType selectionType, @JsonKey(name: 'is_required', fromJson: boolOrFalse)  bool isRequired, @JsonKey(fromJson: drinkOptionsFromJson)  List<DrinkOption> options)  $default,) {final _that = this;
switch (_that) {
case _OptionGroup():
return $default(_that.id,_that.name,_that.selectionType,_that.isRequired,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: groupIdValue, fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'selection_type', fromJson: OptionSelectionType.fromJson)  OptionSelectionType selectionType, @JsonKey(name: 'is_required', fromJson: boolOrFalse)  bool isRequired, @JsonKey(fromJson: drinkOptionsFromJson)  List<DrinkOption> options)?  $default,) {final _that = this;
switch (_that) {
case _OptionGroup() when $default != null:
return $default(_that.id,_that.name,_that.selectionType,_that.isRequired,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _OptionGroup implements OptionGroup {
  const _OptionGroup({@JsonKey(readValue: groupIdValue, fromJson: parseInt) required this.id, @JsonKey(fromJson: parseString) required this.name, @JsonKey(name: 'selection_type', fromJson: OptionSelectionType.fromJson) required this.selectionType, @JsonKey(name: 'is_required', fromJson: boolOrFalse) this.isRequired = false, @JsonKey(fromJson: drinkOptionsFromJson)  List<DrinkOption> options = const <DrinkOption>[]}): _options = options;
  factory _OptionGroup.fromJson(Map<String, dynamic> json) => _$OptionGroupFromJson(json);

@override@JsonKey(readValue: groupIdValue, fromJson: parseInt) final  int id;
@override@JsonKey(fromJson: parseString) final  String name;
@override@JsonKey(name: 'selection_type', fromJson: OptionSelectionType.fromJson) final  OptionSelectionType selectionType;
@override@JsonKey(name: 'is_required', fromJson: boolOrFalse) final  bool isRequired;
 final  List<DrinkOption> _options;
@override@JsonKey(fromJson: drinkOptionsFromJson) List<DrinkOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of OptionGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptionGroupCopyWith<_OptionGroup> get copyWith => __$OptionGroupCopyWithImpl<_OptionGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptionGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.selectionType, selectionType) || other.selectionType == selectionType)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other.options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,selectionType,isRequired,const DeepCollectionEquality().hash(_options));
}

@override
String toString() {
    return 'OptionGroup(id: $id, name: $name, selectionType: $selectionType, isRequired: $isRequired, options: $options)';
}


}

/// @nodoc
abstract mixin class _$OptionGroupCopyWith<$Res> implements $OptionGroupCopyWith<$Res> {
  factory _$OptionGroupCopyWith(_OptionGroup value, $Res Function(_OptionGroup) _then) = __$OptionGroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: groupIdValue, fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'selection_type', fromJson: OptionSelectionType.fromJson) OptionSelectionType selectionType,@JsonKey(name: 'is_required', fromJson: boolOrFalse) bool isRequired,@JsonKey(fromJson: drinkOptionsFromJson) List<DrinkOption> options
});




}
/// @nodoc
class __$OptionGroupCopyWithImpl<$Res>
    implements _$OptionGroupCopyWith<$Res> {
  __$OptionGroupCopyWithImpl(this._self, this._then);

  final _OptionGroup _self;
  final $Res Function(_OptionGroup) _then;

/// Create a copy of OptionGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? selectionType = null,Object? isRequired = null,Object? options = null,}) {
  return _then(_OptionGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,selectionType: null == selectionType ? _self.selectionType : selectionType // ignore: cast_nullable_to_non_nullable
as OptionSelectionType,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<DrinkOption>,
  ));
}


}


/// @nodoc
mixin _$DrinkOption {

@JsonKey(readValue: optionIdValue, fromJson: parseInt) int get id;@JsonKey(fromJson: parseString) String get name;@JsonKey(name: 'price_delta', fromJson: parseDecimal) Decimal get priceDelta;/// Whether this option is preselected by default (the value the cashier
/// gets without touching the group).
@JsonKey(name: 'is_default', fromJson: boolOrFalse) bool get isDefault;
/// Create a copy of DrinkOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrinkOptionCopyWith<DrinkOption> get copyWith => _$DrinkOptionCopyWithImpl<DrinkOption>(this as DrinkOption, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DrinkOption;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrinkOption&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.priceDelta, _this.priceDelta) || other.priceDelta == _this.priceDelta)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DrinkOption;
  return Object.hash(runtimeType,_this.id,_this.name,_this.priceDelta,_this.isDefault);
}

@override
String toString() {
  final _this = this as DrinkOption;
  return 'DrinkOption(id: ${_this.id}, name: ${_this.name}, priceDelta: ${_this.priceDelta}, isDefault: ${_this.isDefault})';
}


}

/// @nodoc
abstract mixin class $DrinkOptionCopyWith<$Res>  {
  factory $DrinkOptionCopyWith(DrinkOption value, $Res Function(DrinkOption) _then) = _$DrinkOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: optionIdValue, fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'price_delta', fromJson: parseDecimal) Decimal priceDelta,@JsonKey(name: 'is_default', fromJson: boolOrFalse) bool isDefault
});




}
/// @nodoc
class _$DrinkOptionCopyWithImpl<$Res>
    implements $DrinkOptionCopyWith<$Res> {
  _$DrinkOptionCopyWithImpl(this._self, this._then);

  final DrinkOption _self;
  final $Res Function(DrinkOption) _then;

/// Create a copy of DrinkOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? priceDelta = null,Object? isDefault = null,}) {
  return _then(DrinkOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceDelta: null == priceDelta ? _self.priceDelta : priceDelta // ignore: cast_nullable_to_non_nullable
as Decimal,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DrinkOption].
extension DrinkOptionPatterns on DrinkOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrinkOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrinkOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrinkOption value)  $default,){
final _that = this;
switch (_that) {
case _DrinkOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrinkOption value)?  $default,){
final _that = this;
switch (_that) {
case _DrinkOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: optionIdValue, fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'price_delta', fromJson: parseDecimal)  Decimal priceDelta, @JsonKey(name: 'is_default', fromJson: boolOrFalse)  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrinkOption() when $default != null:
return $default(_that.id,_that.name,_that.priceDelta,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: optionIdValue, fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'price_delta', fromJson: parseDecimal)  Decimal priceDelta, @JsonKey(name: 'is_default', fromJson: boolOrFalse)  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _DrinkOption():
return $default(_that.id,_that.name,_that.priceDelta,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: optionIdValue, fromJson: parseInt)  int id, @JsonKey(fromJson: parseString)  String name, @JsonKey(name: 'price_delta', fromJson: parseDecimal)  Decimal priceDelta, @JsonKey(name: 'is_default', fromJson: boolOrFalse)  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _DrinkOption() when $default != null:
return $default(_that.id,_that.name,_that.priceDelta,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _DrinkOption implements DrinkOption {
  const _DrinkOption({@JsonKey(readValue: optionIdValue, fromJson: parseInt) required this.id, @JsonKey(fromJson: parseString) required this.name, @JsonKey(name: 'price_delta', fromJson: parseDecimal) required this.priceDelta, @JsonKey(name: 'is_default', fromJson: boolOrFalse) this.isDefault = false});
  factory _DrinkOption.fromJson(Map<String, dynamic> json) => _$DrinkOptionFromJson(json);

@override@JsonKey(readValue: optionIdValue, fromJson: parseInt) final  int id;
@override@JsonKey(fromJson: parseString) final  String name;
@override@JsonKey(name: 'price_delta', fromJson: parseDecimal) final  Decimal priceDelta;
/// Whether this option is preselected by default (the value the cashier
/// gets without touching the group).
@override@JsonKey(name: 'is_default', fromJson: boolOrFalse) final  bool isDefault;

/// Create a copy of DrinkOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrinkOptionCopyWith<_DrinkOption> get copyWith => __$DrinkOptionCopyWithImpl<_DrinkOption>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrinkOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceDelta, priceDelta) || other.priceDelta == priceDelta)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,priceDelta,isDefault);
}

@override
String toString() {
    return 'DrinkOption(id: $id, name: $name, priceDelta: $priceDelta, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$DrinkOptionCopyWith<$Res> implements $DrinkOptionCopyWith<$Res> {
  factory _$DrinkOptionCopyWith(_DrinkOption value, $Res Function(_DrinkOption) _then) = __$DrinkOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: optionIdValue, fromJson: parseInt) int id,@JsonKey(fromJson: parseString) String name,@JsonKey(name: 'price_delta', fromJson: parseDecimal) Decimal priceDelta,@JsonKey(name: 'is_default', fromJson: boolOrFalse) bool isDefault
});




}
/// @nodoc
class __$DrinkOptionCopyWithImpl<$Res>
    implements _$DrinkOptionCopyWith<$Res> {
  __$DrinkOptionCopyWithImpl(this._self, this._then);

  final _DrinkOption _self;
  final $Res Function(_DrinkOption) _then;

/// Create a copy of DrinkOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? priceDelta = null,Object? isDefault = null,}) {
  return _then(_DrinkOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceDelta: null == priceDelta ? _self.priceDelta : priceDelta // ignore: cast_nullable_to_non_nullable
as Decimal,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SelectedOption {

 int get optionId; String get name; Decimal get priceDelta; int get quantity;
/// Create a copy of SelectedOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedOptionCopyWith<SelectedOption> get copyWith => _$SelectedOptionCopyWithImpl<SelectedOption>(this as SelectedOption, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SelectedOption;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedOption&&(identical(other.optionId, _this.optionId) || other.optionId == _this.optionId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.priceDelta, _this.priceDelta) || other.priceDelta == _this.priceDelta)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity));
}


@override
int get hashCode {
  final _this = this as SelectedOption;
  return Object.hash(runtimeType,_this.optionId,_this.name,_this.priceDelta,_this.quantity);
}

@override
String toString() {
  final _this = this as SelectedOption;
  return 'SelectedOption(optionId: ${_this.optionId}, name: ${_this.name}, priceDelta: ${_this.priceDelta}, quantity: ${_this.quantity})';
}


}

/// @nodoc
abstract mixin class $SelectedOptionCopyWith<$Res>  {
  factory $SelectedOptionCopyWith(SelectedOption value, $Res Function(SelectedOption) _then) = _$SelectedOptionCopyWithImpl;
@useResult
$Res call({
 int optionId, String name, Decimal priceDelta, int quantity
});




}
/// @nodoc
class _$SelectedOptionCopyWithImpl<$Res>
    implements $SelectedOptionCopyWith<$Res> {
  _$SelectedOptionCopyWithImpl(this._self, this._then);

  final SelectedOption _self;
  final $Res Function(SelectedOption) _then;

/// Create a copy of SelectedOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? optionId = null,Object? name = null,Object? priceDelta = null,Object? quantity = null,}) {
  return _then(SelectedOption(
optionId: null == optionId ? _self.optionId : optionId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceDelta: null == priceDelta ? _self.priceDelta : priceDelta // ignore: cast_nullable_to_non_nullable
as Decimal,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectedOption].
extension SelectedOptionPatterns on SelectedOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectedOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectedOption value)  $default,){
final _that = this;
switch (_that) {
case _SelectedOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectedOption value)?  $default,){
final _that = this;
switch (_that) {
case _SelectedOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int optionId,  String name,  Decimal priceDelta,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedOption() when $default != null:
return $default(_that.optionId,_that.name,_that.priceDelta,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int optionId,  String name,  Decimal priceDelta,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _SelectedOption():
return $default(_that.optionId,_that.name,_that.priceDelta,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int optionId,  String name,  Decimal priceDelta,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _SelectedOption() when $default != null:
return $default(_that.optionId,_that.name,_that.priceDelta,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _SelectedOption implements SelectedOption {
  const _SelectedOption({required this.optionId, required this.name, required this.priceDelta, this.quantity = 1});
  

@override final  int optionId;
@override final  String name;
@override final  Decimal priceDelta;
@override@JsonKey() final  int quantity;

/// Create a copy of SelectedOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedOptionCopyWith<_SelectedOption> get copyWith => __$SelectedOptionCopyWithImpl<_SelectedOption>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedOption&&(identical(other.optionId, optionId) || other.optionId == optionId)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceDelta, priceDelta) || other.priceDelta == priceDelta)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode {
    return Object.hash(runtimeType,optionId,name,priceDelta,quantity);
}

@override
String toString() {
    return 'SelectedOption(optionId: $optionId, name: $name, priceDelta: $priceDelta, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$SelectedOptionCopyWith<$Res> implements $SelectedOptionCopyWith<$Res> {
  factory _$SelectedOptionCopyWith(_SelectedOption value, $Res Function(_SelectedOption) _then) = __$SelectedOptionCopyWithImpl;
@override @useResult
$Res call({
 int optionId, String name, Decimal priceDelta, int quantity
});




}
/// @nodoc
class __$SelectedOptionCopyWithImpl<$Res>
    implements _$SelectedOptionCopyWith<$Res> {
  __$SelectedOptionCopyWithImpl(this._self, this._then);

  final _SelectedOption _self;
  final $Res Function(_SelectedOption) _then;

/// Create a copy of SelectedOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? optionId = null,Object? name = null,Object? priceDelta = null,Object? quantity = null,}) {
  return _then(_SelectedOption(
optionId: null == optionId ? _self.optionId : optionId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceDelta: null == priceDelta ? _self.priceDelta : priceDelta // ignore: cast_nullable_to_non_nullable
as Decimal,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
