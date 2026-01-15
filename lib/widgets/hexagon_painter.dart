import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom painter pour dessiner des hexagones
class HexagonPainter extends CustomPainter {
  final Color? color;
  final Color? borderColor;
  final double borderWidth;

  const HexagonPainter({
    this.color,
    this.borderColor,
    this.borderWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    if (color != null) {
      final fillPaint = Paint()
        ..color = color!
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    if (borderColor != null) {
      final borderPaint = Paint()
        ..color = borderColor!
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
