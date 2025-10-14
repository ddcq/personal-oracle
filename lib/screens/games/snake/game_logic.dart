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

// ==========================================
// GAME STATE
// ==========================================
/// Holds all the data representing the current state of the game.
class GameState {
  final int gridWidth;
  final int gridHeight;
  static const int _initialSnakeHeadPadding = 2;

  List<SnakeSegment> snake;
  IntVector2 food;
  ValueNotifier<FoodType> foodType;
  double foodAge; // Add this line
  List<IntVector2> obstacles;
  int score;
  dp.Direction direction;
  dp.Direction nextDirection;
  bool isGameRunning;
  bool isGameOver;

  GameState({
    required this.snake,
    required this.food,
    FoodType foodType = FoodType.regular,
    this.foodAge = 0.0, // Initialize foodAge
    required this.obstacles,
    this.score = 0,
    this.direction = dp.Direction.right,
    this.nextDirection = dp.Direction.right,
    this.isGameRunning = false,
    this.isGameOver = false,
    required this.gridWidth,
    required this.gridHeight,
  }) : foodType = ValueNotifier(foodType);

  /// Creates a GameState with the default initial values.
  factory GameState.initial({required int gridWidth, required int gridHeight}) {
    final Random random = Random();
    IntVector2 initialSnakeHead = _generateRandomPosition(
      random,
      _initialSnakeHeadPadding,
      gridWidth - _initialSnakeHeadPadding - 1,
      _initialSnakeHeadPadding,
      gridHeight - _initialSnakeHeadPadding - 1,
    );
    IntVector2 initialFood = _generateRandomPosition(random, 0, gridWidth - 1, 0, gridHeight - 1, exclude: [initialSnakeHead]);

    // Determine the best initial direction
    Map<dp.Direction, int> distances = {
      dp.Direction.up: _calculateStraightDistance(initialSnakeHead, dp.Direction.up, gridWidth, gridHeight),
      dp.Direction.down: _calculateStraightDistance(initialSnakeHead, dp.Direction.down, gridWidth, gridHeight),
      dp.Direction.left: _calculateStraightDistance(initialSnakeHead, dp.Direction.left, gridWidth, gridHeight),
      dp.Direction.right: _calculateStraightDistance(initialSnakeHead, dp.Direction.right, gridWidth, gridHeight),
    };

    dp.Direction bestDirection = dp.Direction.right; // Default if all are 0 or tied
    int maxDistance = -1;

    // Find the direction with the maximum distance
    distances.forEach((direction, distance) {
      if (distance > maxDistance) {
        maxDistance = distance;
        bestDirection = direction;
      }
    });

    return GameState(
      snake: [SnakeSegment(position: initialSnakeHead, type: 'head')],
      food: initialFood,
      foodType: FoodType.regular,
      foodAge: 0.0, // Initialize foodAge
      obstacles: [],
      score: 0,
      direction: bestDirection,
      nextDirection: bestDirection,
      isGameRunning: false,
      isGameOver: false,
      gridWidth: gridWidth,
      gridHeight: gridHeight,
    );
  }

  static IntVector2 _generateRandomPosition(Random random, int minX, int maxX, int minY, int maxY, {List<IntVector2>? exclude}) {
    IntVector2 position;
    do {
      position = IntVector2(random.nextInt(maxX - minX + 1) + minX, random.nextInt(maxY - minY + 1) + minY);
    } while (exclude != null && exclude.contains(position));
    return position;
  }

  static int _calculateStraightDistance(IntVector2 start, dp.Direction direction, int gridWidth, int gridHeight) {
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

      if (current.x < 0 || current.x >= gridWidth || current.y < 0 || current.y >= gridHeight) {
        break; // Hit a wall
      }
      distance++;
    }
    return distance;
  }

  GameState clone() {
    return GameState(
      snake: snake.map((segment) => segment.clone()).toList(),
      food: food.clone(),
      foodType: foodType.value, // Clone the value
      foodAge: foodAge,
      obstacles: obstacles.map((obstacle) => obstacle.clone()).toList(),
      score: score,
      direction: direction,
      nextDirection: nextDirection,
      isGameRunning: isGameRunning,
      isGameOver: isGameOver,
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
  static const int _baseObstacles = 5;

  VoidCallback? onRottenFoodEaten;
  VoidCallback? onConfettiTrigger; // Add this line
  late int level;

  GameState updateGame(GameState state) {
    if (!state.isGameRunning || state.isGameOver) return state;

    state.direction = state.nextDirection;
    IntVector2 headPos = state.snake.first.position;
    IntVector2 newHeadPos = _getNewHeadPosition(headPos, state.direction);

    final currentSnakePositions = state.snake.map((s) => s.position).toList();
    if (_isCollision(state, newHeadPos, currentSnakePositions)) {
      state.isGameRunning = false;
      state.isGameOver = true;
      return state;
    }

    bool foodEaten = _handleFoodConsumption(state, newHeadPos);

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

    // 3. Add the rest of the body segments (from state.snake[1] onwards)
    // These segments keep their position and pattern.
    for (int i = 1; i < state.snake.length; i++) {
      newSnake.add(state.snake[i].clone());
    }

    // 4. Handle food consumption and tail removal
    if (foodEaten) {
      generateNewFood(state, newSnake.map((s) => s.position).toList());
    } else {
      // If not eating, remove the last segment
      newSnake.removeLast();
      if (newSnake.length > 1) {
        // Ensure there's a tail to modify
        final lastSegment = newSnake.last;
        // The subPattern should already be set from when it was a body segment.
        lastSegment.type = 'tail'; // Change type to 'tail'
      }
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

  bool _isCollision(GameState state, IntVector2 newHead, List<IntVector2> snakePositions) {
    if (newHead.x < 0 || newHead.x >= state.gridWidth || newHead.y < 0 || newHead.y >= state.gridHeight) {
      return true;
    }
    if (snakePositions.contains(newHead) || state.obstacles.contains(newHead)) {
      return true;
    }
    return false;
  }

  bool _handleFoodConsumption(GameState state, IntVector2 newHead) {
          if (newHead == state.food) {
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
          }    return false;
  }

  void generateNewFood(GameState state, List<IntVector2> snakePositions) {
    Random random = Random();
    IntVector2 newFood = _generateUniquePosition(random, snakePositions, state.obstacles, state.food, state.gridWidth, state.gridHeight);

    if (random.nextDouble() < _goldenFoodProbability) {
      state.foodType.value = FoodType.golden;
    } else {
      state.foodType.value = FoodType.regular;
    }
    state.food = newFood;
    state.foodAge = 0.0;
  }

  void changeDirection(GameState state, dp.Direction newDirection) {
    if (!state.isGameRunning || state.isGameOver) return;

    final bool isOppositeDirection =
        (( // This line was changed
        state.direction == dp.Direction.up && newDirection == dp.Direction.down) ||
        (state.direction == dp.Direction.down && newDirection == dp.Direction.up) ||
        (state.direction == dp.Direction.left && newDirection == dp.Direction.right) ||
        (state.direction == dp.Direction.right && newDirection == dp.Direction.left));

    if (!isOppositeDirection) {
      state.nextDirection = newDirection;
    }
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
    final snakePositions = state.snake.map((s) => s.position).toList();

    int obstacleCount = 0;
    int attempts = 0; // To prevent infinite loops
    while (obstacleCount < (_baseObstacles + level) && attempts < 1000) {
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
    int gridHeight, [
    List<IntVector2>? currentObstacles,
  ]) {
    IntVector2 position;
    do {
      position = IntVector2(random.nextInt(gridWidth), random.nextInt(gridHeight));
    } while (snake.contains(position) || obstacles.contains(position) || food == position || (currentObstacles != null && currentObstacles.contains(position)));
    return position;
  }

  String _getPattern(IntVector2 prevPos, IntVector2 currentPos, IntVector2 nextPos) {
    final prevRelative = prevPos - currentPos;
    final nextRelative = nextPos - currentPos;
    return '${prevRelative.x},${prevRelative.y},${nextRelative.x},${nextRelative.y}';
  }
}
