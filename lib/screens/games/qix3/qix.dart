import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class QixComponent extends PositionComponent {
  QixComponent() {
    size = Vector2.all(32);
    anchor = Anchor.center;
    position = Vector2(200, 200); // Center of the 400x400 arena
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw a "stick figure" Qix
    canvas.drawLine(const Offset(-15, -15), const Offset(15, 15), paint);
    canvas.drawLine(const Offset(15, -15), const Offset(-15, 15), paint);
    canvas.drawLine(const Offset(-10, 0), const Offset(10, 0), paint);
    canvas.drawLine(const Offset(0, -10), const Offset(0, 10), paint);
  }
}
