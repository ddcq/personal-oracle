// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myth_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MythCard _$MythCardFromJson(Map<String, dynamic> json) => _MythCard(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  imagePath: json['imagePath'] as String,
  videoUrl: json['videoUrl'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  version:
      $enumDecodeNullable(_$CardVersionEnumMap, json['version']) ??
      CardVersion.epic,
  detailedStory: json['detailedStory'] as String,
);

Map<String, dynamic> _$MythCardToJson(_MythCard instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'imagePath': instance.imagePath,
  'videoUrl': instance.videoUrl,
  'tags': instance.tags,
  'version': instance.version,
  'detailedStory': instance.detailedStory,
};

const _$CardVersionEnumMap = {
  CardVersion.chibi: 'chibi',
  CardVersion.premium: 'premium',
  CardVersion.epic: 'epic',
};
