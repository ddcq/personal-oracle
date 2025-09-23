import 'package:flame/components.dart';
import 'package:flame/effects.dart'; // Import effects
import 'package:flutter/animation.dart'; // For Curves
import 'dart:ui';
import 'dart:math'; // For pi
import 'game_logic.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;
import 'snake_flame_game.dart'; // Make sure this file defines SnakeFlameGame

// Define CircleData class outside SnakeComponent
class CircleData {
  Offset center;
  double radius;
  CircleData(this.center, this.radius);
}

class SnakeComponent extends PositionComponent with HasGameReference<SnakeFlameGame> {
  GameState gameState;
  final double cellSize;

  // Components
  late SpriteComponent _headComponent;

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
  Offset _previousHeadPosition;
  Offset _currentHeadPosition;
  double _animationProgress;
  double _animationDuration; // Removed final
  final Curve _animationCurve = Curves.linear; // Easing curve for animation

  // Setter for animationDuration
  set animationDuration(double value) {
    _animationDuration = value;
  }

  SnakeComponent({required this.gameState, required this.cellSize, required Sprite snakeHeadSprite, required double animationDuration})
    : _animationDuration = animationDuration,
      _previousHeadPosition = (gameState.snake[0].toVector2() * cellSize).toOffset(),
      _currentHeadPosition = (gameState.snake[0].toVector2() * cellSize).toOffset(),
      _animationProgress = 0.0 {
    _headComponent = SpriteComponent(sprite: snakeHeadSprite, size: Vector2.all(cellSize * 1.5), anchor: Anchor.center);
    add(_headComponent);
    _top = Vector2(cellSize * 0.5, cellSize * 0.18);
    _bottom = Vector2(cellSize * 0.5, cellSize * 0.82);
    _left = Vector2(cellSize * 0.18, cellSize * 0.5);
    _right = Vector2(cellSize * 0.82, cellSize * 0.5);
    _smallRadius = cellSize * 0.25;
    _halfCellOffset = Vector2(cellSize * 0.5, cellSize * 0.5);
    _cornerCenters = {
      // Top-Left (snake turns from up to left, or from left to up)
      [0, -1, -1, 0]: [_top, Vector2(cellSize * 0.4, cellSize * 0.4), _left],
      [-1, 0, 0, -1]: [_left, Vector2(cellSize * 0.4, cellSize * 0.4), _top],
      // Top-Right (snake turns from up to right, or from right to up)
      [0, -1, 1, 0]: [_top, Vector2(cellSize * 0.6, cellSize * 0.4), _right],
      [1, 0, 0, -1]: [_right, Vector2(cellSize * 0.6, cellSize * 0.4), _top],
      // Bottom-Left (snake turns from down to left, or from left to down)
      [0, 1, -1, 0]: [_bottom, Vector2(cellSize * 0.4, cellSize * 0.6), _left],
      [-1, 0, 0, 1]: [_left, Vector2(cellSize * 0.4, cellSize * 0.6), _bottom],
      // Bottom-Right (snake turns from down to right, or from right to down)
      [0, 1, 1, 0]: [_bottom, Vector2(cellSize * 0.6, cellSize * 0.6), _right],
      [1, 0, 0, 1]: [_right, Vector2(cellSize * 0.6, cellSize * 0.6), _bottom],
      // Horizontal segment
      [-1, 0, 1, 0]: [_left, _halfCellOffset, _right],
      [1, 0, -1, 0]: [_right, _halfCellOffset, _left],
      // Vertical segment
      [0, -1, 0, 1]: [_top, _halfCellOffset, _bottom],
      [0, 1, 0, -1]: [_bottom, _halfCellOffset, _top],
    };
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

    // Calculate target angle for rotation
    double targetAngle = 0;
    switch (newGameState.direction) {
      case dp.Direction.right:
        targetAngle = radians(90);
        break;
      case dp.Direction.down:
        targetAngle = radians(180);
        break;
      case dp.Direction.left:
        targetAngle = radians(270);
        break;
      case dp.Direction.up:
        targetAngle = radians(0);
        break;
    }

    // Normalize targetAngle to be within 0 to 2*pi
    targetAngle = targetAngle % (2 * pi);
    if (targetAngle < 0) {
      targetAngle += (2 * pi);
    }

    // Get current angle of the head component
    double currentAngle = _headComponent.angle;

    // Normalize currentAngle to be within 0 to 2*pi
    currentAngle = currentAngle % (2 * pi);
    if (currentAngle < 0) {
      currentAngle += (2 * pi);
    }

    // Calculate the shortest angle difference
    double angleDifference = targetAngle - currentAngle;

    if (angleDifference > pi) {
      angleDifference -= (2 * pi);
    } else if (angleDifference < -pi) {
      angleDifference += (2 * pi);
    }

    // Apply RotateEffect.by with the shortest angle difference
    _headComponent.add(RotateEffect.by(angleDifference, EffectController(duration: _animationDuration, curve: _animationCurve)));

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
        // Head of the snake - handled by _headComponent
        // Update _headComponent's position
        Offset animatedHeadPosition = _currentHeadPosition;
        if (_animationProgress < _animationDuration) {
          final t = _animationCurve.transform(_animationProgress / _animationDuration);
          animatedHeadPosition = Offset.lerp(_previousHeadPosition, _currentHeadPosition, t)!;
        }
        _headComponent.position = Vector2(animatedHeadPosition.dx + cellSize / 2, animatedHeadPosition.dy + cellSize / 2);
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
