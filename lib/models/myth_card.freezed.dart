// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'myth_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MythCard {

 String get id; String get title; String get description; String get imagePath; String? get videoUrl; List<String> get tags; CardVersion get version; String get detailedStory;
/// Create a copy of MythCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MythCardCopyWith<MythCard> get copyWith => _$MythCardCopyWithImpl<MythCard>(this as MythCard, _$identity);

  /// Serializes this MythCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MythCard&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.version, version) || other.version == version)&&(identical(other.detailedStory, detailedStory) || other.detailedStory == detailedStory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,imagePath,videoUrl,const DeepCollectionEquality().hash(tags),version,detailedStory);

@override
String toString() {
  return 'MythCard(id: $id, title: $title, description: $description, imagePath: $imagePath, videoUrl: $videoUrl, tags: $tags, version: $version, detailedStory: $detailedStory)';
}


}

/// @nodoc
abstract mixin class $MythCardCopyWith<$Res>  {
  factory $MythCardCopyWith(MythCard value, $Res Function(MythCard) _then) = _$MythCardCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String imagePath, String? videoUrl, List<String> tags, CardVersion version, String detailedStory
});




}
/// @nodoc
class _$MythCardCopyWithImpl<$Res>
    implements $MythCardCopyWith<$Res> {
  _$MythCardCopyWithImpl(this._self, this._then);

  final MythCard _self;
  final $Res Function(MythCard) _then;

/// Create a copy of MythCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imagePath = null,Object? videoUrl = freezed,Object? tags = null,Object? version = null,Object? detailedStory = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as CardVersion,detailedStory: null == detailedStory ? _self.detailedStory : detailedStory // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MythCard].
extension MythCardPatterns on MythCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MythCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MythCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MythCard value)  $default,){
final _that = this;
switch (_that) {
case _MythCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MythCard value)?  $default,){
final _that = this;
switch (_that) {
case _MythCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String imagePath,  String? videoUrl,  List<String> tags,  CardVersion version,  String detailedStory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MythCard() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imagePath,_that.videoUrl,_that.tags,_that.version,_that.detailedStory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String imagePath,  String? videoUrl,  List<String> tags,  CardVersion version,  String detailedStory)  $default,) {final _that = this;
switch (_that) {
case _MythCard():
return $default(_that.id,_that.title,_that.description,_that.imagePath,_that.videoUrl,_that.tags,_that.version,_that.detailedStory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String imagePath,  String? videoUrl,  List<String> tags,  CardVersion version,  String detailedStory)?  $default,) {final _that = this;
switch (_that) {
case _MythCard() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imagePath,_that.videoUrl,_that.tags,_that.version,_that.detailedStory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MythCard implements MythCard {
  const _MythCard({required this.id, required this.title, required this.description, required this.imagePath, this.videoUrl, final  List<String> tags = const [], this.version = CardVersion.epic, required this.detailedStory}): _tags = tags;
  factory _MythCard.fromJson(Map<String, dynamic> json) => _$MythCardFromJson(json);

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
@override final  String detailedStory;

/// Create a copy of MythCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MythCardCopyWith<_MythCard> get copyWith => __$MythCardCopyWithImpl<_MythCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MythCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MythCard&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.version, version) || other.version == version)&&(identical(other.detailedStory, detailedStory) || other.detailedStory == detailedStory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,imagePath,videoUrl,const DeepCollectionEquality().hash(_tags),version,detailedStory);

@override
String toString() {
  return 'MythCard(id: $id, title: $title, description: $description, imagePath: $imagePath, videoUrl: $videoUrl, tags: $tags, version: $version, detailedStory: $detailedStory)';
}


}

/// @nodoc
abstract mixin class _$MythCardCopyWith<$Res> implements $MythCardCopyWith<$Res> {
  factory _$MythCardCopyWith(_MythCard value, $Res Function(_MythCard) _then) = __$MythCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String imagePath, String? videoUrl, List<String> tags, CardVersion version, String detailedStory
});




}
/// @nodoc
class __$MythCardCopyWithImpl<$Res>
    implements _$MythCardCopyWith<$Res> {
  __$MythCardCopyWithImpl(this._self, this._then);

  final _MythCard _self;
  final $Res Function(_MythCard) _then;

/// Create a copy of MythCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imagePath = null,Object? videoUrl = freezed,Object? tags = null,Object? version = null,Object? detailedStory = null,}) {
  return _then(_MythCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as CardVersion,detailedStory: null == detailedStory ? _self.detailedStory : detailedStory // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
