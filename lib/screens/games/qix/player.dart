import 'package:flame/components.dart';
import 'package:flutter/foundation.dart'; // Import for VoidCallback
import 'dart:ui' as ui; // For Image
import 'package:oracle_d_asgard/screens/games/qix/arena.dart';

import 'package:oracle_d_asgard/screens/games/qix/constants.dart'
    as game_constants;
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/components/animated_character_component.dart'; // Import AnimatedCharacterComponent

enum PlayerState { onEdge, drawing, dead, rescued }

class Player extends PositionComponent {
  static const int _characterIndex = 0;
  static const double _characterSpriteScale = 6.0;
  static const double _positionSnapThreshold = 0.1;

  final ArenaComponent arena;
  final Function(PlayerState) onPlayerStateChanged;
  final VoidCallback onSelfIntersection; // Add this line
  final int gridSize;
  final double cellSize;
  IntVector2 gridPosition; // Logical grid position
  IntVector2 targetGridPosition; // Target grid position for smooth movement
  late final double _moveSpeed; // Pixels per second
  final int difficulty;

  PlayerState state = PlayerState.onEdge;
  List<IntVector2> currentPath = [];
  IntVector2? pathStartGridPosition;
  dp.Direction? currentDirection; // Current direction for automatic movement
  bool _isManualInput =
      false; // True if the last direction change was from user input

  late AnimatedCharacterComponent _characterSprite;

  Player({
    required this.gridSize,
    required this.cellSize,
    required ui.Image characterSpriteSheet,
    required this.arena,
    required this.onPlayerStateChanged,
    required this.onSelfIntersection,
    required this.difficulty,
  }) : gridPosition = IntVector2(0, 0),
       targetGridPosition = IntVector2(0, 0) {
    size = Vector2.all(cellSize);
    anchor = Anchor.topLeft;
    position = gridPosition.toVector2() * cellSize;
    final double playerSpeedCellsPerSecond =
        (game_constants.kBasePlayerSpeedCellsPerSecond -
                difficulty *
                    game_constants.kPlayerSpeedChangePerLevelCellsPerSecond)
            .clamp(
              1.0,
              double.infinity,
            ); // Ensure speed doesn't go below 1 cell/sec
    _moveSpeed = playerSpeedCellsPerSecond * cellSize;
    _characterSprite = AnimatedCharacterComponent(
      characterSpriteSheet: characterSpriteSheet,
      characterIndex: _characterIndex, // Character1
      size: Vector2.all(
        cellSize * _characterSpriteScale,
      ), // 4 times the cell size
      anchor: Anchor.center, // Center the sprite on the player component
      position: Vector2.all(
        cellSize / 2,
      ), // Center the character within the cell
    );
    add(_characterSprite);
  }

  void setDirection(dp.Direction? direction, {bool isManual = false}) {
    if (isManual) {
      // Prevent U-turn only when drawing a path
      if (state == PlayerState.drawing &&
          direction != null &&
          currentDirection != null &&
          direction == _getOppositeDirection(currentDirection)) {
        return; // Ignore U-turn input while drawing
      }

      bool originalIsManualInput = _isManualInput;
      _isManualInput = true; // Temporarily set to true for _canMove check
      if (direction != null && _canMove(direction)) {
        currentDirection = direction;
        _isManualInput = true; // Set permanently for manual input
      } else {
        _isManualInput = originalIsManualInput; // Revert if move is impossible;
      }
    } else {
      currentDirection = direction;
      _isManualInput = isManual;
    }
    // Update the character sprite's direction
    _characterSprite.direction = _mapDirectionToCharacterDirection(
      currentDirection,
    );
  }

  // Helper to map Flame Direction to CharacterDirection
  CharacterDirection _mapDirectionToCharacterDirection(
    dp.Direction? direction,
  ) {
    switch (direction) {
      case dp.Direction.up:
        return CharacterDirection.up;
      case dp.Direction.down:
        return CharacterDirection.down;
      case dp.Direction.left:
        return CharacterDirection.left;
      case dp.Direction.right:
        return CharacterDirection.right;
      default:
        return CharacterDirection.down; // Default direction
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (state == PlayerState.rescued) {
      state = PlayerState.onEdge;
      return;
    }

    // Smoothly move towards the target grid position
    Vector2 targetPixelPosition = targetGridPosition.toVector2() * cellSize;
    if (position.distanceTo(targetPixelPosition) > _positionSnapThreshold) {
      position.moveToTarget(targetPixelPosition, _moveSpeed * dt);
    } else {
      position =
          targetPixelPosition; // Snap to target to avoid floating point inaccuracies
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
    dp.Direction? oppositeDirection = _getOppositeDirection(currentDirection);
    List<dp.Direction> possibleDirections = _getPossibleDirections(
      oppositeDirection,
    );

    if (state == PlayerState.onEdge) {
      _handleOnEdgeState(possibleDirections);
    } else {
      _handleDrawingState(possibleDirections);
    }
    // Update the character sprite's direction after currentDirection might have changed
    _characterSprite.direction = _mapDirectionToCharacterDirection(
      currentDirection,
    );
  }

  dp.Direction? _getOppositeDirection(dp.Direction? direction) {
    switch (direction) {
      case dp.Direction.up:
        return dp.Direction.down;
      case dp.Direction.down:
        return dp.Direction.up;
      case dp.Direction.left:
        return dp.Direction.right;
      case dp.Direction.right:
        return dp.Direction.left;
      default:
        return null;
    }
  }

  List<dp.Direction> _getPossibleDirections(dp.Direction? oppositeDirection) {
    List<dp.Direction> possibleDirections = [];
    List<dp.Direction> allDirections = [
      dp.Direction.up,
      dp.Direction.down,
      dp.Direction.left,
      dp.Direction.right,
    ];

    for (dp.Direction dir in allDirections) {
      if (dir != oppositeDirection) {
        bool canMoveResult = _canMove(dir);
        if (canMoveResult) {
          possibleDirections.add(dir);
        }
      }
    }
    return possibleDirections;
  }

  void _handleOnEdgeState(List<dp.Direction> possibleDirections) {
    List<dp.Direction> edgeDirections = [];
    for (dp.Direction dir in possibleDirections) {
      IntVector2 nextPos = _getNewGridPosition(dir);
      bool isNextPosEdge =
          arena.getGridValue(nextPos.x, nextPos.y) == game_constants.kGridEdge;
      if (isNextPosEdge) {
        edgeDirections.add(dir);
      }
    }

    if (edgeDirections.length == 1) {
      currentDirection = edgeDirections.first;
      _isManualInput = false;
    } else if (edgeDirections.length > 1) {
      // Prioritize continuing straight if possible
      if (currentDirection != null &&
          edgeDirections.contains(currentDirection)) {
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
  }

  void _handleDrawingState(List<dp.Direction> possibleDirections) {
    if (possibleDirections.length == 1) {
      currentDirection = possibleDirections.first;
      _isManualInput = false;
    } else {
      currentDirection = null;
      _isManualInput = false;
    }
  }

  bool _canMove(dp.Direction direction) {
    IntVector2 newGridPosition = _getNewGridPosition(direction);

    // Clamp to grid boundaries
    newGridPosition = newGridPosition.clamp(0, gridSize - 1, 0, gridSize - 1);

    // If automatic movement, prevent moving to the same spot
    if (!_isManualInput && newGridPosition == gridPosition) {
      return false;
    }

    // Check if the new position is within bounds after clamping
    if (!_isWithinBounds(newGridPosition)) {
      return false; // Cannot move further in this direction (hit boundary)
    }

    // Check if the new position is traversable
    if (!_isTraversable(newGridPosition)) {
      return false;
    }

    // If on edge, only allow moving off the edge with manual input
    if (state == PlayerState.onEdge && _isMovingOffEdge(newGridPosition)) {
      return false;
    }
    return true;
  }

  bool _isWithinBounds(IntVector2 position) {
    return position.isInBounds(0, gridSize - 1, 0, gridSize - 1);
  }

  bool _isTraversable(IntVector2 position) {
    return arena.isTraversable(position.x, position.y);
  }

  bool _isMovingOffEdge(IntVector2 newGridPosition) {
    bool isNewPositionOnEdge =
        arena.getGridValue(newGridPosition.x, newGridPosition.y) ==
        game_constants.kGridEdge;
    return !isNewPositionOnEdge && !_isManualInput;
  }

  bool move(dp.Direction direction) {
    // Only allow new move if player has reached the current target
    if (position.distanceTo(targetGridPosition.toVector2() * cellSize) >
        _positionSnapThreshold) {
      return false;
    }

    if (!_canMove(direction)) {
      return false;
    }

    IntVector2 newGridPosition = _getNewGridPosition(direction);

    // Clamp to grid boundaries
    newGridPosition = newGridPosition.clamp(0, gridSize - 1, 0, gridSize - 1);

    if (state == PlayerState.onEdge) {
      _handleOnEdgeMovement(newGridPosition);
    } else if (state == PlayerState.drawing) {
      _handleDrawingMovement(newGridPosition);
    }

    // If the player is on an edge and the new position is the same as the current position
    // (meaning they hit a boundary and couldn’t move further in that direction),
    // return false to trigger _findNextAutoDirection.
    if (state == PlayerState.onEdge && newGridPosition == gridPosition) {
      return false;
    }

    return true;
  }

  void _handleOnEdgeMovement(IntVector2 newGridPosition) {
    bool isNewPositionOnEdge =
        arena.getGridValue(newGridPosition.x, newGridPosition.y) ==
        game_constants.kGridEdge;
    if (!isNewPositionOnEdge) {
      // Moving off the edge
      state = PlayerState.drawing;
      pathStartGridPosition = IntVector2(gridPosition.x, gridPosition.y);
      currentPath.add(IntVector2(gridPosition.x, gridPosition.y));
      currentPath.add(IntVector2(newGridPosition.x, newGridPosition.y));
      arena.startPath(IntVector2(gridPosition.x, gridPosition.y));
      arena.addPathPoint(IntVector2(newGridPosition.x, newGridPosition.y));
    }
    // If still on edge, just update target position
    targetGridPosition = newGridPosition;
  }

  void _handleDrawingMovement(IntVector2 newGridPosition) {
    bool isNewPositionOnEdge =
        arena.getGridValue(newGridPosition.x, newGridPosition.y) ==
        game_constants.kGridEdge;
    if (isNewPositionOnEdge) {
      // Hit an existing boundary
      arena.addPathPoint(IntVector2(newGridPosition.x, newGridPosition.y));
      state = PlayerState.onEdge;
      onPlayerStateChanged(state);
      currentPath.clear(); // Clear the path when hitting an existing boundary
    } else {
      // Check for self-intersection if drawing
      if (currentPath.contains(newGridPosition)) {
        onSelfIntersection();
        return; // Prevent further movement
      }
      // Continue drawing path
      currentPath.add(IntVector2(newGridPosition.x, newGridPosition.y));
      arena.addPathPoint(IntVector2(newGridPosition.x, newGridPosition.y));
    }
    targetGridPosition = newGridPosition;
  }

  IntVector2 _getNewGridPosition(dp.Direction direction) {
    IntVector2 nextPos;
    switch (direction) {
      case dp.Direction.up:
        nextPos = IntVector2(gridPosition.x, gridPosition.y - 1);
        break;
      case dp.Direction.down:
        nextPos = IntVector2(gridPosition.x, gridPosition.y + 1);
        break;
      case dp.Direction.left:
        nextPos = IntVector2(gridPosition.x - 1, gridPosition.y);
        break;
      case dp.Direction.right:
        nextPos = IntVector2(gridPosition.x + 1, gridPosition.y);
        break;
    }
    return nextPos.clamp(0, gridSize - 1, 0, gridSize - 1);
  }

  void teleportTo(IntVector2 newPosition) {
    gridPosition = newPosition;
    targetGridPosition = newPosition;
    position = newPosition.toVector2() * cellSize;
    currentDirection = null; // Reset direction since player is teleported
    state = PlayerState.rescued; // Reset state to onEdge after teleport
    currentPath.clear(); // Clear current path since teleporting
    pathStartGridPosition = null; // Reset path start position
    arena.endPath(); // Clear the visual path in the arena
  }
}
