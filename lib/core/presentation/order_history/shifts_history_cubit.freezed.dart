// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shifts_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShiftsHistoryState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftsHistoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ShiftsHistoryState()';
}


}

/// @nodoc
class $ShiftsHistoryStateCopyWith<$Res>  {
$ShiftsHistoryStateCopyWith(ShiftsHistoryState _, $Res Function(ShiftsHistoryState) __);
}


/// Adds pattern-matching-related methods to [ShiftsHistoryState].
extension ShiftsHistoryStatePatterns on ShiftsHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ShiftsHistoryInitial value)?  initial,TResult Function( ShiftsHistoryLoading value)?  loading,TResult Function( ShiftsHistoryError value)?  error,TResult Function( ShiftsHistoryLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ShiftsHistoryInitial() when initial != null:
return initial(_that);case ShiftsHistoryLoading() when loading != null:
return loading(_that);case ShiftsHistoryError() when error != null:
return error(_that);case ShiftsHistoryLoaded() when loaded != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ShiftsHistoryInitial value)  initial,required TResult Function( ShiftsHistoryLoading value)  loading,required TResult Function( ShiftsHistoryError value)  error,required TResult Function( ShiftsHistoryLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case ShiftsHistoryInitial():
return initial(_that);case ShiftsHistoryLoading():
return loading(_that);case ShiftsHistoryError():
return error(_that);case ShiftsHistoryLoaded():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ShiftsHistoryInitial value)?  initial,TResult? Function( ShiftsHistoryLoading value)?  loading,TResult? Function( ShiftsHistoryError value)?  error,TResult? Function( ShiftsHistoryLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case ShiftsHistoryInitial() when initial != null:
return initial(_that);case ShiftsHistoryLoading() when loading != null:
return loading(_that);case ShiftsHistoryError() when error != null:
return error(_that);case ShiftsHistoryLoaded() when loaded != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( List<ShiftSummary> items,  bool hasNext,  int page,  bool isLoadingMore,  bool loadMoreError)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ShiftsHistoryInitial() when initial != null:
return initial();case ShiftsHistoryLoading() when loading != null:
return loading();case ShiftsHistoryError() when error != null:
return error(_that.message);case ShiftsHistoryLoaded() when loaded != null:
return loaded(_that.items,_that.hasNext,_that.page,_that.isLoadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( List<ShiftSummary> items,  bool hasNext,  int page,  bool isLoadingMore,  bool loadMoreError)  loaded,}) {final _that = this;
switch (_that) {
case ShiftsHistoryInitial():
return initial();case ShiftsHistoryLoading():
return loading();case ShiftsHistoryError():
return error(_that.message);case ShiftsHistoryLoaded():
return loaded(_that.items,_that.hasNext,_that.page,_that.isLoadingMore,_that.loadMoreError);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( List<ShiftSummary> items,  bool hasNext,  int page,  bool isLoadingMore,  bool loadMoreError)?  loaded,}) {final _that = this;
switch (_that) {
case ShiftsHistoryInitial() when initial != null:
return initial();case ShiftsHistoryLoading() when loading != null:
return loading();case ShiftsHistoryError() when error != null:
return error(_that.message);case ShiftsHistoryLoaded() when loaded != null:
return loaded(_that.items,_that.hasNext,_that.page,_that.isLoadingMore,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class ShiftsHistoryInitial implements ShiftsHistoryState {
  const ShiftsHistoryInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftsHistoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ShiftsHistoryState.initial()';
}


}




/// @nodoc


class ShiftsHistoryLoading implements ShiftsHistoryState {
  const ShiftsHistoryLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftsHistoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ShiftsHistoryState.loading()';
}


}




/// @nodoc


class ShiftsHistoryError implements ShiftsHistoryState {
  const ShiftsHistoryError(this.message);
  

 final  String message;

/// Create a copy of ShiftsHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftsHistoryErrorCopyWith<ShiftsHistoryError> get copyWith => _$ShiftsHistoryErrorCopyWithImpl<ShiftsHistoryError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftsHistoryError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ShiftsHistoryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ShiftsHistoryErrorCopyWith<$Res> implements $ShiftsHistoryStateCopyWith<$Res> {
  factory $ShiftsHistoryErrorCopyWith(ShiftsHistoryError value, $Res Function(ShiftsHistoryError) _then) = _$ShiftsHistoryErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ShiftsHistoryErrorCopyWithImpl<$Res>
    implements $ShiftsHistoryErrorCopyWith<$Res> {
  _$ShiftsHistoryErrorCopyWithImpl(this._self, this._then);

  final ShiftsHistoryError _self;
  final $Res Function(ShiftsHistoryError) _then;

/// Create a copy of ShiftsHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ShiftsHistoryError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ShiftsHistoryLoaded implements ShiftsHistoryState {
  const ShiftsHistoryLoaded({required  List<ShiftSummary> items, required this.hasNext, required this.page, this.isLoadingMore = false, this.loadMoreError = false}): _items = items;
  

 final  List<ShiftSummary> _items;
 List<ShiftSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  bool hasNext;
 final  int page;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  bool loadMoreError;

/// Create a copy of ShiftsHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftsHistoryLoadedCopyWith<ShiftsHistoryLoaded> get copyWith => _$ShiftsHistoryLoadedCopyWithImpl<ShiftsHistoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftsHistoryLoaded&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext)&&(identical(other.page, page) || other.page == page)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreError, loadMoreError) || other.loadMoreError == loadMoreError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasNext,page,isLoadingMore,loadMoreError);
}

@override
String toString() {
    return 'ShiftsHistoryState.loaded(items: $items, hasNext: $hasNext, page: $page, isLoadingMore: $isLoadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class $ShiftsHistoryLoadedCopyWith<$Res> implements $ShiftsHistoryStateCopyWith<$Res> {
  factory $ShiftsHistoryLoadedCopyWith(ShiftsHistoryLoaded value, $Res Function(ShiftsHistoryLoaded) _then) = _$ShiftsHistoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<ShiftSummary> items, bool hasNext, int page, bool isLoadingMore, bool loadMoreError
});




}
/// @nodoc
class _$ShiftsHistoryLoadedCopyWithImpl<$Res>
    implements $ShiftsHistoryLoadedCopyWith<$Res> {
  _$ShiftsHistoryLoadedCopyWithImpl(this._self, this._then);

  final ShiftsHistoryLoaded _self;
  final $Res Function(ShiftsHistoryLoaded) _then;

/// Create a copy of ShiftsHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasNext = null,Object? page = null,Object? isLoadingMore = null,Object? loadMoreError = null,}) {
  return _then(ShiftsHistoryLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ShiftSummary>,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: null == loadMoreError ? _self.loadMoreError : loadMoreError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
