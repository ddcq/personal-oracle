import 'dart:math';
import 'dart:ui';

// ==========================================
// ENUMS
// ==========================================
enum FoodType { regular, golden }
enum Direction { up, down, left, right }


// ==========================================
// GAME STATE
// ==========================================
/// Holds all the data representing the current state of the game.
class GameState {
  List<Offset> snake;
  Offset food;
  FoodType foodType;
  List<Offset> obstacles;
  int score;
  Direction direction;
  Direction nextDirection;
  bool isGameRunning;
  bool isGameOver;

  static const int gridSize = 20;

  GameState({
    required this.snake,
    required this.food,
    this.foodType = FoodType.regular,
    required this.obstacles,
    this.score = 0,
    this.direction = Direction.right,
    this.nextDirection = Direction.right,
    this.isGameRunning = false,
    this.isGameOver = false,
  });

  /// Creates a GameState with the default initial values.
  factory GameState.initial() {
    return GameState(
      snake: [const Offset(10, 10)],
      food: const Offset(15, 15),
      obstacles: [],
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
    Offset head = state.snake.first;
    Offset newHead;

    switch (state.direction) {
      case Direction.up:
        newHead = Offset(head.dx, head.dy - 1);
        break;
      case Direction.down:
        newHead = Offset(head.dx, head.dy + 1);
        break;
      case Direction.left:
        newHead = Offset(head.dx - 1, head.dy);
        break;
      case Direction.right:
        newHead = Offset(head.dx + 1, head.dy);
        break;
    }

    // Handle screen boundaries (teleportation)
    if (newHead.dx < 0) newHead = Offset(GameState.gridSize - 1, newHead.dy);
    if (newHead.dx >= GameState.gridSize) newHead = Offset(0, newHead.dy);
    if (newHead.dy < 0) newHead = Offset(newHead.dx, GameState.gridSize - 1);
    if (newHead.dy >= GameState.gridSize) newHead = Offset(newHead.dx, 0);

    // Check for collision with self or obstacles
    if (state.snake.contains(newHead) || state.obstacles.contains(newHead)) {
      state.isGameRunning = false;
      state.isGameOver = true;
      return state;
    }

    // Update snake
    List<Offset> newSnake = List.from(state.snake);
    newSnake.insert(0, newHead);

    // Check for food
    if (newHead == state.food) {
      state.score += (state.foodType == FoodType.golden) ? 50 : 10;
      // Don't remove tail, generate new food
      _generateNewFood(state);
    } else {
      newSnake.removeLast();
    }

    state.snake = newSnake;
    return state;
  }

  void _generateNewFood(GameState state) {
    Random random = Random();
    Offset newFood;
    do {
      newFood = Offset(
        random.nextInt(GameState.gridSize).toDouble(),
        random.nextInt(GameState.gridSize).toDouble(),
      );
    } while (state.snake.contains(newFood) || state.obstacles.contains(newFood));

    if (random.nextDouble() < 0.15) {
      state.foodType = FoodType.golden;
    } else {
      state.foodType = FoodType.regular;
    }
    state.food = newFood;
  }

  void changeDirection(GameState state, Direction newDirection) {
    if (!state.isGameRunning || state.isGameOver) return;

    if ((state.direction == Direction.up && newDirection == Direction.down) ||
        (state.direction == Direction.down && newDirection == Direction.up) ||
        (state.direction == Direction.left && newDirection == Direction.right) ||
        (state.direction == Direction.right && newDirection == Direction.left)) {
      return;
    }

    state.nextDirection = newDirection;
  }

  List<Offset> generateObstacles(GameState state) {
    Random random = Random();
    List<Offset> newObstacles = [];
    for (int i = 0; i < 5; i++) {
      Offset newObstacle;
      do {
        newObstacle = Offset(
          random.nextInt(GameState.gridSize).toDouble(),
          random.nextInt(GameState.gridSize).toDouble(),
        );
      } while (state.snake.contains(newObstacle) || state.food == newObstacle || newObstacles.contains(newObstacle));
      newObstacles.add(newObstacle);
    }
    return newObstacles;
  }
}