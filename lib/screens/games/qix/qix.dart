import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/qix/constants.dart' as game_constants;
import 'package:oracle_d_asgard/utils/int_vector2.dart';

typedef IsGridEdgeChecker = bool Function(IntVector2 position);
typedef IsPlayerPathChecker = bool Function(IntVector2 position);
typedef OnGameOver = void Function();

class QixComponent extends PositionComponent {
  final double cellSize;
  IntVector2 _gridPosition;
  IntVector2 _targetGridPosition; // For smooth movement
  IntVector2 _direction;
  final int gridSize;
  final IsGridEdgeChecker isGridEdge;
  final IsPlayerPathChecker isPlayerPath;
  final OnGameOver onGameOver;
  final ui.Image snakeHeadImage;
  final int difficulty;
  double _moveTimer = 0.0;
  final double _moveInterval; // Time in seconds to move one cell
  double _animationTime = 0.0; // For sinusoidal movement and rotation

  QixComponent({
    required IntVector2 gridPosition,
    required this.cellSize,
    required this.gridSize,
    required this.isGridEdge,
    required this.isPlayerPath,
    required this.onGameOver,
    required this.snakeHeadImage,
    required this.difficulty,
  }) : _gridPosition = gridPosition,
       _targetGridPosition = gridPosition, // Initialize target to current position
       _direction = _getRandomDirection(),
       _moveInterval =
           1.0 /
           (game_constants.kBaseMonsterSpeedCellsPerSecond + difficulty * game_constants.kMonsterSpeedChangePerLevelCellsPerSecond).clamp(
             1.0,
             double.infinity,
           ), // Monster speed increases with difficulty
       super(position: gridPosition.toVector2() * cellSize, size: Vector2.all(cellSize));

  IntVector2 get gridPosition => _gridPosition;
  set gridPosition(IntVector2 value) {
    _gridPosition = value;
    position = _gridPosition.toVector2() * cellSize;
  }

  @override
  void update(double dt) {
    super.update(dt);

    _animationTime += dt; // Update animation time for smooth effects

    // Smoothly move towards the target grid position
    Vector2 targetPixelPosition = _targetGridPosition.toVector2() * cellSize;
    final double moveSpeed = cellSize / _moveInterval; // Pixels per second

    // Move towards target
    position.moveToTarget(targetPixelPosition, moveSpeed * dt);

    // Check if monster has arrived at the target cell
    if (position.distanceTo(targetPixelPosition) < 0.1) {
      position = targetPixelPosition; // Snap to target to avoid floating point inaccuracies

      _moveTimer += dt; // Advance the timer only when at the target cell
      if (_moveTimer >= _moveInterval) {
        _moveTimer = 0.0; // Reset the timer

        _gridPosition = _targetGridPosition; // Update current grid position

        // Determine next direction based on potential bounces from _gridPosition
        IntVector2 potentialNextGridPosition = _gridPosition + _direction;
        IntVector2 newDirection = _direction;

        // Check for horizontal bounce
        if (isGridEdge(IntVector2(potentialNextGridPosition.x, _gridPosition.y))) {
          newDirection = newDirection * game_constants.kDirectionDownLeft;
        }

        // Check for vertical bounce
        if (isGridEdge(IntVector2(_gridPosition.x, potentialNextGridPosition.y))) {
          newDirection = newDirection * game_constants.kDirectionUpRight;
        }
        _direction = newDirection; // Update the monster's direction

        // Calculate new target grid position
        _targetGridPosition = _gridPosition + _direction;

        // Check for collision with player's path
        if (isPlayerPath(_targetGridPosition)) {
          onGameOver();
          return; // Stop further movement if game is over
        }

        // Ensure the Qix stays within bounds (this is still important for initial placement and edge cases)
        _targetGridPosition = _targetGridPosition.clamp(0, gridSize - 1, 0, gridSize - 1);
      }
    }
  }

  static IntVector2 _getRandomDirection() {
    final math.Random random = math.Random();
    final int directionIndex = random.nextInt(4);
    switch (directionIndex) {
      case 0:
        return game_constants.kDirectionDownLeft;
      case 1:
        return game_constants.kDirectionDownRight;
      case 2:
        return game_constants.kDirectionUpLeft;
      case 3:
      default:
        return game_constants.kDirectionUpRight;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Sinusoidal movement (slight up/down or left/right wobble)
    // Sinusoidal wobble and head bobbing
    final double wobbleMagnitude = cellSize * 2;
    final double wobbleFrequency = 5.0;
    final double wobbleOffset = math.sin(_animationTime * wobbleFrequency) * wobbleMagnitude;

    // Perpendicular vector for wobble
    final directionVector = Vector2(_direction.x.toDouble(), _direction.y.toDouble()).normalized();
    final renderOffset = Vector2(directionVector.y, -directionVector.x) * wobbleOffset;

    final double maxRotation = math.pi / 12;
    final double rotation = -math.cos(_animationTime * wobbleFrequency) * maxRotation;
    final double angle = math.atan2(_direction.y.toDouble(), _direction.x.toDouble()) + math.pi / 2;

    final center = Offset(size.x / 2, size.y / 2);

    canvas.save();
    canvas.translate(center.dx + renderOffset.x, center.dy + renderOffset.y);
    canvas.rotate(angle + rotation);
    canvas.translate(-center.dx, -center.dy);

    // Precompute imageRect only once
    final imageRect = Rect.fromCenter(center: center, width: size.x * 5, height: size.y * 5);

    final paint = Paint();
    canvas.drawImageRect(snakeHeadImage, Rect.fromLTWH(0, 0, snakeHeadImage.width.toDouble(), snakeHeadImage.height.toDouble()), imageRect, paint);

    canvas.restore();
  }
}
