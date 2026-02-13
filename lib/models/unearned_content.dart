import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';

/// Represents content that the player has not yet earned/unlocked.
///
/// This class encapsulates collectible cards and myth stories that are
/// still available to be unlocked, providing type safety over using Maps.
class UnearnedContent {
  final List<CollectibleCard> collectibleCards;
  final List<MythStory> mythStories;

  const UnearnedContent({
    required this.collectibleCards,
    required this.mythStories,
  });

  /// Returns true if there is no unearned content left.
  bool get isEmpty => collectibleCards.isEmpty && mythStories.isEmpty;

  /// Returns true if there is still unearned content available.
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() {
    return 'UnearnedContent(cards: ${collectibleCards.length}, stories: ${mythStories.length})';
  }
}
