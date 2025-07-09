import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import './puzzle_game.dart';
import './puzzle_model.dart';

class DashedRectangleComponent extends RectangleComponent {
  DashedRectangleComponent({required Rect rect}) : super(position: Vector2(rect.left, rect.top), size: Vector2(rect.width, rect.height)) {
    paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
  }

  @override
  void render(Canvas canvas) {
    final Path path = Path();
    _drawDashedLine(path, Offset.zero, Offset(size.x, 0), 5.0, 5.0);
    _drawDashedLine(path, Offset(size.x, 0), Offset(size.x, size.y), 5.0, 5.0);
    _drawDashedLine(path, Offset(size.x, size.y), Offset(0, size.y), 5.0, 5.0);
    _drawDashedLine(path, Offset(0, size.y), Offset.zero, 5.0, 5.0);
    canvas.drawPath(path, paint);
  }

  void _drawDashedLine(
    Path path,
    Offset p1,
    Offset p2,
    double dash,
    double space,
  ) {
    double distance = (p2 - p1).distance;
    double current = 0.0;
    while (current < distance) {
      path.moveTo(
        p1.dx + (p2.dx - p1.dx) * (current / distance),
        p1.dy + (p2.dy - p1.dy) * (current / distance),
      );
      current += dash;
      if (current > distance) current = distance;
      path.lineTo(
        p1.dx + (p2.dx - p1.dx) * (current / distance),
        p1.dy + (p2.dy - p1.dy) * (current / distance),
      );
      current += space;
    }
  }
}

class PuzzleFlameGame extends FlameGame with HasCollisionDetection {
  final PuzzleGame puzzleGame;

  PuzzleFlameGame({required this.puzzleGame});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Dessiner le plateau de jeu en pointillés
    final double pieceSize = puzzleGame.pieceSize;
    final double boardWidth = pieceSize * puzzleGame.cols;
    final double boardHeight = pieceSize * puzzleGame.rows;

    final double offsetX = (size.x - boardWidth) / 2;
    final double offsetY = (size.y - boardHeight) / 2;

    for (int i = 0; i < puzzleGame.rows; i++) {
      for (int j = 0; j < puzzleGame.cols; j++) {
        final Rect rect = Rect.fromLTWH(
          offsetX + j * pieceSize,
          offsetY + i * pieceSize,
          pieceSize,
          pieceSize,
        );
        add(DashedRectangleComponent(rect: rect));
      }
    }

    // Ajouter les pièces de puzzle
    for (var pieceData in puzzleGame.pieces) {
      add(PuzzlePieceComponent(pieceData: pieceData, gameRef: this, offsetX: offsetX, offsetY: offsetY));
    }
  }
}

class PuzzlePieceComponent extends PositionComponent with DragCallbacks {
  final PuzzlePieceData pieceData;
  final PuzzleFlameGame gameRef;
  final double offsetX;
  final double offsetY;

  PuzzlePieceComponent({required this.pieceData, required this.gameRef, required this.offsetX, required this.offsetY}) : super(
    position: Vector2(pieceData.currentPosition.dx + offsetX, pieceData.currentPosition.dy + offsetY),
    size: Vector2(pieceData.size.width, pieceData.size.height),
  );

  @override
  void render(Canvas canvas) {
    final Paint piecePaint = Paint()
      ..color = pieceData.isLocked ? Colors.green : Colors.pink;
    canvas.drawRect(size.toRect(), piecePaint);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '${pieceData.id}',
        style: const TextStyle(color: Colors.white, fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Mettre à jour la position du composant Flame en fonction des données du modèle
    position.x = pieceData.currentPosition.dx + offsetX;
    position.y = pieceData.currentPosition.dy + offsetY;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!pieceData.isLocked) {
      position.add(event.localDelta);
      pieceData.currentPosition = Offset(position.x - offsetX, position.y - offsetY);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!pieceData.isLocked) {
      gameRef.puzzleGame.handlePieceDrop(pieceData.id, Offset(position.x - offsetX, position.y - offsetY));
    }
  }
}