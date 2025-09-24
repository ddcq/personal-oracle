import 'dart:io';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:vibration/vibration.dart';

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
  static const double _shakeIntensity = 10.0;
  static const int _shakeDurationMs = 200;
  static const int _shakeIntervalMs = 50;
  static const int _gameSpeedInitial = 300; // milliseconds
  static const double _growthAnimationPeriod = 0.15;
  static const double _foodRottingTimeBase = 8.0;
  static const double _foodRottingTimeLevelFactor = 0.5;
  static const int _vibrationDurationShort = 100;
  static const int _vibrationDurationMedium = 200;
  static const int _vibrationDurationLong = 500;
  static const int _vibrationAmplitudeHigh = 255;
  static const int _victoryScoreThreshold = 200;
  static const int _speedReductionScoreInterval = 20;
  static const double _speedReductionFactor = 20.0;
  static const double _speedAccelerationPerLevel = 0.07; // 7% faster per level
  static const int _minGameSpeed = 50;

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
    // gridWidth and gridHeight will be calculated in onLoad()
    gameLogic.onRottenFoodEaten = onRottenFoodEaten; // Pass the callback
    gameLogic.level = level; // Pass level to gameLogic
  }

  @override
  Color backgroundColor() => Colors.transparent;

  // ...

  void shakeScreen() {
    final originalPosition = camera.viewfinder.position.clone();

    // Simple shake by rapidly changing camera position
    async.Timer.periodic(const Duration(milliseconds: _shakeIntervalMs), (timer) {
      if (timer.tick * _shakeIntervalMs > _shakeDurationMs) {
        timer.cancel();
        camera.viewfinder.position = originalPosition; // Reset camera position
        return;
      }
      final random = Random();
      camera.viewfinder.position =
          originalPosition + Vector2((random.nextDouble() - 0.5) * _shakeIntensity * 2, (random.nextDouble() - 0.5) * _shakeIntensity * 2);
    });
  }

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
  late final Sprite snakeBodySprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final screenWidth = size.x;
    final screenHeight = size.y;

    // Define a base grid dimension for the shorter side
    final int baseGridDimension = 20; // This was GameState.gridSize previously

    int calculatedGridWidth;
    int calculatedGridHeight;

    if (screenWidth < screenHeight) {
      calculatedGridWidth = baseGridDimension;
      cellSize = screenWidth / calculatedGridWidth;
      calculatedGridHeight = (screenHeight / cellSize).round();
    } else {
      calculatedGridHeight = baseGridDimension;
      cellSize = screenHeight / calculatedGridHeight;
      calculatedGridWidth = (screenWidth / cellSize).round();
    }

    // Initialize gameState with the calculated grid dimensions
    gameState = GameState.initial(gridWidth: calculatedGridWidth, gridHeight: calculatedGridHeight);

    // Load sprites
    regularFoodSprite = await loadSprite('apple_regular.png');
    goldenFoodSprite = await loadSprite('apple_golden.png');
    rottenFoodSprite = await loadSprite('apple_rotten.png');
    obstacleSprite = await loadSprite('stone.png');

    snakeHeadSprite = await loadSprite('snake_head.png');
    snakeBodySprite = await loadSprite('snake_body.png');
    _snakeComponent = SnakeComponent(
      gameState: gameState,
      cellSize: cellSize,
      snakeHeadSprite: snakeHeadSprite,
      snakeBodySprite: snakeBodySprite,
      animationDuration: _gameSpeedInitial / 1000.0, // Initial animation duration
    );
    add(_snakeComponent);

    // Initialize components once
    _foodComponent = SpriteComponent(sprite: regularFoodSprite, position: Vector2.zero(), size: Vector2.all(cellSize));
    add(_foodComponent);

    // Initialize growth animation timer
    _growthAnimationTimer = TimerComponent(
      period: _growthAnimationPeriod, // 150 milliseconds
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
    final double foodRottingTime = _foodRottingTimeBase - (gameLogic.level * _foodRottingTimeLevelFactor); // Adjusted rotting time
    if (gameState.foodAge >= foodRottingTime) {
      // 8 seconds for each stage
      gameState.foodAge = 0.0; // Reset timer after state change
      if (gameState.foodType == FoodType.golden) {
        gameState.foodType = FoodType.regular;
      } else if (gameState.foodType == FoodType.regular) {
        gameState.foodType = FoodType.rotten;
      } else if (gameState.foodType == FoodType.rotten) {
        final currentSnakePositions = gameState.snake.map((s) => s.position).toList();
        gameLogic.generateNewFood(gameState, currentSnakePositions); // Disappear and generate new food
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

  double _calculateGameSpeed(int currentScore) {
    final double baseSpeedReduction = (currentScore ~/ _speedReductionScoreInterval) * _speedReductionFactor;
    final double acceleratedSpeedReduction = baseSpeedReduction * (1 + gameLogic.level * _speedAccelerationPerLevel); // 10% faster per level
    return (_gameSpeedInitial - acceleratedSpeedReduction).clamp(_minGameSpeed, _gameSpeedInitial).toDouble();
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

    if (oldScore < gameState.score) {
      onScoreChanged?.call();
      // Vibrate based on food type
      switch (oldFoodType) {
        case FoodType.regular:
          if (Platform.isAndroid || Platform.isIOS) {
            Vibration.vibrate(duration: _vibrationDurationShort);
          }
          break;
        case FoodType.golden:
          if (Platform.isAndroid || Platform.isIOS) {
            Vibration.vibrate(duration: _vibrationDurationShort, amplitude: _vibrationAmplitudeHigh);
          }
          break;
        case FoodType.rotten:
          // No vibration for rotten food
          break;
      }
    } else if (oldScore > gameState.score) {
      // Rotten apple eaten
      onScoreChanged?.call();
      if (Platform.isAndroid || Platform.isIOS) {
        Vibration.vibrate(duration: _vibrationDurationMedium, amplitude: _vibrationAmplitudeHigh);
      }
      await Future.delayed(const Duration(milliseconds: _vibrationDurationMedium));
      if (Platform.isAndroid || Platform.isIOS) {
        Vibration.vibrate(duration: _vibrationDurationMedium, amplitude: _vibrationAmplitudeHigh);
      }
    }

    // Update food
    _foodComponent.position = gameState.food.toVector2() * cellSize;
    if (gameState.foodType != oldFoodType) {
      _foodComponent.sprite = _getFoodSprite(gameState.foodType);
    }

    if (!wasGameOver && gameState.isGameOver) {
      pauseEngine();
      if (Platform.isAndroid || Platform.isIOS) {
        Vibration.vibrate(duration: _vibrationDurationLong); // Game over vibration
      }
      final bool isVictory = gameState.score >= _victoryScoreThreshold;
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

  void resetGame() {
    // Reinitialize gameState to its initial state
    gameState = GameState.initial(gridWidth: gameState.gridWidth, gridHeight: gameState.gridHeight);

    // Remove all existing components from the game
    removeAll([_snakeComponent, _foodComponent, ..._obstacles]);
    _obstacles.clear(); // Clear the list of obstacle components

    // Re-create and re-add the snake component
    _snakeComponent = SnakeComponent(
      gameState: gameState,
      cellSize: cellSize,
      snakeHeadSprite: snakeHeadSprite,
      snakeBodySprite: snakeBodySprite,
      animationDuration: _gameSpeedInitial / 1000.0, // Initial animation duration
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
