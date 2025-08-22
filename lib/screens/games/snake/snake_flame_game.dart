import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'package:flame/extensions.dart';
import 'dart:async' as async;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_component.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart'; // Import CollectibleCard

import 'game_logic.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;

class SnakeFlameGame extends FlameGame with KeyboardEvents {
  final GameLogic gameLogic = GameLogic();
  late GameState gameState;
  final GamificationService gamificationService;
  final Function(int score, {required bool isVictory, CollectibleCard? wonCard}) onGameEnd; // Modified callback
  final VoidCallback onResetGame;
  final VoidCallback? onRottenFoodEaten;
  final int level;
  final VoidCallback? onGameLoaded; // Add this line
  final VoidCallback? onScoreChanged;

  SnakeFlameGame({
    required this.gamificationService,
    required this.onGameEnd, // Modified callback
    required this.onResetGame,
    this.onRottenFoodEaten,
    required this.level,
    this.onGameLoaded, // Add this line to constructor
    this.onScoreChanged,
  }) {
    gameState = GameState.initial();
    gameLogic.onRottenFoodEaten = onRottenFoodEaten; // Pass the callback
    gameLogic.level = level; // Pass level to gameLogic
  }

  // ...

  void shakeScreen() {
    final originalPosition = camera.viewfinder.position.clone();
    const double shakeIntensity = 10.0;
    const int shakeDurationMs = 200; // 0.2 seconds

    // Simple shake by rapidly changing camera position
    async.Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (timer.tick * 50 > shakeDurationMs) {
        timer.cancel();
        camera.viewfinder.position = originalPosition; // Reset camera position
        return;
      }
      final random = Random();
      camera.viewfinder.position =
          originalPosition + Vector2((random.nextDouble() - 0.5) * shakeIntensity * 2, (random.nextDouble() - 0.5) * shakeIntensity * 2);
    });
  }

  static const int gameSpeed = 300; // milliseconds
  double timeSinceLastTick = 0;

  late final double cellSize;
  late SpriteComponent _foodComponent;
  final List<SpriteComponent> _obstacles = [];

  // Sprites
  late final Sprite regularFoodSprite;
  late final Sprite goldenFoodSprite;
  late final Sprite obstacleSprite;
  late final Sprite rottenFoodSprite;

  // Animation
  late final TimerComponent _growthAnimationTimer;

  // Snake component
  late SnakeComponent _snakeComponent;

  late final Sprite snakeHeadSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Calculate cell size based on the shortest screen dimension
    final screenWidth = size.x;
    final screenHeight = size.y;
    cellSize = (screenWidth < screenHeight ? screenWidth : screenHeight) / GameState.gridSize;

    // Load sprites
    regularFoodSprite = await loadSprite('apple_regular.png');
    goldenFoodSprite = await loadSprite('apple_golden.png');
    rottenFoodSprite = await loadSprite('apple_rotten.png');
    obstacleSprite = await loadSprite('stone.png');

    snakeHeadSprite = await loadSprite('snake_head.png');

    _snakeComponent = SnakeComponent(
      gameState: gameState,
      cellSize: cellSize,
      snakeHeadSprite: snakeHeadSprite,
      animationDuration: gameSpeed / 1000.0, // Initial animation duration
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

    // Initial call to initializeGame, but don’t start the engine yet
    initializeGame();
    pauseEngine(); // Pause engine until start button is pressed

    // Call the onGameLoaded callback when the game is fully loaded
    onGameLoaded?.call(); // Add this line
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

    // Food aging logic
    gameState.foodAge += dt;
    final double foodRottingTime = 8.0 - (gameLogic.level * 0.5); // Adjusted rotting time
    if (gameState.foodAge >= foodRottingTime) {
      // 8 seconds for each stage
      gameState.foodAge = 0.0; // Reset timer after state change
      if (gameState.foodType == FoodType.golden) {
        gameState.foodType = FoodType.regular;
      } else if (gameState.foodType == FoodType.regular) {
        gameState.foodType = FoodType.rotten;
      } else if (gameState.foodType == FoodType.rotten) {
        gameLogic.generateNewFood(gameState); // Disappear and generate new food
      }
      // Update food component sprite after food type change
      _foodComponent.sprite = _getFoodSprite(gameState.foodType);
    }

    timeSinceLastTick += dt;
    final double tickTime = _calculateGameSpeed(gameState.score) / 1000.0;

    if (timeSinceLastTick >= tickTime) {
      timeSinceLastTick = 0;
      tick();
    }

    // Interpolate snake position for smooth movement
  }

  void tick() async {
    // Made tick() async
    final wasGameOver = gameState.isGameOver;
    final oldFoodType = gameState.foodType;
    final oldScore = gameState.score;

    gameState = gameLogic.updateGame(gameState);

    // Update snake component with new game state and animation duration
    _snakeComponent.updateGameState(gameState);
    _snakeComponent.animationDuration = _calculateGameSpeed(gameState.score) / 1000.0;

    if (oldScore != gameState.score) {
      onScoreChanged?.call();
    }

    // Update food
    _foodComponent.position = gameState.food.toVector2() * cellSize;
    if (gameState.foodType != oldFoodType) {
      _foodComponent.sprite = _getFoodSprite(gameState.foodType);
    }

    if (!wasGameOver && gameState.isGameOver) {
      pauseEngine();
      final bool isVictory = gameState.score >= 200;
      CollectibleCard? wonCard;

      if (isVictory) {
        gamificationService.saveGameScore('Snake', gameState.score);
        wonCard = await gamificationService.selectRandomUnearnedCollectibleCard();
      }
      onGameEnd(gameState.score, isVictory: isVictory, wonCard: wonCard);
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
    if (foodType == FoodType.golden) {
      return goldenFoodSprite;
    } else if (foodType == FoodType.regular) {
      return regularFoodSprite;
    } else {
      // FoodType.rotten
      return rottenFoodSprite;
    }
  }

  double _calculateGameSpeed(int currentScore) {
    final double baseSpeedReduction = (currentScore ~/ 20) * 20.0;
    final double acceleratedSpeedReduction = baseSpeedReduction * (1 + gameLogic.level * 0.1); // 10% faster per level
    return (300 - acceleratedSpeedReduction).clamp(50, 300).toDouble();
  }

  void resetGame() {
    // Reinitialize gameState to its initial state
    gameState = GameState.initial();

    // Remove all existing components from the game
    removeAll([_snakeComponent, _foodComponent, ..._obstacles]);
    _obstacles.clear(); // Clear the list of obstacle components

    // Re-create and re-add the snake component
    _snakeComponent = SnakeComponent(
      gameState: gameState,
      cellSize: cellSize,
      snakeHeadSprite: snakeHeadSprite,
      animationDuration: gameSpeed / 1000.0, // Initial animation duration
    );
    add(_snakeComponent);

    // Re-add food component
    add(_foodComponent);

    // Re-initialize game state (generates new food and obstacles)
    initializeGame();

    // Pause the game engine after reset, waiting for the user to start
    pauseEngine();
  }
}
