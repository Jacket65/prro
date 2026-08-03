// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatePaymentRequest {

/// Payment amount in kopecks (1/100 of currency unit).
 int get amount;/// Currency code (e.g., 'UAH').
 String get currency;/// Payment description shown to the customer.
 String get description;/// Optional order ID to associate with this payment.
@JsonKey(name: 'order_id') String? get orderId;/// Optional additional metadata.
 Map<String, dynamic>? get metadata;
/// Create a copy of CreatePaymentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePaymentRequestCopyWith<CreatePaymentRequest> get copyWith => _$CreatePaymentRequestCopyWithImpl<CreatePaymentRequest>(this as CreatePaymentRequest, _$identity);

  /// Serializes this CreatePaymentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePaymentRequest&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.description, description) || other.description == description)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,currency,description,orderId,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'CreatePaymentRequest(amount: $amount, currency: $currency, description: $description, orderId: $orderId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $CreatePaymentRequestCopyWith<$Res>  {
  factory $CreatePaymentRequestCopyWith(CreatePaymentRequest value, $Res Function(CreatePaymentRequest) _then) = _$CreatePaymentRequestCopyWithImpl;
@useResult
$Res call({
 int amount, String currency, String description,@JsonKey(name: 'order_id') String? orderId, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$CreatePaymentRequestCopyWithImpl<$Res>
    implements $CreatePaymentRequestCopyWith<$Res> {
  _$CreatePaymentRequestCopyWithImpl(this._self, this._then);

  final CreatePaymentRequest _self;
  final $Res Function(CreatePaymentRequest) _then;

/// Create a copy of CreatePaymentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? currency = null,Object? description = null,Object? orderId = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatePaymentRequest].
extension CreatePaymentRequestPatterns on CreatePaymentRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePaymentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePaymentRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePaymentRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreatePaymentRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePaymentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePaymentRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int amount,  String currency,  String description, @JsonKey(name: 'order_id')  String? orderId,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePaymentRequest() when $default != null:
return $default(_that.amount,_that.currency,_that.description,_that.orderId,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int amount,  String currency,  String description, @JsonKey(name: 'order_id')  String? orderId,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _CreatePaymentRequest():
return $default(_that.amount,_that.currency,_that.description,_that.orderId,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int amount,  String currency,  String description, @JsonKey(name: 'order_id')  String? orderId,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _CreatePaymentRequest() when $default != null:
return $default(_that.amount,_that.currency,_that.description,_that.orderId,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePaymentRequest implements CreatePaymentRequest {
  const _CreatePaymentRequest({required this.amount, required this.currency, required this.description, @JsonKey(name: 'order_id') this.orderId, final  Map<String, dynamic>? metadata}): _metadata = metadata;
  factory _CreatePaymentRequest.fromJson(Map<String, dynamic> json) => _$CreatePaymentRequestFromJson(json);

/// Payment amount in kopecks (1/100 of currency unit).
@override final  int amount;
/// Currency code (e.g., 'UAH').
@override final  String currency;
/// Payment description shown to the customer.
@override final  String description;
/// Optional order ID to associate with this payment.
@override@JsonKey(name: 'order_id') final  String? orderId;
/// Optional additional metadata.
 final  Map<String, dynamic>? _metadata;
/// Optional additional metadata.
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of CreatePaymentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePaymentRequestCopyWith<_CreatePaymentRequest> get copyWith => __$CreatePaymentRequestCopyWithImpl<_CreatePaymentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePaymentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePaymentRequest&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.description, description) || other.description == description)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,currency,description,orderId,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'CreatePaymentRequest(amount: $amount, currency: $currency, description: $description, orderId: $orderId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$CreatePaymentRequestCopyWith<$Res> implements $CreatePaymentRequestCopyWith<$Res> {
  factory _$CreatePaymentRequestCopyWith(_CreatePaymentRequest value, $Res Function(_CreatePaymentRequest) _then) = __$CreatePaymentRequestCopyWithImpl;
@override @useResult
$Res call({
 int amount, String currency, String description,@JsonKey(name: 'order_id') String? orderId, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$CreatePaymentRequestCopyWithImpl<$Res>
    implements _$CreatePaymentRequestCopyWith<$Res> {
  __$CreatePaymentRequestCopyWithImpl(this._self, this._then);

  final _CreatePaymentRequest _self;
  final $Res Function(_CreatePaymentRequest) _then;

/// Create a copy of CreatePaymentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? currency = null,Object? description = null,Object? orderId = freezed,Object? metadata = freezed,}) {
  return _then(_CreatePaymentRequest(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
