import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

typedef IsGridEdgeChecker = bool Function(IntVector2 position);

class QixComponent extends PositionComponent {
  final double cellSize;
  IntVector2 _gridPosition;
  IntVector2 _direction;
  final int gridSize;
  final IsGridEdgeChecker isGridEdge;
  double _moveTimer = 0.0;
  final double _moveInterval = 0.1; // Move every 0.1 seconds

  QixComponent({
    required IntVector2 gridPosition,
    required this.cellSize,
    required this.gridSize,
    required this.isGridEdge,
  })  : _gridPosition = gridPosition,
        _direction = const IntVector2(1, 1), // Initial direction (down-right)
        super(position: gridPosition.toVector2() * cellSize, size: Vector2.all(cellSize));

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
      _direction = IntVector2(-_direction.x, _direction.y);
    }

    // Check for vertical bounce
    if (isGridEdge(IntVector2(_gridPosition.x, _gridPosition.y + _direction.y))) {
      _direction = IntVector2(_direction.x, -_direction.y);
    }

    // Move the Qix
    _gridPosition = _gridPosition + _direction;

    // Ensure the Qix stays within bounds (this is still important for initial placement and edge cases)
    _gridPosition = _gridPosition.clamp(0, gridSize - 1, 0, gridSize - 1);
    position = _gridPosition.toVector2() * cellSize;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw a simple circle for now to represent the Qix
    final paint = Paint()..color = Colors.red;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), cellSize / 2, paint);
  }
}