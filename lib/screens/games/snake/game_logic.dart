import 'dart:math';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;
import 'package:flutter/foundation.dart'; // For VoidCallback
import 'package:oracle_d_asgard/screens/games/snake/snake_segment.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_flame_game.dart'; // Import for victoryScoreThreshold

// ==========================================
// ENUMS
// ==========================================
enum FoodType { regular, golden, rotten }

enum BonusType { speed, shield, freeze, ghost, coin }

// ==========================================
// BONUS
// ==========================================
class Bonus {
  final IntVector2 position;
  final BonusType type;
  final double spawnTime;

  Bonus({required this.position, required this.type, required this.spawnTime});

  Bonus clone() {
    return Bonus(position: position.clone(), type: type, spawnTime: spawnTime);
  }
}

class ActiveBonusEffect {
  final BonusType type;
  final double activationTime;

  ActiveBonusEffect({required this.type, required this.activationTime});

  ActiveBonusEffect clone() {
    return ActiveBonusEffect(type: type, activationTime: activationTime);
  }
}

// ==========================================
// GAME STATE
// ==========================================
/// Holds all the data representing the current state of the game.
class GameState {
  final int gridWidth;
  final int gridHeight;

  List<SnakeSegment> snake;
  IntVector2 food;
  ValueNotifier<FoodType> foodType;
  double foodAge;
  List<IntVector2> obstacles;
  Bonus? activeBonus;
  List<BonusType> collectedBonuses;
  List<ActiveBonusEffect> activeBonusEffects;
  int score;
  dp.Direction direction;
  dp.Direction nextDirection;
  bool isGameRunning;
  bool isGameOver;
  bool bonusJustCollected;
  bool pendingGameOver;
  bool foodJustEaten;

  GameState({
    required this.snake,
    required this.food,
    FoodType foodType = FoodType.regular,
    this.foodAge = 0.0,
    required this.obstacles,
    this.activeBonus,
    List<BonusType>? collectedBonuses,
    List<ActiveBonusEffect>? activeBonusEffects,
    this.score = 0,
    this.direction = dp.Direction.right,
    this.nextDirection = dp.Direction.right,
    this.isGameRunning = false,
    this.isGameOver = false,
    this.bonusJustCollected = false,
    this.pendingGameOver = false,
    this.foodJustEaten = false,
    required this.gridWidth,
    required this.gridHeight,
  }) : foodType = ValueNotifier(foodType),
       collectedBonuses = collectedBonuses ?? [],
       activeBonusEffects = activeBonusEffects ?? [];

  /// Creates a GameState with the default initial values.
  factory GameState.initial({required int gridWidth, required int gridHeight, List<IntVector2>? obstacles}) {
    final Random random = Random();
    final obstacleList = obstacles ?? [];

    // Find longest path in all rows and columns
    int maxPathLength = 0;
    IntVector2 bestStartPosition = IntVector2(0, 0);
    dp.Direction bestDirection = dp.Direction.right;

    // Check all horizontal paths (left to right)
    for (int y = 0; y < gridHeight; y++) {
      int pathLength = _calculateStraightDistanceWithObstacles(IntVector2(0, y), dp.Direction.right, gridWidth, gridHeight, obstacleList);
      if (pathLength > maxPathLength) {
        maxPathLength = pathLength;
        bestStartPosition = IntVector2(0, y);
        bestDirection = dp.Direction.right;
      }
    }

    // Check all vertical paths (bottom to top)
    for (int x = 0; x < gridWidth; x++) {
      int pathLength = _calculateStraightDistanceWithObstacles(IntVector2(x, gridHeight - 1), dp.Direction.up, gridWidth, gridHeight, obstacleList);
      if (pathLength > maxPathLength) {
        maxPathLength = pathLength;
        bestStartPosition = IntVector2(x, gridHeight - 1);
        bestDirection = dp.Direction.up;
      }
    }

    IntVector2 initialFood = _generateRandomPosition(random, 0, gridWidth - 1, 0, gridHeight - 1, exclude: [bestStartPosition], obstacles: obstacleList);

    return GameState(
      snake: [SnakeSegment(position: bestStartPosition, type: 'head')],
      food: initialFood,
      foodType: FoodType.regular,
      foodAge: 0.0,
      obstacles: obstacleList,
      activeBonus: null,
      collectedBonuses: [],
      activeBonusEffects: [],
      score: 0,
      direction: bestDirection,
      nextDirection: bestDirection,
      isGameRunning: false,
      isGameOver: false,
      gridWidth: gridWidth,
      gridHeight: gridHeight,
    );
  }

  static IntVector2 _generateRandomPosition(Random random, int minX, int maxX, int minY, int maxY, {List<IntVector2>? exclude, List<IntVector2>? obstacles}) {
    IntVector2 position;
    do {
      position = IntVector2(random.nextInt(maxX - minX + 1) + minX, random.nextInt(maxY - minY + 1) + minY);
    } while ((exclude != null && exclude.contains(position)) || (obstacles != null && obstacles.contains(position)));
    return position;
  }

  static int _calculateStraightDistanceWithObstacles(IntVector2 start, dp.Direction direction, int gridWidth, int gridHeight, List<IntVector2> obstacles) {
    int distance = 0;
    IntVector2 current = start;
    while (true) {
      switch (direction) {
        case dp.Direction.up:
          current = IntVector2(current.x, current.y - 1);
          break;
        case dp.Direction.down:
          current = IntVector2(current.x, current.y + 1);
          break;
        case dp.Direction.left:
          current = IntVector2(current.x - 1, current.y);
          break;
        case dp.Direction.right:
          current = IntVector2(current.x + 1, current.y);
          break;
      }

      if (current.x < 0 || current.x >= gridWidth || current.y < 0 || current.y >= gridHeight || obstacles.contains(current)) {
        break; // Hit a wall or obstacle
      }
      distance++;
    }
    return distance;
  }

  GameState clone() {
    return GameState(
      snake: snake.map((segment) => segment.clone()).toList(),
      food: food.clone(),
      foodType: foodType.value,
      foodAge: foodAge,
      obstacles: obstacles.map((obstacle) => obstacle.clone()).toList(),
      activeBonus: activeBonus?.clone(),
      collectedBonuses: List<BonusType>.from(collectedBonuses),
      activeBonusEffects: activeBonusEffects.map((effect) => effect.clone()).toList(),
      score: score,
      direction: direction,
      nextDirection: nextDirection,
      isGameRunning: isGameRunning,
      isGameOver: isGameOver,
      bonusJustCollected: bonusJustCollected,
      pendingGameOver: pendingGameOver,
      foodJustEaten: foodJustEaten,
      gridWidth: gridWidth,
      gridHeight: gridHeight,
    );
  }
}

// ==========================================
// GAME LOGIC
// ==========================================
class GameLogic {
  static const int _scoreGoldenFood = 50;
  static const int _scoreRegularFood = 10;
  static const int _scoreRottenFoodPenaltyBase = 10;
  static const int _scoreRottenFoodPenaltyPerLevel = 10;
  static const double _goldenFoodProbability = 0.15;
  static const int _baseObstacles = 1;
  static const double bonusSpawnProbability = 1;
  static const double bonusLifetime = 8.0;
  static const double bonusEffectDuration = 8.0;
  static const double speedBonusMultiplier = 0.7; // 30% faster (multiply time by 0.7)
  static const double freezeBonusMultiplier = 1.3; // 30% slower (multiply time by 1.3)

  VoidCallback? onRottenFoodEaten;
  VoidCallback? onConfettiTrigger;
  VoidCallback? onBonusCollected;
  late int level;

  GameLogic({required this.level});

  GameState updateGame(GameState state) {
    if (!state.isGameRunning || state.isGameOver) return state;

    state.bonusJustCollected = false;
    state.foodJustEaten = false;
    state.direction = state.nextDirection;
    IntVector2 headPos = state.snake.first.position;
    IntVector2 newHeadPos = _getNewHeadPosition(headPos, state.direction);

    final currentSnakePositions = state.snake.map((s) => s.position).toList();

    // Check for bonus effects
    bool hasGhostEffect = state.activeBonusEffects.any((effect) => effect.type == BonusType.ghost);
    bool hasShieldEffect = state.activeBonusEffects.any((effect) => effect.type == BonusType.shield);

    // Check collision (ignore obstacles if ghost or shield is active)
    if (_isCollision(state, newHeadPos, currentSnakePositions, ignoreObstacles: hasGhostEffect || hasShieldEffect)) {
      state.pendingGameOver = true;
    }

    // Handle shield effect - destroy obstacles on collision
    if (hasShieldEffect && state.obstacles.contains(newHeadPos)) {
      _removeObstacleBlock(state, newHeadPos);
    }

    bool foodEaten = _handleFoodConsumption(state, newHeadPos);
    _handleBonusCollection(state, newHeadPos);

    List<SnakeSegment> newSnake = [];

    // 1. Add the new head
    newSnake.add(SnakeSegment(position: newHeadPos, type: 'head'));

    // 2. Add the old head (now the first body segment)
    String? oldHeadSubPattern;
    if (state.snake.length > 1) {
      oldHeadSubPattern = _getPattern(newHeadPos, state.snake.first.position, state.snake[1].position);
    } else {
      // If the snake was just a head, it becomes a straight body segment.
      final dx = newHeadPos.x - state.snake.first.position.x;
      final dy = newHeadPos.y - state.snake.first.position.y;
      oldHeadSubPattern = '${-dx},${-dy},$dx,$dy';
    }
    newSnake.add(SnakeSegment(position: state.snake.first.position, type: 'body', subPattern: oldHeadSubPattern));

    // 3. Add the rest of the body segments (from state.snake[1] onwards, excluding the old head at index 0)
    // These segments keep their position and pattern.
    for (int i = 1; i < state.snake.length; i++) {
      newSnake.add(state.snake[i].clone());
    }

    // 4. Handle food consumption and tail removal
    if (foodEaten) {
      generateNewFood(state, newSnake.map((s) => s.position).toList());
      // Keep all segments when eating - the snake grows by 1
    } else {
      // If not eating, remove the last segment to maintain length
      if (newSnake.length > 1) {
        newSnake.removeLast();
      }
    }
    
    // 5. Set the tail type on the last segment
    if (newSnake.length > 1) {
      newSnake.last.type = 'tail';
    }

    state.snake = newSnake;
    return state;
  }

  IntVector2 _getNewHeadPosition(IntVector2 currentHead, dp.Direction direction) {
    switch (direction) {
      case dp.Direction.up:
        return IntVector2(currentHead.x, currentHead.y - 1);
      case dp.Direction.down:
        return IntVector2(currentHead.x, currentHead.y + 1);
      case dp.Direction.left:
        return IntVector2(currentHead.x - 1, currentHead.y);
      case dp.Direction.right:
        return IntVector2(currentHead.x + 1, currentHead.y);
    }
  }

  bool _isCollision(GameState state, IntVector2 newHead, List<IntVector2> snakePositions, {bool ignoreObstacles = false}) {
    if (newHead.x < 0 || newHead.x >= state.gridWidth || newHead.y < 0 || newHead.y >= state.gridHeight) {
      return true;
    }
    if (snakePositions.contains(newHead)) {
      return true;
    }
    if (!ignoreObstacles && state.obstacles.contains(newHead)) {
      return true;
    }
    return false;
  }

  bool _handleFoodConsumption(GameState state, IntVector2 newHead) {
    if (newHead == state.food) {
      state.foodJustEaten = true;
      if (state.foodType.value == FoodType.golden) {
        state.score += _scoreGoldenFood;
      } else if (state.foodType.value == FoodType.regular) {
        state.score += _scoreRegularFood;
      } else if (state.foodType.value == FoodType.rotten) {
        state.score -= (_scoreRottenFoodPenaltyBase + (level * _scoreRottenFoodPenaltyPerLevel));
        onRottenFoodEaten?.call();
      }

      // Trigger confetti if score is above threshold and food is not rotten
      if (state.score >= SnakeFlameGame.victoryScoreThreshold && state.foodType.value != FoodType.rotten) {
        onConfettiTrigger?.call();
      }
      return true;
    }
    return false;
  }

  bool _handleBonusCollection(GameState state, IntVector2 newHead) {
    if (state.activeBonus != null && newHead == state.activeBonus!.position) {
      final bonusType = state.activeBonus!.type;

      if (bonusType == BonusType.coin) {
        state.score += 20;
        state.activeBonus = null;
        onBonusCollected?.call();
        state.bonusJustCollected = true;
        return true;
      }

      state.collectedBonuses.add(bonusType);
      state.activeBonusEffects.add(ActiveBonusEffect(type: bonusType, activationTime: 0.0));
      state.activeBonus = null;
      onBonusCollected?.call();
      state.bonusJustCollected = true;
      return true;
    }
    return false;
  }

  double getSpeedMultiplier(GameState state) {
    double multiplier = 1.0;
    for (var effect in state.activeBonusEffects) {
      if (effect.type == BonusType.speed) {
        multiplier *= speedBonusMultiplier;
      } else if (effect.type == BonusType.freeze) {
        multiplier *= freezeBonusMultiplier;
      }
    }
    return multiplier;
  }

  void generateNewFood(GameState state, List<IntVector2> snakePositions) {
    Random random = Random();
    IntVector2 newFood = _generateUniquePosition(
      random,
      snakePositions,
      state.obstacles,
      state.food,
      state.gridWidth,
      state.gridHeight,
      state.activeBonus?.position,
    );

    if (random.nextDouble() < _goldenFoodProbability) {
      state.foodType.value = FoodType.golden;
    } else {
      state.foodType.value = FoodType.regular;
    }
    state.food = newFood;
    state.foodAge = 0.0;

    // Randomly spawn bonus
    if (state.activeBonus == null && random.nextDouble() < bonusSpawnProbability) {
      spawnBonus(state, snakePositions);
    }
  }

  void spawnBonus(GameState state, List<IntVector2> snakePositions) {
    Random random = Random();
    List<BonusType> bonusTypes;

    if (state.obstacles.isEmpty) {
      bonusTypes = [BonusType.speed, BonusType.freeze, BonusType.coin];
    } else {
      bonusTypes = [BonusType.speed, BonusType.shield, BonusType.freeze, BonusType.ghost];
    }

    final randomBonusType = bonusTypes[random.nextInt(bonusTypes.length)];

    IntVector2 bonusPosition = _generateUniquePosition(random, snakePositions, state.obstacles, state.food, state.gridWidth, state.gridHeight, null);

    state.activeBonus = Bonus(position: bonusPosition, type: randomBonusType, spawnTime: 0.0);
  }

  void changeDirection(GameState state, dp.Direction newDirection, {bool isRetroactive = false}) {
    if (!state.isGameRunning || state.isGameOver) return;

    final currentDirection = isRetroactive && state.snake.length > 1
        ? _getDirectionFromPositions(state.snake[1].position, state.snake[0].position)
        : state.direction;

    final bool isOppositeDirection = ((currentDirection == dp.Direction.up && newDirection == dp.Direction.down) ||
        (currentDirection == dp.Direction.down && newDirection == dp.Direction.up) ||
        (currentDirection == dp.Direction.left && newDirection == dp.Direction.right) ||
        (currentDirection == dp.Direction.right && newDirection == dp.Direction.left));

    if (!isOppositeDirection) {
      state.nextDirection = newDirection;
    }
  }

  dp.Direction _getDirectionFromPositions(IntVector2 from, IntVector2 to) {
    if (to.x > from.x) return dp.Direction.right;
    if (to.x < from.x) return dp.Direction.left;
    if (to.y > from.y) return dp.Direction.down;
    return dp.Direction.up;
  }

  void rotateLeft(GameState state) {
    final currentDirection = state.direction;
    dp.Direction newDirection;
    switch (currentDirection) {
      case dp.Direction.up:
        newDirection = dp.Direction.left;
        break;
      case dp.Direction.right:
        newDirection = dp.Direction.up;
        break;
      case dp.Direction.down:
        newDirection = dp.Direction.right;
        break;
      case dp.Direction.left:
        newDirection = dp.Direction.down;
        break;
    }
    changeDirection(state, newDirection);
  }

  void rotateRight(GameState state) {
    final currentDirection = state.direction;
    dp.Direction newDirection;
    switch (currentDirection) {
      case dp.Direction.up:
        newDirection = dp.Direction.right;
        break;
      case dp.Direction.right:
        newDirection = dp.Direction.down;
        break;
      case dp.Direction.down:
        newDirection = dp.Direction.left;
        break;
      case dp.Direction.left:
        newDirection = dp.Direction.up;
        break;
    }
    changeDirection(state, newDirection);
  }

  bool performRetrospectiveUpdate(GameState state, dp.Direction newDirection) {
    // 1. Pre-computation & Safety checks
    if (state.bonusJustCollected || state.foodJustEaten) return false;
    if (state.snake.length < 2) return false; // Cannot look back one step

    final IntVector2 headBeforeLastMove = state.snake[1].position;

    final bool isOpposite = ((state.direction == dp.Direction.up && newDirection == dp.Direction.down) ||
        (state.direction == dp.Direction.down && newDirection == dp.Direction.up) ||
        (state.direction == dp.Direction.left && newDirection == dp.Direction.right) ||
        (state.direction == dp.Direction.right && newDirection == dp.Direction.left));
    if (isOpposite) return false;

    // 2. Calculate intended new head position
    final IntVector2 intendedHeadPos = _getNewHeadPosition(headBeforeLastMove, newDirection);

    // 3. Collision check for the intended move
    final snakeBodyForCollision = state.snake.sublist(1).map((s) => s.position).toList();
    bool hasGhostEffect = state.activeBonusEffects.any((effect) => effect.type == BonusType.ghost);
    bool hasShieldEffect = state.activeBonusEffects.any((effect) => effect.type == BonusType.shield);

    if (_isCollision(state, intendedHeadPos, snakeBodyForCollision, ignoreObstacles: hasGhostEffect || hasShieldEffect)) {
      return false;
    }

    // --- At this point, we commit to the change ---

    // 4. Preserve info about the original move
    final IntVector2 originalHeadPos = state.snake[0].position;
    final bool originalMoveAteFood = (originalHeadPos == state.food);

    // 5. Check food/bonus situation for the NEW move
    final bool newMoveAteFood = (intendedHeadPos == state.food);
    final bool newMoveCollectedBonus = (state.activeBonus != null && intendedHeadPos == state.activeBonus!.position);

    // 6. Adjust score
    if (originalMoveAteFood && !newMoveAteFood) {
      _adjustScore(state, state.foodType.value, subtract: true);
    }
    if (newMoveAteFood && !originalMoveAteFood) {
      _adjustScore(state, state.foodType.value, subtract: false);
    }

    // 7. Build the new snake
    List<SnakeSegment> newSnake = [];
    newSnake.add(SnakeSegment(position: intendedHeadPos, type: 'head')); // New head

    String? newBodySegmentPattern;
    if (state.snake.length > 2) {
      newBodySegmentPattern = _getPattern(intendedHeadPos, state.snake[1].position, state.snake[2].position);
    } else {
      final dx = intendedHeadPos.x - state.snake[1].position.x;
      final dy = intendedHeadPos.y - state.snake[1].position.y;
      newBodySegmentPattern = '${-dx},${-dy},$dx,$dy';
    }
    newSnake.add(SnakeSegment(position: headBeforeLastMove, type: 'body', subPattern: newBodySegmentPattern));

    newSnake.addAll(state.snake.sublist(2));

    // 8. Handle food consumption and tail management
    if (newMoveAteFood) {
      generateNewFood(state, newSnake.map((s) => s.position).toList());
      // Snake grows by 1 - keep all segments
    }
    // Note: We do NOT remove the last segment when not eating in retrospective update
    // because we're replacing the last move, not adding a new move
    
    // 9. Set the tail type
    if (newSnake.length > 1) {
      newSnake.last.type = 'tail';
    } else if (newSnake.length == 1) {
      newSnake.first.type = 'head';
    }

    // 9. Update the state object
    state.snake = newSnake;
    state.direction = newDirection;
    state.nextDirection = newDirection;

    // 10. Handle food generation if needed
    if (newMoveAteFood) {
      generateNewFood(state, newSnake.map((s) => s.position).toList());
    }

    // 11. Handle bonus collection
    if (newMoveCollectedBonus) {
      _handleBonusCollection(state, intendedHeadPos);
    }
    
    // 12. Handle shield effect
    if (hasShieldEffect && state.obstacles.contains(intendedHeadPos)) {
      _removeObstacleBlock(state, intendedHeadPos);
    }

    return true; // Success!
  }

  void _adjustScore(GameState state, FoodType foodType, {bool subtract = false}) {
    int sign = subtract ? -1 : 1;
    if (foodType == FoodType.golden) {
      state.score += _scoreGoldenFood * sign;
    } else if (foodType == FoodType.regular) {
      state.score += _scoreRegularFood * sign;
    } else if (foodType == FoodType.rotten) {
      state.score -= (_scoreRottenFoodPenaltyBase + (level * _scoreRottenFoodPenaltyPerLevel)) * sign;
      if (!subtract) {
        onRottenFoodEaten?.call();
      }
    }
  }

  List<IntVector2> generateObstacles(GameState state) {
    Random random = Random();
    List<IntVector2> newObstacles = [];
    final snakePositions = state.snake.map((s) => s.position).toList();

    final targetObstacleCount = _baseObstacles + level;

    int obstacleCount = 0;
    int attempts = 0; // To prevent infinite loops
    while (obstacleCount < targetObstacleCount && attempts < 1000) {
      attempts++;
      // Generate top-left corner, ensuring it's not on the very edge
      IntVector2 topLeft = IntVector2(random.nextInt(state.gridWidth - 1), random.nextInt(state.gridHeight - 1));

      List<IntVector2> obstacleCells = [
        topLeft,
        IntVector2(topLeft.x + 1, topLeft.y),
        IntVector2(topLeft.x, topLeft.y + 1),
        IntVector2(topLeft.x + 1, topLeft.y + 1),
      ];

      // Check for overlap with snake, existing obstacles, or food
      bool isOccupied = obstacleCells.any(
        (cell) => snakePositions.contains(cell) || state.obstacles.contains(cell) || newObstacles.contains(cell) || state.food == cell,
      );

      if (!isOccupied) {
        newObstacles.addAll(obstacleCells);
        obstacleCount++;
      }
    }
    return newObstacles;
  }

  static IntVector2 _generateUniquePosition(
    Random random,
    List<IntVector2> snake,
    List<IntVector2> obstacles,
    IntVector2 food,
    int gridWidth,
    int gridHeight,
    IntVector2? bonusPosition,
  ) {
    IntVector2 position;
    do {
      position = IntVector2(random.nextInt(gridWidth), random.nextInt(gridHeight));
    } while (snake.contains(position) || obstacles.contains(position) || food == position || (bonusPosition != null && bonusPosition == position));
    return position;
  }

  void _removeObstacleBlock(GameState state, IntVector2 hitPosition) {
    // Obstacles are stored in blocks of 4 consecutive cells (2x2)
    // Find which block contains the hit position
    for (int i = 0; i < state.obstacles.length; i += 4) {
      if (i + 3 < state.obstacles.length) {
        final block = state.obstacles.getRange(i, i + 4);

        if (block.contains(hitPosition)) {
          // Remove all 4 cells of this obstacle block
          state.obstacles.removeRange(i, i + 4);
          return;
        }
      }
    }
  }

  String _getPattern(IntVector2 prevPos, IntVector2 currentPos, IntVector2 nextPos) {
    final prevRelative = prevPos - currentPos;
    final nextRelative = nextPos - currentPos;
    return '${prevRelative.x},${prevRelative.y},${nextRelative.x},${nextRelative.y}';
  }
}
