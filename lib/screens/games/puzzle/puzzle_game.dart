import 'dart:math';
import 'dart:ui';
import 'package:oracle_d_asgard/screens/games/puzzle/puzzle_model.dart'; // Le modèle pur créé à l’étape 1

class PuzzleGame {
  static const double _snapThreshold = 20.0;
  List<PuzzlePieceData> pieces = [];
  late int rows;
  late int cols;
  late double pieceSize;
  VoidCallback? onGameCompleted;
  String? associatedCardId;

  PuzzleGame({this.onGameCompleted, required this.rows, required this.cols});

  void initializeAndScatter(Rect puzzleBoardBounds, Size availableArea) {
    _initializePuzzle();
    scatterPieces(availableArea, puzzleBoardBounds);
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

  // Note: La logique de dispersion dépend de la taille de l’écran.
  // La classe devra la recevoir en paramètre.
  void scatterPieces(Size availableArea, Rect puzzleBoardBounds) {
    final Random random = Random();

    // Marges pour éviter que les pièces apparaissent sous l'appbar ou les boutons de navigation
    final double topMargin = availableArea.height / 20.0;
    final double bottomMargin = availableArea.height / 20.0 + pieceSize;

    // Zone de dispersion pour le coin supérieur gauche des pièces.
    // On s'assure que toute la pièce reste visible.
    final double scatterWidth = availableArea.width - pieceSize;
    final double scatterHeight =
        availableArea.height - pieceSize - topMargin - bottomMargin;

    for (var piece in pieces) {
      // Génère une position aléatoire dans la zone de dispersion.
      // Utilise max(0, ...) pour éviter des valeurs négatives si la zone est plus petite que la pièce.
      final randomGlobalX = random.nextDouble() * max(0, scatterWidth);
      final randomGlobalY =
          topMargin + (random.nextDouble() * max(0, scatterHeight));

      // Convertit la position globale en position locale par rapport au plateau de jeu.
      // La position du composant sera la position globale, car l’offset du plateau est ajouté plus tard.
      final localRandomX = randomGlobalX - puzzleBoardBounds.left;
      final localRandomY = randomGlobalY - puzzleBoardBounds.top;

      piece.currentPosition = Offset(localRandomX, localRandomY);
    }
  }

  bool handlePieceDrop(int pieceId, Offset droppedPosition) {
    final piece = pieces.firstWhere((p) => p.id == pieceId);
    final double distance = (droppedPosition - piece.targetPosition).distance;

    if (distance < _snapThreshold) {
      piece.currentPosition = piece.targetPosition;
      piece.isLocked = true;
      if (isGameCompleted()) {
        onGameCompleted?.call();
      }
      return true; // Indique que l’état a changé
    }
    // La pièce reste où elle est déposée
    piece.currentPosition = droppedPosition;
    piece.isLocked = false;
    return true; // L’état a changé
  }

  bool isGameCompleted() {
    return pieces.every((piece) => piece.isLocked);
  }
}
