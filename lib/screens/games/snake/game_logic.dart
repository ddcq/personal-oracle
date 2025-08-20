import 'dart:math';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;

// ==========================================
// ENUMS
// ==========================================
enum FoodType { regular, golden }



// ==========================================
// GAME STATE
// ==========================================
/// Holds all the data representing the current state of the game.
class GameState {
  List<IntVector2> snake;
  IntVector2 food;
  FoodType foodType;
  List<IntVector2> obstacles;
  int score;
  dp.Direction direction;
  dp.Direction nextDirection;
  bool isGameRunning;
  bool isGameOver;

  static const int gridSize = 20;

  GameState({
    required this.snake,
    required this.food,
    this.foodType = FoodType.regular,
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
    IntVector2 initialSnakeHead;
    IntVector2 initialFood;

    // Generate random initial snake head position
    do {
      initialSnakeHead = IntVector2(
        random.nextInt(gridSize),
        random.nextInt(gridSize),
      );
    } while (initialSnakeHead.x < 2 || initialSnakeHead.y < 2 || initialSnakeHead.x > gridSize - 3 || initialSnakeHead.y > gridSize - 3); // Ensure not too close to edges

    // Generate random initial food position, not on snake
    do {
      initialFood = IntVector2(
        random.nextInt(gridSize),
        random.nextInt(gridSize),
      );
    } while (initialFood == initialSnakeHead);

    return GameState(
      snake: [initialSnakeHead],
      food: initialFood,
      obstacles: [],
      score: 0,
      direction: dp.Direction.right,
      nextDirection: dp.Direction.right,
      isGameRunning: false,
      isGameOver: false,
    );
  }
}

// ==========================================
// GAME LOGIC
// ==========================================
class GameLogic {
  GameState updateGame(GameState state) {
    if (!state.isGameRunning || state.isGameOver) return state;

    // Calculate new head position
    state.direction = state.nextDirection;
    IntVector2 head = state.snake.first;
    IntVector2 newHead = head; // Initialize newHead to avoid "not assigned" error
    switch (state.direction) {
      case dp.Direction.up:
        newHead = IntVector2(head.x, head.y - 1);
        break;
      case dp.Direction.down:
        newHead = IntVector2(head.x, head.y + 1);
        break;
      case dp.Direction.left:
        newHead = IntVector2(head.x - 1, head.y);
        break;
      case dp.Direction.right:
        newHead = IntVector2(head.x + 1, head.y);
        break;
    }

    // Handle screen boundaries (game over)
    if (newHead.x < 0 || newHead.x >= GameState.gridSize ||
        newHead.y < 0 || newHead.y >= GameState.gridSize) {
      state.isGameRunning = false;
      state.isGameOver = true;
      return state;
    }

    // Check for collision with self or obstacles
    if (state.snake.contains(newHead) || state.obstacles.contains(newHead)) {
      state.isGameRunning = false;
      state.isGameOver = true;
      return state;
    }

    // Update snake
    List<IntVector2> newSnake = List.from(state.snake);
    newSnake.insert(0, newHead);

    // Check for food
    if (newHead == state.food) {
      state.score += (state.foodType == FoodType.golden) ? 50 : 10;
      // Don’t remove tail, generate new food
      _generateNewFood(state);
    } else {
      newSnake.removeLast();
    }

    state.snake = newSnake;
    return state;
  }

  void _generateNewFood(GameState state) {
    Random random = Random();
    IntVector2 newFood;
    do {
      newFood = IntVector2(
        random.nextInt(GameState.gridSize),
        random.nextInt(GameState.gridSize),
      );
    } while (state.snake.contains(newFood) || state.obstacles.contains(newFood));

    if (random.nextDouble() < 0.15) {
      state.foodType = FoodType.golden;
    } else {
      state.foodType = FoodType.regular;
    }
    state.food = newFood;
  }

  void changeDirection(GameState state, dp.Direction newDirection) {
    if (!state.isGameRunning || state.isGameOver) return;

    if ((state.direction == dp.Direction.up && newDirection == dp.Direction.down) ||
        (state.direction == dp.Direction.down && newDirection == dp.Direction.up) ||
        (state.direction == dp.Direction.left && newDirection == dp.Direction.right) ||
        (state.direction == dp.Direction.right && newDirection == dp.Direction.left)) {
      return;
    }

    state.nextDirection = newDirection;
  }

  List<IntVector2> generateObstacles(GameState state) {
    Random random = Random();
    List<IntVector2> newObstacles = [];
    for (int i = 0; i < 5; i++) {
      IntVector2 newObstacle;
      do {
        newObstacle = IntVector2(
          random.nextInt(GameState.gridSize),
          random.nextInt(GameState.gridSize),
        );
      } while (state.snake.contains(newObstacle) || state.food == newObstacle || newObstacles.contains(newObstacle));
      newObstacles.add(newObstacle);
    }
    return newObstacles;
  }
}