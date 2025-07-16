import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'qix_game.dart';

import 'constants.dart' as game_constants;

enum Direction { up, down, left, right }

class Player extends PositionComponent with HasGameReference<QixGame> {
  final double gridSize;
  final double cellSize;
  Vector2 gridPosition; // Logical grid position
  Vector2 targetGridPosition; // Target grid position for smooth movement
  final double _moveSpeed = 200.0; // Pixels per second

  bool onEdge = true;
  List<Vector2> currentPath = [];
  Vector2? pathStartGridPosition;
  Direction? currentDirection; // Current direction for automatic movement

  Player({
    required this.gridSize,
    required this.cellSize,
  }) : gridPosition = Vector2(0, 0),
       targetGridPosition = Vector2(0, 0) {
    size = Vector2.all(cellSize);
    anchor = Anchor.topLeft;
    position = gridPosition * cellSize;
  }

  void setDirection(Direction? direction) {
    currentDirection = direction;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Smoothly move towards the target grid position
    Vector2 targetPixelPosition = targetGridPosition * cellSize;
    if (position.distanceTo(targetPixelPosition) > 0.1) {
      position.moveToTarget(targetPixelPosition, _moveSpeed * dt);
    } else {
      position = targetPixelPosition; // Snap to target to avoid floating point inaccuracies
      gridPosition = targetGridPosition.clone(); // Update logical grid position

      // If player has reached target, and there's a current direction, move again
      if (currentDirection != null) {
        bool moved = move(currentDirection!);
        if (!moved) {
          // Player cannot move in the current direction, find alternatives
          List<Direction> possibleDirections = [];
          List<Direction> allDirections = [Direction.up, Direction.down, Direction.left, Direction.right];

          // Determine the opposite direction to prevent U-turns
          Direction? oppositeDirection;
          if (currentDirection == Direction.up) {
            oppositeDirection = Direction.down;
          } else if (currentDirection == Direction.down) {
            oppositeDirection = Direction.up;
          } else if (currentDirection == Direction.left) {
            oppositeDirection = Direction.right;
          } else if (currentDirection == Direction.right) {
            oppositeDirection = Direction.left;
          }

          for (Direction dir in allDirections) {
            if (dir != oppositeDirection && _canMove(dir)) {
              possibleDirections.add(dir);
            }
          }

          if (possibleDirections.length == 1) {
            currentDirection = possibleDirections.first;
            move(currentDirection!); // Move in the new direction
          } else {
            currentDirection = null; // Stop automatic movement if multiple or no options
          }
        }
      }
    }
  }

  bool _canMove(Direction direction) {
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

    // Check if the new position is within bounds after clamping
    if (newGridPosition.x == gridPosition.x && newGridPosition.y == gridPosition.y) {
      return false; // Cannot move further in this direction (hit boundary)
    }

    bool isNewPositionTrulyOnEdge = game.arena.getGridValue(newGridPosition.x.toInt(), newGridPosition.y.toInt()) == game_constants.kGridEdge;

    if (onEdge) {
      // If on edge, prevent moving into an already filled area that is not a boundary
      if (game.arena.isFilled(newGridPosition.x.toInt(), newGridPosition.y.toInt()) && !isNewPositionTrulyOnEdge) {
        return false; // Do not move into a filled non-boundary area
      }
    }
    return true;
  }

  bool move(Direction direction) {
    // Only allow new move if player has reached the current target
    if (position.distanceTo(targetGridPosition * cellSize) > 0.1) {
      return false;
    }

    if (!_canMove(direction)) {
      return false;
    }

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
    bool isNewPositionTrulyOnEdge = game.arena.getGridValue(newGridPosition.x.toInt(), newGridPosition.y.toInt()) == game_constants.kGridEdge;

    if (onEdge) {
      if (!isNewPositionTrulyOnEdge) {
        // Moving off the edge
        onEdge = false;
        pathStartGridPosition = gridPosition.clone();
        currentPath.add(gridPosition.clone());
        currentPath.add(newGridPosition.clone());
        game.arena.startPath(gridPosition.clone());
        game.arena.addPathPoint(newGridPosition.clone());
      }
      // If still on edge, just update target position
      targetGridPosition = newGridPosition;
    } else {
      // Currently drawing a path
      if (isNewPositionTrulyOnEdge) {
        // Hit an existing boundary
        game.arena.addPathPoint(newGridPosition.clone());
        game.arena.fillArea(currentPath, pathStartGridPosition!, newGridPosition);
        onEdge = true;
        pathStartGridPosition = null;
        game.arena.endPath();
        currentPath.clear();

        // After filling, ensure player is on a boundary. If not, teleport to nearest boundary point.
        debugPrint('Player hit boundary at $newGridPosition. Filling area...');
        if (!game.arena.isPointOnBoundary(newGridPosition)) {
          Vector2 nearestBoundary = game.arena.findNearestBoundaryPoint(newGridPosition);
          debugPrint('Player not on boundary after fill. Teleporting to nearest boundary at $nearestBoundary');
          targetGridPosition = nearestBoundary;
          gridPosition = nearestBoundary; // Snap immediately for teleportation
        } else {
          debugPrint('Player remains on boundary at $newGridPosition after fill.');
        }
      } else {
        // Continue drawing path
        currentPath.add(newGridPosition.clone());
        game.arena.addPathPoint(newGridPosition.clone());
      }
      targetGridPosition = newGridPosition;
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.yellow;
    canvas.drawRect(size.toRect(), paint);

    
  }
}