// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'myth_story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MythStory {

 String get id; String get title; List<MythCard> get correctOrder;
/// Create a copy of MythStory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MythStoryCopyWith<MythStory> get copyWith => _$MythStoryCopyWithImpl<MythStory>(this as MythStory, _$identity);

  /// Serializes this MythStory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MythStory&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.correctOrder, correctOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(correctOrder));

@override
String toString() {
  return 'MythStory(id: $id, title: $title, correctOrder: $correctOrder)';
}


}

/// @nodoc
abstract mixin class $MythStoryCopyWith<$Res>  {
  factory $MythStoryCopyWith(MythStory value, $Res Function(MythStory) _then) = _$MythStoryCopyWithImpl;
@useResult
$Res call({
 String id, String title, List<MythCard> correctOrder
});




}
/// @nodoc
class _$MythStoryCopyWithImpl<$Res>
    implements $MythStoryCopyWith<$Res> {
  _$MythStoryCopyWithImpl(this._self, this._then);

  final MythStory _self;
  final $Res Function(MythStory) _then;

/// Create a copy of MythStory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? correctOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,correctOrder: null == correctOrder ? _self.correctOrder : correctOrder // ignore: cast_nullable_to_non_nullable
as List<MythCard>,
  ));
}

}


/// Adds pattern-matching-related methods to [MythStory].
extension MythStoryPatterns on MythStory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MythStory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MythStory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MythStory value)  $default,){
final _that = this;
switch (_that) {
case _MythStory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MythStory value)?  $default,){
final _that = this;
switch (_that) {
case _MythStory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  List<MythCard> correctOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MythStory() when $default != null:
return $default(_that.id,_that.title,_that.correctOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  List<MythCard> correctOrder)  $default,) {final _that = this;
switch (_that) {
case _MythStory():
return $default(_that.id,_that.title,_that.correctOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  List<MythCard> correctOrder)?  $default,) {final _that = this;
switch (_that) {
case _MythStory() when $default != null:
return $default(_that.id,_that.title,_that.correctOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MythStory implements MythStory {
  const _MythStory({required this.id, required this.title, required final  List<MythCard> correctOrder}): _correctOrder = correctOrder;
  factory _MythStory.fromJson(Map<String, dynamic> json) => _$MythStoryFromJson(json);

@override final  String id;
@override final  String title;
 final  List<MythCard> _correctOrder;
@override List<MythCard> get correctOrder {
  if (_correctOrder is EqualUnmodifiableListView) return _correctOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_correctOrder);
}


/// Create a copy of MythStory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MythStoryCopyWith<_MythStory> get copyWith => __$MythStoryCopyWithImpl<_MythStory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MythStoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MythStory&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._correctOrder, _correctOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(_correctOrder));

@override
String toString() {
  return 'MythStory(id: $id, title: $title, correctOrder: $correctOrder)';
}


}

/// @nodoc
abstract mixin class _$MythStoryCopyWith<$Res> implements $MythStoryCopyWith<$Res> {
  factory _$MythStoryCopyWith(_MythStory value, $Res Function(_MythStory) _then) = __$MythStoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, List<MythCard> correctOrder
});




}
/// @nodoc
class __$MythStoryCopyWithImpl<$Res>
    implements _$MythStoryCopyWith<$Res> {
  __$MythStoryCopyWithImpl(this._self, this._then);

  final _MythStory _self;
  final $Res Function(_MythStory) _then;

/// Create a copy of MythStory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? correctOrder = null,}) {
  return _then(_MythStory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,correctOrder: null == correctOrder ? _self._correctOrder : correctOrder // ignore: cast_nullable_to_non_nullable
as List<MythCard>,
  ));
}


}

// dart format on
