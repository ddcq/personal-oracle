import 'dart:async' as async;
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:oracle_d_asgard/screens/games/snake/config/snake_game_config.dart';
import 'package:oracle_d_asgard/screens/games/snake/rock_explosion_effect.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

/// Manages visual effects for Snake game
class EffectsManager {
  /// Shake the camera for visual impact
  static void shakeCamera(CameraComponent camera) {
    final originalPosition = camera.viewfinder.position.clone();

    async.Timer.periodic(
      Duration(milliseconds: SnakeGameConfig.shakeIntervalMs),
      (timer) {
        if (timer.tick * SnakeGameConfig.shakeIntervalMs >
            SnakeGameConfig.shakeDurationMs) {
          timer.cancel();
          camera.viewfinder.position = originalPosition;
          return;
        }
        final random = Random();
        camera.viewfinder.position = originalPosition +
            Vector2(
              (random.nextDouble() - 0.5) * SnakeGameConfig.shakeIntensity * 2,
              (random.nextDouble() - 0.5) * SnakeGameConfig.shakeIntensity * 2,
            );
      },
    );
  }

  /// Trigger rock explosion effect when obstacle is destroyed
  static void triggerRockExplosion({
    required IntVector2 obstacleTopLeft,
    required double cellSize,
    required void Function(Component) addComponent,
    required CameraComponent camera,
    required Sprite obstacleSprite,
  }) {
    final position = (obstacleTopLeft.toOffset() * cellSize).toVector2();
    final size = Vector2.all(cellSize * 4);
    final center = position + size / 2;

    // Play explosion sound
    final soundService = getIt<SoundService>();
    soundService.playSoundEffect('audio/explode.mp3');

    // Flash effect
    final flashEffect = FlashEffect(position: position, size: size);
    addComponent(flashEffect);

    // Rock fragments - split into 4 pieces
    final random = Random();
    final fragmentSize = Vector2.all(cellSize * 2);

    final fragmentOffsets = [
      Vector2(0, 0),
      Vector2(cellSize * 2, 0),
      Vector2(0, cellSize * 2),
      Vector2(cellSize * 2, cellSize * 2),
    ];

    final fragmentVelocities = [
      Vector2(-80, -80),
      Vector2(80, -80),
      Vector2(-80, 80),
      Vector2(80, 80),
    ];

    for (int i = 0; i < 4; i++) {
      final fragment = RockFragment(
        sprite: obstacleSprite,
        position: position + fragmentOffsets[i] + fragmentSize / 2,
        size: fragmentSize,
        velocity: fragmentVelocities[i],
        rotationSpeed: (random.nextDouble() - 0.5) * 8,
      );
      addComponent(fragment);
    }

    // Debris particles
    const particleCount = 12;
    final debrisColors = [
      const Color(0xFF808080),
      const Color(0xFF696969),
      const Color(0xFFA9A9A9),
      const Color(0xFF5C4033),
    ];

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * pi + random.nextDouble() * 0.5;
      final speed = 100 + random.nextDouble() * 100;
      final velocity = Vector2(cos(angle) * speed, sin(angle) * speed);

      final debris = DebrisParticle(
        position: center.clone(),
        velocity: velocity,
        particleColor: debrisColors[random.nextInt(debrisColors.length)],
        rotationSpeed: (random.nextDouble() - 0.5) * 10,
      );
      addComponent(debris);
    }

    // Camera shake
    shakeCamera(camera);
  }
}
