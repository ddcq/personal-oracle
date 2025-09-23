import 'dart:math';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;
import 'package:flutter/foundation.dart'; // For VoidCallback

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

  List<IntVector2> snake;
  IntVector2 food;
  FoodType foodType;
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
    this.foodType = FoodType.regular,
    this.foodAge = 0.0, // Initialize foodAge
    required this.obstacles,
    this.score = 0,
    this.direction = dp.Direction.right,
    this.nextDirection = dp.Direction.right,
    this.isGameRunning = false,
    this.isGameOver = false,
    required this.gridWidth,
    required this.gridHeight,
  });

  /// Creates a GameState with the default initial values.
  factory GameState.initial({required int gridWidth, required int gridHeight}) {
    final Random random = Random();
    IntVector2 initialSnakeHead = _generateRandomPosition(random, _initialSnakeHeadPadding, gridWidth - _initialSnakeHeadPadding - 1, _initialSnakeHeadPadding, gridHeight - _initialSnakeHeadPadding - 1);
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
      snake: [initialSnakeHead],
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

  VoidCallback? onRottenFoodEaten; // Add this line
  late int level; // Add this line

  GameState updateGame(GameState state) {
    if (!state.isGameRunning || state.isGameOver) return state;

    // Calculate new head position
    state.direction = state.nextDirection;
    IntVector2 head = state.snake.first;
    IntVector2 newHead = _getNewHeadPosition(head, state.direction);

    // Handle collisions
    if (_isCollision(state, newHead)) {
      state.isGameRunning = false;
      state.isGameOver = true;
      return state;
    }

    // Update snake
    List<IntVector2> newSnake = List.from(state.snake);
    newSnake.insert(0, newHead);

    // Handle food
    if (_handleFoodConsumption(state, newHead, newSnake)) {
      generateNewFood(state);
    } else {
      newSnake.removeLast();
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

  bool _isCollision(GameState state, IntVector2 newHead) {
    // Check for screen boundaries
    if (newHead.x < 0 || newHead.x >= state.gridWidth || newHead.y < 0 || newHead.y >= state.gridHeight) {
      return true;
    }
    // Check for collision with self or obstacles
    if (state.snake.contains(newHead) || state.obstacles.contains(newHead)) {
      return true;
    }
    return false;
  }

  bool _handleFoodConsumption(GameState state, IntVector2 newHead, List<IntVector2> newSnake) {
    if (newHead == state.food) {
      if (state.foodType == FoodType.golden) {
        state.score += _scoreGoldenFood;
      } else if (state.foodType == FoodType.regular) {
        state.score += _scoreRegularFood;
      } else if (state.foodType == FoodType.rotten) {
        state.score -= (_scoreRottenFoodPenaltyBase + (level * _scoreRottenFoodPenaltyPerLevel));
        onRottenFoodEaten?.call();
      }
      return true;
    }
    return false;
  }

  void generateNewFood(GameState state) {
    Random random = Random();
    IntVector2 newFood = _generateUniquePosition(random, state.snake, state.obstacles, state.food, state.gridWidth, state.gridHeight);

    if (random.nextDouble() < _goldenFoodProbability) {
      state.foodType = FoodType.golden;
    } else {
      state.foodType = FoodType.regular;
    }
    state.food = newFood;
    state.foodAge = 0.0;
  }

  void changeDirection(GameState state, dp.Direction newDirection) {
    if (!state.isGameRunning || state.isGameOver) return;

    final bool isOppositeDirection = (
            (state.direction == dp.Direction.up && newDirection == dp.Direction.down) ||
            (state.direction == dp.Direction.down && newDirection == dp.Direction.up) ||
            (state.direction == dp.Direction.left && newDirection == dp.Direction.right) ||
            (state.direction == dp.Direction.right && newDirection == dp.Direction.left)
        );

    if (!isOppositeDirection) {
      state.nextDirection = newDirection;
    }
  }

  List<IntVector2> generateObstacles(GameState state) {
    Random random = Random();
    List<IntVector2> newObstacles = [];
    for (int i = 0; i < (_baseObstacles + level); i++) {
      IntVector2 newObstacle = _generateUniquePosition(random, state.snake, state.obstacles, state.food, state.gridWidth, state.gridHeight, newObstacles);
      newObstacles.add(newObstacle);
    }
    return newObstacles;
  }

  static IntVector2 _generateUniquePosition(Random random, List<IntVector2> snake, List<IntVector2> obstacles, IntVector2 food, int gridWidth, int gridHeight, [List<IntVector2>? currentObstacles]) {
    IntVector2 position;
    do {
      position = IntVector2(random.nextInt(gridWidth), random.nextInt(gridHeight));
    } while (snake.contains(position) || obstacles.contains(position) || food == position || (currentObstacles != null && currentObstacles.contains(position)));
    return position;
  }
}