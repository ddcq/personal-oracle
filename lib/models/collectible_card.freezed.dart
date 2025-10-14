// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collectible_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollectibleCard {

 String get id; String get title; String get description; String get imagePath; String? get videoUrl; List<String> get tags; CardVersion get version;
/// Create a copy of CollectibleCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectibleCardCopyWith<CollectibleCard> get copyWith => _$CollectibleCardCopyWithImpl<CollectibleCard>(this as CollectibleCard, _$identity);

  /// Serializes this CollectibleCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectibleCard&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,imagePath,videoUrl,const DeepCollectionEquality().hash(tags),version);

@override
String toString() {
  return 'CollectibleCard(id: $id, title: $title, description: $description, imagePath: $imagePath, videoUrl: $videoUrl, tags: $tags, version: $version)';
}


}

/// @nodoc
abstract mixin class $CollectibleCardCopyWith<$Res>  {
  factory $CollectibleCardCopyWith(CollectibleCard value, $Res Function(CollectibleCard) _then) = _$CollectibleCardCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String imagePath, String? videoUrl, List<String> tags, CardVersion version
});




}
/// @nodoc
class _$CollectibleCardCopyWithImpl<$Res>
    implements $CollectibleCardCopyWith<$Res> {
  _$CollectibleCardCopyWithImpl(this._self, this._then);

  final CollectibleCard _self;
  final $Res Function(CollectibleCard) _then;

/// Create a copy of CollectibleCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imagePath = null,Object? videoUrl = freezed,Object? tags = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as CardVersion,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectibleCard].
extension CollectibleCardPatterns on CollectibleCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectibleCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectibleCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectibleCard value)  $default,){
final _that = this;
switch (_that) {
case _CollectibleCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectibleCard value)?  $default,){
final _that = this;
switch (_that) {
case _CollectibleCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String imagePath,  String? videoUrl,  List<String> tags,  CardVersion version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectibleCard() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imagePath,_that.videoUrl,_that.tags,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String imagePath,  String? videoUrl,  List<String> tags,  CardVersion version)  $default,) {final _that = this;
switch (_that) {
case _CollectibleCard():
return $default(_that.id,_that.title,_that.description,_that.imagePath,_that.videoUrl,_that.tags,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String imagePath,  String? videoUrl,  List<String> tags,  CardVersion version)?  $default,) {final _that = this;
switch (_that) {
case _CollectibleCard() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imagePath,_that.videoUrl,_that.tags,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollectibleCard implements CollectibleCard {
  const _CollectibleCard({required this.id, required this.title, required this.description, required this.imagePath, this.videoUrl, final  List<String> tags = const [], this.version = CardVersion.epic}): _tags = tags;
  factory _CollectibleCard.fromJson(Map<String, dynamic> json) => _$CollectibleCardFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String imagePath;
@override final  String? videoUrl;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  CardVersion version;

/// Create a copy of CollectibleCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectibleCardCopyWith<_CollectibleCard> get copyWith => __$CollectibleCardCopyWithImpl<_CollectibleCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectibleCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectibleCard&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,imagePath,videoUrl,const DeepCollectionEquality().hash(_tags),version);

@override
String toString() {
  return 'CollectibleCard(id: $id, title: $title, description: $description, imagePath: $imagePath, videoUrl: $videoUrl, tags: $tags, version: $version)';
}


}

/// @nodoc
abstract mixin class _$CollectibleCardCopyWith<$Res> implements $CollectibleCardCopyWith<$Res> {
  factory _$CollectibleCardCopyWith(_CollectibleCard value, $Res Function(_CollectibleCard) _then) = __$CollectibleCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String imagePath, String? videoUrl, List<String> tags, CardVersion version
});




}
/// @nodoc
class __$CollectibleCardCopyWithImpl<$Res>
    implements _$CollectibleCardCopyWith<$Res> {
  __$CollectibleCardCopyWithImpl(this._self, this._then);

  final _CollectibleCard _self;
  final $Res Function(_CollectibleCard) _then;

/// Create a copy of CollectibleCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imagePath = null,Object? videoUrl = freezed,Object? tags = null,Object? version = null,}) {
  return _then(_CollectibleCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as CardVersion,
  ));
}


}

// dart format on
