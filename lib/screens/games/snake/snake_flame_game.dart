import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
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
  final List<RectangleComponent> _snakeSegments = [];
  late SpriteComponent _foodComponent;
  final List<SpriteComponent> _obstacles = [];

  // Previous state for interpolation
  late List<Offset> previousSnake;

  // Sprites
  late final Sprite regularFoodSprite;
  late final Sprite goldenFoodSprite;
  late final Sprite obstacleSprite;

  // Animation
  late final TimerComponent _growthAnimationTimer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load sprites
    regularFoodSprite = await loadSprite('apple_regular.png');
    goldenFoodSprite = await loadSprite('apple_golden.png');
    obstacleSprite = await loadSprite('stone.png');

    // Calculate cell size based on the shortest screen dimension
    final screenWidth = size.x;
    final screenHeight = size.y;
    cellSize = (screenWidth < screenHeight ? screenWidth : screenHeight) / GameState.gridSize;

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
    for (final segment in gameState.snake) {
      final newSegment = RectangleComponent(
        position: segment.toVector2() * cellSize,
        size: Vector2.all(cellSize),
        paint: Paint()..color = const Color(0xFF22C55E),
      );
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
      final prevSegment = previousSnake.length > i ? previousSnake[i] : currentSegment;

      final interpolatedDx = prevSegment.dx + (currentSegment.dx - prevSegment.dx) * interpolationFactor;
      final interpolatedDy = prevSegment.dy + (currentSegment.dy - prevSegment.dy) * interpolationFactor;

      _snakeSegments[i].position = Offset(interpolatedDx, interpolatedDy).toVector2() * cellSize;

      // Apply growth animation to the last segment if it's growing
      if (i == gameState.snake.length - 1 && _growthAnimationTimer.timer.isRunning()) {
        final scale = _growthAnimationTimer.timer.progress;
        _snakeSegments[i].size = Vector2.all(cellSize * scale);
        _snakeSegments[i].position = Offset(
          interpolatedDx * cellSize + (cellSize * (1 - scale)) / 2,
          interpolatedDy * cellSize + (cellSize * (1 - scale)) / 2,
        ).toVector2();
      } else {
        _snakeSegments[i].size = Vector2.all(cellSize);
      }
    }
  }

  void tick() {
    final wasGameOver = gameState.isGameOver;
    final oldFoodType = gameState.foodType;
    final oldSnakeLength = gameState.snake.length;

    previousSnake = List.from(gameState.snake); // Store current snake for interpolation

    gameState = gameLogic.updateGame(gameState);

    // Update food
    _foodComponent.position = gameState.food.toVector2() * cellSize;
    if (gameState.foodType != oldFoodType) {
      _foodComponent.sprite = _getFoodSprite(gameState.foodType);
    }

    // Add new snake segments if grown
    if (gameState.snake.length > oldSnakeLength) {
      final newSegment = RectangleComponent(
        position: gameState.snake.last.toVector2() * cellSize,
        size: Vector2.all(cellSize),
        paint: Paint()..color = const Color(0xFF22C55E),
      );
      _snakeSegments.add(newSegment);
      add(newSegment);
      _growthAnimationTimer.timer.start(); // Start growth animation
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
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
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