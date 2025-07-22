import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';

class MythStory {
  final String title;
  final List<MythCard> correctOrder;
  final List<CollectibleCard> collectibleCards;
  final List<String> tags;

  MythStory({
    required this.title,
    required this.correctOrder,
    required this.collectibleCards,
    this.tags = const [],
  });
}