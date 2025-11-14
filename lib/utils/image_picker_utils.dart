import 'dart:math';
import 'package:oracle_d_asgard/data/collectible_cards_data.dart';

String getRandomCardImagePath() {
  if (allCollectibleCards.isEmpty) {
    return 'home_illu.png'; // Fallback if no cards are defined
  }
  final random = Random();
  final selectedCard = allCollectibleCards[random.nextInt(allCollectibleCards.length)];
  return selectedCard.imagePath;
}
