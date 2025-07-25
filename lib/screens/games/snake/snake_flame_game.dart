import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_component.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';

import 'game_logic.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;

class SnakeFlameGame extends FlameGame with KeyboardEvents {
  final GameLogic gameLogic = GameLogic();
  late GameState gameState;
  final GamificationService gamificationService;

  SnakeFlameGame({required this.gamificationService});

  static const int gameSpeed = 300; // milliseconds
  double timeSinceLastTick = 0;

  late final double cellSize;
  late SpriteComponent _foodComponent;
  final List<SpriteComponent> _obstacles = [];

  // Sprites
  late final Sprite regularFoodSprite;
  late final Sprite goldenFoodSprite;
  late final Sprite obstacleSprite;

  // Animation
  late final TimerComponent _growthAnimationTimer;

  // Snake component
  late final SnakeComponent _snakeComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Calculate cell size based on the shortest screen dimension
    final screenWidth = size.x;
    final screenHeight = size.y;
    cellSize = (screenWidth < screenHeight ? screenWidth : screenHeight) / GameState.gridSize;

    // Initialize gameState first
    gameState = GameState.initial();

    // Load sprites
    regularFoodSprite = await loadSprite('apple_regular.png');
    goldenFoodSprite = await loadSprite('apple_golden.png');
    obstacleSprite = await loadSprite('stone.png');

    final image = await images.load('games/snake-graphics.png');
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2.all(64));

    final snakeHeadUpSprite = spriteSheet.getSprite(0, 3);
    final snakeHeadRightSprite = spriteSheet.getSprite(0, 4);
    final snakeHeadLeftSprite = spriteSheet.getSprite(1, 3);
    final snakeHeadDownSprite = spriteSheet.getSprite(1, 4);
    final snakeBodyHorizontalSprite = spriteSheet.getSprite(0, 1);
    final snakeBodyVerticalSprite = spriteSheet.getSprite(1, 2);
    final snakeBodyCornerTopLeftSprite = spriteSheet.getSprite(0, 0);
    final snakeBodyCornerTopRightSprite = spriteSheet.getSprite(0, 2);
    final snakeBodyCornerBottomLeftSprite = spriteSheet.getSprite(1, 0);
    final snakeBodyCornerBottomRightSprite = spriteSheet.getSprite(2, 2);
    final snakeTailUpSprite = spriteSheet.getSprite(2, 3);
    final snakeTailRightSprite = spriteSheet.getSprite(2, 4);
    final snakeTailLeftSprite = spriteSheet.getSprite(3, 3);
    final snakeTailDownSprite = spriteSheet.getSprite(3, 4);

    _snakeComponent = SnakeComponent(
      gameState: gameState,
      cellSize: cellSize,
      snakeBodyCornerBottomLeftSprite: snakeBodyCornerBottomLeftSprite,
      snakeBodyCornerBottomRightSprite: snakeBodyCornerBottomRightSprite,
      snakeBodyCornerTopLeftSprite: snakeBodyCornerTopLeftSprite,
      snakeBodyCornerTopRightSprite: snakeBodyCornerTopRightSprite,
      snakeBodyHorizontalSprite: snakeBodyHorizontalSprite,
      snakeBodyVerticalSprite: snakeBodyVerticalSprite,
      snakeHeadDownSprite: snakeHeadDownSprite,
      snakeHeadLeftSprite: snakeHeadLeftSprite,
      snakeHeadRightSprite: snakeHeadRightSprite,
      snakeHeadUpSprite: snakeHeadUpSprite,
      snakeTailDownSprite: snakeTailDownSprite,
      snakeTailLeftSprite: snakeTailLeftSprite,
      snakeTailRightSprite: snakeTailRightSprite,
      snakeTailUpSprite: snakeTailUpSprite,
    );
    add(_snakeComponent);

    // Initialize components once
    _foodComponent = SpriteComponent(sprite: regularFoodSprite, position: Vector2.zero(), size: Vector2.all(cellSize));
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
    gameState.isGameRunning = false; // Game starts paused
    gameState.obstacles = gameLogic.generateObstacles(gameState);

    // Update food component position and sprite
    _foodComponent.position = gameState.food.toVector2() * cellSize;
    _foodComponent.sprite = _getFoodSprite(gameState.foodType);

    // Clear and re-add obstacles
    for (var obstacle in _obstacles) {
      obstacle.removeFromParent();
    }
    _obstacles.clear();
    for (final obstacle in gameState.obstacles) {
      final newObstacle = SpriteComponent(sprite: obstacleSprite, position: (obstacle.toOffset() * cellSize).toVector2(), size: Vector2.all(cellSize));
      _obstacles.add(newObstacle);
      add(newObstacle);
    }
    _snakeComponent.initializeSnake();

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
  }

  void tick() {
    final wasGameOver = gameState.isGameOver;
    final oldFoodType = gameState.foodType;

    gameState = gameLogic.updateGame(gameState);

    // Update food
    _foodComponent.position = gameState.food.toVector2() * cellSize;
    if (gameState.foodType != oldFoodType) {
      _foodComponent.sprite = _getFoodSprite(gameState.foodType);
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
        gamificationService.unlockStoryPart('Fenrir enchaîné', 'fenrir_story');
      }
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          gameLogic.changeDirection(gameState, dp.Direction.up);
          break;
        case LogicalKeyboardKey.arrowDown:
          gameLogic.changeDirection(gameState, dp.Direction.down);
          break;
        case LogicalKeyboardKey.arrowLeft:
          gameLogic.changeDirection(gameState, dp.Direction.left);
          break;
        case LogicalKeyboardKey.arrowRight:
          gameLogic.changeDirection(gameState, dp.Direction.right);
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
