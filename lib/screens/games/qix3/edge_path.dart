import 'package:flame/components.dart';

class EdgePath {
  final Vector2 start;
  final Vector2 end;

  EdgePath(this.start, this.end);

  bool isHorizontal() => start.y == end.y;
  bool isVertical() => start.x == end.x;

  bool contains(Vector2 point) {
    if (isHorizontal()) {
      return point.y == start.y &&
          point.x >= start.x && point.x <= end.x;
    } else if (isVertical()) {
      return point.x == start.x &&
          point.y >= start.y && point.y <= end.y;
    }
    return false;
  }

  Vector2 direction() => (end - start).normalized();

  Vector2 inwardNormal() {
    final dir = direction();
    return Vector2(-dir.y, dir.x);
  }
}
