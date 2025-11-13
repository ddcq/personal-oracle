import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:oracle_d_asgard/screens/games/snake/game_logic.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_flame_game.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;

class SnakeComponent extends PositionComponent with HasGameReference<SnakeFlameGame> {
  ValueNotifier<GameState> gameState;
  final double cellSize;
  final Sprite snakeHeadSprite;
  final Sprite snakeBodySprite;

  static const double _tailSize1Factor = 2.0;

  // Components
  late SpriteComponent _headComponent;
  late RectangleComponent _headBackground;

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

  set animationDuration(double value) {
    _animationDuration = value;
  }

  SnakeComponent({
    required this.gameState,
    required this.cellSize,
    required this.snakeHeadSprite,
    required this.snakeBodySprite,
    required double animationDuration,
  }) : _animationDuration = animationDuration,
       _previousHeadPosition = (gameState.value.snake[0].position.toVector2() * cellSize).toOffset(),
       _currentHeadPosition = (gameState.value.snake[0].position.toVector2() * cellSize).toOffset(),
       _animationProgress = 0.0 {
    // Head background
    _headBackground = RectangleComponent(
      size: Vector2.all(cellSize * 2),
      anchor: Anchor.center,
      paint: Paint()..color = Colors.green.withValues(alpha: 0.3),
    );
    add(_headBackground);
    
    _headComponent = SpriteComponent(sprite: snakeHeadSprite, size: Vector2.all(cellSize * 2), anchor: Anchor.center);
    add(_headComponent);
    
    // Doubled positions for 2x2 blocks
    _top = Vector2(cellSize * 1.0, cellSize * 0.36);
    _bottom = Vector2(cellSize * 1.0, cellSize * 1.64);
    _left = Vector2(cellSize * 0.36, cellSize * 1.0);
    _right = Vector2(cellSize * 1.64, cellSize * 1.0);
    _smallRadius = cellSize * 0.5;
    _halfCellOffset = Vector2(cellSize * 1.0, cellSize * 1.0);
    
    _cornerCenters = {
      // Top-Left
      '0,-1,-1,0': [_top, Vector2(cellSize * 0.8, cellSize * 0.8), _left],
      '-1,0,0,-1': [_left, Vector2(cellSize * 0.8, cellSize * 0.8), _top],
      // Top-Right
      '0,-1,1,0': [_top, Vector2(cellSize * 1.2, cellSize * 0.8), _right],
      '1,0,0,-1': [_right, Vector2(cellSize * 1.2, cellSize * 0.8), _top],
      // Bottom-Left
      '0,1,-1,0': [_bottom, Vector2(cellSize * 0.8, cellSize * 1.2), _left],
      '-1,0,0,1': [_left, Vector2(cellSize * 0.8, cellSize * 1.2), _bottom],
      // Bottom-Right
      '0,1,1,0': [_bottom, Vector2(cellSize * 1.2, cellSize * 1.2), _right],
      '1,0,0,1': [_right, Vector2(cellSize * 1.2, cellSize * 1.2), _bottom],
      // Horizontal
      '-1,0,1,0': [_left, _halfCellOffset, _right],
      '1,0,-1,0': [_right, _halfCellOffset, _left],
      // Vertical
      '0,-1,0,1': [_top, _halfCellOffset, _bottom],
      '0,1,0,-1': [_bottom, _halfCellOffset, _top],
    };
    
    _cornerRotations = {
      // Straight
      '-1,0,1,0': [-90.0, -90.0, -90.0],
      '1,0,-1,0': [90.0, 90.0, 90.0],
      '0,-1,0,1': [0.0, 0.0, 0.0],
      '0,1,0,-1': [180.0, 180.0, 180.0],
      // Corners
      '0,-1,-1,0': [10.0, 45.0, 80.0],
      '-1,0,0,-1': [-100.0, -135.0, -170.0],
      '0,-1,1,0': [-10.0, -45.0, -80.0],
      '1,0,0,-1': [100.0, 135.0, 170.0],
      '0,1,-1,0': [170.0, 135.0, 100.0],
      '-1,0,0,1': [-80.0, -45.0, -10.0],
      '0,1,1,0': [-170.0, -135.0, -100.0],
      '1,0,0,1': [80.0, 45.0, 10.0],
    };
  }

  @override
  void update(double dt) {
    super.update(dt);
    _animationProgress = (_animationProgress + dt).clamp(0.0, _animationDuration);
  }

  double _calculateShortestAngle(double currentAngle, double targetAngle) {
    targetAngle = targetAngle % (2 * pi);
    if (targetAngle < 0) targetAngle += (2 * pi);

    currentAngle = currentAngle % (2 * pi);
    if (currentAngle < 0) currentAngle += (2 * pi);

    double angleDifference = targetAngle - currentAngle;

    if (angleDifference > pi) {
      angleDifference -= (2 * pi);
    } else if (angleDifference < -pi) {
      angleDifference += (2 * pi);
    }

    return angleDifference;
  }

  void updateGameState(GameState newGameState) {
    _previousHeadPosition = _currentHeadPosition;

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
    _headComponent.add(RotateEffect.by(angleDifference, EffectController(duration: _animationDuration, curve: _animationCurve)));

    gameState.value = newGameState;
    _currentHeadPosition = (gameState.value.snake[0].position.toVector2() * cellSize).toOffset();
    _animationProgress = 0.0;
  }

  void _renderBodyPart(Canvas canvas, Vector2 center, double rotation, Vector2 size, {Paint? overridePaint}) {
    canvas.save();
    canvas.translate(center.x, center.y);
    canvas.rotate(rotation);
    snakeBodySprite.render(canvas, position: Vector2.zero(), size: size, anchor: Anchor.center, overridePaint: overridePaint);
    canvas.restore();
  }

  void _renderBackground(Canvas canvas, Vector2 position, Vector2 size) {
    final paint = Paint()..color = Colors.green.withValues(alpha: 0.3);
    canvas.drawRect(
      Rect.fromLTWH(position.x, position.y, size.x, size.y),
      paint,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Render body and tail (skip index 1 which is the neck hidden under the head)
    for (int i = 2; i < gameState.value.snake.length; i++) {
      final segment = gameState.value.snake[i];
      final segmentPosition = segment.position.toVector2() * cellSize;
      final type = segment.type;
      final subPattern = segment.subPattern;

      // Draw background for body segment (2x2 block)
      _renderBackground(canvas, segmentPosition, Vector2.all(cellSize * 2));

      if (type == 'body' && subPattern != null) {
        final centers = _cornerCenters[subPattern];
        final rotations = _cornerRotations[subPattern];

        if (centers != null && rotations != null) {
          final bodySize = Vector2.all(_smallRadius * 4);
          for (int j = 0; j < centers.length; j++) {
            _renderBodyPart(canvas, segmentPosition + centers[j], radians(rotations[j]), bodySize);
          }
        }
      } else if (type == 'tail' && subPattern != null) {
        final centers = _cornerCenters[subPattern];
        final rotations = _cornerRotations[subPattern];

        if (centers != null && rotations != null) {
          final progress = _animationCurve.transform(_animationProgress / _animationDuration);
          final paint = Paint()..color = Color.fromRGBO(255, 255, 255, 1.0 - progress);
          final fullSize = Vector2.all(cellSize * _tailSize1Factor);

          _renderBodyPart(canvas, segmentPosition + centers[0], radians(rotations[0]), fullSize, overridePaint: paint);
          _renderBodyPart(canvas, segmentPosition + centers[1], radians(rotations[1]), fullSize, overridePaint: paint);
          _renderBodyPart(canvas, segmentPosition + centers[2], radians(rotations[2]), fullSize, overridePaint: paint);
        }
      }
    }

    // Head animation
    Offset animatedHeadPosition = _currentHeadPosition;
    if (_animationProgress < _animationDuration) {
      final t = _animationCurve.transform(_animationProgress / _animationDuration);
      animatedHeadPosition = Offset.lerp(_previousHeadPosition, _currentHeadPosition, t)!;
    }
    _headComponent.position = Vector2(animatedHeadPosition.dx + cellSize, animatedHeadPosition.dy + cellSize);
    _headBackground.position = Vector2(animatedHeadPosition.dx + cellSize, animatedHeadPosition.dy + cellSize);
  }
}
