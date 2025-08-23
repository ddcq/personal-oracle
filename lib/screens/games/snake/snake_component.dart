import 'package:flame/components.dart';
import 'package:flutter/animation.dart'; // For Curves
import 'dart:ui';
import 'game_logic.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;

// Define CircleData class outside SnakeComponent
class CircleData {
  Offset center;
  double radius;
  CircleData(this.center, this.radius);
}

class SnakeComponent extends PositionComponent {
  GameState gameState;
  final double cellSize;

  // Sprites
  final Sprite snakeHeadSprite;

  late final Vector2 _top;
  late final Vector2 _bottom;
  late final Vector2 _left;
  late final Vector2 _right;
  late final Map<List<int>, List<Vector2>> _cornerCenters;
  late final double _smallRadius;
  late final Vector2 _halfCellOffset;

  // New fields for animation
  final List<List<CircleData>> _previousSegmentCircles = [];
  final List<List<CircleData>> _currentSegmentCircles = [];
  Offset _previousHeadPosition = Offset.zero;
  Offset _currentHeadPosition = Offset.zero;
  double _animationProgress = 0.0;
  double _animationDuration; // Removed final
  final Curve _animationCurve = Curves.linear; // Easing curve for animation

  // Setter for animationDuration
  set animationDuration(double value) {
    _animationDuration = value;
  }

  SnakeComponent({required this.gameState, required this.cellSize, required this.snakeHeadSprite, required double animationDuration})
    : _animationDuration = animationDuration,
      _top = Vector2(cellSize * 0.5, cellSize * 0.18),
      _bottom = Vector2(cellSize * 0.5, cellSize * 0.82),
      _left = Vector2(cellSize * 0.18, cellSize * 0.5),
      _right = Vector2(cellSize * 0.82, cellSize * 0.5),
      _smallRadius = cellSize * 0.25,
      _halfCellOffset = Vector2(cellSize * 0.5, cellSize * 0.5) {
    _cornerCenters = {
      // Top-Left (snake turns from up to left, or from left to up)
      [0, -1, -1, 0] // prev: up, next: left
      : [
        _top,
        Vector2(cellSize * 0.4, cellSize * 0.4),
        _left,
      ],
      [-1, 0, 0, -1] // prev: left, next: up
      : [
        _left,
        Vector2(cellSize * 0.4, cellSize * 0.4),
        _top,
      ],
      // Top-Right (snake turns from up to right, or from right to up)
      [0, -1, 1, 0] // prev: up, next: right
      : [
        _top,
        Vector2(cellSize * 0.6, cellSize * 0.4),
        _right,
      ],
      [1, 0, 0, -1] // prev: right, next: up
      : [
        _right,
        Vector2(cellSize * 0.6, cellSize * 0.4),
        _top,
      ],
      // Bottom-Left (snake turns from down to left, or from left to down)
      [0, 1, -1, 0] // prev: down, next: left
      : [
        _bottom,
        Vector2(cellSize * 0.4, cellSize * 0.6),
        _left,
      ],
      // Bottom-Left (snake turns from down to left, or from left to down)
      [-1, 0, 0, 1] // prev: left, next: down
      : [
        _left,
        Vector2(cellSize * 0.4, cellSize * 0.6),
        _bottom,
      ],
      // Bottom-Right (snake turns from down to right, or from right to down)
      [0, 1, 1, 0] // prev: down, next: right
      : [
        _bottom,
        Vector2(cellSize * 0.6, cellSize * 0.6),
        _right,
      ],
      [1, 0, 0, 1] // prev: right, next: down
      : [
        _right,
        Vector2(cellSize * 0.6, cellSize * 0.6),
        _bottom,
      ],
      // Horizontal segment
      [-1, 0, 1, 0] // prev: left, next: right
      : [
        _left,
        _halfCellOffset,
        _right,
      ],
      [1, 0, -1, 0] // prev: right, next: left
      : [
        _right,
        _halfCellOffset,
        _left,
      ],
      // Vertical segment
      [0, -1, 0, 1] // prev: up, next: down
      : [
        _top,
        _halfCellOffset,
        _bottom,
      ],
      [0, 1, 0, -1] // prev: down, next: up
      : [
        _bottom,
        _halfCellOffset,
        _top,
      ],
    };
    _populateCurrentSegmentCircles(); // Initialize current circles
  }

  // Helper method to get circles for a single segment
  List<CircleData> _getSegmentCircles(IntVector2 segment, IntVector2? prevSegment, IntVector2? nextSegment) {
    final List<CircleData> circles = [];
    final segmentPosition = segment.toVector2() * cellSize;

    // Case 1: Head of the snake (prevSegment is null)
    if (prevSegment == null) {
      return circles; // Head is a sprite, no circles drawn here.
    }
    // Case 2: Tail of the snake (nextSegment is null, prevSegment is not null)
    else if (nextSegment == null) {
      final tailDirectionX = segment.x - prevSegment.x; // prevSegment is guaranteed non-null here
      final tailDirectionY = segment.y - prevSegment.y;

      final double radius1 = cellSize * 0.2;
      final double radius2 = cellSize * 0.1;

      final double centerX = cellSize * 0.5;
      final double centerY = cellSize * 0.5;
      final double offset02 = cellSize * 0.2;
      final double offset03 = cellSize * 0.3;
      final double offset07 = cellSize * 0.7;
      final double offset08 = cellSize * 0.8;

      Vector2 center1, center2;

      if (tailDirectionX == 1) {
        // prev: left, current: right (tail moving right)
        center1 = segmentPosition + Vector2(offset02, centerY);
        center2 = segmentPosition + Vector2(offset03, centerY);
      } else if (tailDirectionX == -1) {
        // prev: right, current: left (tail moving left)
        center1 = segmentPosition + Vector2(offset08, centerY);
        center2 = segmentPosition + Vector2(offset07, centerY);
      } else if (tailDirectionY == 1) {
        // prev: up, current: down (tail moving down)
        center1 = segmentPosition + Vector2(centerX, offset02);
        center2 = segmentPosition + Vector2(centerX, offset03);
      } else if (tailDirectionY == -1) {
        // prev: down, current: up (tail moving up)
        center1 = segmentPosition + Vector2(centerX, offset08);
        center2 = segmentPosition + Vector2(centerX, offset07);
      } else {
        // Should not happen for a valid snake
        center1 = segmentPosition + Vector2(centerX, centerY);
        center2 = segmentPosition + Vector2(centerX, centerY);
      }
      circles.add(CircleData(center1.toOffset(), radius1));
      circles.add(CircleData(center2.toOffset(), radius2));
    }
    // Case 3: Body segment (prevSegment is not null, nextSegment is not null)
    else {
      final prevRelativeX = prevSegment.x - segment.x; // prevSegment is guaranteed non-null here
      final prevRelativeY = prevSegment.y - segment.y;
      final nextRelativeX = nextSegment.x - segment.x; // nextSegment is guaranteed non-null here
      final nextRelativeY = nextSegment.y - segment.y;

      bool foundPattern = false;
      for (var entry in _cornerCenters.entries) {
        var pattern = entry.key;
        if (prevRelativeX == pattern[0] && prevRelativeY == pattern[1] && nextRelativeX == pattern[2] && nextRelativeY == pattern[3]) {
          final center1 = segmentPosition + entry.value[0];
          final center2 = segmentPosition + entry.value[1];
          final center3 = segmentPosition + entry.value[2];
          circles.add(CircleData(center1.toOffset(), _smallRadius));
          circles.add(CircleData(center2.toOffset(), _smallRadius));
          circles.add(CircleData(center3.toOffset(), _smallRadius));
          foundPattern = true;
        }
        if (foundPattern) break;
      }
      // If not a corner, it's a straight segment. Original code doesn't draw circles for straight body segments.
      // So, we return an empty list for straight body segments.
    }
    return circles;
  }

  void _populateCurrentSegmentCircles() {
    _currentSegmentCircles.clear();
    _currentHeadPosition = (gameState.snake[0].toVector2() * cellSize).toOffset(); // Update current head position
    for (int i = 0; i < gameState.snake.length; i++) {
      final segment = gameState.snake[i];
      IntVector2? prevSegment;
      if (i > 0) {
        prevSegment = gameState.snake[i - 1];
      }
      IntVector2? nextSegment;
      if (i < gameState.snake.length - 1) {
        nextSegment = gameState.snake[i + 1];
      }
      _currentSegmentCircles.add(_getSegmentCircles(segment, prevSegment, nextSegment));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _animationProgress = (_animationProgress + dt).clamp(0.0, _animationDuration);
  }

  void updateGameState(GameState newGameState) {
    _previousSegmentCircles.clear();
    _previousSegmentCircles.addAll(_currentSegmentCircles); // Copy current to previous
    _previousHeadPosition = _currentHeadPosition; // Copy current head position to previous

    // Update gameState to newGameState *before* calculating _currentSegmentCircles
    // so that _getSegmentCircles uses the new state.
    gameState = newGameState;
    _populateCurrentSegmentCircles(); // Populate current circles based on new game state
    _animationProgress = 0.0;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()..color = const Color(0xFF006400); // Dark Green color

    for (int i = 0; i < gameState.snake.length; i++) {

      if (i == 0) {
        // Head of the snake - Qix monster with rotation
        double rotationAngle = 0; // Default: Up
        switch (gameState.direction) {
          case dp.Direction.right:
            rotationAngle = radians(90);
            break;
          case dp.Direction.down:
            rotationAngle = radians(180);
            break;
          case dp.Direction.left:
            rotationAngle = radians(270); // or radians(-90)
            break;
          case dp.Direction.up:
            rotationAngle = radians(0);
            break;
        }

        // Animate head position
        Offset animatedHeadPosition = _currentHeadPosition;
        if (_animationProgress < _animationDuration) {
          final t = _animationCurve.transform(_animationProgress / _animationDuration);
          animatedHeadPosition = Offset.lerp(_previousHeadPosition, _currentHeadPosition, t)!;
        }

        canvas.save();
        canvas.translate(animatedHeadPosition.dx + cellSize / 2, animatedHeadPosition.dy + cellSize / 2);
        canvas.rotate(rotationAngle);
        canvas.translate(-(animatedHeadPosition.dx + cellSize / 2), -(animatedHeadPosition.dy + cellSize / 2));
        snakeHeadSprite.render(
          canvas,
          position: Vector2(animatedHeadPosition.dx, animatedHeadPosition.dy) - Vector2(cellSize * 0.25, cellSize * 0.25),
          size: Vector2.all(cellSize * 1.5),
        );
        canvas.restore();
      } else {
        // Body and Tail segments - draw animated circles
        
        

        final currentSegmentCircles = _currentSegmentCircles[i];
        List<CircleData> previousSegmentCircles = [];
        if (_previousSegmentCircles.length > i) {
          previousSegmentCircles = _previousSegmentCircles[i];
        }

        for (int j = 0; j < currentSegmentCircles.length; j++) {
          final currentCircle = currentSegmentCircles[j];
          Offset animatedCenter = currentCircle.center;
          double animatedRadius = currentCircle.radius;

          if (_animationProgress < _animationDuration && previousSegmentCircles.length > j) {
            final previousCircle = previousSegmentCircles[j];
            final t = _animationCurve.transform(_animationProgress / _animationDuration);

            animatedCenter = Offset.lerp(previousCircle.center, currentCircle.center, t)!;
            animatedRadius = previousCircle.radius + (currentCircle.radius - previousCircle.radius) * t;
          }
          canvas.drawCircle(animatedCenter, animatedRadius, paint);
        }
      }
    }
  }
}
