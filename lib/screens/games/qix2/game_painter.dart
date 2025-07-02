// --- Classe pour le rendu du jeu
import 'package:flutter/material.dart';
import 'constants.dart';
import 'model.dart';

class GamePainter extends CustomPainter {
  final List<bool> pixels;
  final Coordinate playerPos;
  final List<Bar> bars;
  final List<Coordinate> currentPath;

  GamePainter({
    required this.pixels,
    required this.playerPos,
    required this.bars,
    required this.currentPath,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double pixelWidth = size.width / screenWidth;
    double pixelHeight = size.height / screenHeight;

    final filledPaint = Paint()..color = Colors.cyan..style = PaintingStyle.fill;
    final playerPaint = Paint()..color = Colors.yellow..style = PaintingStyle.fill;
    final barPaint = Paint()..color = Colors.red..strokeWidth = 2.0;
    final pathPaint = Paint()..color = Colors.yellow..strokeWidth = 1.5;

    // 1. Dessiner les pixels remplis
    for (int y = 0; y < screenHeight; y++) {
      for (int x = 0; x < screenWidth; x++) {
        if (pixels[y * screenWidth + x]) {
          canvas.drawRect(
            Rect.fromLTWH(x * pixelWidth, y * pixelHeight, pixelWidth, pixelHeight),
            filledPaint,
          );
        }
      }
    }
    
    // 2. Dessiner le chemin en cours
    if (currentPath.length > 1) {
      final path = Path();
      path.moveTo(
        (currentPath.first.x + 0.5) * pixelWidth, 
        (currentPath.first.y + 0.5) * pixelHeight);
      for (int i = 1; i < currentPath.length; i++) {
        path.lineTo(
          (currentPath[i].x + 0.5) * pixelWidth, 
          (currentPath[i].y + 0.5) * pixelHeight);
      }
      canvas.drawPath(path, pathPaint);
    }

    // 3. Dessiner les barres (Qix)
    for (int i = 0; i < bars.length; i++) {
      final bar = bars[i];
      // On diminue l'opacité pour l'effet de traînée
      barPaint.color = Colors.red.withOpacity(1.0 - (i / bars.length));
      canvas.drawLine(
        Offset((bar.p1.pos.x + 0.5) * pixelWidth, (bar.p1.pos.y + 0.5) * pixelHeight),
        Offset((bar.p2.pos.x + 0.5) * pixelWidth, (bar.p2.pos.y + 0.5) * pixelHeight),
        barPaint,
      );
    }

    // 4. Dessiner le joueur
    canvas.drawRect(
      Rect.fromLTWH(
        playerPos.x * pixelWidth,
        playerPos.y * pixelHeight,
        pixelWidth,
        pixelHeight,
      ),
      playerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Redessiner à chaque frame
    return true;
  }
}