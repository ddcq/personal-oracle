import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'arena.dart';
import 'pyqix_game.dart';

class SplitResult {
  final List<Vector2> newArenaVertices;
  final List<Vector2> claimedAreaVertices;
  final bool traversedReversed;

  SplitResult(this.newArenaVertices, this.claimedAreaVertices, this.traversedReversed);
}

class PlayerComponent extends PositionComponent
    with HasGameReference<PyQixGame> {
  final double speed = 100;
  // currentEdge will now be represented by the index of its starting vertex in arena.vertices
  int? currentEdgeIndex;
  // _startEdge will now be represented by the index of its starting vertex in arena.vertices
  int? _startEdgeIndex;
  Arena? arena;

  Vector2 velocity = Vector2.zero();
  bool onEdge = true;
  List<Vector2> currentPath = [];

  PlayerComponent({this.arena}) {
    size = Vector2.all(16);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    position = arena!.vertices.first; // Start at the first vertex of the arena
    currentEdgeIndex = 0; // Start on the first edge
    velocity =
        (arena!.vertices[1] - arena!.vertices[0]).normalized() *
        speed; // Initial velocity along the first edge
    position.setFrom(arena!.vertices[0]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (onEdge) {
      _moveOnEdge(dt);
    } else {
      _moveInSpace(dt);
    }
  }

  void _moveOnEdge(double dt) {
    if (currentEdgeIndex == null) return;

    final p1 = arena!.vertices[currentEdgeIndex!];
    final p2 =
        arena!.vertices[(currentEdgeIndex! + 1) % arena!.vertices.length];

    final toEnd = p2 - p1;
    final toPlayer = position - p1;

    position += velocity * dt;

    if (toPlayer.dot(toEnd) >= toEnd.length2) {
      position.setFrom(p2);
      currentEdgeIndex = (currentEdgeIndex! + 1) % arena!.vertices.length;
      final nextP1 = arena!.vertices[currentEdgeIndex!];
      final nextP2 =
          arena!.vertices[(currentEdgeIndex! + 1) % arena!.vertices.length];
      velocity = (nextP2 - nextP1).normalized() * speed;
    }
  }

  void _moveInSpace(double dt) {
    final previousPosition = position.clone();
    position += velocity * dt;

    int? hitEdgeIndex;
    Vector2? intersectionPoint;

    for (int i = 0; i < arena!.vertices.length; i++) {
      final p1 = arena!.vertices[i];
      final p2 = arena!.vertices[(i + 1) % arena!.vertices.length];

      if (_intersectsEdge(previousPosition, position, p1, p2)) {
        hitEdgeIndex = i;
        intersectionPoint = _closestPointOnEdge(position, p1, p2);
        break;
      }
    }

    if (hitEdgeIndex != null && intersectionPoint != null) {
      currentPath.add(intersectionPoint);
      final initialVelocityDirection = velocity.normalized();
      _splitArena(hitEdgeIndex, intersectionPoint);

      onEdge = true;
      position.setFrom(intersectionPoint);

      // Find the new edge the player is on and set velocity
      // Iterate through the new arena vertices to find the edge containing the intersection point
      // and determine the correct direction.
      for (int i = 0; i < arena!.vertices.length; i++) {
        // Check if the intersection point is on this new edge segment
        if (_isPointOnEdge(intersectionPoint, i)) {
          currentEdgeIndex = i;
          final edgeDirection = _getEdgeDirection(currentEdgeIndex!); // Forward direction of the edge
          final reverseEdgeDirection = -edgeDirection; // Backward direction of the edge

          // Determine which direction (forward or backward) is closer to the player's initial velocity
          if (initialVelocityDirection.dot(edgeDirection) > initialVelocityDirection.dot(reverseEdgeDirection)) {
            velocity = edgeDirection * speed;
          } else {
            velocity = reverseEdgeDirection * speed;
          }
          break;
        }
      }
      currentPath = [];
    }
  }

  SplitResult _splitArenaSameEdge(
    List<Vector2> originalVertices,
    int startIndex,
    Vector2 pathStartPoint,
    Vector2 endPoint,
    List<Vector2> currentPath,
  ) {
    final numVertices = originalVertices.length;
    final p1OriginalEdge = originalVertices[startIndex];
    final p2OriginalEdge = originalVertices[(startIndex + 1) % numVertices];

    final distToPathStart = (pathStartPoint - p1OriginalEdge).length2;
    final distToEndPoint = (endPoint - p1OriginalEdge).length2;

    Vector2 firstPointOnEdge;
    Vector2 secondPointOnEdge;
    List<Vector2> pathForNewArena;
    List<Vector2> pathForClaimedArea;
    bool traversedReversed;

    if (distToPathStart < distToEndPoint) {
      firstPointOnEdge = pathStartPoint;
      secondPointOnEdge = endPoint;
      pathForNewArena = currentPath;
      pathForClaimedArea = currentPath.reversed.toList();
      traversedReversed = false;
    } else {
      firstPointOnEdge = endPoint;
      secondPointOnEdge = pathStartPoint;
      pathForNewArena = currentPath.reversed.toList();
      pathForClaimedArea = currentPath;
      traversedReversed = true;
    }

    final newVertices1 = <Vector2>[];
    newVertices1.add(p1OriginalEdge);
    newVertices1.add(firstPointOnEdge);
    newVertices1.addAll(pathForNewArena.sublist(1));
    newVertices1.add(secondPointOnEdge);
    newVertices1.add(p2OriginalEdge);

    for (int i = (startIndex + 1) % numVertices; i != startIndex; i = (i + 1) % numVertices) {
      if (i != startIndex) {
        newVertices1.add(originalVertices[i]);
      }
    }

    final newVertices2 = <Vector2>[];
    newVertices2.add(firstPointOnEdge);
    newVertices2.addAll(pathForClaimedArea.sublist(1));
    newVertices2.add(secondPointOnEdge);
    newVertices2.add(firstPointOnEdge);

    return SplitResult(newVertices1, newVertices2, traversedReversed);
  }

  SplitResult _splitArenaDifferentEdges(
    List<Vector2> originalVertices,
    int startIndex,
    int endIndex,
    Vector2 pathStartPoint,
    Vector2 endPoint,
    List<Vector2> currentPath,
  ) {
    

    final numVertices = originalVertices.length;

    final poly1 = <Vector2>[];
    poly1.addAll(currentPath); // Adds pathStartPoint, intermediate points, and endPoint

    // Add original arena vertices from the vertex after endIndex, clockwise, until startIndex
    var currentIdx = (endIndex + 1) % numVertices;
    while (currentIdx != startIndex) {
      poly1.add(originalVertices[currentIdx]);
      currentIdx = (currentIdx + 1) % numVertices;
    }
    poly1.add(originalVertices[startIndex]); // Add the start vertex of the start edge

    final poly2 = <Vector2>[];
    poly2.add(pathStartPoint);
    // Add intermediate points of currentPath in reverse
    for (int i = currentPath.length - 2; i >= 1; i--) {
      poly2.add(currentPath[i]);
    }
    poly2.add(endPoint);

    // Add original arena vertices from startIndex to endIndex (clockwise)
    currentIdx = startIndex;
    while (currentIdx != endIndex) {
      poly2.add(originalVertices[(currentIdx + 1) % numVertices]);
      currentIdx = (currentIdx + 1) % numVertices;
    }

    

    return SplitResult(poly1, poly2, false);
  }

  SplitResult _splitArena(int endEdgeIndex, Vector2 endPoint) {
    final pathStartPoint = currentPath.first;
    final originalVertices = arena!.vertices;
    final startIndex = _startEdgeIndex!;
    final endIndex = endEdgeIndex;

    SplitResult result;

    if (startIndex == endIndex) {
      result = _splitArenaSameEdge(
        originalVertices,
        startIndex,
        pathStartPoint,
        endPoint,
        currentPath,
      );
    } else {
      result = _splitArenaDifferentEdges(
        originalVertices,
        startIndex,
        endIndex,
        pathStartPoint,
        endPoint,
        currentPath,
      );
    }

    final tempArena1 = Arena()..vertices = result.newArenaVertices;
    if (tempArena1.contains(game.qix.position)) {
      arena!.updateEdges(result.newArenaVertices, result.claimedAreaVertices);
      return SplitResult(result.newArenaVertices, result.claimedAreaVertices, result.traversedReversed);
    } else {
      arena!.updateEdges(result.claimedAreaVertices, result.newArenaVertices);
      return SplitResult(result.claimedAreaVertices, result.newArenaVertices, result.traversedReversed);
    }
  }

  // Helper to get the direction of an edge from its index
  Vector2 _getEdgeDirection(int index) {
    final p1 = arena!.vertices[index];
    final p2 = arena!.vertices[(index + 1) % arena!.vertices.length];
    return (p2 - p1).normalized();
  }

  // Helper to check if a point is on an edge (for the new vertex-based arena)
  bool _isPointOnEdge(Vector2 point, int edgeIndex) {
    final p1 = arena!.vertices[edgeIndex];
    final p2 = arena!.vertices[(edgeIndex + 1) % arena!.vertices.length];
    final edgeVector = p2 - p1;
    final pointVector = point - p1;
    final dotProduct = pointVector.dot(edgeVector);
    final edgeLengthSquared = edgeVector.length2;

    if (dotProduct < 0 || dotProduct > edgeLengthSquared) {
      return false; // Point is outside the segment
    }

    // Check if point is collinear with the edge
    return (pointVector.cross(edgeVector)).abs() < 1e-6;
  }

  Vector2 _closestPointOnEdge(Vector2 p, Vector2 edgeP1, Vector2 edgeP2) {
    final a = edgeP1;
    final b = edgeP2;
    final ap = p - a;
    final ab = b - a;
    final t = (ap.dot(ab) / ab.length2).clamp(0.0, 1.0);
    return a + ab * t;
  }

  bool _intersectsEdge(
    Vector2 from,
    Vector2 to,
    Vector2 edgeP1,
    Vector2 edgeP2,
  ) {
    final p1 = from;
    final q1 = to;
    final p2 = edgeP1;
    final q2 = edgeP2;

    double cross(Vector2 a, Vector2 b) => a.x * b.y - a.y * b.x;

    final r = q1 - p1;
    final s = q2 - p2;

    final rxs = cross(r, s);
    final qpxr = cross(p2 - p1, r);

    if (rxs.abs() < 1e-8 && qpxr.abs() < 1e-8) {
      return false;
    }

    if (rxs.abs() < 1e-8) {
      return false;
    }

    final t = cross(p2 - p1, s) / rxs;
    final u = cross(p2 - p1, r) / rxs;

    return t >= 0 && t <= 1 && u >= 0 && u <= 1;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color(0xFFFF0000);
    canvas.drawRect(size.toRect(), paint);
  }

  // Helper to get the inward normal of a direction vector (assuming clockwise orientation)
  Vector2 _getInwardNormal(Vector2 direction) {
    return Vector2(-direction.y, direction.x);
  }

  void handleKey(LogicalKeyboardKey key) {
    Vector2? inputDirection;

    if (key == LogicalKeyboardKey.arrowUp) {
      inputDirection = Vector2(0, -1);
    } else if (key == LogicalKeyboardKey.arrowDown) {
      inputDirection = Vector2(0, 1);
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      inputDirection = Vector2(-1, 0);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      inputDirection = Vector2(1, 0);
    }

    if (inputDirection == null) return;

    if (onEdge) {
      final inward = _getInwardNormal(_getEdgeDirection(currentEdgeIndex!));
      if (inputDirection.dot(inward) > 0) {
        onEdge = false;
        _startEdgeIndex = currentEdgeIndex;
        velocity = inputDirection * speed;
        position += inward * 1.0;
        currentPath = [position.clone()];
      }
    } else {
      // Dans l’arène : autoriser le changement de direction orthogonal
      if (inputDirection.dot(velocity.normalized()).abs() < 0.1) {
        currentPath.add(position.clone());
        velocity = inputDirection * speed;
      }
    }
  }
}
