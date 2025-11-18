import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;

/// Utilities for direction handling in Snake game
class DirectionUtils {
  /// Map of direction to offset vector for 2x2 blocks
  static final Map<dp.Direction, IntVector2> directionOffsets = {
    dp.Direction.up: IntVector2(0, -2),
    dp.Direction.down: IntVector2(0, 2),
    dp.Direction.left: IntVector2(-2, 0),
    dp.Direction.right: IntVector2(2, 0),
  };

  /// Map of direction to single step offset (for 1x1 movement)
  static final Map<dp.Direction, IntVector2> singleStepOffsets = {
    dp.Direction.up: IntVector2(0, -1),
    dp.Direction.down: IntVector2(0, 1),
    dp.Direction.left: IntVector2(-1, 0),
    dp.Direction.right: IntVector2(1, 0),
  };

  /// Get new head position based on direction (1x1 movement)
  static IntVector2 getNewHeadPosition(
    IntVector2 currentHead,
    dp.Direction direction,
  ) {
    final offset = singleStepOffsets[direction]!;
    return IntVector2(currentHead.x + offset.x, currentHead.y + offset.y);
  }

  /// Get previous position for initialization (2x2 movement)
  static IntVector2 getPreviousPosition(
    IntVector2 position,
    dp.Direction direction,
  ) {
    final offset = directionOffsets[direction]!;
    return IntVector2(position.x - offset.x, position.y - offset.y);
  }

  /// Get initial pattern for snake body segment
  static String getInitialPattern(dp.Direction direction) {
    switch (direction) {
      case dp.Direction.up:
        return '0,1,0,-1';
      case dp.Direction.down:
        return '0,-1,0,1';
      case dp.Direction.left:
        return '1,0,-1,0';
      case dp.Direction.right:
        return '-1,0,1,0';
    }
  }

  /// Check if two directions are opposite
  static bool isOppositeDirection(dp.Direction dir1, dp.Direction dir2) {
    return (dir1 == dp.Direction.up && dir2 == dp.Direction.down) ||
        (dir1 == dp.Direction.down && dir2 == dp.Direction.up) ||
        (dir1 == dp.Direction.left && dir2 == dp.Direction.right) ||
        (dir1 == dp.Direction.right && dir2 == dp.Direction.left);
  }

  /// Calculate straight distance with obstacles (2x2 movement)
  static int calculateStraightDistanceWithObstacles(
    IntVector2 start,
    dp.Direction direction,
    int gridWidth,
    int gridHeight,
    List<IntVector2> obstacles,
  ) {
    int distance = 0;
    IntVector2 current = start;
    final offset = directionOffsets[direction]!;

    while (true) {
      current = IntVector2(current.x + offset.x, current.y + offset.y);

      bool collision = false;
      for (int y = 0; y < 2; y++) {
        for (int x = 0; x < 2; x++) {
          final checkPos = IntVector2(current.x + x, current.y + y);
          if (checkPos.x < 0 ||
              checkPos.x >= gridWidth ||
              checkPos.y < 0 ||
              checkPos.y >= gridHeight ||
              obstacles.contains(checkPos)) {
            collision = true;
            break;
          }
        }
        if (collision) break;
      }

      if (collision) {
        break;
      }
      distance++;
    }
    return distance;
  }
}
