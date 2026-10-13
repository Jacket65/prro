// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrdersHistoryState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersHistoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'OrdersHistoryState()';
}


}

/// @nodoc
class $OrdersHistoryStateCopyWith<$Res>  {
$OrdersHistoryStateCopyWith(OrdersHistoryState _, $Res Function(OrdersHistoryState) __);
}


/// Adds pattern-matching-related methods to [OrdersHistoryState].
extension OrdersHistoryStatePatterns on OrdersHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OrdersHistoryInitial value)?  initial,TResult Function( OrdersHistoryLoading value)?  loading,TResult Function( OrdersHistoryError value)?  error,TResult Function( OrdersHistoryLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OrdersHistoryInitial() when initial != null:
return initial(_that);case OrdersHistoryLoading() when loading != null:
return loading(_that);case OrdersHistoryError() when error != null:
return error(_that);case OrdersHistoryLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OrdersHistoryInitial value)  initial,required TResult Function( OrdersHistoryLoading value)  loading,required TResult Function( OrdersHistoryError value)  error,required TResult Function( OrdersHistoryLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case OrdersHistoryInitial():
return initial(_that);case OrdersHistoryLoading():
return loading(_that);case OrdersHistoryError():
return error(_that);case OrdersHistoryLoaded():
return loaded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OrdersHistoryInitial value)?  initial,TResult? Function( OrdersHistoryLoading value)?  loading,TResult? Function( OrdersHistoryError value)?  error,TResult? Function( OrdersHistoryLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case OrdersHistoryInitial() when initial != null:
return initial(_that);case OrdersHistoryLoading() when loading != null:
return loading(_that);case OrdersHistoryError() when error != null:
return error(_that);case OrdersHistoryLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( List<OrderListItem> items,  bool hasNext,  int page,  String sort,  String order,  bool isLoadingMore,  bool loadMoreError)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OrdersHistoryInitial() when initial != null:
return initial();case OrdersHistoryLoading() when loading != null:
return loading();case OrdersHistoryError() when error != null:
return error(_that.message);case OrdersHistoryLoaded() when loaded != null:
return loaded(_that.items,_that.hasNext,_that.page,_that.sort,_that.order,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( List<OrderListItem> items,  bool hasNext,  int page,  String sort,  String order,  bool isLoadingMore,  bool loadMoreError)  loaded,}) {final _that = this;
switch (_that) {
case OrdersHistoryInitial():
return initial();case OrdersHistoryLoading():
return loading();case OrdersHistoryError():
return error(_that.message);case OrdersHistoryLoaded():
return loaded(_that.items,_that.hasNext,_that.page,_that.sort,_that.order,_that.isLoadingMore,_that.loadMoreError);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( List<OrderListItem> items,  bool hasNext,  int page,  String sort,  String order,  bool isLoadingMore,  bool loadMoreError)?  loaded,}) {final _that = this;
switch (_that) {
case OrdersHistoryInitial() when initial != null:
return initial();case OrdersHistoryLoading() when loading != null:
return loading();case OrdersHistoryError() when error != null:
return error(_that.message);case OrdersHistoryLoaded() when loaded != null:
return loaded(_that.items,_that.hasNext,_that.page,_that.sort,_that.order,_that.isLoadingMore,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class OrdersHistoryInitial implements OrdersHistoryState {
  const OrdersHistoryInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersHistoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'OrdersHistoryState.initial()';
}


}




/// @nodoc


class OrdersHistoryLoading implements OrdersHistoryState {
  const OrdersHistoryLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersHistoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'OrdersHistoryState.loading()';
}


}




/// @nodoc


class OrdersHistoryError implements OrdersHistoryState {
  const OrdersHistoryError(this.message);
  

 final  String message;

/// Create a copy of OrdersHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersHistoryErrorCopyWith<OrdersHistoryError> get copyWith => _$OrdersHistoryErrorCopyWithImpl<OrdersHistoryError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersHistoryError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'OrdersHistoryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $OrdersHistoryErrorCopyWith<$Res> implements $OrdersHistoryStateCopyWith<$Res> {
  factory $OrdersHistoryErrorCopyWith(OrdersHistoryError value, $Res Function(OrdersHistoryError) _then) = _$OrdersHistoryErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$OrdersHistoryErrorCopyWithImpl<$Res>
    implements $OrdersHistoryErrorCopyWith<$Res> {
  _$OrdersHistoryErrorCopyWithImpl(this._self, this._then);

  final OrdersHistoryError _self;
  final $Res Function(OrdersHistoryError) _then;

/// Create a copy of OrdersHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(OrdersHistoryError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class OrdersHistoryLoaded implements OrdersHistoryState {
  const OrdersHistoryLoaded({required  List<OrderListItem> items, required this.hasNext, required this.page, this.sort = 'created_at', this.order = 'desc', this.isLoadingMore = false, this.loadMoreError = false}): _items = items;
  

 final  List<OrderListItem> _items;
 List<OrderListItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  bool hasNext;
 final  int page;
@JsonKey() final  String sort;
@JsonKey() final  String order;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  bool loadMoreError;

/// Create a copy of OrdersHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersHistoryLoadedCopyWith<OrdersHistoryLoaded> get copyWith => _$OrdersHistoryLoadedCopyWithImpl<OrdersHistoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersHistoryLoaded&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext)&&(identical(other.page, page) || other.page == page)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.order, order) || other.order == order)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasNext,page,sort,order,isLoadingMore,loadMoreError);
}

@override
String toString() {
    return 'OrdersHistoryState.loaded(items: $items, hasNext: $hasNext, page: $page, sort: $sort, order: $order, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class $OrdersHistoryLoadedCopyWith<$Res> implements $OrdersHistoryStateCopyWith<$Res> {
  factory $OrdersHistoryLoadedCopyWith(OrdersHistoryLoaded value, $Res Function(OrdersHistoryLoaded) _then) = _$OrdersHistoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<OrderListItem> items, bool hasNext, int page, String sort, String order, bool isLoadingMore, bool loadMoreError
});




}
/// @nodoc
class _$OrdersHistoryLoadedCopyWithImpl<$Res>
    implements $OrdersHistoryLoadedCopyWith<$Res> {
  _$OrdersHistoryLoadedCopyWithImpl(this._self, this._then);

  final OrdersHistoryLoaded _self;
  final $Res Function(OrdersHistoryLoaded) _then;

/// Create a copy of OrdersHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasNext = null,Object? page = null,Object? sort = null,Object? order = null,Object? isLoadingMore = null,Object? loadMoreError = null,}) {
  return _then(OrdersHistoryLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderListItem>,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: null == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
