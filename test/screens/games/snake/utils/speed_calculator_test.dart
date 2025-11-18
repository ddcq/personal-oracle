import 'package:flutter_test/flutter_test.dart';
import 'package:oracle_d_asgard/screens/games/snake/utils/speed_calculator.dart';
import 'package:oracle_d_asgard/screens/games/snake/config/snake_game_config.dart';

void main() {
  group('SpeedCalculator', () {
    group('calculate', () {
      test('should return initial speed for score 0', () {
        final speed = SpeedCalculator.calculate(0);
        expect(speed, SnakeGameConfig.gameSpeedInitial.toDouble());
      });

      test('should decrease speed as score increases', () {
        final speed1 = SpeedCalculator.calculate(0);
        final speed2 = SpeedCalculator.calculate(50);
        final speed3 = SpeedCalculator.calculate(100);
        
        expect(speed2, lessThan(speed1));
        expect(speed3, lessThan(speed2));
      });

      test('should not go below minimum speed', () {
        final speed = SpeedCalculator.calculate(10000);
        expect(speed, greaterThanOrEqualTo(10.0));
      });

      test('should not exceed initial speed', () {
        final speed = SpeedCalculator.calculate(50);
        expect(speed, lessThanOrEqualTo(SnakeGameConfig.gameSpeedInitial.toDouble()));
      });

      test('should use logarithmic scaling', () {
        final speed50 = SpeedCalculator.calculate(50);
        final speed100 = SpeedCalculator.calculate(100);
        final speed200 = SpeedCalculator.calculate(200);
        
        final diff1 = speed50 - speed100;
        final diff2 = speed100 - speed200;
        
        // Logarithmic scaling means diff1 should be greater than diff2
        expect(diff1, greaterThan(diff2));
      });
    });

    group('calculateInSeconds', () {
      test('should convert milliseconds to seconds', () {
        final speedMs = SpeedCalculator.calculate(0);
        final speedSec = SpeedCalculator.calculateInSeconds(0);
        
        expect(speedSec, speedMs / 1000.0);
      });

      test('should maintain proportions in seconds', () {
        final speed1 = SpeedCalculator.calculateInSeconds(0);
        final speed2 = SpeedCalculator.calculateInSeconds(100);
        
        expect(speed2, lessThan(speed1));
      });
    });
  });
}
