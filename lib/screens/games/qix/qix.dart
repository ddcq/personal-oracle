import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/qix/constants.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

typedef IsGridEdgeChecker = bool Function(IntVector2 position);
typedef IsPlayerPathChecker = bool Function(IntVector2 position);
typedef OnGameOver = void Function();

class QixComponent extends PositionComponent {
  final double cellSize;
  IntVector2 _gridPosition;
  IntVector2 _direction;
  final int gridSize;
  final IsGridEdgeChecker isGridEdge;
  final IsPlayerPathChecker isPlayerPath;
  final OnGameOver onGameOver;
  final ui.Image snakeHeadImage;
  double _moveTimer = 0.0;
  final double _moveInterval = 0.1; // Move every 0.1 seconds

  QixComponent({
    required IntVector2 gridPosition,
    required this.cellSize,
    required this.gridSize,
    required this.isGridEdge,
    required this.isPlayerPath,
    required this.onGameOver,
    required this.snakeHeadImage,
  })  : _gridPosition = gridPosition,
        _direction = _getRandomDirection(),
        super(position: gridPosition.toVector2() * cellSize, size: Vector2.all(cellSize));

  IntVector2 get gridPosition => _gridPosition;
  set gridPosition(IntVector2 value) {
    _gridPosition = value;
    position = _gridPosition.toVector2() * cellSize;
  }

  @override
  void update(double dt) {
    super.update(dt);

    _moveTimer += dt;
    if (_moveTimer < _moveInterval) {
      return; // Not enough time has passed to move yet
    }
    _moveTimer = 0.0; // Reset the timer

    // Check for horizontal bounce
    if (isGridEdge(IntVector2(_gridPosition.x + _direction.x, _gridPosition.y))) {
      _direction = _direction * kDirectionDownLeft;
    }

    // Check for vertical bounce
    if (isGridEdge(IntVector2(_gridPosition.x, _gridPosition.y + _direction.y))) {
      _direction = _direction * kDirectionUpRight;
    }

    // Move the Qix
    _gridPosition = _gridPosition + _direction;

    // Check for collision with player's path
    if (isPlayerPath(_gridPosition)) {
      onGameOver();
      return; // Stop further movement if game is over
    }

    // Ensure the Qix stays within bounds (this is still important for initial placement and edge cases)
    _gridPosition = _gridPosition.clamp(0, gridSize - 1, 0, gridSize - 1);
    position = _gridPosition.toVector2() * cellSize;
  }

  static IntVector2 _getRandomDirection() {
    final Random random = Random();
    final int directionIndex = random.nextInt(4);
    switch (directionIndex) {
      case 0:
        return kDirectionDownLeft;
      case 1:
        return kDirectionDownRight;
      case 2:
        return kDirectionUpLeft;
      case 3:
      default:
        return kDirectionUpRight;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final angle = atan2(_direction.y.toDouble(), _direction.x.toDouble()) + pi / 2;
    final paint = Paint();
    final center = Offset(size.x / 2, size.y / 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);

    final imageSize = size * 5;
    final imageRect = Rect.fromCenter(center: center, width: imageSize.x, height: imageSize.y);

    canvas.drawImageRect(
      snakeHeadImage,
      Rect.fromLTWH(0, 0, snakeHeadImage.width.toDouble(), snakeHeadImage.height.toDouble()),
      imageRect,
      paint,
    );

    canvas.restore();
  }
}