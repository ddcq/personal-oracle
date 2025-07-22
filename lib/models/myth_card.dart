import 'package:oracle_d_asgard/models/collectible_card.dart';

class MythCard extends CollectibleCard {
  final String detailedStory;

  MythCard({required super.id, required super.title, required super.description, required super.imagePath, required this.detailedStory});
}