// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myth_story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MythStory _$MythStoryFromJson(Map<String, dynamic> json) => _MythStory(
  id: json['id'] as String,
  title: json['title'] as String,
  correctOrder: (json['correctOrder'] as List<dynamic>)
      .map((e) => MythCard.fromJson(e as Map<String, dynamic>))
      .toList(),
  price: (json['price'] as num?)?.toInt() ?? 200,
);

Map<String, dynamic> _$MythStoryToJson(_MythStory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'correctOrder': instance.correctOrder,
      'price': instance.price,
    };
