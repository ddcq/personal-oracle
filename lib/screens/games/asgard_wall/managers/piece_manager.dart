import 'dart:math';
import 'package:oracle_d_asgard/screens/games/asgard_wall/game_data.dart';

/// Manages piece generation and rotation for Asgard Wall game
class PieceManager {
  final int totalPieceTypes;

  PieceManager({required this.totalPieceTypes});

  /// Generate a queue of 5 random pieces
  List<int> generateNextPieces() {
    Random random = Random();
    List<int> nextPieces = [];

    for (int i = 0; i < 5; i++) {
      int pieceIndex = random.nextInt(totalPieceTypes);
      nextPieces.add(pieceIndex);
    }

    return nextPieces;
  }

  /// Get a new random piece index
  int getRandomPieceIndex() {
    Random random = Random();
    return random.nextInt(totalPieceTypes);
  }

  /// Try to rotate a piece, with wall kicks if needed
  /// Returns [rotatedPiece, newX, rotated] tuple
  (List<List<bool>>, int, bool) tryRotatePiece({
    required int currentPieceIndex,
    required int currentRotationIndex,
    required int currentX,
    required int currentY,
    required bool Function(List<List<bool>>, int, int) canPlacePieceAt,
  }) {
    int nextRotationIndex =
        (currentRotationIndex + 1) % pieces[currentPieceIndex].length;
    List<List<bool>> nextPiece = List.generate(
      pieces[currentPieceIndex][nextRotationIndex].length,
      (i) => List.from(pieces[currentPieceIndex][nextRotationIndex][i]),
    );

    // Try rotation without offset
    if (canPlacePieceAt(nextPiece, currentX, currentY)) {
      return (nextPiece, currentX, true);
    }

    // Try wall kicks (offsets)
    for (int offset = 1; offset <= 2; offset++) {
      // Try right
      if (canPlacePieceAt(nextPiece, currentX + offset, currentY)) {
        return (nextPiece, currentX + offset, true);
      }
      // Try left
      if (canPlacePieceAt(nextPiece, currentX - offset, currentY)) {
        return (nextPiece, currentX - offset, true);
      }
    }

    // Rotation failed
    return ([], currentX, false);
  }

  /// Get the centered X position for a piece
  int getCenteredX(List<List<bool>> piece, int boardWidth) {
    return (boardWidth - piece[0].length) ~/ 2;
  }
}
