import 'dart:math';
import 'package:oracle_d_asgard/screens/games/snake/config/snake_game_config.dart';

/// Calculates game speed based on score for Snake game
class SpeedCalculator {
  /// Calculate game speed (in milliseconds) based on current score
  /// Uses logarithmic scaling for smooth difficulty progression
  static double calculate(int currentScore) {
    if (currentScore == 0) {
      return SnakeGameConfig.gameSpeedInitial.toDouble();
    }

    // Formula: speed = initial - k * log(score + 1)
    // At score 100: 50ms = 200ms - k * log(101)
    // k = (200 - 50) / log(101) ≈ 32.5
    const double k = 150 / 4.615120517; // log(101) ≈ 4.615

    final speed =
        SnakeGameConfig.gameSpeedInitial - (k * log(currentScore + 1));

    // Keep reasonable floor for speed
    return speed.clamp(10.0, SnakeGameConfig.gameSpeedInitial.toDouble());
  }

  /// Calculate speed in seconds (for timers)
  static double calculateInSeconds(int currentScore) {
    return calculate(currentScore) / 1000.0;
  }
}
