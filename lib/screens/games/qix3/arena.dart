import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Arena {
  List<Vector2> vertices;
  final List<List<Vector2>> _claimedAreas = [];

  Arena({double x = 0, double y = 0, double width = 400, double height = 400})
      : vertices = [
          Vector2(x, y),
          Vector2(x + width, y),
          Vector2(x + width, y + height),
          Vector2(x, y + height),
        ];

  void updateEdges(List<Vector2> newVertices, List<Vector2> claimedArea) {
    vertices = newVertices;
    _claimedAreas.add(claimedArea);
  }

  bool contains(Vector2 point) {
    int intersections = 0;
    for (int i = 0; i < vertices.length; i++) {
      final p1 = vertices[i];
      final p2 = vertices[(i + 1) % vertices.length];

      if (((p1.y <= point.y && point.y < p2.y) || (p2.y <= point.y && point.y < p1.y)) &&
          (point.x < (p2.x - p1.x) * (point.y - p1.y) / (p2.y - p1.y) + p1.x)) {
        intersections++;
      }
    }
    return intersections % 2 != 0;
  }

  double signedArea() {
    double area = 0;
    for (int i = 0; i < vertices.length; i++) {
      final p1 = vertices[i];
      final p2 = vertices[(i + 1) % vertices.length];
      area += (p1.x * p2.y - p2.x * p1.y);
    }
    return area / 2;
  }

  void render(Canvas canvas) {
    final defaultEdgePaint = Paint()
      ..color = const Color(0xFF00FF00) // Green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final firstEdgePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final lastEdgePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (vertices.isNotEmpty) {
      // Draw first edge (red)
      canvas.drawLine(
        vertices[0].toOffset(),
        vertices[1].toOffset(),
        firstEdgePaint,
      );

      // Draw middle edges (green)
      for (var i = 1; i < vertices.length - 1; i++) {
        canvas.drawLine(
          vertices[i].toOffset(),
          vertices[i + 1].toOffset(),
          defaultEdgePaint,
        );
      }

      // Draw last edge (blue)
      canvas.drawLine(
        vertices[vertices.length - 1].toOffset(),
        vertices[0].toOffset(),
        lastEdgePaint,
      );
    }

    final claimedPaint = Paint()..color = const Color(0x880000FF);
    for (final area in _claimedAreas) {
      final claimedPath = Path();
      claimedPath.moveTo(area.first.x, area.first.y);
      for (var i = 1; i < area.length; i++) {
        claimedPath.lineTo(area[i].x, area[i].y);
      }
      claimedPath.close();
      canvas.drawPath(claimedPath, claimedPaint);
    }
  }
}
