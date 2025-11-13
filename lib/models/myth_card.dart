import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oracle_d_asgard/models/card_version.dart';

part 'myth_card.freezed.dart';
part 'myth_card.g.dart';

@freezed
abstract class MythCard with _$MythCard {
  const factory MythCard({
    required String id,
    required String title,
    required String description,
    required String imagePath,
    String? videoUrl,
    @Default([]) List<String> tags,
    @Default(CardVersion.epic) CardVersion version,
    required String detailedStory,
  }) = _MythCard;

  factory MythCard.fromJson(Map<String, dynamic> json) =>
      _$MythCardFromJson(json);
}
