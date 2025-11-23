import 'package:oracle_d_asgard/screens/games/asgard_wall/models/wall_game_models.dart';

/// Game logic for Asgard Wall (Tetris-like) game
class WallGameLogic {
  static const int boardWidth = 11;
  static const int boardHeight = 22;
  static const int victoryHeight = 12;

  /// Check if a piece can be placed at position (x, y)
  bool canPlacePiece(
    List<List<bool>> piece,
    int x,
    int y,
    List<List<bool>> collisionBoard,
  ) {
    for (int row = 0; row < piece.length; row++) {
      for (int col = 0; col < piece[row].length; col++) {
        if (piece[row][col]) {
          int boardX = x + col;
          int boardY = y + row;

          if (boardX < 0 ||
              boardX >= boardWidth ||
              boardY >= boardHeight ||
              (boardY >= 0 && collisionBoard[boardY][boardX])) {
            return false;
          }
        }
      }
    }
    return true;
  }

  /// Update the contour when a piece is placed
  void updateContour(
    List<List<bool>> piece,
    int pieceX,
    int pieceY,
    Set<Segment> contour,
  ) {
    for (int r = 0; r < piece.length; r++) {
      for (int c = 0; c < piece[r].length; c++) {
        if (piece[r][c]) {
          int x = pieceX + c;
          int y = pieceY + r;

          final topEdge = Segment(x, y, x + 1, y);
          if (!contour.remove(topEdge)) {
            contour.add(topEdge);
          }

          final bottomEdge = Segment(x, y + 1, x + 1, y + 1);
          if (!contour.remove(bottomEdge)) {
            contour.add(bottomEdge);
          }

          final leftEdge = Segment(x, y, x, y + 1);
          if (!contour.remove(leftEdge)) {
            contour.add(leftEdge);
          }

          final rightEdge = Segment(x + 1, y, x + 1, y + 1);
          if (!contour.remove(rightEdge)) {
            contour.add(rightEdge);
          }
        }
      }
    }
  }

  /// Check for inaccessible holes created by a piece placement
  bool checkInaccessibleHoles(
    List<List<bool>> piece,
    int pieceX,
    int pieceY,
    List<List<bool>> collisionBoard,
  ) {
    final pieceWidth = piece[0].length;
    final pieceHeight = piece.length;

    final startX = pieceX - 1;
    final endX = pieceX + pieceWidth;
    final startY = pieceY - 1;
    final endY = pieceY + pieceHeight;

    for (int cy = startY; cy <= endY; cy++) {
      for (int cx = startX; cx <= endX; cx++) {
        if (cx >= 0 && cx < boardWidth && cy > 0 && cy < boardHeight && !collisionBoard[cy][cx]) {
          final bool blockedTop = collisionBoard[cy - 1][cx];
          final bool blockedLeft = (cx == 0) || collisionBoard[cy][cx - 1];
          final bool blockedRight = (cx == boardWidth - 1) || collisionBoard[cy][cx + 1];

          if (blockedTop && blockedLeft && blockedRight) {
            return true;
          }
        }
      }
    }

    return false;
  }

  /// Check if the wall is complete (victory condition)
  bool checkWallComplete(List<List<bool>> collisionBoard) {
    for (int row = boardHeight - 1; row >= boardHeight - victoryHeight; row--) {
      for (int col = 0; col < boardWidth; col++) {
        if (!collisionBoard[row][col]) {
          return false;
        }
      }
    }
    return true;
  }

  /// Check if cell is occupied in collision board
  bool isCellOccupied(int x, int y, List<List<bool>> collisionBoard) {
    if (y < 0 || y >= boardHeight || x < 0 || x >= boardWidth) {
      return true; // Out of bounds = occupied
    }
    return collisionBoard[y][x];
  }
}
