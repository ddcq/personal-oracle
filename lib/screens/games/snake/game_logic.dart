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
  static const int gridSize = 20;
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
  });

  /// Creates a GameState with the default initial values.
  factory GameState.initial() {
    final Random random = Random();
    IntVector2 initialSnakeHead = _generateRandomPosition(random, _initialSnakeHeadPadding, gridSize - _initialSnakeHeadPadding - 1);
    IntVector2 initialFood = _generateRandomPosition(random, 0, gridSize - 1, exclude: [initialSnakeHead]);

    return GameState(
      snake: [initialSnakeHead],
      food: initialFood,
      foodType: FoodType.regular,
      foodAge: 0.0, // Initialize foodAge
      obstacles: [],
      score: 0,
      direction: dp.Direction.right,
      nextDirection: dp.Direction.right,
      isGameRunning: false,
      isGameOver: false,
    );
  }

  static IntVector2 _generateRandomPosition(Random random, int min, int max, {List<IntVector2>? exclude}) {
    IntVector2 position;
    do {
      position = IntVector2(random.nextInt(max - min + 1) + min, random.nextInt(max - min + 1) + min);
    } while (exclude != null && exclude.contains(position));
    return position;
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
    if (newHead.x < 0 || newHead.x >= GameState.gridSize || newHead.y < 0 || newHead.y >= GameState.gridSize) {
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
    IntVector2 newFood = _generateUniquePosition(random, state.snake, state.obstacles, state.food);

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
      IntVector2 newObstacle = _generateUniquePosition(random, state.snake, state.obstacles, state.food, newObstacles);
      newObstacles.add(newObstacle);
    }
    return newObstacles;
  }

  static IntVector2 _generateUniquePosition(Random random, List<IntVector2> snake, List<IntVector2> obstacles, IntVector2 food, [List<IntVector2>? currentObstacles]) {
    IntVector2 position;
    do {
      position = IntVector2(random.nextInt(GameState.gridSize), random.nextInt(GameState.gridSize));
    } while (snake.contains(position) || obstacles.contains(position) || food == position || (currentObstacles != null && currentObstacles.contains(position)));
    return position;
  }
}