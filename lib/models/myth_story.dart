import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';

part 'myth_story.freezed.dart';
part 'myth_story.g.dart';

@freezed
abstract class MythStory with _$MythStory {
  const factory MythStory({
    required String id,
    required String title,
    required List<MythCard> correctOrder,
  }) = _MythStory;

  factory MythStory.fromJson(Map<String, dynamic> json) =>
      _$MythStoryFromJson(json);
}
