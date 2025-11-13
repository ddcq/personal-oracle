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
  static const int _gameSpeedInitial = 150; // milliseconds
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
  ValueNotifier<GameState>? _gameState;

  /// Safe getter for gameState that doesn't throw
  ValueNotifier<GameState> get gameState {
    if (_gameState == null) {
      // Return a dummy state to prevent crashes - this shouldn't be used in practice
      return ValueNotifier(GameState.initial(gridWidth: 10, gridHeight: 10, obstacles: []));
    }
    return _gameState!;
  }

  late final ValueNotifier<double> remainingFoodTime = ValueNotifier<double>(0);
  bool _isLoaded = false;

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
  final List<RectangleComponent> _obstacleBackgrounds = [];

  // Sprites
  late final Sprite regularFoodSprite;
  late final Sprite goldenFoodSprite;
  late final Sprite obstacleSprite;
  late final Sprite rottenFoodSprite;
  late final Map<BonusType, Sprite> bonusSprites = {};
  
  // Background components
  RectangleComponent? _foodBackground;
  RectangleComponent? _bonusBackground;

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

    int baseGridWidth;
    int baseGridHeight;
    double tempCellSize;

    if (screenWidth < screenHeight) {
      baseGridWidth = baseGridDimension;
      tempCellSize = screenWidth / baseGridWidth;
      baseGridHeight = (screenHeight / tempCellSize).round();
    } else {
      baseGridHeight = baseGridDimension;
      tempCellSize = screenHeight / baseGridHeight;
      baseGridWidth = (screenWidth / tempCellSize).round();
    }

    // Double the resolution for the new "half-square" grid
    final calculatedGridWidth = baseGridWidth * 2;
    final calculatedGridHeight = baseGridHeight * 2;
    cellSize = tempCellSize / 2;

    gameLogic = GameLogic(level: level);
    gameLogic.onRottenFoodEaten = onRottenFoodEaten;
    gameLogic.onConfettiTrigger = onConfettiTrigger;
    gameLogic.onBonusCollected = onBonusCollected;

    // Initialize gameState with the calculated grid dimensions
    // First create a temporary state to generate obstacles
    final tempState = GameState.initial(gridWidth: calculatedGridWidth, gridHeight: calculatedGridHeight, obstacles: []);
    final obstacles = gameLogic.generateObstacles(tempState);
    _gameState = ValueNotifier(GameState.initial(gridWidth: calculatedGridWidth, gridHeight: calculatedGridHeight, obstacles: obstacles));

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
    bonusSprites[BonusType.coin] = await loadSprite('sparkle.png');

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

    // Initialize food background
    _foodBackground = RectangleComponent(
      position: Vector2.zero(),
      size: Vector2.all(cellSize * 2),
      paint: Paint()..color = Colors.red.withValues(alpha: 0.3),
    );
    add(_foodBackground!);

    // Initialize components once
    _foodComponent = SpriteComponent(sprite: regularFoodSprite, position: Vector2.zero(), size: Vector2.all(cellSize * 2));
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

    // Mark game as loaded and call the callback
    _isLoaded = true;
    onGameLoaded?.call();
  }

  void initializeGame() {
    gameState.value.isGameRunning = false; // Game starts paused
    // Obstacles are already set in the GameState.initial factory
    remainingFoodTime.value = _foodRottingTimeBase - (level * _foodRottingTimeLevelFactor);

    // Update food component position and sprite
    _foodComponent.position = gameState.value.food.toVector2() * cellSize;
    _foodComponent.sprite = _getFoodSprite(gameState.value.foodType.value);
    
    // Update food background position
    _foodBackground?.position = gameState.value.food.toVector2() * cellSize;

    // Clear and re-add obstacles
    for (var obstacle in _obstacles) {
      obstacle.removeFromParent();
    }
    _obstacles.clear();
    for (var background in _obstacleBackgrounds) {
      background.removeFromParent();
    }
    _obstacleBackgrounds.clear();
    for (int i = 0; i < gameState.value.obstacles.length; i += 16) {
      final obstacleTopLeft = gameState.value.obstacles[i];
      
      // Add background
      final background = RectangleComponent(
        position: (obstacleTopLeft.toOffset() * cellSize).toVector2(),
        size: Vector2.all(cellSize * 4),
        paint: Paint()..color = Colors.grey.withValues(alpha: 0.4),
      );
      _obstacleBackgrounds.add(background);
      add(background);
      
      final newObstacle = SpriteComponent(
        sprite: obstacleSprite,
        position: (obstacleTopLeft.toOffset() * cellSize).toVector2(),
        size: Vector2.all(cellSize * 4),
      );
      _obstacles.add(newObstacle);
      add(newObstacle);
    }

    _growthAnimationTimer.timer.stop(); // Reset growth animation timer
    _growthAnimationTimer.timer.reset();
  }

  void startGame() {
    // Only start if game is fully loaded
    if (_isLoaded) {
      gameState.value.isGameRunning = true;
      resumeEngine();
    }
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
        gameLogic.generateNewFood(gameState.value); // Disappear and generate new food
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

  void _processGameUpdate(GameState oldState) {
    final oldFoodType = oldState.foodType.value;
    final oldScore = oldState.score;
    final oldObstacleCount = oldState.obstacles.length;
    final oldObstacles = List<IntVector2>.from(oldState.obstacles);
    final oldBonusCount = oldState.activeBonusEffects.length;

    _snakeComponent.updateGameState(gameState.value);
    _snakeComponent.animationDuration = _calculateGameSpeed(gameState.value.score) / 1000.0;

    if (oldBonusCount != gameState.value.activeBonusEffects.length) {
      final temp = gameState.value.clone();
      gameState.value = temp;
    }

    if (oldObstacleCount != gameState.value.obstacles.length) {
      final destroyedObstacle = _findDestroyedObstacle(oldObstacles, gameState.value.obstacles);
      if (destroyedObstacle != null) {
        _triggerRockExplosion(destroyedObstacle);
      }
      _updateObstacles();
    }

    if (oldScore != gameState.value.score) {
      onScoreChanged?.call();
      if (gameState.value.score > oldScore) {
        switch (oldFoodType) {
          case FoodType.regular:
            if (Platform.isAndroid || Platform.isIOS) Vibration.vibrate(duration: _vibrationDurationShort);
            break;
          case FoodType.golden:
            if (Platform.isAndroid || Platform.isIOS) Vibration.vibrate(duration: _vibrationDurationShort, amplitude: _vibrationAmplitudeHigh);
            break;
          default:
            break;
        }
      } else {
        if (Platform.isAndroid || Platform.isIOS) {
          Vibration.vibrate(duration: _vibrationDurationMedium, amplitude: _vibrationAmplitudeHigh);
        }
      }
    }

    _foodComponent.position = gameState.value.food.toVector2() * cellSize;
    _foodBackground?.position = gameState.value.food.toVector2() * cellSize;
    remove(_foodComponent);
    _foodComponent = SpriteComponent(sprite: _getFoodSprite(gameState.value.foodType.value), position: _foodComponent.position, size: Vector2.all(cellSize * 2));
    add(_foodComponent);

    if (gameState.value.activeBonus != null && _bonusComponent == null) {
      // Add bonus background
      _bonusBackground = RectangleComponent(
        position: gameState.value.activeBonus!.position.toVector2() * cellSize,
        size: Vector2.all(cellSize * 2),
        paint: Paint()..color = Colors.yellow.withValues(alpha: 0.3),
      );
      add(_bonusBackground!);
      
      _bonusComponent = SpriteComponent(
        sprite: bonusSprites[gameState.value.activeBonus!.type]!,
        position: gameState.value.activeBonus!.position.toVector2() * cellSize,
        size: Vector2.all(cellSize * 2),
      );
      add(_bonusComponent!);
    } else if (gameState.value.activeBonus == null && _bonusComponent != null) {
      _bonusComponent!.removeFromParent();
      _bonusComponent = null;
      _bonusBackground?.removeFromParent();
      _bonusBackground = null;
      onBonusCollected?.call();
    }
  }

  void _processGameOver() async {
    gameState.value.isGameOver = true;
    gameState.value.isGameRunning = false;
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

  void tick() async {
    if (gameState.value.isGameOver) {
      _processGameOver();
      return;
    }

    final oldState = gameState.value.clone();
    final newState = gameLogic.updateGame(oldState.clone());

    if (newState.pendingGameOver) {
      // Game over immediately
      gameState.value = newState; // update to the final state before game over
      _processGameOver();
      return;
    }

    gameState.value = newState;
    _processGameUpdate(oldState);
  }

  void requestDirectionChange(dp.Direction newDirection) {
    if (!gameState.value.isGameRunning || gameState.value.isGameOver) return;

    // Queue direction change for next tick
    gameLogic.changeDirection(gameState.value, newDirection);
  }

  void _updateObstacles() {
    // Remove all obstacle components
    for (var obstacle in _obstacles) {
      obstacle.removeFromParent();
    }
    _obstacles.clear();

    // Re-add obstacles based on current gameState
    for (int i = 0; i < gameState.value.obstacles.length; i += 16) {
      final obstacleTopLeft = gameState.value.obstacles[i];
      final newObstacle = SpriteComponent(
        sprite: obstacleSprite,
        position: (obstacleTopLeft.toOffset() * cellSize).toVector2(),
        size: Vector2.all(cellSize * 4),
      );
      _obstacles.add(newObstacle);
      add(newObstacle);
    }
  }

  IntVector2? _findDestroyedObstacle(List<IntVector2> oldObstacles, List<IntVector2> newObstacles) {
    // Obstacles are in blocks of 16, find which block is missing
    for (int i = 0; i < oldObstacles.length; i += 16) {
      if (i + 15 < oldObstacles.length) {
        final oldBlock = oldObstacles.getRange(i, i + 16).toList();
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
    final size = Vector2.all(cellSize * 4);
    final center = position + size / 2;

    // Play explosion sound
    final soundService = getIt<SoundService>();
    soundService.playSoundEffect('audio/explode.mp3');

    // Step 1: Flash effect
    final flashEffect = FlashEffect(position: position, size: size);
    add(flashEffect);

    // Step 2: Rock fragments - split rock into 4 pieces
    final random = Random();
    final fragmentSize = Vector2.all(cellSize * 2); // Each fragment is 2x2 cells

    // Create 4 fragments (top-left, top-right, bottom-left, bottom-right)
    final fragmentOffsets = [
      Vector2(0, 0), // Top-left
      Vector2(cellSize * 2, 0), // Top-right
      Vector2(0, cellSize * 2), // Bottom-left
      Vector2(cellSize * 2, cellSize * 2), // Bottom-right
    ];

    final fragmentVelocities = [
      Vector2(-80, -80), // Top-left flies up-left
      Vector2(80, -80), // Top-right flies up-right
      Vector2(-80, 80), // Bottom-left flies down-left
      Vector2(80, 80), // Bottom-right flies down-right
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
      final velocity = Vector2(cos(angle) * speed, sin(angle) * speed);

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
          requestDirectionChange(dp.Direction.up);
          break;
        case LogicalKeyboardKey.arrowDown:
          requestDirectionChange(dp.Direction.down);
          break;
        case LogicalKeyboardKey.arrowLeft:
          requestDirectionChange(dp.Direction.left);
          break;
        case LogicalKeyboardKey.arrowRight:
          requestDirectionChange(dp.Direction.right);
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
    _isLoaded = false; // Mark as not loaded during reset

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

    _isLoaded = true; // Mark as loaded after reset is complete
    pauseEngine();
  }
}