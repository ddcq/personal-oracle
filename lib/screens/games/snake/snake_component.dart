import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'game_logic.dart';

class SnakeComponent extends PositionComponent {
  final GameState gameState;
  final double cellSize;
  final List<SpriteComponent> snakeSegments = [];

  // Sprites
  final Sprite snakeHeadUpSprite;
  final Sprite snakeHeadRightSprite;
  final Sprite snakeHeadLeftSprite;
  final Sprite snakeHeadDownSprite;
  final Sprite snakeBodyHorizontalSprite;
  final Sprite snakeBodyVerticalSprite;
  final Sprite snakeBodyCornerTopLeftSprite;
  final Sprite snakeBodyCornerTopRightSprite;
  final Sprite snakeBodyCornerBottomLeftSprite;
  final Sprite snakeBodyCornerBottomRightSprite;
  final Sprite snakeTailUpSprite;
  final Sprite snakeTailRightSprite;
  final Sprite snakeTailLeftSprite;
  final Sprite snakeTailDownSprite;

  SnakeComponent({
    required this.gameState,
    required this.cellSize,
    required this.snakeHeadUpSprite,
    required this.snakeHeadRightSprite,
    required this.snakeHeadLeftSprite,
    required this.snakeHeadDownSprite,
    required this.snakeBodyHorizontalSprite,
    required this.snakeBodyVerticalSprite,
    required this.snakeBodyCornerTopLeftSprite,
    required this.snakeBodyCornerTopRightSprite,
    required this.snakeBodyCornerBottomLeftSprite,
    required this.snakeBodyCornerBottomRightSprite,
    required this.snakeTailUpSprite,
    required this.snakeTailRightSprite,
    required this.snakeTailLeftSprite,
    required this.snakeTailDownSprite,
  }) {
    initializeSnake();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Ensure snakeSegments is in sync with gameState.snake before updating
    if (snakeSegments.length != gameState.snake.length) {
      initializeSnake();
    }
    updateSnakeSegments();
  }

  void initializeSnake() {
    // Remove all existing snake segments from the component tree
    removeAll(children.whereType<SpriteComponent>());
    snakeSegments.clear();

    for (int i = 0; i < gameState.snake.length; i++) {
      final segment = gameState.snake[i];
      SpriteComponent newSegment;

      if (i == 0) {
        // Head of the snake
        newSegment = SpriteComponent(
          sprite: _getSnakeHeadSprite(gameState.direction),
          position: Vector2(segment.dx, segment.dy) * cellSize,
          size: Vector2.all(cellSize),
        );
      } else if (i == gameState.snake.length - 1) {
        // Tail of the snake
        final bodySegmentBeforeTail = gameState.snake[i - 1];
        newSegment = SpriteComponent(
          sprite: _getSnakeTailSprite(segment, bodySegmentBeforeTail),
          position: Vector2(segment.dx, segment.dy) * cellSize,
          size: Vector2.all(cellSize),
        );
      } else {
        // Body segments
        newSegment = SpriteComponent(
          sprite: _getSnakeBodySprite(
            gameState.snake[i],
            gameState.snake[i - 1],
            gameState.snake[i + 1],
          ),
          position: Vector2(segment.dx, segment.dy) * cellSize,
          size: Vector2.all(cellSize),
        );
      }

      snakeSegments.add(newSegment);
      add(newSegment);
    }
  }

  void updateSnakeSegments() {
    for (int i = 0; i < gameState.snake.length; i++) {
      final segment = gameState.snake[i];
      final snakeSegment = snakeSegments[i];

      if (i == 0) {
        // Head of the snake
        snakeSegment.sprite = _getSnakeHeadSprite(gameState.direction);
      } else if (i == gameState.snake.length - 1) {
        // Tail of the snake
        final bodySegmentBeforeTail = gameState.snake[i - 1];
        snakeSegment.sprite = _getSnakeTailSprite(segment, bodySegmentBeforeTail);
      } else {
        // Body segments
        snakeSegment.sprite = _getSnakeBodySprite(
          gameState.snake[i],
          gameState.snake[i - 1],
          gameState.snake[i + 1],
        );
      }

      snakeSegment.position = Vector2(segment.dx, segment.dy) * cellSize;
    }
  }

  Sprite _getSnakeHeadSprite(Direction direction) {
    switch (direction) {
      case Direction.up:
        return snakeHeadUpSprite;
      case Direction.right:
        return snakeHeadRightSprite;
      case Direction.left:
        return snakeHeadLeftSprite;
      case Direction.down:
        return snakeHeadDownSprite;
    }
  }

  Sprite _getSnakeTailSprite(Offset tailPosition, Offset bodyPosition) {
    if (tailPosition.dx > bodyPosition.dx) {
      return snakeTailLeftSprite;
    } else if (tailPosition.dx < bodyPosition.dx) {
      return snakeTailRightSprite;
    } else if (tailPosition.dy > bodyPosition.dy) {
      return snakeTailUpSprite;
    } else {
      return snakeTailDownSprite;
    }
  }

  Sprite _getSnakeBodySprite(Offset currentSegment, Offset prevSegment, Offset nextSegment) {
    if (prevSegment.dy == currentSegment.dy && currentSegment.dy == nextSegment.dy) {
      return snakeBodyHorizontalSprite;
    } else if (prevSegment.dx == currentSegment.dx && currentSegment.dx == nextSegment.dx) {
      return snakeBodyVerticalSprite;
    } else {
      final prevRelativeX = prevSegment.dx - currentSegment.dx;
      final prevRelativeY = prevSegment.dy - currentSegment.dy;
      final nextRelativeX = nextSegment.dx - currentSegment.dx;
      final nextRelativeY = nextSegment.dy - currentSegment.dy;

      if ((prevRelativeX == 1 && prevRelativeY == 0 && nextRelativeX == 0 && nextRelativeY == 1) ||
          (prevRelativeX == 0 && prevRelativeY == 1 && nextRelativeX == 1 && nextRelativeY == 0)) {
        return snakeBodyCornerTopLeftSprite;
      } else if ((prevRelativeX == -1 && prevRelativeY == 0 && nextRelativeX == 0 && nextRelativeY == 1) ||
                 (prevRelativeX == 0 && prevRelativeY == 1 && nextRelativeX == -1 && nextRelativeY == 0)) {
        return snakeBodyCornerTopRightSprite;
      } else if ((prevRelativeX == 1 && prevRelativeY == 0 && nextRelativeX == 0 && nextRelativeY == -1) ||
                 (prevRelativeX == 0 && prevRelativeY == -1 && nextRelativeX == 1 && nextRelativeY == 0)) {
        return snakeBodyCornerBottomLeftSprite;
      } else if ((prevRelativeX == -1 && prevRelativeY == 0 && nextRelativeX == 0 && nextRelativeY == -1) ||
                 (prevRelativeX == 0 && prevRelativeY == -1 && nextRelativeX == -1 && nextRelativeY == 0)) {
        return snakeBodyCornerBottomRightSprite;
      } else {
        return snakeBodyHorizontalSprite;
      }
    }
  }
}

