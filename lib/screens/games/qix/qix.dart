import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/qix/constants.dart' as game_constants;
import 'package:oracle_d_asgard/screens/games/qix/qix_game.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

typedef IsGridEdgeChecker = bool Function(IntVector2 position);
typedef IsPlayerPathChecker = bool Function(IntVector2 position);
typedef OnGameOver = void Function();

class QixComponent extends PositionComponent with HasGameReference<QixGame> {
  final double cellSize;
  final int gridSize;
  final IsGridEdgeChecker isGridEdge;
  final IsPlayerPathChecker isPlayerPath;
  final OnGameOver onGameOver;
  final ui.Image snakeHeadImage;
  final int difficulty;

  late Vector2 virtualPosition;
  late double angle;
  late double speed;

  IntVector2 get gridPosition => IntVector2(
        (virtualPosition.x / cellSize).round(),
        (virtualPosition.y / cellSize).round(),
      );

  double _animationTime = 0.0;

  QixComponent({
    required IntVector2 initialGridPosition,
    required this.cellSize,
    required this.gridSize,
    required this.isGridEdge,
    required this.isPlayerPath,
    required this.onGameOver,
    required this.snakeHeadImage,
    required this.difficulty,
  }) : super(size: Vector2.all(cellSize)) {
    virtualPosition = initialGridPosition.toVector2() * cellSize;
    angle = math.Random().nextDouble() * 2 * math.pi;
    speed = (game_constants.kBaseMonsterSpeedCellsPerSecond +
            difficulty * game_constants.kMonsterSpeedChangePerLevelCellsPerSecond)
        .clamp(1.0, double.infinity) * cellSize;

    position = virtualPosition;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _animationTime += dt;

    // --- Homing logic ---
    final playerPosition = game.player.position;
    final vectorToPlayer = playerPosition - virtualPosition;
    final angleToPlayer = math.atan2(vectorToPlayer.y, vectorToPlayer.x);

    // Normalize angle difference to be between -pi and pi
    double angleDifference = angleToPlayer - angle;
    while (angleDifference < -math.pi) angleDifference += 2 * math.pi;
    while (angleDifference > math.pi) angleDifference -= 2 * math.pi;

    // Turn towards the player by 1 degree
    const double turnStep = 0.002; // 0.002 radians
    if (angleDifference.abs() > turnStep) {
      angle += angleDifference.sign * turnStep;
    } else {
      angle = angleToPlayer;
    }
    // --- End Homing logic ---

    // Calculate potential next position
    final double velocityX = math.cos(angle) * speed;
    final double velocityY = math.sin(angle) * speed;
    final nextVirtualPosition = virtualPosition + Vector2(velocityX, velocityY) * dt;
    final nextGridPosition = IntVector2(
      (nextVirtualPosition.x / cellSize).round(),
      (nextVirtualPosition.y / cellSize).round(),
    );

    // Collision detection using isGridEdge
    if (isGridEdge(nextGridPosition)) {
      final currentGridPos = gridPosition;
      bool bounced = false;

      // Check for horizontal collision (hitting a vertical wall)
      if (isGridEdge(IntVector2(nextGridPosition.x, currentGridPos.y))) {
        angle = math.pi - angle;
        bounced = true;
      }
      
      // Check for vertical collision (hitting a horizontal wall)
      if (isGridEdge(IntVector2(currentGridPos.x, nextGridPosition.y))) {
        angle = -angle;
        bounced = true;
      }

      if (!bounced) {
        angle = angle + math.pi; 
      }

      angle += (math.Random().nextDouble() - 0.5) * 0.6; // Increased random perturbation

    } else {
      virtualPosition = nextVirtualPosition;
    }

    position = virtualPosition;

    if (isPlayerPath(gridPosition)) {
      onGameOver();
      return;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final double wobbleMagnitude = cellSize * 0.25; // Restored magnitude for a visible effect
    final double wobbleFrequency = 5.0;
    final double wobbleOffset = math.sin(_animationTime * wobbleFrequency) * wobbleMagnitude;

    final perpendicularAngle = angle + math.pi / 2;
    final renderOffset = Vector2(math.cos(perpendicularAngle), math.sin(perpendicularAngle)) * wobbleOffset;

    final double maxRotation = math.pi / 12;
    final double rotation = -math.cos(_animationTime * wobbleFrequency) * maxRotation;
    final double visualAngle = angle + math.pi / 2;

    final center = Offset(size.x / 2, size.y / 2);

    canvas.save();
    canvas.translate(center.dx + renderOffset.x, center.dy + renderOffset.y);
    canvas.rotate(visualAngle + rotation);
    canvas.translate(-center.dx, -center.dy);

    final imageRect = Rect.fromCenter(center: center, width: size.x * 5, height: size.y * 5);
    final paint = Paint();
    canvas.drawImageRect(snakeHeadImage, Rect.fromLTWH(0, 0, snakeHeadImage.width.toDouble(), snakeHeadImage.height.toDouble()), imageRect, paint);

    canvas.restore();
  }
}