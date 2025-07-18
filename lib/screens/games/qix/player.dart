import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'qix_game.dart';

import 'constants.dart' as game_constants;
import 'constants.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

enum PlayerState { onEdge, drawing, dead }

class Player extends PositionComponent with HasGameReference<QixGame> {
  final int gridSize;
  final double cellSize;
  IntVector2 gridPosition; // Logical grid position
  IntVector2 targetGridPosition; // Target grid position for smooth movement
  final double _moveSpeed = 200.0; // Pixels per second

  PlayerState state = PlayerState.onEdge;
  List<IntVector2> currentPath = [];
  IntVector2? pathStartGridPosition;
  Direction? currentDirection; // Current direction for automatic movement
  bool _isManualInput = false; // True if the last direction change was from user input

  Player({
    required this.gridSize,
    required this.cellSize,
  }) : gridPosition = IntVector2(0, 0),
       targetGridPosition = IntVector2(0, 0) {
    size = Vector2.all(cellSize);
    anchor = Anchor.topLeft;
    position = gridPosition.toVector2() * cellSize;
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
    Vector2 targetPixelPosition = targetGridPosition.toVector2() * cellSize;
    if (position.distanceTo(targetPixelPosition) > 0.1) {
      position.moveToTarget(targetPixelPosition, _moveSpeed * dt);
    } else {
      position = targetPixelPosition; // Snap to target to avoid floating point inaccuracies
      gridPosition = targetGridPosition; // Update logical grid position

      // If player has reached target, and there's a current direction, move again
      if (currentDirection != null) {
        bool moved = move(currentDirection!);
        if (!moved) {
          // Player cannot move in the current direction, find alternatives
          _findNextAutoDirection();
          if (currentDirection != null) {
            move(currentDirection!); // Move in the new direction
          }
          }
        }
    }
  }

  void _findNextAutoDirection() {
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
      if (dir != oppositeDirection) {
        bool canMoveResult = _canMove(dir);
        if (canMoveResult) {
          possibleDirections.add(dir);
        }
      }
    }

    if (state == PlayerState.onEdge) {
      List<Direction> edgeDirections = [];
      for (Direction dir in possibleDirections) {
        IntVector2 nextPos = _getNextGridPosition(dir);
        bool isNextPosEdge = game.arena.getGridValue(nextPos.x, nextPos.y) == game_constants.kGridEdge;
        if (isNextPosEdge) {
          edgeDirections.add(dir);
        }
      }

      if (edgeDirections.length == 1) {
        currentDirection = edgeDirections.first;
        _isManualInput = false;
      } else if (edgeDirections.length > 1) {
        // Prioritize continuing straight if possible
        if (currentDirection != null && edgeDirections.contains(currentDirection)) {
          currentDirection = currentDirection;
          _isManualInput = false;
        } else {
          // If no straight continuation, pick the first available edge direction
          currentDirection = edgeDirections.first;
          _isManualInput = false;
        }
      } else {
        currentDirection = null;
        _isManualInput = false;
      }
    } else {
      // Original logic for drawing state
      if (possibleDirections.length == 1) {
        currentDirection = possibleDirections.first;
        _isManualInput = false;
      } else {
        currentDirection = null;
        _isManualInput = false;
      }
    }
  }

  bool _canMove(Direction direction) {
    IntVector2 newGridPosition;
    switch (direction) {
      case Direction.up:
        newGridPosition = IntVector2(gridPosition.x, gridPosition.y - 1);
        break;
      case Direction.down:
        newGridPosition = IntVector2(gridPosition.x, gridPosition.y + 1);
        break;
      case Direction.left:
        newGridPosition = IntVector2(gridPosition.x - 1, gridPosition.y);
        break;
      case Direction.right:
        newGridPosition = IntVector2(gridPosition.x + 1, gridPosition.y);
        break;
    }

    // Clamp to grid boundaries
    newGridPosition = newGridPosition.clamp(0, gridSize - 1, 0, gridSize - 1);

    // If automatic movement, prevent moving to the same spot
    if (!_isManualInput && newGridPosition == gridPosition) {
      return false;
    }

    // Check if the new position is within bounds after clamping
    if (!newGridPosition.isInBounds(0, gridSize - 1, 0, gridSize - 1)) {
      return false; // Cannot move further in this direction (hit boundary)
    }

    // Check if the new position is traversable
    if (!game.arena.isTraversable(newGridPosition.x, newGridPosition.y)) {
      return false;
    }

    // If on edge, only allow moving off the edge with manual input
    bool isNewPositionOnEdge = game.arena.getGridValue(newGridPosition.x, newGridPosition.y) == game_constants.kGridEdge;
    if (state == PlayerState.onEdge && !isNewPositionOnEdge && !_isManualInput) {
      return false;
    }
    return true;
  }

  bool move(Direction direction) {
    // Only allow new move if player has reached the current target
    if (position.distanceTo(targetGridPosition.toVector2() * cellSize) > 0.1) {
      return false;
    }

    if (!_canMove(direction)) {
      return false;
    }

    IntVector2 newGridPosition;

    switch (direction) {
      case Direction.up:
        newGridPosition = IntVector2(gridPosition.x, gridPosition.y - 1);
        break;
      case Direction.down:
        newGridPosition = IntVector2(gridPosition.x, gridPosition.y + 1);
        break;
      case Direction.left:
        newGridPosition = IntVector2(gridPosition.x - 1, gridPosition.y);
        break;
      case Direction.right:
        newGridPosition = IntVector2(gridPosition.x + 1, gridPosition.y);
        break;
    }

    // Clamp to grid boundaries
    newGridPosition = newGridPosition.clamp(0, gridSize - 1, 0, gridSize - 1);

    bool isNewPositionOnEdge = game.arena.getGridValue(newGridPosition.x, newGridPosition.y) == game_constants.kGridEdge;

    if (state == PlayerState.onEdge) {
      if (!isNewPositionOnEdge) {
        // Moving off the edge
        state = PlayerState.drawing;
        pathStartGridPosition = IntVector2(gridPosition.x, gridPosition.y);
        currentPath.add(IntVector2(gridPosition.x, gridPosition.y));
        currentPath.add(IntVector2(newGridPosition.x, newGridPosition.y));
        game.arena.startPath(IntVector2(gridPosition.x, gridPosition.y));
        game.arena.addPathPoint(IntVector2(newGridPosition.x, newGridPosition.y));
      }
      // If still on edge, just update target position
      targetGridPosition = newGridPosition;
    } else if (state == PlayerState.drawing) {
      // Currently drawing a path
      if (isNewPositionOnEdge) {
        // Hit an existing boundary
        game.arena.addPathPoint(IntVector2(newGridPosition.x, newGridPosition.y));
        state = PlayerState.onEdge;
        game.onPlayerStateChanged(state);

        // After filling, ensure player is on a boundary. If not, teleport to nearest boundary point.
        
        if (!game.arena.isPointOnBoundary(newGridPosition)) {
          IntVector2 nearestBoundary = game.arena.findNearestBoundaryPoint(newGridPosition);
          
          targetGridPosition = nearestBoundary;
          gridPosition = nearestBoundary; // Snap immediately for teleportation
        } else {
          
        }
      } else {
        // Continue drawing path
        currentPath.add(IntVector2(newGridPosition.x, newGridPosition.y));
        game.arena.addPathPoint(IntVector2(newGridPosition.x, newGridPosition.y));
      }
      targetGridPosition = newGridPosition;
    }

    // If the player is on an edge and the new position is the same as the current position
    // (meaning they hit a boundary and couldn't move further in that direction),
    // return false to trigger _findNextAutoDirection.
    if (state == PlayerState.onEdge && newGridPosition == gridPosition) {
      return false;
    }

    return true;
  }

  @override
  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.red;
    canvas.drawRect(size.toRect(), paint);

    
  }

  IntVector2 _getNextGridPosition(Direction direction) {
    IntVector2 nextPos;
    switch (direction) {
      case Direction.up:
        nextPos = IntVector2(gridPosition.x, gridPosition.y - 1);
        break;
      case Direction.down:
        nextPos = IntVector2(gridPosition.x, gridPosition.y + 1);
        break;
      case Direction.left:
        nextPos = IntVector2(gridPosition.x - 1, gridPosition.y);
        break;
      case Direction.right:
        nextPos = IntVector2(gridPosition.x + 1, gridPosition.y);
        break;
    }
    return nextPos.clamp(0, gridSize - 1, 0, gridSize - 1);
  }
}