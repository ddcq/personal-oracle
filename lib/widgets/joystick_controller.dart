import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' show Direction;
import 'dart:math' as math;

class JoystickController extends StatefulWidget {
  final ValueChanged<Direction> onDirectionChanged;
  final double size;
  final double deadZoneRadius;

  const JoystickController({
    super.key,
    required this.onDirectionChanged,
    this.size = 120.0,
    this.deadZoneRadius = 20.0,
  });

  @override
  State<JoystickController> createState() => _JoystickControllerState();
}

class _JoystickControllerState extends State<JoystickController> {
  Offset? _dragPosition;
  Direction? _lastDirection;

  @override
  Widget build(BuildContext context) {
    const baseColor = Colors.grey;
    final lightGrey = _lighten(baseColor, 0.3);
    final darkGrey = _darken(baseColor, 0.3);
    final borderColor = _darken(baseColor, 0.4);

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onPanStart: _handlePanStart,
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [lightGrey, baseColor, darkGrey],
                stops: const [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
              border: Border.all(color: borderColor, width: 3),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Direction triangles
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _DirectionTrianglesPainter(
                    size: widget.size,
                  ),
                ),
                // Dead zone indicator
                Container(
                  width: widget.deadZoneRadius * 2,
                  height: widget.deadZoneRadius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [darkGrey, baseColor],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
                // Active direction indicator
                if (_dragPosition != null)
                  CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _DirectionIndicatorPainter(
                      dragPosition: _dragPosition!,
                      size: widget.size,
                      deadZoneRadius: widget.deadZoneRadius,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lighter = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lighter.toColor();
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darker = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darker.toColor();
  }

  void _handlePanStart(DragStartDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    _updateDirection(localPosition);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    _updateDirection(localPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _dragPosition = null;
      _lastDirection = null;
    });
  }

  void _updateDirection(Offset localPosition) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final delta = localPosition - center;
    final distance = delta.distance;

    setState(() {
      _dragPosition = localPosition;
    });

    // If finger is in the dead zone, don't change direction
    if (distance <= widget.deadZoneRadius) {
      return;
    }

    // Calculate angle in radians
    final angle = math.atan2(delta.dy, delta.dx);
    
    // Convert angle to direction (0° is right, 90° is down, etc.)
    Direction newDirection;
    
    // Divide the circle into 4 quadrants
    // Right: -45° to 45°
    // Down: 45° to 135°
    // Left: 135° to -135° (or 135° to 225°)
    // Up: -135° to -45° (or 225° to 315°)
    
    final degrees = angle * 180 / math.pi;
    
    if (degrees >= -45 && degrees < 45) {
      newDirection = Direction.right;
    } else if (degrees >= 45 && degrees < 135) {
      newDirection = Direction.down;
    } else if (degrees >= -135 && degrees < -45) {
      newDirection = Direction.up;
    } else {
      newDirection = Direction.left;
    }

    // Only trigger callback if direction changed
    if (newDirection != _lastDirection) {
      _lastDirection = newDirection;
      widget.onDirectionChanged(newDirection);
    }
  }
}

class _DirectionTrianglesPainter extends CustomPainter {
  final double size;

  _DirectionTrianglesPainter({required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(size / 2, size / 2);
    final triangleDistance = size / 2 - 25;
    final triangleSize = 12.0;

    // Triangle paint with inset effect
    final trianglePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Up triangle
    _drawInsetTriangle(
      canvas,
      center + Offset(0, -triangleDistance),
      triangleSize,
      0, // pointing up
      trianglePaint,
      shadowPaint,
    );

    // Right triangle
    _drawInsetTriangle(
      canvas,
      center + Offset(triangleDistance, 0),
      triangleSize,
      90, // pointing right
      trianglePaint,
      shadowPaint,
    );

    // Down triangle
    _drawInsetTriangle(
      canvas,
      center + Offset(0, triangleDistance),
      triangleSize,
      180, // pointing down
      trianglePaint,
      shadowPaint,
    );

    // Left triangle
    _drawInsetTriangle(
      canvas,
      center + Offset(-triangleDistance, 0),
      triangleSize,
      270, // pointing left
      trianglePaint,
      shadowPaint,
    );
  }

  void _drawInsetTriangle(
    Canvas canvas,
    Offset position,
    double size,
    double rotationDegrees,
    Paint trianglePaint,
    Paint shadowPaint,
  ) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotationDegrees * math.pi / 180);

    final path = Path();
    path.moveTo(0, -size / 2);
    path.lineTo(size / 2, size / 2);
    path.lineTo(-size / 2, size / 2);
    path.close();

    // Draw shadow (light on bottom-right for inset effect)
    final shadowPath = Path();
    final shadowOffset = 1.5;
    shadowPath.moveTo(shadowOffset, -size / 2 + shadowOffset);
    shadowPath.lineTo(size / 2 + shadowOffset, size / 2 + shadowOffset);
    shadowPath.lineTo(-size / 2 + shadowOffset, size / 2 + shadowOffset);
    shadowPath.close();
    canvas.drawPath(shadowPath, shadowPaint);

    // Draw main triangle
    canvas.drawPath(path, trianglePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_DirectionTrianglesPainter oldDelegate) => false;
}

class _DirectionIndicatorPainter extends CustomPainter {
  final Offset dragPosition;
  final double size;
  final double deadZoneRadius;

  _DirectionIndicatorPainter({
    required this.dragPosition,
    required this.size,
    required this.deadZoneRadius,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(size / 2, size / 2);
    final delta = dragPosition - center;
    final distance = delta.distance;

    if (distance <= deadZoneRadius) {
      return;
    }

    // Draw line from center to drag position
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Limit the line length to the edge of the circle
    final maxLength = size / 2 - 10;
    final normalizedDelta = delta / distance * math.min(distance, maxLength);
    final endPoint = center + normalizedDelta;

    canvas.drawLine(center, endPoint, paint);

    // Draw a circle at the drag position with emboss effect
    final circleShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final circleHighlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final circlePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    // Shadow
    canvas.drawCircle(endPoint + const Offset(1, 1), 9, circleShadowPaint);
    
    // Main circle
    canvas.drawCircle(endPoint, 8, circlePaint);
    
    // Highlight
    canvas.drawCircle(endPoint - const Offset(1.5, 1.5), 3, circleHighlightPaint);
  }

  @override
  bool shouldRepaint(_DirectionIndicatorPainter oldDelegate) {
    return oldDelegate.dragPosition != dragPosition;
  }
}
