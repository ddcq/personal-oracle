/// Configuration for Asgard Wall game dimensions and rules
class WallDimensions {
  static const int boardWidth = 11;
  static const int boardHeight = 22;
  static const int victoryHeight = 12;

  // Timer intervals
  static const int gameTimerMs = 800;
  static const int visualEffectTimerMs = 100;

  // Queue size
  static const int nextPiecesQueueSize = 5;

  // Prevent instantiation
  const WallDimensions._();

  /// Check if position is within board bounds
  static bool isInBounds(int x, int y) {
    return x >= 0 && x < boardWidth && y >= 0 && y < boardHeight;
  }

  /// Check if position is in victory zone
  static bool isInVictoryZone(int y) {
    return y >= boardHeight - victoryHeight;
  }
}
