import 'package:oracle_d_asgard/models/myth_card.dart';

class MythStory {
  final String title;
  final List<MythCard> correctOrder;

  MythStory({
    required this.title,
    required this.correctOrder,
  });
}