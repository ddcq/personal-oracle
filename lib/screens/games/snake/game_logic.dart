import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;
import 'package:oracle_d_asgard/screens/games/snake/snake_segment.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_flame_game.dart';

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
  dp.Direction? pendingDirection; // Queue for rapid direction changes
  int movesSinceDirectionChange; // Track moves in current direction for 2x2 blocks
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
    this.pendingDirection,
    this.movesSinceDirectionChange = 0,
    this.isGameRunning = false,
    this.isGameOver = false,
    this.bonusJustCollected = false,
    this.pendingGameOver = false,
    this.foodJustEaten = false,
    required this.gridWidth,
    required this.gridHeight,
  })  : foodType = ValueNotifier(foodType),
        collectedBonuses = collectedBonuses ?? [],
        activeBonusEffects = activeBonusEffects ?? [];

  /// Creates a GameState with the default initial values.
  factory GameState.initial({required int gridWidth, required int gridHeight, List<IntVector2>? obstacles}) {
    final Random random = Random();
    final obstacleList = obstacles ?? [];

    // Find longest path in all rows and columns, moving by 2 units
    int maxPathLength = 0;
    IntVector2 bestStartPosition = IntVector2(0, 0);
    dp.Direction bestDirection = dp.Direction.right;

    // Check all horizontal paths (left to right) on even rows
    for (int y = 0; y < gridHeight; y += 2) {
      int pathLength = _calculateStraightDistanceWithObstacles(IntVector2(0, y), dp.Direction.right, gridWidth, gridHeight, obstacleList);
      if (pathLength > maxPathLength) {
        maxPathLength = pathLength;
        bestStartPosition = IntVector2(0, y);
        bestDirection = dp.Direction.right;
      }
    }

    // Check all vertical paths (bottom to top) on even columns
    for (int x = 0; x < gridWidth; x += 2) {
      int pathLength = _calculateStraightDistanceWithObstacles(IntVector2(x, gridHeight - 2), dp.Direction.up, gridWidth, gridHeight, obstacleList);
      if (pathLength > maxPathLength) {
        maxPathLength = pathLength;
        bestStartPosition = IntVector2(x, gridHeight - 2);
        bestDirection = dp.Direction.up;
      }
    }

    IntVector2 initialFood;
    bool foodIsValid;
    int attempts = 0;
    do {
      attempts++;
      int x = random.nextInt((gridWidth - 2) ~/ 2) * 2;
      int y = random.nextInt((gridHeight - 2) ~/ 2) * 2;
      initialFood = IntVector2(x, y);

      foodIsValid = true;
      // Check against snake
      if ((initialFood.x - bestStartPosition.x).abs() < 2 && (initialFood.y - bestStartPosition.y).abs() < 2) {
        foodIsValid = false;
      }
      // Check against obstacles
      if (foodIsValid) {
        for (int j = 0; j < 2; j++) {
          for (int i = 0; i < 2; i++) {
            if (obstacleList.contains(IntVector2(initialFood.x + i, initialFood.y + j))) {
              foodIsValid = false;
              break;
            }
          }
          if (!foodIsValid) break;
        }
      }
    } while (!foodIsValid && attempts < 1000);

    return GameState(
      snake: [
        SnakeSegment(position: bestStartPosition, type: 'head'),
        SnakeSegment(position: _getPreviousPosition(bestStartPosition, bestDirection), type: 'body', subPattern: _getInitialPattern(bestDirection)),
      ],
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

  static IntVector2 _getPreviousPosition(IntVector2 position, dp.Direction direction) {
    switch (direction) {
      case dp.Direction.up:
        return IntVector2(position.x, position.y + 2);
      case dp.Direction.down:
        return IntVector2(position.x, position.y - 2);
      case dp.Direction.left:
        return IntVector2(position.x + 2, position.y);
      case dp.Direction.right:
        return IntVector2(position.x - 2, position.y);
    }
  }

  static String _getInitialPattern(dp.Direction direction) {
    switch (direction) {
      case dp.Direction.up:
        return '0,1,0,-1'; // vertical going up
      case dp.Direction.down:
        return '0,-1,0,1'; // vertical going down
      case dp.Direction.left:
        return '1,0,-1,0'; // horizontal going left
      case dp.Direction.right:
        return '-1,0,1,0'; // horizontal going right
    }
  }

  static int _calculateStraightDistanceWithObstacles(IntVector2 start, dp.Direction direction, int gridWidth, int gridHeight, List<IntVector2> obstacles) {
    int distance = 0;
    IntVector2 current = start;
    while (true) {
      switch (direction) {
        case dp.Direction.up:
          current = IntVector2(current.x, current.y - 2);
          break;
        case dp.Direction.down:
          current = IntVector2(current.x, current.y + 2);
          break;
        case dp.Direction.left:
          current = IntVector2(current.x - 2, current.y);
          break;
        case dp.Direction.right:
          current = IntVector2(current.x + 2, current.y);
          break;
      }

      bool collision = false;
      for (int y = 0; y < 2; y++) {
        for (int x = 0; x < 2; x++) {
          final checkPos = IntVector2(current.x + x, current.y + y);
          if (checkPos.x < 0 || checkPos.x >= gridWidth || checkPos.y < 0 || checkPos.y >= gridHeight || obstacles.contains(checkPos)) {
            collision = true;
            break;
          }
        }
        if (collision) break;
      }

      if (collision) {
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
      pendingDirection: pendingDirection,
      movesSinceDirectionChange: movesSinceDirectionChange,
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
    
    // Check if direction is changing
    bool directionChanging = state.direction != state.nextDirection;
    
    // Apply nextDirection
    state.direction = state.nextDirection;
    
    // Reset or increment move counter
    if (directionChanging) {
      state.movesSinceDirectionChange = 0;
    } else {
      state.movesSinceDirectionChange++;
    }
    
    // If there's a pending direction and we've moved enough in current direction
    // (need at least 2 moves for 2x2 blocks to clear)
    if (state.pendingDirection != null && state.movesSinceDirectionChange >= 2) {
      state.nextDirection = state.pendingDirection!;
      state.pendingDirection = null;
    }
    
    IntVector2 headPos = state.snake.first.position;
    IntVector2 newHeadPos = _getNewHeadPosition(headPos, state.direction);

    final currentSnakePositions = state.snake.map((s) => s.position).toList();

    // Check for bonus effects
    bool hasGhostEffect = state.activeBonusEffects.any((effect) => effect.type == BonusType.ghost);
    bool hasShieldEffect = state.activeBonusEffects.any((effect) => effect.type == BonusType.shield);
    
    // Shield takes priority over ghost if both are active
    bool ignoreObstacles = hasShieldEffect || hasGhostEffect;

    // Check collision (ignore obstacles if ghost or shield is active)
    if (_isCollision(state, newHeadPos, currentSnakePositions, ignoreObstacles: ignoreObstacles)) {
      state.pendingGameOver = true;
    }

    // Handle shield effect - destroy obstacles on collision (shield rules take priority)
    if (hasShieldEffect) {
      final headCells = [
        newHeadPos,
        IntVector2(newHeadPos.x + 1, newHeadPos.y),
        IntVector2(newHeadPos.x, newHeadPos.y + 1),
        IntVector2(newHeadPos.x + 1, newHeadPos.y + 1),
      ];
      for (final cell in headCells) {
        if (state.obstacles.contains(cell)) {
          _removeObstacleBlock(state, cell);
          // We destroyed an obstacle, so we don't game over.
          state.pendingGameOver = false;
          break; // only destroy one block per tick
        }
      }
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
      generateNewFood(state);
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

  bool _isCollision(GameState state, IntVector2 newHeadPos, List<IntVector2> snakePositions, {bool ignoreObstacles = false}) {
    // Wall collision (head is 2x2)
    if (newHeadPos.x < 0 || newHeadPos.x >= state.gridWidth - 1 || newHeadPos.y < 0 || newHeadPos.y >= state.gridHeight - 1) {
      return true;
    }

    // Self-collision
    // The head can overlap with the neck (first body segment) after direction change, so skip first 2 elements.
    for (int i = 2; i < snakePositions.length; i++) {
      final bodyPos = snakePositions[i];
      if ((newHeadPos.x - bodyPos.x).abs() < 2 && (newHeadPos.y - bodyPos.y).abs() < 2) {
        debugPrint('Snake self-collision: newHeadPos=$newHeadPos, bodyPos=$bodyPos (segment $i)');
        return true;
      }
    }

    // Obstacle collision
    if (!ignoreObstacles) {
      final headCells = [
        newHeadPos,
        IntVector2(newHeadPos.x + 1, newHeadPos.y),
        IntVector2(newHeadPos.x, newHeadPos.y + 1),
        IntVector2(newHeadPos.x + 1, newHeadPos.y + 1),
      ];
      for (final cell in headCells) {
        if (state.obstacles.contains(cell)) {
          return true;
        }
      }
    }

    return false;
  }

  bool _handleFoodConsumption(GameState state, IntVector2 newHeadPos) {
    // Food is 2x2, head is 2x2. Check for overlap.
    if ((newHeadPos.x - state.food.x).abs() < 2 && (newHeadPos.y - state.food.y).abs() < 2) {
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

  bool _handleBonusCollection(GameState state, IntVector2 newHeadPos) {
    if (state.activeBonus != null && (newHeadPos.x - state.activeBonus!.position.x).abs() < 2 && (newHeadPos.y - state.activeBonus!.position.y).abs() < 2) {
      final bonusType = state.activeBonus!.type;

      if (bonusType == BonusType.coin) {
        state.score += 20;
        state.activeBonus = null;
        onBonusCollected?.call();
        state.bonusJustCollected = true;
        return true;
      }

      // Check if already have this bonus type
      final existingEffectIndex = state.activeBonusEffects.indexWhere((e) => e.type == bonusType);
      
      if (existingEffectIndex != -1) {
        // Replace existing bonus with new one (reset timer)
        state.activeBonusEffects[existingEffectIndex] = ActiveBonusEffect(type: bonusType, activationTime: 0.0);
      } else {
        // Special rule: Shield replaces Ghost (shield is stronger)
        if (bonusType == BonusType.shield) {
          final ghostIndex = state.activeBonusEffects.indexWhere((e) => e.type == BonusType.ghost);
          if (ghostIndex != -1) {
            state.activeBonusEffects.removeAt(ghostIndex);
            state.collectedBonuses.remove(BonusType.ghost);
          }
        }
        // If collecting ghost while having shield, add it but shield rules take priority
        // (no special handling needed, just add it normally)
        
        state.collectedBonuses.add(bonusType);
        state.activeBonusEffects.add(ActiveBonusEffect(type: bonusType, activationTime: 0.0));
      }
      
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

  void generateNewFood(GameState state) {
    Random random = Random();

    final Set<IntVector2> extraOccupied = {};
    if (state.activeBonus != null) {
      final pos = state.activeBonus!.position;
      extraOccupied.add(pos);
      extraOccupied.add(IntVector2(pos.x + 1, pos.y));
      extraOccupied.add(IntVector2(pos.x, pos.y + 1));
      extraOccupied.add(IntVector2(pos.x + 1, pos.y + 1));
    }

    IntVector2 newFood = _generateValidPositionFor2x2(state, random, extraOccupiedCells: extraOccupied);

    if (random.nextDouble() < _goldenFoodProbability) {
      state.foodType.value = FoodType.golden;
    } else {
      state.foodType.value = FoodType.regular;
    }
    state.food = newFood;
    state.foodAge = 0.0;

    // Randomly spawn bonus
    if (state.activeBonus == null && random.nextDouble() < bonusSpawnProbability) {
      spawnBonus(state);
    }
  }

  void spawnBonus(GameState state) {
    Random random = Random();
    List<BonusType> bonusTypes;

    if (state.obstacles.isEmpty) {
      bonusTypes = [BonusType.speed, BonusType.freeze, BonusType.coin];
    } else {
      bonusTypes = [BonusType.speed, BonusType.shield, BonusType.freeze, BonusType.ghost];
    }

    final randomBonusType = bonusTypes[random.nextInt(bonusTypes.length)];

    final Set<IntVector2> extraOccupied = {
      state.food,
      IntVector2(state.food.x + 1, state.food.y),
      IntVector2(state.food.x, state.food.y + 1),
      IntVector2(state.food.x + 1, state.food.y + 1)
    };

    IntVector2 bonusPosition = _generateValidPositionFor2x2(state, random, extraOccupiedCells: extraOccupied);

    state.activeBonus = Bonus(position: bonusPosition, type: randomBonusType, spawnTime: 0.0);
  }

  void changeDirection(GameState state, dp.Direction newDirection, {bool isRetroactive = false}) {
    if (!state.isGameRunning || state.isGameOver) return;

    // For 2x2 blocks, we need to ensure we've moved at least once in the current direction
    // before allowing another direction change
    final effectiveDirection = state.nextDirection;
    
    // Check if it's opposite to nextDirection (the planned direction)
    final bool isOppositeToNext = _isOppositeDirection(effectiveDirection, newDirection);

    // If opposite to next direction
    if (isOppositeToNext) {
      // Allow direct U-turn only if snake has no body (length <= 2: head + neck)
      if (state.snake.length <= 2) {
        state.nextDirection = newDirection;
        state.pendingDirection = null;
        return;
      }
      // Otherwise ignore the U-turn completely (don't queue it)
      return;
    }

    // Also check if opposite to pendingDirection (if it exists)
    if (state.pendingDirection != null && _isOppositeDirection(state.pendingDirection!, newDirection)) {
      // Ignore this as it would create a U-turn with the pending direction
      return;
    }

    // For 2x2 blocks: if we just changed direction, queue the next change
    if (state.movesSinceDirectionChange < 1 && state.nextDirection != newDirection) {
      // Don't queue if already same as pending
      if (state.pendingDirection != newDirection) {
        state.pendingDirection = newDirection;
      }
      return;
    }

    // Not opposite to next direction and safe to apply
    state.nextDirection = newDirection;
    // Clear pending if we set a new next direction
    state.pendingDirection = null;
  }

  bool _isOppositeDirection(dp.Direction dir1, dp.Direction dir2) {
    return (dir1 == dp.Direction.up && dir2 == dp.Direction.down) ||
           (dir1 == dp.Direction.down && dir2 == dp.Direction.up) ||
           (dir1 == dp.Direction.left && dir2 == dp.Direction.right) ||
           (dir1 == dp.Direction.right && dir2 == dp.Direction.left);
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

  List<IntVector2> generateObstacles(GameState state) {
    Random random = Random();
    List<IntVector2> newObstacles = [];

    // Expand snake and food to all their occupied cells
    final snakeCells = state.snake.expand((s) {
      final pos = s.position;
      return [pos, IntVector2(pos.x + 1, pos.y), IntVector2(pos.x, pos.y + 1), IntVector2(pos.x + 1, pos.y + 1)];
    }).toSet();

    final foodCells = {
      state.food,
      IntVector2(state.food.x + 1, state.food.y),
      IntVector2(state.food.x, state.food.y + 1),
      IntVector2(state.food.x + 1, state.food.y + 1)
    };

    final targetObstacleCount = _baseObstacles + level;

    int obstacleCount = 0;
    int attempts = 0; // To prevent infinite loops
    while (obstacleCount < targetObstacleCount && attempts < 1000) {
      attempts++;
      // Generate top-left corner, ensuring it's not on the very edge for a 4x4 obstacle
      IntVector2 topLeft = IntVector2(random.nextInt(state.gridWidth - 3), random.nextInt(state.gridHeight - 3));

      // Ensure the top-left corner is on an even coordinate to align with the old grid
      if (topLeft.x.isOdd) topLeft = IntVector2(topLeft.x - 1, topLeft.y);
      if (topLeft.y.isOdd) topLeft = IntVector2(topLeft.x, topLeft.y - 1);

      List<IntVector2> obstacleCells = [];
      for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
          obstacleCells.add(IntVector2(topLeft.x + x, topLeft.y + y));
        }
      }

      // Check for overlap with snake, existing obstacles, or food
      final occupiedCells = {...snakeCells, ...foodCells, ...state.obstacles, ...newObstacles};
      bool isOccupied = obstacleCells.any((cell) => occupiedCells.contains(cell));

      if (!isOccupied) {
        newObstacles.addAll(obstacleCells);
        obstacleCount++;
      }
    }
    return newObstacles;
  }

  void _removeObstacleBlock(GameState state, IntVector2 hitPosition) {
    // Obstacles are stored in blocks of 16 consecutive cells (4x4)
    // Find which block contains the hit position
    for (int i = 0; i < state.obstacles.length; i += 16) {
      if (i + 15 < state.obstacles.length) {
        final block = state.obstacles.getRange(i, i + 16);

        if (block.contains(hitPosition)) {
          // Remove all 16 cells of this obstacle block
          state.obstacles.removeRange(i, i + 16);
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

  IntVector2 _generateValidPositionFor2x2(GameState state, Random random, {Set<IntVector2>? extraOccupiedCells}) {
    final Set<IntVector2> occupied = {};

    // Add all snake cells
    for (final segment in state.snake) {
      final pos = segment.position;
      occupied.add(pos);
      occupied.add(IntVector2(pos.x + 1, pos.y));
      occupied.add(IntVector2(pos.x, pos.y + 1));
      occupied.add(IntVector2(pos.x + 1, pos.y + 1));
    }

    // Add all obstacle cells
    occupied.addAll(state.obstacles);

    // Add extra cells if any
    if (extraOccupiedCells != null) {
      occupied.addAll(extraOccupiedCells);
    }

    IntVector2 position;
    bool positionIsValid;
    int attempts = 0;
    do {
      attempts++;
      // Generate a top-left position, ensuring it's on an even coordinate and within bounds for a 2x2 block
      int x = random.nextInt((state.gridWidth - 2) ~/ 2) * 2;
      int y = random.nextInt((state.gridHeight - 2) ~/ 2) * 2;
      position = IntVector2(x, y);

      // Check if the 2x2 block is free
      positionIsValid = true;
      for (int j = 0; j < 2; j++) {
        for (int i = 0; i < 2; i++) {
          if (occupied.contains(IntVector2(position.x + i, position.y + j))) {
            positionIsValid = false;
            break;
          }
        }
        if (!positionIsValid) break;
      }
    } while (!positionIsValid && attempts < 1000);

    if (!positionIsValid) {
      // Fallback: just find any free 2x2 space, not necessarily aligned
      attempts = 0;
      do {
        attempts++;
        position = IntVector2(random.nextInt(state.gridWidth - 1), random.nextInt(state.gridHeight - 1));
        positionIsValid = true;
        for (int j = 0; j < 2; j++) {
          for (int i = 0; i < 2; i++) {
            if (occupied.contains(IntVector2(position.x + i, position.y + j))) {
              positionIsValid = false;
              break;
            }
          }
          if (!positionIsValid) break;
        }
      } while (!positionIsValid && attempts < 2000);
    }

    // If still no position, we might be in trouble, but let's return it anyway
    return position;
  }
}
