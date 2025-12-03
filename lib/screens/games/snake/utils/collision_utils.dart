import 'package:flutter/foundation.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/screens/games/snake/models/snake_game_state.dart';

/// Utilities for collision detection in Snake game
class CollisionUtils {
  /// Check if a 2x2 block at position is free from occupied cells
  static bool isBlock2x2Free(
    IntVector2 position,
    Set<IntVector2> occupiedCells,
  ) {
    for (int j = 0; j < 2; j++) {
      for (int i = 0; i < 2; i++) {
        if (occupiedCells.contains(
          IntVector2(position.x + i, position.y + j),
        )) {
          return false;
        }
      }
    }
    return true;
  }

  /// Get all cells occupied by a 2x2 block
  static List<IntVector2> get2x2BlockCells(IntVector2 topLeft) {
    return [
      topLeft,
      IntVector2(topLeft.x + 1, topLeft.y),
      IntVector2(topLeft.x, topLeft.y + 1),
      IntVector2(topLeft.x + 1, topLeft.y + 1),
    ];
  }

  /// Check for collision with walls, obstacles, or snake body
  static bool isCollision(
    GameState state,
    IntVector2 newHeadPos,
    List<IntVector2> snakePositions, {
    bool ignoreObstacles = false,
  }) {
    // Wall collision (head is 2x2)
    if (newHeadPos.x < 0 ||
        newHeadPos.x >= state.gridWidth - 1 ||
        newHeadPos.y < 0 ||
        newHeadPos.y >= state.gridHeight - 1) {
      return true;
    }

    // Self-collision
    // The head can overlap with the neck (first body segment) after direction change
    for (int i = 2; i < snakePositions.length; i++) {
      final bodyPos = snakePositions[i];
      if ((newHeadPos.x - bodyPos.x).abs() < 2 &&
          (newHeadPos.y - bodyPos.y).abs() < 2) {
        debugPrint(
          'Snake self-collision: newHeadPos=$newHeadPos, bodyPos=$bodyPos (segment $i)',
        );
        return true;
      }
    }

    // Obstacle collision
    if (!ignoreObstacles) {
      final headCells = get2x2BlockCells(newHeadPos);
      for (final cell in headCells) {
        if (state.obstacles.contains(cell)) {
          return true;
        }
      }
    }

    return false;
  }

  /// Check if two 2x2 blocks overlap
  static bool do2x2BlocksOverlap(IntVector2 pos1, IntVector2 pos2) {
    return (pos1.x - pos2.x).abs() < 2 && (pos1.y - pos2.y).abs() < 2;
  }

  /// Get all occupied cells from snake segments
  static Set<IntVector2> getOccupiedCellsFromSnake(GameState state) {
    final occupied = <IntVector2>{};
    for (final segment in state.snake) {
      occupied.addAll(get2x2BlockCells(segment.position));
    }
    return occupied;
  }

  /// Get all occupied cells including snake, obstacles, and optional extra cells
  static Set<IntVector2> getAllOccupiedCells(
    GameState state, {
    Set<IntVector2>? extraCells,
  }) {
    final occupied = getOccupiedCellsFromSnake(state);
    occupied.addAll(state.obstacles);
    if (extraCells != null) {
      occupied.addAll(extraCells);
    }
    return occupied;
  }
}
