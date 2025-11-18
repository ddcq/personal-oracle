import 'package:flame/extensions.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

/// Extensions for IntVector2 to facilitate game position conversions
extension GamePositionExtension on IntVector2 {
  /// Convert to game position (Vector2) scaled by cell size
  Vector2 toGamePosition(double cellSize) {
    return toVector2() * cellSize;
  }

  /// Convert to game offset scaled by cell size
  Offset toGameOffset(double cellSize) {
    return toGamePosition(cellSize).toOffset();
  }

  /// Convert to centered game position (for 2x2 blocks)
  Vector2 toCenteredGamePosition(double cellSize) {
    return toGamePosition(cellSize) + Vector2.all(cellSize);
  }
}
