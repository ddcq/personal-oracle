import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/qix/constants.dart'
    as game_constants;
import 'package:oracle_d_asgard/screens/games/qix/qix_game.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

typedef IsGridEdgeChecker = bool Function(IntVector2 position);
typedef IsPlayerPathChecker = bool Function(IntVector2 position);
typedef OnGameOver = void Function();

class QixComponent extends PositionComponent with HasGameReference<QixGame> {
  static const double _turnStep = 0.002;
  static const double _randomPerturbationFactor = 0.6;
  static const double _wobbleMagnitudeFactor = 0.25;
  static const double _wobbleFrequency = 5.0;
  static const double _maxRotationFactor = 1 / 12;
  static const double _imageScaleFactor = 5.0;

  final double cellSize;
  final int gridSize;
  final IsGridEdgeChecker isGridEdge;
  final IsPlayerPathChecker isPlayerPath;
  final OnGameOver onGameOver;
  final ui.Image snakeHeadImage;
  final int difficulty;

  late Vector2 virtualPosition;
  late double _moveAngle;
  late double speed;

  IntVector2 get gridPosition => IntVector2(
    (virtualPosition.x / cellSize).round(),
    (virtualPosition.y / cellSize).round(),
  );

  double _animationTime = 0.0;
  
  // Cache for rendering calculations
  late double _wobbleMagnitude;
  final Vector2 _cachedRenderOffset = Vector2.zero();
  final Vector2 _cachedVelocity = Vector2.zero();

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
    _moveAngle = math.Random().nextDouble() * 2 * math.pi;
    speed =
        (game_constants.kBaseMonsterSpeedCellsPerSecond +
                difficulty *
                    game_constants.kMonsterSpeedChangePerLevelCellsPerSecond)
            .clamp(1.0, double.infinity) *
        cellSize;
    _wobbleMagnitude = cellSize * _wobbleMagnitudeFactor;
    position = virtualPosition;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _animationTime += dt;

    // Homing logic
    final playerPosition = game.player.position;
    final vectorToPlayer = playerPosition - virtualPosition;
    final angleToPlayer = math.atan2(vectorToPlayer.y, vectorToPlayer.x);

    double angleDifference = angleToPlayer - _moveAngle;
    while (angleDifference < -math.pi) {
      angleDifference += 2 * math.pi;
    }
    while (angleDifference > math.pi) {
      angleDifference -= 2 * math.pi;
    }

    if (angleDifference.abs() > _turnStep) {
      _moveAngle += angleDifference.sign * _turnStep;
    } else {
      _moveAngle = angleToPlayer;
    }

    // Precalculate velocity (reused)
    _cachedVelocity.x = math.cos(_moveAngle) * speed;
    _cachedVelocity.y = math.sin(_moveAngle) * speed;
    
    final nextVirtualPosition = virtualPosition + _cachedVelocity * dt;
    final nextGridPosition = IntVector2(
      (nextVirtualPosition.x / cellSize).round(),
      (nextVirtualPosition.y / cellSize).round(),
    );

    // Simplified collision detection
    if (isGridEdge(nextGridPosition)) {
      final currentGridPos = gridPosition;
      bool bounced = false;

      if (isGridEdge(IntVector2(nextGridPosition.x, currentGridPos.y))) {
        _moveAngle = math.pi - _moveAngle;
        bounced = true;
      }

      if (isGridEdge(IntVector2(currentGridPos.x, nextGridPosition.y))) {
        _moveAngle = -_moveAngle;
        bounced = true;
      }

      if (!bounced) {
        _moveAngle = _moveAngle + math.pi;
      }

      _moveAngle += (math.Random().nextDouble() - 0.5) * _randomPerturbationFactor;
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

    final double wobbleOffset =
        math.sin(_animationTime * _wobbleFrequency) * _wobbleMagnitude;

    final perpendicularAngle = _moveAngle + math.pi / 2;
    _cachedRenderOffset.x = math.cos(perpendicularAngle) * wobbleOffset;
    _cachedRenderOffset.y = math.sin(perpendicularAngle) * wobbleOffset;

    final double maxRotation = math.pi * _maxRotationFactor;
    final double rotation =
        -math.cos(_animationTime * _wobbleFrequency) * maxRotation;
    final double visualAngle = _moveAngle + math.pi / 2;

    final center = Offset(size.x / 2, size.y / 2);

    canvas.save();
    canvas.translate(center.dx + _cachedRenderOffset.x, center.dy + _cachedRenderOffset.y);
    canvas.rotate(visualAngle + rotation);
    canvas.translate(-center.dx, -center.dy);

    final imageRect = Rect.fromCenter(
      center: center,
      width: size.x * _imageScaleFactor,
      height: size.y * _imageScaleFactor,
    );
    final paint = Paint();
    canvas.drawImageRect(
      snakeHeadImage,
      Rect.fromLTWH(
        0,
        0,
        snakeHeadImage.width.toDouble(),
        snakeHeadImage.height.toDouble(),
      ),
      imageRect,
      paint,
    );

    canvas.restore();
  }
}
