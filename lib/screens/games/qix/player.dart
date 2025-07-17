import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'qix_game.dart';

import 'constants.dart' as game_constants;
import 'constants.dart';

enum PlayerState { onEdge, drawing, dead }

class Player extends PositionComponent with HasGameReference<QixGame> {
  final double gridSize;
  final double cellSize;
  Vector2 gridPosition; // Logical grid position
  Vector2 targetGridPosition; // Target grid position for smooth movement
  final double _moveSpeed = 200.0; // Pixels per second

  PlayerState state = PlayerState.onEdge;
  List<Vector2> currentPath = [];
  Vector2? pathStartGridPosition;
  Direction? currentDirection; // Current direction for automatic movement
  bool _isManualInput = false; // True if the last direction change was from user input

  Player({
    required this.gridSize,
    required this.cellSize,
  }) : gridPosition = Vector2(0, 0),
       targetGridPosition = Vector2(0, 0) {
    size = Vector2.all(cellSize);
    anchor = Anchor.topLeft;
    position = gridPosition * cellSize;
  }

  void setDirection(Direction? direction, {bool isManual = false}) {
    if (isManual) {
      bool originalIsManualInput = _isManualInput;
      _isManualInput = true; // Temporarily set to true for _canMove check
      if (direction != null && _canMove(direction)) {
        currentDirection = direction;
        _isManualInput = true; // Set permanently for manual input
      } else {
        _isManualInput = originalIsManualInput; // Revert if move is impossible
      }
    } else {
      currentDirection = direction;
      _isManualInput = isManual;
    }
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
              _isManualInput = false; // Automatically chosen path is not manual
              move(currentDirection!); // Move in the new direction
            } else {
              currentDirection = null; // Stop automatic movement if multiple or no options
              _isManualInput = false; // Reset manual input flag
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

    // Check if the new position is traversable
    if (!game.arena.isTraversable(newGridPosition.x.toInt(), newGridPosition.y.toInt())) {
      return false;
    }

    // If on edge, only allow moving off the edge with manual input
    bool isNewPositionOnEdge = game.arena.getGridValue(newGridPosition.x.toInt(), newGridPosition.y.toInt()) == game_constants.kGridEdge;
    if (state == PlayerState.onEdge && !isNewPositionOnEdge && !_isManualInput) {
      return false;
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

    bool isNewPositionOnEdge = game.arena.getGridValue(newGridPosition.x.toInt(), newGridPosition.y.toInt()) == game_constants.kGridEdge;

    if (state == PlayerState.onEdge) {
      if (!isNewPositionOnEdge) {
        // Moving off the edge
        state = PlayerState.drawing;
        pathStartGridPosition = gridPosition.clone();
        currentPath.add(gridPosition.clone());
        currentPath.add(newGridPosition.clone());
        game.arena.startPath(gridPosition.clone());
        game.arena.addPathPoint(newGridPosition.clone());
      }
      // If still on edge, just update target position
      targetGridPosition = newGridPosition;
    } else if (state == PlayerState.drawing) {
      // Currently drawing a path
      if (isNewPositionOnEdge) {
        // Hit an existing boundary
        game.arena.addPathPoint(newGridPosition.clone());
        state = PlayerState.onEdge;
        game.onPlayerStateChanged(state);

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
    final paint = Paint()..color = Colors.red;
    canvas.drawRect(size.toRect(), paint);

    
  }
}