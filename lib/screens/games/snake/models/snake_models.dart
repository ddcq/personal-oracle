import 'package:oracle_d_asgard/utils/int_vector2.dart';

enum FoodType { regular, golden, rotten }

enum BonusType { speed, shield, freeze, ghost, coin }

class Bonus {
  final IntVector2 position;
  final BonusType type;
  final double spawnTime;

  Bonus({required this.position, required this.type, required this.spawnTime});

  Bonus clone() {
    return Bonus(position: position.clone(), type: type, spawnTime: spawnTime);
  }
}

class ActiveBonusEffect {
  final BonusType type;
  final double activationTime;

  ActiveBonusEffect({required this.type, required this.activationTime});

  ActiveBonusEffect clone() {
    return ActiveBonusEffect(type: type, activationTime: activationTime);
  }
}
