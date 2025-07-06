import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'qix_game.dart';
import 'arena.dart';

class PlayerComponent extends PositionComponent with HasGameReference<QixGame> {
  final double gridSize;
  final double cellSize;
  Vector2 gridPosition;
  bool onEdge = true;
  List<Vector2> currentPath = [];
  Vector2? pathStartGridPosition;

  PlayerComponent({
    required this.gridSize,
    required this.cellSize,
    required QixGame gameRef,
  }) : gridPosition = Vector2(0, 0) {
    size = Vector2.all(cellSize);
    anchor = Anchor.topLeft;
    position = gridPosition * cellSize;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position = gridPosition * cellSize;
  }

  void move(Direction direction) {
    Vector2 newGridPosition = gridPosition.clone();

    switch (direction) {
      case Direction.up:
        newGridPosition.y--;
        break;
      case Direction.down:
        newGridPosition.y++;
        break;
      case Direction.left:
        newGridPosition.x--;
        break;
      case Direction.right:
        newGridPosition.x++;
        break;
    }

    // Clamp to grid boundaries
    newGridPosition.x = newGridPosition.x.clamp(0, gridSize - 1);
    newGridPosition.y = newGridPosition.y.clamp(0, gridSize - 1);

    // Check if moving off the edge or back onto it
    bool isNewPositionOnEdge = game.arena.isPointOnBoundary(newGridPosition);

    if (onEdge) {
      if (!isNewPositionOnEdge) {
        // Moving off the edge
        onEdge = false;
        pathStartGridPosition = gridPosition.clone();
        currentPath.add(gridPosition.clone());
        currentPath.add(newGridPosition.clone());
        game.arena.startPath(gridPosition.clone());
        game.arena.addPathPoint(newGridPosition.clone());
      }
      // If still on edge, just update position
      gridPosition = newGridPosition;
    } else {
      // Currently drawing a path
      if (isNewPositionOnEdge) {
        // Hit an existing boundary
        game.arena.addPathPoint(newGridPosition.clone());
        game.arena.fillArea(currentPath, pathStartGridPosition!, newGridPosition);
        onEdge = true;
        pathStartGridPosition = null;
        game.arena.endPath();
        currentPath.clear();
      } else {
        // Continue drawing path
        currentPath.add(newGridPosition.clone());
        game.arena.addPathPoint(newGridPosition.clone());
      }
      gridPosition = newGridPosition;
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.yellow;
    canvas.drawRect(size.toRect(), paint);

    
  }
}