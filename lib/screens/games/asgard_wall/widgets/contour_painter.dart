import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/models/wall_game_models.dart';

/// Custom painter for drawing the contour lines around placed pieces
class ContourPainter extends CustomPainter {
  final Set<Segment> contour;
  final double cellWidth;
  final double cellHeight;
  final Color color;
  final double strokeWidth;

  ContourPainter({
    required this.contour,
    required this.cellWidth,
    required this.cellHeight,
    this.color = Colors.cyanAccent,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (final segment in contour) {
      final p1 = Offset(segment.p1.x * cellWidth, segment.p1.y * cellHeight);
      final p2 = Offset(segment.p2.x * cellWidth, segment.p2.y * cellHeight);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ContourPainter oldDelegate) {
    return oldDelegate.contour != contour;
  }
}
