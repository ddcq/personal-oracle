import 'dart:math';
import 'package:oracle_d_asgard/data/collectible_cards_data.dart';

String getRandomCardImagePath() {
  final allCards = getCollectibleCards();
  if (allCards.isEmpty) {
    return 'home_illu.png'; // Fallback if no cards are defined
  }
  final random = Random();
  final selectedCard = allCards[random.nextInt(allCards.length)];
  return selectedCard.imagePath;
}
