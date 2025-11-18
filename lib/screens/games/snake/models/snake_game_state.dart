import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;
import 'package:oracle_d_asgard/screens/games/snake/snake_segment.dart';
import 'package:oracle_d_asgard/screens/games/snake/models/snake_models.dart';
import 'package:oracle_d_asgard/screens/games/snake/utils/direction_utils.dart';

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
  dp.Direction? pendingDirection;
  int movesSinceDirectionChange;
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
  }) : foodType = ValueNotifier(foodType),
       collectedBonuses = collectedBonuses ?? [],
       activeBonusEffects = activeBonusEffects ?? [];

  factory GameState.initial({
    required int gridWidth,
    required int gridHeight,
    List<IntVector2>? obstacles,
  }) {
    final Random random = Random();
    final obstacleList = obstacles ?? [];

    int maxPathLength = 0;
    IntVector2 bestStartPosition = IntVector2(0, 0);
    dp.Direction bestDirection = dp.Direction.right;

    for (int y = 0; y < gridHeight; y += 2) {
      int pathLength = DirectionUtils.calculateStraightDistanceWithObstacles(
        IntVector2(0, y),
        dp.Direction.right,
        gridWidth,
        gridHeight,
        obstacleList,
      );
      if (pathLength > maxPathLength) {
        maxPathLength = pathLength;
        bestStartPosition = IntVector2(0, y);
        bestDirection = dp.Direction.right;
      }
    }

    for (int x = 0; x < gridWidth; x += 2) {
      int pathLength = DirectionUtils.calculateStraightDistanceWithObstacles(
        IntVector2(x, gridHeight - 2),
        dp.Direction.up,
        gridWidth,
        gridHeight,
        obstacleList,
      );
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
      if ((initialFood.x - bestStartPosition.x).abs() < 2 &&
          (initialFood.y - bestStartPosition.y).abs() < 2) {
        foodIsValid = false;
      }
      if (foodIsValid) {
        for (int j = 0; j < 2; j++) {
          for (int i = 0; i < 2; i++) {
            if (obstacleList.contains(
              IntVector2(initialFood.x + i, initialFood.y + j),
            )) {
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
        SnakeSegment(
          position: DirectionUtils.getPreviousPosition(
            bestStartPosition,
            bestDirection,
          ),
          type: 'body',
          subPattern: DirectionUtils.getInitialPattern(bestDirection),
        ),
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

  GameState clone() {
    return GameState(
      snake: snake.map((segment) => segment.clone()).toList(),
      food: food.clone(),
      foodType: foodType.value,
      foodAge: foodAge,
      obstacles: obstacles.map((obstacle) => obstacle.clone()).toList(),
      activeBonus: activeBonus?.clone(),
      collectedBonuses: List<BonusType>.from(collectedBonuses),
      activeBonusEffects: activeBonusEffects
          .map((effect) => effect.clone())
          .toList(),
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
