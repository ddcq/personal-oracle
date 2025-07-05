import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_oracle/services/gamification_service.dart';

import 'game_logic.dart';

class SnakeFlameGame extends FlameGame with KeyboardEvents {
  final GameLogic gameLogic = GameLogic();
  late GameState gameState;
  final GamificationService gamificationService;

  SnakeFlameGame({required this.gamificationService});

  static const int gameSpeed = 300; // milliseconds
  double timeSinceLastTick = 0;

  late final double cellSize;
  final List<PositionComponent> _snakeSegments = [];
  late SpriteComponent _foodComponent;
  final List<SpriteComponent> _obstacles = [];

  // Previous state for interpolation
  late List<Offset> previousSnake;

  // Sprites
  late final Sprite regularFoodSprite;
  late final Sprite goldenFoodSprite;
  late final Sprite obstacleSprite;

  // Snake head sprites
  late final Sprite snakeHeadUpSprite;
  late final Sprite snakeHeadRightSprite;
  late final Sprite snakeHeadLeftSprite;
  late final Sprite snakeHeadDownSprite;

  // Snake body sprites
  late final Sprite snakeBodyHorizontalSprite;
  late final Sprite snakeBodyVerticalSprite;
  late final Sprite snakeBodyCornerTopLeftSprite;
  late final Sprite snakeBodyCornerTopRightSprite;
  late final Sprite snakeBodyCornerBottomLeftSprite;
  late final Sprite snakeBodyCornerBottomRightSprite;

  // Snake tail sprites
  late final Sprite snakeTailUpSprite;
  late final Sprite snakeTailRightSprite;
  late final Sprite snakeTailLeftSprite;
  late final Sprite snakeTailDownSprite;

  // Animation
  late final TimerComponent _growthAnimationTimer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load sprites
    regularFoodSprite = await loadSprite('apple_regular.png');
    goldenFoodSprite = await loadSprite('apple_golden.png');
    obstacleSprite = await loadSprite('stone.png');

    final image = await images.load('snake-graphics.png');
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2.all(64));

    snakeHeadUpSprite = spriteSheet.getSprite(0, 3);
    snakeHeadRightSprite = spriteSheet.getSprite(0, 4);
    snakeHeadLeftSprite = spriteSheet.getSprite(1, 3);
    snakeHeadDownSprite = spriteSheet.getSprite(1, 4);
    snakeBodyHorizontalSprite = spriteSheet.getSprite(0, 1);
    snakeBodyVerticalSprite = spriteSheet.getSprite(1, 2);
    snakeBodyCornerTopLeftSprite = spriteSheet.getSprite(0, 0);
    snakeBodyCornerTopRightSprite = spriteSheet.getSprite(0, 2);
    snakeBodyCornerBottomLeftSprite = spriteSheet.getSprite(1, 0);
    snakeBodyCornerBottomRightSprite = spriteSheet.getSprite(2, 2);
    snakeTailUpSprite = spriteSheet.getSprite(2, 3);
    snakeTailRightSprite = spriteSheet.getSprite(2, 4);
    snakeTailLeftSprite = spriteSheet.getSprite(3, 3);
    snakeTailDownSprite = spriteSheet.getSprite(3, 4);

    // Calculate cell size based on the shortest screen dimension
    final screenWidth = size.x;
    final screenHeight = size.y;
    cellSize =
        (screenWidth < screenHeight ? screenWidth : screenHeight) /
        GameState.gridSize;

    // Initialize components once
    _foodComponent = SpriteComponent(
      sprite: regularFoodSprite,
      position: Vector2.zero(),
      size: Vector2.all(cellSize),
    );
    add(_foodComponent);

    // Initialize growth animation timer
    _growthAnimationTimer = TimerComponent(
      period: 0.15, // 150 milliseconds
      autoStart: false,
      onTick: () {},
    );
    add(_growthAnimationTimer);

    // Initial call to initializeGame, but don't start the engine yet
    initializeGame();
    pauseEngine(); // Pause engine until start button is pressed
  }

  void initializeGame() {
    gameState = GameState.initial();
    gameState.isGameRunning = false; // Game starts paused
    gameState.obstacles = gameLogic.generateObstacles(gameState);

    // Update food component position and sprite
    _foodComponent.position = gameState.food.toVector2() * cellSize;
    _foodComponent.sprite = _getFoodSprite(gameState.foodType);

    // Clear and re-add snake segments
    for (var segment in _snakeSegments) {
      segment.removeFromParent();
    }
    _snakeSegments.clear();
    for (int i = 0; i < gameState.snake.length; i++) {
      final segment = gameState.snake[i];
      SpriteComponent newSegment;
      if (i == 0) {
        // Head of the snake
        newSegment = SpriteComponent(
          sprite: _getSnakeHeadSprite(gameState.direction),
          position: segment.toVector2() * cellSize,
          size: Vector2.all(cellSize),
        );
      } else if (i == gameState.snake.length - 1) {
        // Tail of the snake
        final bodySegmentBeforeTail = gameState.snake[i - 1];
        newSegment = SpriteComponent(
          sprite: _getSnakeTailSprite(segment, bodySegmentBeforeTail),
          position: segment.toVector2() * cellSize,
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
          position: segment.toVector2() * cellSize,
          size: Vector2.all(cellSize),
        );
      }
      _snakeSegments.add(newSegment);
      add(newSegment);
    }

    // Clear and re-add obstacles
    for (var obstacle in _obstacles) {
      obstacle.removeFromParent();
    }
    _obstacles.clear();
    for (final obstacle in gameState.obstacles) {
      final newObstacle = SpriteComponent(
        sprite: obstacleSprite,
        position: obstacle.toVector2() * cellSize,
        size: Vector2.all(cellSize),
      );
      _obstacles.add(newObstacle);
      add(newObstacle);
    }
    previousSnake = List.from(gameState.snake);

    _growthAnimationTimer.timer.stop(); // Reset growth animation timer
    _growthAnimationTimer.timer.reset();
  }

  void startGame() {
    gameState.isGameRunning = true;
    resumeEngine();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameState.isGameRunning || gameState.isGameOver) {
      return;
    }

    timeSinceLastTick += dt;
    final double tickTime = _calculateGameSpeed(gameState.score) / 1000.0;

    if (timeSinceLastTick >= tickTime) {
      timeSinceLastTick = 0;
      tick();
    }

    // Interpolate snake position for smooth movement
    final interpolationFactor = timeSinceLastTick / tickTime;
    for (int i = 0; i < gameState.snake.length; i++) {
      final currentSegment = gameState.snake[i];
      final prevSegment = previousSnake.length > i
          ? previousSnake[i]
          : currentSegment;

      final interpolatedDx =
          prevSegment.dx +
          (currentSegment.dx - prevSegment.dx) * interpolationFactor;
      final interpolatedDy =
          prevSegment.dy +
          (currentSegment.dy - prevSegment.dy) * interpolationFactor;

      _snakeSegments[i].position =
          Offset(interpolatedDx, interpolatedDy).toVector2() * cellSize;

      if (i == 0) {
        // Head of the snake
        (_snakeSegments[i] as SpriteComponent).sprite = _getSnakeHeadSprite(
          gameState.direction,
        );
        _snakeSegments[i].position =
            Offset(interpolatedDx, interpolatedDy).toVector2() * cellSize;
        _snakeSegments[i].size = Vector2.all(cellSize);
      } else if (i == gameState.snake.length - 1) {
        // Tail of the snake
        final bodySegmentBeforeTail = gameState.snake[i - 1];
        (_snakeSegments[i] as SpriteComponent).sprite = _getSnakeTailSprite(
          currentSegment,
          bodySegmentBeforeTail,
        );
        _snakeSegments[i].size = Vector2.all(cellSize);
        _snakeSegments[i].position =
            Offset(interpolatedDx, interpolatedDy).toVector2() * cellSize;
      } else if (i == gameState.snake.length - 1) {
        // Tail of the snake
        final bodySegmentBeforeTail = gameState.snake[i - 1];
        (_snakeSegments[i] as SpriteComponent).sprite = _getSnakeTailSprite(
          currentSegment,
          bodySegmentBeforeTail,
        );
        _snakeSegments[i].size = Vector2.all(cellSize);
        _snakeSegments[i].position =
            Offset(interpolatedDx, interpolatedDy).toVector2() * cellSize;

        // Handle growth animation for the tail if it's growing
        if (_growthAnimationTimer.timer.isRunning()) {
          final scale = _growthAnimationTimer.timer.progress;
          _snakeSegments[i].size = Vector2.all(cellSize * scale);
          _snakeSegments[i].position = Offset(
            interpolatedDx * cellSize + (cellSize * (1 - scale)) / 2,
            interpolatedDy * cellSize + (cellSize * (1 - scale)) / 2,
          ).toVector2();
        }
      } else {
        // Body segments (neither head nor tail)
        (_snakeSegments[i] as SpriteComponent).sprite = _getSnakeBodySprite(
          currentSegment,
          gameState.snake[i - 1],
          gameState.snake[i + 1],
        );
        _snakeSegments[i].size = Vector2.all(cellSize);
        _snakeSegments[i].position =
            Offset(interpolatedDx, interpolatedDy).toVector2() * cellSize;
      }
    }
  }

  void tick() {
    final wasGameOver = gameState.isGameOver;
    final oldFoodType = gameState.foodType;
    final oldSnakeLength = gameState.snake.length;

    previousSnake = List.from(
      gameState.snake,
    ); // Store current snake for interpolation

    gameState = gameLogic.updateGame(gameState);

    // Update food
    _foodComponent.position = gameState.food.toVector2() * cellSize;
    if (gameState.foodType != oldFoodType) {
      _foodComponent.sprite = _getFoodSprite(gameState.foodType);
    }

    // Add new snake segments if grown
    if (gameState.snake.length > oldSnakeLength) {
      // The previous tail (now a body segment) needs its sprite updated
      if (oldSnakeLength > 1) {
        // Ensure there was a tail before
        (_snakeSegments[oldSnakeLength - 1] as SpriteComponent).sprite = _getSnakeBodySprite(
            gameState.snake[oldSnakeLength - 1],
            gameState.snake[oldSnakeLength - 2],
            gameState.snake[oldSnakeLength]);
      }

      final newSegment = SpriteComponent(
        sprite: _getSnakeTailSprite(
          gameState.snake.last,
          gameState.snake[gameState.snake.length - 2],
        ), // New tail
        position: gameState.snake.last.toVector2() * cellSize,
        size: Vector2.all(cellSize),
      );
      _snakeSegments.add(newSegment);
      add(newSegment);
      _growthAnimationTimer.timer.start(); // Start growth animation
    }

    // Update snake head sprite if direction changed
    if (_snakeSegments.isNotEmpty && _snakeSegments[0] is SpriteComponent) {
      (_snakeSegments[0] as SpriteComponent).sprite = _getSnakeHeadSprite(
        gameState.direction,
      );
    }

    // Remove extra segments if snake has shrunk (which it doesn't in this game, but good practice)
    if (gameState.snake.length < _snakeSegments.length) {
      final segmentsToRemove = _snakeSegments.sublist(gameState.snake.length);
      for (var segment in segmentsToRemove) {
        world.remove(segment);
      }
      _snakeSegments.removeRange(gameState.snake.length, _snakeSegments.length);
    }

    if (!wasGameOver && gameState.isGameOver) {
      overlays.add('gameOverOverlay');
      pauseEngine();
      gamificationService.saveGameScore('Snake', gameState.score);
      if (gameState.score > 50) {
        gamificationService.unlockTrophy('snake_master');
      }
      if (gameState.score > 80) {
        gamificationService.unlockCollectibleCard('fenrir_card');
      }
      if (gameState.score > 90) {
        gamificationService.unlockStory('fenrir_story');
      }
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          gameLogic.changeDirection(gameState, Direction.up);
          break;
        case LogicalKeyboardKey.arrowDown:
          gameLogic.changeDirection(gameState, Direction.down);
          break;
        case LogicalKeyboardKey.arrowLeft:
          gameLogic.changeDirection(gameState, Direction.left);
          break;
        case LogicalKeyboardKey.arrowRight:
          gameLogic.changeDirection(gameState, Direction.right);
          break;
        case LogicalKeyboardKey.keyR:
          resetGame();
          break;
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Sprite _getFoodSprite(FoodType foodType) {
    return foodType == FoodType.golden ? goldenFoodSprite : regularFoodSprite;
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
    // Determine the direction of the tail relative to the body segment before it
    if (tailPosition.dx > bodyPosition.dx) {
      // Tail is to the right of the body segment, meaning the snake moved left to right.
      // So the tail is pointing left (towards the body).
      return snakeTailLeftSprite;
    } else if (tailPosition.dx < bodyPosition.dx) {
      // Tail is to the left of the body segment, meaning the snake moved right to left.
      // So the tail is pointing right (towards the body).
      return snakeTailRightSprite;
    } else if (tailPosition.dy > bodyPosition.dy) {
      // Tail is below the body segment, meaning the snake moved up to down.
      // So the tail is pointing up (towards the body).
      return snakeTailUpSprite;
    } else {
      // Tail is above the body segment, meaning the snake moved down to up.
      // So the tail is pointing down (towards the body).
      return snakeTailDownSprite;
    }
  }

  Sprite _getSnakeBodySprite(
      Offset currentSegment, Offset prevSegment, Offset nextSegment) {
    // Check if it's a horizontal segment
    if (prevSegment.dy == currentSegment.dy &&
        currentSegment.dy == nextSegment.dy) {
      return snakeBodyHorizontalSprite;
    }
    // Check if it's a vertical segment
    else if (prevSegment.dx == currentSegment.dx &&
        currentSegment.dx == nextSegment.dx) {
      return snakeBodyVerticalSprite;
    }
    // It's a corner segment
    else {
      // Determine the type of corner based on relative positions
      // Normalize prev and next segments relative to currentSegment
      final prevRelativeX = prevSegment.dx - currentSegment.dx;
      final prevRelativeY = prevSegment.dy - currentSegment.dy;
      final nextRelativeX = nextSegment.dx - currentSegment.dx;
      final nextRelativeY = nextSegment.dy - currentSegment.dy;

      // Top-Left Corner (0,0)
      // Came from right (1,0) and going down (0,1) OR Came from down (0,1) and going right (1,0)
      if ((prevRelativeX == 1 && prevRelativeY == 0 && nextRelativeX == 0 && nextRelativeY == 1) ||
          (prevRelativeX == 0 && prevRelativeY == 1 && nextRelativeX == 1 && nextRelativeY == 0)) {
        return snakeBodyCornerTopLeftSprite;
      }
      // Top-Right Corner (0,2)
      // Came from left (-1,0) and going down (0,1) OR Came from down (0,1) and going left (-1,0)
      else if ((prevRelativeX == -1 && prevRelativeY == 0 && nextRelativeX == 0 && nextRelativeY == 1) ||
               (prevRelativeX == 0 && prevRelativeY == 1 && nextRelativeX == -1 && nextRelativeY == 0)) {
        return snakeBodyCornerTopRightSprite;
      }
      // Bottom-Left Corner (2,0)
      // Came from right (1,0) and going up (0,-1) OR Came from up (0,-1) and going right (1,0)
      else if ((prevRelativeX == 1 && prevRelativeY == 0 && nextRelativeX == 0 && nextRelativeY == -1) ||
               (prevRelativeX == 0 && prevRelativeY == -1 && nextRelativeX == 1 && nextRelativeY == 0)) {
        return snakeBodyCornerBottomLeftSprite;
      }
      // Bottom-Right Corner (2,2)
      // Came from left (-1,0) and going up (0,-1) OR Came from up (0,-1) and going left (-1,0)
      else if ((prevRelativeX == -1 && prevRelativeY == 0 && nextRelativeX == 0 && nextRelativeY == -1) ||
               (prevRelativeX == 0 && prevRelativeY == -1 && nextRelativeX == -1 && nextRelativeY == 0)) {
        return snakeBodyCornerBottomRightSprite;
      }
      // Fallback for unexpected cases (should not happen with valid snake movement)
      return snakeBodyHorizontalSprite; // This should ideally not be reached
    }
  }

  double _calculateGameSpeed(int currentScore) {
    return (300 - (currentScore ~/ 20) * 20).clamp(50, 300).toDouble();
  }

  void resetGame() {
    overlays.remove('gameOverOverlay');
    initializeGame();
    startGame();
  }
}

extension OffsetExtension on Offset {
  Vector2 toVector2() => Vector2(dx, dy);
}
