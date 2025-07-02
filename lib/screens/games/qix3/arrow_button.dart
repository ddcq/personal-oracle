import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

enum ArrowDirection {
  up,
  down,
  left,
  right,
}

class ArrowButtonComponent extends ButtonComponent {
  final ArrowDirection direction;

  ArrowButtonComponent({
    required this.direction,
    required Vector2 position,
    required Vector2 size,
    required VoidCallback onPressed,
  }) : super(
          position: position,
          size: size,
          onPressed: onPressed,
          button: RectangleComponent(size: size, paint: Paint()..color = Colors.grey),
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    switch (direction) {
      case ArrowDirection.up:
        path.moveTo(size.x / 2, size.y / 4);
        path.lineTo(size.x / 4, size.y * 3 / 4);
        path.lineTo(size.x * 3 / 4, size.y * 3 / 4);
        break;
      case ArrowDirection.down:
        path.moveTo(size.x / 2, size.y * 3 / 4);
        path.lineTo(size.x / 4, size.y / 4);
        path.lineTo(size.x * 3 / 4, size.y / 4);
        break;
      case ArrowDirection.left:
        path.moveTo(size.x / 4, size.y / 2);
        path.lineTo(size.x * 3 / 4, size.y / 4);
        path.lineTo(size.x * 3 / 4, size.y * 3 / 4);
        break;
      case ArrowDirection.right:
        path.moveTo(size.x * 3 / 4, size.y / 2);
        path.lineTo(size.x / 4, size.y / 4);
        path.lineTo(size.x / 4, size.y * 3 / 4);
        break;
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}
