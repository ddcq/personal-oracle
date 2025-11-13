import 'package:oracle_d_asgard/models/card_version.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'collectible_card.freezed.dart';
part 'collectible_card.g.dart';

@freezed
abstract class CollectibleCard with _$CollectibleCard {
  const factory CollectibleCard({
    required String id,
    required String title,
    required String description,
    required String imagePath,
    String? videoUrl,
    @Default([]) List<String> tags,
    @Default(CardVersion.epic) CardVersion version,
  }) = _CollectibleCard;

  factory CollectibleCard.fromJson(Map<String, dynamic> json) =>
      _$CollectibleCardFromJson(json);
}
