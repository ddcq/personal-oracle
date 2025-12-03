import 'package:flutter_test/flutter_test.dart';
import 'package:oracle_d_asgard/screens/games/snake/models/snake_models.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

void main() {
  group('Bonus', () {
    test('should create bonus with all properties', () {
      final position = IntVector2(5, 5);
      final bonus = Bonus(
        position: position,
        type: BonusType.speed,
        spawnTime: 10.0,
      );

      expect(bonus.position, position);
      expect(bonus.type, BonusType.speed);
      expect(bonus.spawnTime, 10.0);
    });

    test('should clone bonus correctly', () {
      final position = IntVector2(5, 5);
      final bonus = Bonus(
        position: position,
        type: BonusType.shield,
        spawnTime: 5.0,
      );

      final clone = bonus.clone();

      expect(clone.position.x, bonus.position.x);
      expect(clone.position.y, bonus.position.y);
      expect(clone.type, bonus.type);
      expect(clone.spawnTime, bonus.spawnTime);
      expect(identical(clone, bonus), isFalse);
    });

    test('should clone with independent position', () {
      final position = IntVector2(5, 5);
      final bonus = Bonus(
        position: position,
        type: BonusType.freeze,
        spawnTime: 3.0,
      );

      final clone = bonus.clone();

      // Modifying original position should not affect clone
      expect(clone.position, isNot(same(bonus.position)));
    });
  });

  group('ActiveBonusEffect', () {
    test('should create active bonus effect', () {
      final effect = ActiveBonusEffect(
        type: BonusType.ghost,
        activationTime: 15.0,
      );

      expect(effect.type, BonusType.ghost);
      expect(effect.activationTime, 15.0);
    });

    test('should clone active bonus effect correctly', () {
      final effect = ActiveBonusEffect(
        type: BonusType.coin,
        activationTime: 8.0,
      );

      final clone = effect.clone();

      expect(clone.type, effect.type);
      expect(clone.activationTime, effect.activationTime);
      expect(identical(clone, effect), isFalse);
    });
  });

  group('BonusType enum', () {
    test('should have all bonus types', () {
      expect(BonusType.values.length, 5);
      expect(BonusType.values, contains(BonusType.speed));
      expect(BonusType.values, contains(BonusType.shield));
      expect(BonusType.values, contains(BonusType.freeze));
      expect(BonusType.values, contains(BonusType.ghost));
      expect(BonusType.values, contains(BonusType.coin));
    });
  });

  group('FoodType enum', () {
    test('should have all food types', () {
      expect(FoodType.values.length, 3);
      expect(FoodType.values, contains(FoodType.regular));
      expect(FoodType.values, contains(FoodType.golden));
      expect(FoodType.values, contains(FoodType.rotten));
    });
  });
}
