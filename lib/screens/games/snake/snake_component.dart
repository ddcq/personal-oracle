import 'package:flame/components.dart';
import 'package:flame/effects.dart'; // Import effects
import 'package:flutter/animation.dart'; // For Curves
import 'dart:ui';
import 'dart:math'; // For pi
import 'game_logic.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;
import 'snake_flame_game.dart'; // Make sure this file defines SnakeFlameGame

class SnakeComponent extends PositionComponent with HasGameReference<SnakeFlameGame> {
  GameState gameState;
  final double cellSize;
  final Sprite snakeBodySprite;

  static const double _tailCenter1Offset = 0.2;
  static const double _tailCenter2Offset = 0.3;
  static const double _tailCenter3Offset = 0.7;
  static const double _tailCenter4Offset = 0.8;
  static const double _tailSize1Factor = 1.0;
  static const double _tailSize2Factor = 0.5;

  // Components
  late SpriteComponent _headComponent;

  late final Vector2 _top;
  late final Vector2 _bottom;
  late final Vector2 _left;
  late final Vector2 _right;
  late final Map<String, List<Vector2>> _cornerCenters;
  late final Map<String, List<double>> _cornerRotations;
  late final double _smallRadius;
  late final Vector2 _halfCellOffset;

  // Animation fields
  Offset _previousHeadPosition;
  Offset _currentHeadPosition;
  double _animationProgress;
  double _animationDuration;
  final Curve _animationCurve = Curves.linear;

  // Setter for animationDuration
  set animationDuration(double value) {
    _animationDuration = value;
  }

  SnakeComponent({
    required this.gameState,
    required this.cellSize,
    required Sprite snakeHeadSprite,
    required this.snakeBodySprite,
    required double animationDuration,
  }) : _animationDuration = animationDuration,
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
      '0,-1,-1,0': [_top, Vector2(cellSize * 0.4, cellSize * 0.4), _left],
      '-1,0,0,-1': [_left, Vector2(cellSize * 0.4, cellSize * 0.4), _top],
      // Top-Right (snake turns from up to right, or from right to up)
      '0,-1,1,0': [_top, Vector2(cellSize * 0.6, cellSize * 0.4), _right],
      '1,0,0,-1': [_right, Vector2(cellSize * 0.6, cellSize * 0.4), _top],
      // Bottom-Left (snake turns from down to left, or from left to down)
      '0,1,-1,0': [_bottom, Vector2(cellSize * 0.4, cellSize * 0.6), _left],
      '-1,0,0,1': [_left, Vector2(cellSize * 0.4, cellSize * 0.6), _bottom],
      // Bottom-Right (snake turns from down to right, or from right to down)
      '0,1,1,0': [_bottom, Vector2(cellSize * 0.6, cellSize * 0.6), _right],
      '1,0,0,1': [_right, Vector2(cellSize * 0.6, cellSize * 0.6), _bottom],
      // Horizontal segment
      '-1,0,1,0': [_left, _halfCellOffset, _right],
      '1,0,-1,0': [_right, _halfCellOffset, _left],
      // Vertical segment
      '0,-1,0,1': [_top, _halfCellOffset, _bottom],
      '0,1,0,-1': [_bottom, _halfCellOffset, _top],
    };
    _cornerRotations = {
      // Straight
      '-1,0,1,0': [-90.0, -90.0, -90.0], // left -> right
      '1,0,-1,0': [90.0, 90.0, 90.0], // right -> left
      '0,-1,0,1': [0.0, 0.0, 0.0], // top -> bottom
      '0,1,0,-1': [180.0, 180.0, 180.0], // bottom -> top
      // Corners
      // top-left
      '0,-1,-1,0': [10.0, 45.0, 80.0], // top -> left
      '-1,0,0,-1': [-100.0, -135.0, -170.0], // left -> top
      // top-right
      '0,-1,1,0': [-10.0, -45.0, -80.0], // top -> right
      '1,0,0,-1': [100.0, 135.0, 170.0], // right -> top
      // bottom-left
      '0,1,-1,0': [170.0, 135.0, 100.0], // bottom -> left
      '-1,0,0,1': [-80.0, -45.0, -10.0], // left -> bottom
      // bottom-right
      '0,1,1,0': [-170.0, -135.0, -100.0], // bottom -> right
      '1,0,0,1': [80.0, 45.0, 10.0], // right -> bottom
    };
  }

  @override
  void update(double dt) {
    super.update(dt);
    _animationProgress = (_animationProgress + dt).clamp(0.0, _animationDuration);
  }

  double _calculateShortestAngle(double currentAngle, double targetAngle) {
    targetAngle = targetAngle % (2 * pi);
    if (targetAngle < 0) {
      targetAngle += (2 * pi);
    }

    currentAngle = currentAngle % (2 * pi);
    if (currentAngle < 0) {
      currentAngle += (2 * pi);
    }

    double angleDifference = targetAngle - currentAngle;

    if (angleDifference > pi) {
      angleDifference -= (2 * pi);
    } else if (angleDifference < -pi) {
      angleDifference += (2 * pi);
    }

    return angleDifference;
  }

  void updateGameState(GameState newGameState) {
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

    final angleDifference = _calculateShortestAngle(_headComponent.angle, targetAngle);

    // Apply RotateEffect.by with the shortest angle difference
    _headComponent.add(RotateEffect.by(angleDifference, EffectController(duration: _animationDuration, curve: _animationCurve)));

    gameState = newGameState;
    _currentHeadPosition = (gameState.snake[0].toVector2() * cellSize).toOffset();
    _animationProgress = 0.0;
  }

  void _renderBodyPart(Canvas canvas, Vector2 center, double rotation, Vector2 size) {
    canvas.save();
    canvas.translate(center.x, center.y);
    canvas.rotate(rotation);
    snakeBodySprite.render(canvas, position: Vector2.zero(), size: size, anchor: Anchor.center);
    canvas.restore();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Render the body
    for (int i = 1; i < gameState.snake.length; i++) {
      final segment = gameState.snake[i];
      final segmentPosition = segment.toVector2() * cellSize;
      final prevSegment = gameState.snake[i - 1];
      IntVector2? nextSegment;
      if (i < gameState.snake.length - 1) {
        nextSegment = gameState.snake[i + 1];
      }

      if (nextSegment != null) {
        final prevRelativeX = prevSegment.x - segment.x;
        final prevRelativeY = prevSegment.y - segment.y;
        final nextRelativeX = nextSegment.x - segment.x;
        final nextRelativeY = nextSegment.y - segment.y;

        final pattern = '$prevRelativeX,$prevRelativeY,$nextRelativeX,$nextRelativeY';
        final centers = _cornerCenters[pattern];
        final rotations = _cornerRotations[pattern];

        if (centers != null && rotations != null) {
          final bodySize = Vector2.all(_smallRadius * 4);
          for (int j = 0; j < centers.length; j++) {
            _renderBodyPart(canvas, segmentPosition + centers[j], radians(rotations[j]), bodySize);
          }
        }
      } else {
        // Tail
        final tailDirectionX = segment.x - prevSegment.x;
        final tailDirectionY = segment.y - prevSegment.y;

        final double centerX = cellSize * 0.5;
        final double centerY = cellSize * 0.5;

        Vector2 center1, center2;

        if (tailDirectionX == 1) {
          // prev: left, current: right (tail moving right)
          center1 = segmentPosition + Vector2(cellSize * _tailCenter1Offset, centerY);
          center2 = segmentPosition + Vector2(cellSize * _tailCenter2Offset, centerY);
        } else if (tailDirectionX == -1) {
          // prev: right, current: left (tail moving left)
          center1 = segmentPosition + Vector2(cellSize * _tailCenter4Offset, centerY);
          center2 = segmentPosition + Vector2(cellSize * _tailCenter3Offset, centerY);
        } else if (tailDirectionY == 1) {
          // prev: up, current: down (tail moving down)
          center1 = segmentPosition + Vector2(centerX, cellSize * _tailCenter1Offset);
          center2 = segmentPosition + Vector2(centerX, cellSize * _tailCenter2Offset);
        } else {
          // tailDirectionY == -1
          // prev: down, current: up (tail moving up)
          center1 = segmentPosition + Vector2(centerX, cellSize * _tailCenter4Offset);
          center2 = segmentPosition + Vector2(centerX, cellSize * _tailCenter3Offset);
        }
        final t = _animationCurve.transform(_animationProgress / _animationDuration);
        final paint = Paint()..color = Color.fromRGBO(255, 255, 255, 1.0 - t);

        final tailSize1 = Vector2.all(cellSize * _tailSize1Factor * (1.0 - t));
        final tailSize2 = Vector2.all(cellSize * _tailSize2Factor * (1.0 - t));

        snakeBodySprite.render(canvas, position: center1, size: tailSize1, anchor: Anchor.center, overridePaint: paint);
        snakeBodySprite.render(canvas, position: center2, size: tailSize2, anchor: Anchor.center, overridePaint: paint);
      }
    }

    // Head of the snake - handled by _headComponent
    Offset animatedHeadPosition = _currentHeadPosition;
    if (_animationProgress < _animationDuration) {
      final t = _animationCurve.transform(_animationProgress / _animationDuration);
      animatedHeadPosition = Offset.lerp(_previousHeadPosition, _currentHeadPosition, t)!;
    }
    _headComponent.position = Vector2(animatedHeadPosition.dx + cellSize / 2, animatedHeadPosition.dy + cellSize / 2);
  }
}
