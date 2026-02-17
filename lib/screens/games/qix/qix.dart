import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/qix/constants.dart'
    as game_constants;
import 'package:oracle_d_asgard/screens/games/qix/qix_game.dart';
import 'package:oracle_d_asgard/screens/games/qix/player.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

typedef IsGridEdgeChecker = bool Function(IntVector2 position);
typedef IsPlayerPathChecker = bool Function(IntVector2 position);
typedef IsFilledChecker = bool Function(IntVector2 position);
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
  final IsFilledChecker isFilled;
  final OnGameOver onGameOver;
  final ui.Image snakeHeadImage;
  final int difficulty;

  late Vector2 virtualPosition;
  late double _moveAngle;
  late double speed;

  IntVector2 get gridPosition {
    // Cache grid position calculation to avoid expensive round operations
    if (_lastCheckedVirtualPosition != virtualPosition) {
      _cachedGridPosition = IntVector2(
        (virtualPosition.x / cellSize).round(),
        (virtualPosition.y / cellSize).round(),
      );
      _lastCheckedVirtualPosition = virtualPosition.clone();
    }
    return _cachedGridPosition;
  }

  double _animationTime = 0.0;

  // Cache for rendering calculations
  late double _wobbleMagnitude;
  final Vector2 _cachedRenderOffset = Vector2.zero();
  final Vector2 _cachedVelocity = Vector2.zero();

  // Cache grid position to avoid recalculations
  IntVector2 _cachedGridPosition = IntVector2(0, 0);
  Vector2 _lastCheckedVirtualPosition = Vector2.zero();

  QixComponent({
    required IntVector2 initialGridPosition,
    required this.cellSize,
    required this.gridSize,
    required this.isGridEdge,
    required this.isPlayerPath,
    required this.isFilled,
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

    // Precalculate velocity
    _cachedVelocity.x = math.cos(_moveAngle) * speed;
    _cachedVelocity.y = math.sin(_moveAngle) * speed;

    final displacement = _cachedVelocity * dt;
    final distance = displacement.length;
    final stepCount = (distance / (cellSize / 2)).ceil();
    final stepDisplacement = stepCount > 0
        ? displacement / stepCount.toDouble()
        : Vector2.zero();

    var nextVirtualPosition = virtualPosition;
    bool collision = false;

    for (int i = 0; i < stepCount; i++) {
      var tempNextVirtualPosition = nextVirtualPosition + stepDisplacement;
      final tempNextGridPosition = IntVector2(
        (tempNextVirtualPosition.x / cellSize).round(),
        (tempNextVirtualPosition.y / cellSize).round(),
      );

      // Optimize: check grid edge first as it's faster (usually cached at boundaries)
      // and short-circuit if true to avoid expensive isFilled check
      final bool hitEdge = isGridEdge(tempNextGridPosition);
      final bool hitFilled = !hitEdge && isFilled(tempNextGridPosition);

      if (hitEdge || hitFilled) {
        collision = true;
        final currentGridPos = IntVector2(
          (nextVirtualPosition.x / cellSize).round(),
          (nextVirtualPosition.y / cellSize).round(),
        );

        // Optimize collision checks by avoiding redundant isFilled calls
        final horizontalPos = IntVector2(tempNextGridPosition.x, currentGridPos.y);
        final verticalPos = IntVector2(currentGridPos.x, tempNextGridPosition.y);

        final hitHorizontal =
            isGridEdge(horizontalPos) || isFilled(horizontalPos);
        final hitVertical =
            isGridEdge(verticalPos) || isFilled(verticalPos);

        if (hitHorizontal && hitVertical) {
          // Corner hit, reverse direction
          _moveAngle += math.pi;
        } else if (hitHorizontal) {
          _moveAngle = math.pi - _moveAngle; // Horizontal collision
        } else if (hitVertical) {
          _moveAngle = -_moveAngle; // Vertical collision
        } else {
          // Fallback, reverse direction
          _moveAngle += math.pi;
        }

        _moveAngle +=
            (math.Random().nextDouble() - 0.5) * _randomPerturbationFactor;
        break; // Exit loop on collision
      } else {
        nextVirtualPosition = tempNextVirtualPosition;
      }
    }

    if (!collision) {
      virtualPosition = nextVirtualPosition;
    }

    position = virtualPosition;

    // Only check player path collision if player is actually drawing
    // This avoids expensive contains() checks on empty/small lists
    if (game.player.state == PlayerState.drawing && isPlayerPath(gridPosition)) {
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
    canvas.translate(
      center.dx + _cachedRenderOffset.x,
      center.dy + _cachedRenderOffset.y,
    );
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
