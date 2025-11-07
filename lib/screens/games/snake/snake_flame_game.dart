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

import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/screens/games/snake/game_logic.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_component.dart';
import 'package:oracle_d_asgard/screens/games/snake/rock_explosion_effect.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;

class SnakeFlameGame extends FlameGame with KeyboardEvents {
  final GamificationService gamificationService;
  final Function(int, {required bool isVictory, CollectibleCard? wonCard}) onGameEnd;
  final VoidCallback? onResetGame;
  final VoidCallback? onRottenFoodEaten;
  final VoidCallback? onScoreChanged;
  final VoidCallback? onConfettiTrigger;
  final VoidCallback? onBonusCollected;
  final VoidCallback? onGameLoaded;
  final int level;

  SnakeFlameGame({
    required this.gamificationService,
    required this.onGameEnd,
    this.onResetGame,
    this.onRottenFoodEaten,
    this.onScoreChanged,
    this.onConfettiTrigger,
    this.onBonusCollected,
    this.onGameLoaded,
    required this.level,
  });

  static const double _shakeIntensity = 10.0;
  static const int _shakeDurationMs = 200;
  static const int _shakeIntervalMs = 50;
  static const int _gameSpeedInitial = 300; // milliseconds
  static const double _growthAnimationPeriod = 0.15;
  static const double _foodRottingTimeBase = 12.0;
  static const double _foodRottingTimeLevelFactor = 0.5;
  static const int _vibrationDurationShort = 100;
  static const int _vibrationDurationMedium = 200;
  static const int _vibrationDurationLong = 500;
  static const int _vibrationAmplitudeHigh = 255;
  static const int victoryScoreThreshold = 100;
  static const int _minGameSpeed = 50;

  late final GameLogic gameLogic;
  late final ValueNotifier<GameState> gameState;
  late final ValueNotifier<double> remainingFoodTime = ValueNotifier<double>(0);

  @override
  Color backgroundColor() => Colors.transparent;

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
  SpriteComponent? _bonusComponent;
  final List<SpriteComponent> _obstacles = [];

  // Sprites
  late final Sprite regularFoodSprite;
  late final Sprite goldenFoodSprite;
  late final Sprite obstacleSprite;
  late final Sprite rottenFoodSprite;
  late final Map<BonusType, Sprite> bonusSprites = {};

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

    const int maxBaseGridDimension = 20;
    const int minBaseGridDimension = 10;
    final int baseGridDimension = (minBaseGridDimension + level - 1).clamp(minBaseGridDimension, maxBaseGridDimension).toInt();

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

    gameLogic = GameLogic(level: level);
    gameLogic.onRottenFoodEaten = onRottenFoodEaten;
    gameLogic.onConfettiTrigger = onConfettiTrigger;
    gameLogic.onBonusCollected = onBonusCollected;

    // Initialize gameState with the calculated grid dimensions
    // First create a temporary state to generate obstacles
    final tempState = GameState.initial(gridWidth: calculatedGridWidth, gridHeight: calculatedGridHeight, obstacles: []);
    final obstacles = gameLogic.generateObstacles(tempState);
    gameState = ValueNotifier(GameState.initial(gridWidth: calculatedGridWidth, gridHeight: calculatedGridHeight, obstacles: obstacles));

    // Load sprites
    regularFoodSprite = await loadSprite('snake/apple_regular.png');
    goldenFoodSprite = await loadSprite('snake/apple_golden.png');
    rottenFoodSprite = await loadSprite('snake/apple_rotten.png');
    obstacleSprite = await loadSprite('snake/stone.webp');

    // Load bonus sprites (placeholder - use food sprites for now)
    bonusSprites[BonusType.speed] = await loadSprite('snake/speed.png');
    bonusSprites[BonusType.shield] = await loadSprite('snake/shield.png');
    bonusSprites[BonusType.freeze] = await loadSprite('snake/freeze.png');
    bonusSprites[BonusType.ghost] = await loadSprite('snake/ghost.png');

    snakeHeadSprite = await loadSprite('snake/snake_head.png');
    snakeBodySprite = await loadSprite('snake/snake_body.png');
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
    gameState.value.isGameRunning = false; // Game starts paused
    // Obstacles are already set in the GameState.initial factory
    remainingFoodTime.value = _foodRottingTimeBase - (level * _foodRottingTimeLevelFactor);

    // Update food component position and sprite
    _foodComponent.position = gameState.value.food.toVector2() * cellSize;
    _foodComponent.sprite = _getFoodSprite(gameState.value.foodType.value);

    // Clear and re-add obstacles
    for (var obstacle in _obstacles) {
      obstacle.removeFromParent();
    }
    _obstacles.clear();
    for (int i = 0; i < gameState.value.obstacles.length; i += 4) {
      final obstacleTopLeft = gameState.value.obstacles[i];
      final newObstacle = SpriteComponent(
        sprite: obstacleSprite,
        position: (obstacleTopLeft.toOffset() * cellSize).toVector2(),
        size: Vector2.all(cellSize * 2),
      );
      _obstacles.add(newObstacle);
      add(newObstacle);
    }

    _growthAnimationTimer.timer.stop(); // Reset growth animation timer
    _growthAnimationTimer.timer.reset();
  }

  void startGame() {
    gameState.value.isGameRunning = true;
    resumeEngine();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameState.value.isGameRunning || gameState.value.isGameOver) {
      return;
    }

    // Bonus aging logic
    if (gameState.value.activeBonus != null) {
      final bonus = gameState.value.activeBonus!;
      final updatedBonus = Bonus(position: bonus.position, type: bonus.type, spawnTime: bonus.spawnTime + dt);
      gameState.value.activeBonus = updatedBonus;

      if (updatedBonus.spawnTime >= GameLogic.bonusLifetime) {
        gameState.value.activeBonus = null;
        _bonusComponent?.removeFromParent();
        _bonusComponent = null;
      }
    }

    // Bonus effect aging logic
    if (gameState.value.activeBonusEffects.isNotEmpty) {
      final originalLength = gameState.value.activeBonusEffects.length;
      final updatedEffects = <ActiveBonusEffect>[];

      for (var effect in gameState.value.activeBonusEffects) {
        final updatedEffect = ActiveBonusEffect(type: effect.type, activationTime: effect.activationTime + dt);

        if (updatedEffect.activationTime < GameLogic.bonusEffectDuration) {
          updatedEffects.add(updatedEffect);
        }
      }

      // Update the list
      gameState.value.activeBonusEffects.clear();
      gameState.value.activeBonusEffects.addAll(updatedEffects);

      // If a bonus expired, force immediate notification
      if (updatedEffects.length < originalLength) {
        final newState = gameState.value.clone();
        // Schedule for next frame to avoid setState during build
        Future.microtask(() {
          if (!gameState.value.isGameOver) {
            gameState.value = newState;
          }
        });
      }
    }

    // Food aging logic
    gameState.value.foodAge += dt;
    final double foodRottingTime = _foodRottingTimeBase - (level * _foodRottingTimeLevelFactor); // Adjusted rotting time
    // Defer the update to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      remainingFoodTime.value = foodRottingTime - gameState.value.foodAge;
    });
    if (gameState.value.foodAge >= foodRottingTime) {
      // 8 seconds for each stage
      gameState.value.foodAge = 0.0; // Reset timer after state change
      if (gameState.value.foodType.value == FoodType.golden) {
        gameState.value.foodType.value = FoodType.regular;
        _foodComponent.sprite = _getFoodSprite(gameState.value.foodType.value);
      } else if (gameState.value.foodType.value == FoodType.regular) {
        gameState.value.foodType.value = FoodType.rotten;
        _foodComponent.sprite = _getFoodSprite(gameState.value.foodType.value);
      } else if (gameState.value.foodType.value == FoodType.rotten) {
        final currentSnakePositions = gameState.value.snake.map((s) => s.position).toList();
        gameLogic.generateNewFood(gameState.value, currentSnakePositions); // Disappear and generate new food
        _foodComponent.position = gameState.value.food.toVector2() * cellSize;
        _foodComponent.sprite = _getFoodSprite(gameState.value.foodType.value);
      }
    }

    timeSinceLastTick += dt;
    final double baseTickTime = _calculateGameSpeed(gameState.value.score) / 1000.0;
    final double speedMultiplier = gameLogic.getSpeedMultiplier(gameState.value);
    final double tickTime = baseTickTime * speedMultiplier;

    if (timeSinceLastTick >= tickTime) {
      timeSinceLastTick = 0;
      tick();
    }
  }

  double _calculateGameSpeed(int currentScore) {
    return (_gameSpeedInitial - currentScore).clamp(_minGameSpeed, _gameSpeedInitial).toDouble();
  }

  void tick() async {
    final wasGameOver = gameState.value.isGameOver;
    final oldFoodType = gameState.value.foodType.value;
    final oldScore = gameState.value.score;
    final oldObstacleCount = gameState.value.obstacles.length;
    final oldObstacles = List<IntVector2>.from(gameState.value.obstacles);
    final oldBonusCount = gameState.value.activeBonusEffects.length;

    gameState.value = gameLogic.updateGame(gameState.value);

    _snakeComponent.updateGameState(gameState.value);
    _snakeComponent.animationDuration = _calculateGameSpeed(gameState.value.score) / 1000.0;

    // Check if bonus effects expired
    if (oldBonusCount != gameState.value.activeBonusEffects.length) {
      // Force rebuild by reassigning
      final temp = gameState.value.clone();
      gameState.value = temp;
    }

    // Check if obstacles were destroyed
    if (oldObstacleCount != gameState.value.obstacles.length) {
      // Find which obstacle was destroyed
      final destroyedObstacle = _findDestroyedObstacle(oldObstacles, gameState.value.obstacles);
      if (destroyedObstacle != null) {
        _triggerRockExplosion(destroyedObstacle);
      }
      _updateObstacles();
    }

    if (oldScore < gameState.value.score) {
      onScoreChanged?.call();
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
          break;
      }
    } else if (oldScore > gameState.value.score) {
      onScoreChanged?.call();
      if (Platform.isAndroid || Platform.isIOS) {
        Vibration.vibrate(duration: _vibrationDurationMedium, amplitude: _vibrationAmplitudeHigh);
      }
      await Future.delayed(const Duration(milliseconds: _vibrationDurationMedium));
      if (Platform.isAndroid || Platform.isIOS) {
        Vibration.vibrate(duration: _vibrationDurationMedium, amplitude: _vibrationAmplitudeHigh);
      }
    }

    _foodComponent.position = gameState.value.food.toVector2() * cellSize;
    remove(_foodComponent);
    _foodComponent = SpriteComponent(sprite: _getFoodSprite(gameState.value.foodType.value), position: _foodComponent.position, size: Vector2.all(cellSize));
    add(_foodComponent);

    // Update bonus component
    if (gameState.value.activeBonus != null && _bonusComponent == null) {
      _bonusComponent = SpriteComponent(
        sprite: bonusSprites[gameState.value.activeBonus!.type]!,
        position: gameState.value.activeBonus!.position.toVector2() * cellSize,
        size: Vector2.all(cellSize),
      );
      add(_bonusComponent!);
    } else if (gameState.value.activeBonus == null && _bonusComponent != null) {
      _bonusComponent!.removeFromParent();
      _bonusComponent = null;
      onBonusCollected?.call();
    }

    if (!wasGameOver && gameState.value.isGameOver) {
      pauseEngine();
      if (Platform.isAndroid || Platform.isIOS) {
        Vibration.vibrate(duration: _vibrationDurationLong);
      }
      final bool isVictory = gameState.value.score >= victoryScoreThreshold;
      CollectibleCard? wonCard;

      if (isVictory) {
        gamificationService.saveGameScore('Snake', gameState.value.score);
        wonCard = await gamificationService.selectRandomUnearnedCollectibleCard();
      }
      onGameEnd(gameState.value.score, isVictory: isVictory, wonCard: wonCard);
    }
  }

  void _updateObstacles() {
    // Remove all obstacle components
    for (var obstacle in _obstacles) {
      obstacle.removeFromParent();
    }
    _obstacles.clear();

    // Re-add obstacles based on current gameState
    for (int i = 0; i < gameState.value.obstacles.length; i += 4) {
      final obstacleTopLeft = gameState.value.obstacles[i];
      final newObstacle = SpriteComponent(
        sprite: obstacleSprite,
        position: (obstacleTopLeft.toOffset() * cellSize).toVector2(),
        size: Vector2.all(cellSize * 2),
      );
      _obstacles.add(newObstacle);
      add(newObstacle);
    }
  }

  IntVector2? _findDestroyedObstacle(List<IntVector2> oldObstacles, List<IntVector2> newObstacles) {
    // Obstacles are in blocks of 4, find which block is missing
    for (int i = 0; i < oldObstacles.length; i += 4) {
      if (i + 3 < oldObstacles.length) {
        final oldBlock = oldObstacles.getRange(i, i + 4).toList();
        final blockStillExists = oldBlock.every((pos) => newObstacles.contains(pos));
        
        if (!blockStillExists) {
          // Return the top-left position of the destroyed obstacle
          return oldBlock[0];
        }
      }
    }
    return null;
  }

  void _triggerRockExplosion(IntVector2 obstacleTopLeft) {
    final position = (obstacleTopLeft.toOffset() * cellSize).toVector2();
    final size = Vector2.all(cellSize * 2);
    final center = position + size / 2;

    // Play explosion sound
    final soundService = getIt<SoundService>();
    soundService.playSoundEffect('audio/explode.mp3');

    // Step 1: Flash effect
    final flashEffect = FlashEffect(
      position: position,
      size: size,
    );
    add(flashEffect);

    // Step 2: Rock fragments - split rock into 4 pieces
    final random = Random();
    final fragmentSize = Vector2.all(cellSize); // Each fragment is 1 cell

    // Create 4 fragments (top-left, top-right, bottom-left, bottom-right)
    final fragmentOffsets = [
      Vector2(0, 0),           // Top-left
      Vector2(cellSize, 0),    // Top-right
      Vector2(0, cellSize),    // Bottom-left
      Vector2(cellSize, cellSize), // Bottom-right
    ];

    final fragmentVelocities = [
      Vector2(-80, -80),  // Top-left flies up-left
      Vector2(80, -80),   // Top-right flies up-right
      Vector2(-80, 80),   // Bottom-left flies down-left
      Vector2(80, 80),    // Bottom-right flies down-right
    ];

    for (int i = 0; i < 4; i++) {
      final fragment = RockFragment(
        sprite: obstacleSprite,
        position: position + fragmentOffsets[i] + fragmentSize / 2, // Center of fragment
        size: fragmentSize,
        velocity: fragmentVelocities[i],
        rotationSpeed: (random.nextDouble() - 0.5) * 8, // -4 to 4 rad/s
      );
      add(fragment);
    }

    // Step 3: Debris particles
    const particleCount = 12;
    final debrisColors = [
      const Color(0xFF808080), // Gray
      const Color(0xFF696969), // Dim gray
      const Color(0xFFA9A9A9), // Dark gray
      const Color(0xFF5C4033), // Brown
    ];

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * pi + random.nextDouble() * 0.5;
      final speed = 100 + random.nextDouble() * 100; // 100-200 pixels/sec
      final velocity = Vector2(
        cos(angle) * speed,
        sin(angle) * speed,
      );

      final debris = DebrisParticle(
        position: center.clone(),
        velocity: velocity,
        particleColor: debrisColors[random.nextInt(debrisColors.length)],
        rotationSpeed: (random.nextDouble() - 0.5) * 10, // -5 to 5
      );
      add(debris);
    }

    // Step 4: Camera shake
    shakeScreen();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          gameLogic.changeDirection(gameState.value, dp.Direction.up);
          break;
        case LogicalKeyboardKey.arrowDown:
          gameLogic.changeDirection(gameState.value, dp.Direction.down);
          break;
        case LogicalKeyboardKey.arrowLeft:
          gameLogic.changeDirection(gameState.value, dp.Direction.left);
          break;
        case LogicalKeyboardKey.arrowRight:
          gameLogic.changeDirection(gameState.value, dp.Direction.right);
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
      return rottenFoodSprite;
    }
  }

  void resetGame() {
    // First create a temporary state to generate obstacles
    final tempState = GameState.initial(gridWidth: gameState.value.gridWidth, gridHeight: gameState.value.gridHeight, obstacles: []);
    final obstacles = gameLogic.generateObstacles(tempState);
    gameState.value = GameState.initial(gridWidth: gameState.value.gridWidth, gridHeight: gameState.value.gridHeight, obstacles: obstacles);

    removeAll([_snakeComponent, _foodComponent, ..._obstacles]);
    _obstacles.clear();

    _snakeComponent = SnakeComponent(
      gameState: gameState,
      cellSize: cellSize,
      snakeHeadSprite: snakeHeadSprite,
      snakeBodySprite: snakeBodySprite,
      animationDuration: _gameSpeedInitial / 1000.0,
    );
    add(_snakeComponent);

    add(_foodComponent);

    initializeGame();
    remainingFoodTime.value = _foodRottingTimeBase - (level * _foodRottingTimeLevelFactor);

    pauseEngine();
  }
}
