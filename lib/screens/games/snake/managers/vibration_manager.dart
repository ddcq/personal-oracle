import 'dart:io';
import 'package:vibration/vibration.dart';
import 'package:oracle_d_asgard/screens/games/snake/config/snake_game_config.dart';

/// Manages haptic feedback/vibration patterns for Snake game
class VibrationManager {
  /// Vibrate when eating regular food
  static Future<void> vibrateOnRegularFood() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await Vibration.vibrate(duration: SnakeGameConfig.vibrationDurationShort);
    }
  }

  /// Vibrate when eating golden food (stronger)
  static Future<void> vibrateOnGoldenFood() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await Vibration.vibrate(
        duration: SnakeGameConfig.vibrationDurationShort,
        amplitude: SnakeGameConfig.vibrationAmplitudeHigh,
      );
    }
  }

  /// Vibrate when eating rotten food (medium)
  static Future<void> vibrateOnRottenFood() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await Vibration.vibrate(
        duration: SnakeGameConfig.vibrationDurationMedium,
        amplitude: SnakeGameConfig.vibrationAmplitudeHigh,
      );
    }
  }

  /// Vibrate when game over (long)
  static Future<void> vibrateOnGameOver() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await Vibration.vibrate(duration: SnakeGameConfig.vibrationDurationLong);
    }
  }

  /// Vibrate with custom duration
  static Future<void> vibrateCustom({
    required int duration,
    int? amplitude,
  }) async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (amplitude != null) {
        await Vibration.vibrate(duration: duration, amplitude: amplitude);
      } else {
        await Vibration.vibrate(duration: duration);
      }
    }
  }
}
