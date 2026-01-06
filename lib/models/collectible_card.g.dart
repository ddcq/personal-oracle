// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collectible_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollectibleCard _$CollectibleCardFromJson(Map<String, dynamic> json) =>
    _CollectibleCard(
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
      price: (json['price'] as num?)?.toInt() ?? 100,
    );

Map<String, dynamic> _$CollectibleCardToJson(_CollectibleCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imagePath': instance.imagePath,
      'videoUrl': instance.videoUrl,
      'tags': instance.tags,
      'version': instance.version,
      'price': instance.price,
    };

const _$CardVersionEnumMap = {
  CardVersion.chibi: 'chibi',
  CardVersion.premium: 'premium',
  CardVersion.epic: 'epic',
};
