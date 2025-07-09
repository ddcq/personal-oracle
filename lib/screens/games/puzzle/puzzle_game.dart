import 'dart:math';
import 'dart:ui';
import './puzzle_model.dart'; // Le modèle pur créé à l'étape 1

class PuzzleGame {
  List<PuzzlePieceData> pieces = [];
  final int rows = 3;
  final int cols = 3;
  final double pieceSize = 100.0;

  PuzzleGame() {
    _initializePuzzle();
  }

  void _initializePuzzle() {
    pieces.clear();
    for (int i = 0; i < rows * cols; i++) {
      final int row = i ~/ cols;
      final int col = i % cols;
      final Offset targetPos = Offset(col * pieceSize, row * pieceSize);
      pieces.add(
        PuzzlePieceData(
          id: i,
          currentPosition: targetPos,
          targetPosition: targetPos,
          size: Size(pieceSize, pieceSize),
        ),
      );
    }
  }

  // Note: La logique de dispersion dépend de la taille de l'écran.
  // La classe devra la recevoir en paramètre.
  void scatterPieces(Size availableArea, Rect puzzleBoardBounds) {
    final Random random = Random();
    final double scatterAreaMinY = 0;
    final double scatterAreaMaxY = puzzleBoardBounds.top - pieceSize;

    for (var piece in pieces) {
      final randomGlobalX = random.nextDouble() * (availableArea.width - pieceSize);
      final randomGlobalY = scatterAreaMinY + random.nextDouble() * (scatterAreaMaxY - scatterAreaMinY);
      
      // Convert global random position to local position relative to the puzzle board
      final localRandomX = randomGlobalX - puzzleBoardBounds.left;
      final localRandomY = randomGlobalY - puzzleBoardBounds.top;

      piece.currentPosition = Offset(localRandomX, localRandomY);
    }
  }

  bool handlePieceDrop(int pieceId, Offset droppedPosition) {
    final piece = pieces.firstWhere((p) => p.id == pieceId);
    final double snapThreshold = 20.0;
    final double distance = (droppedPosition - piece.targetPosition).distance;

    if (distance < snapThreshold) {
      piece.currentPosition = piece.targetPosition;
      piece.isLocked = true;
      return true; // Indique que l'état a changé
    }
    // La pièce reste où elle est déposée
    piece.currentPosition = droppedPosition;
    piece.isLocked = false;
    return true; // L'état a changé
  }

  bool isGameCompleted() {
    return pieces.every((piece) => piece.isLocked);
  }
}
