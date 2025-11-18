import 'dart:math';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/screens/games/snake/models/snake_models.dart';
import 'package:oracle_d_asgard/screens/games/snake/models/snake_game_state.dart';
import 'package:oracle_d_asgard/screens/games/snake/utils/collision_utils.dart';

/// Manages spawning of food, bonuses, and obstacles for Snake game
class SpawnManager {
  static const double goldenFoodProbability = 0.15;
  static const double bonusSpawnProbability = 1.0;
  static const int baseObstacles = 1;

  final int level;

  SpawnManager({required this.level});

  /// Generate new food at a valid position
  void generateNewFood(GameState state) {
    Random random = Random();

    final Set<IntVector2> extraOccupied = {};
    if (state.activeBonus != null) {
      extraOccupied.addAll(
        CollisionUtils.get2x2BlockCells(state.activeBonus!.position),
      );
    }

    IntVector2 newFood = _generateValidPositionFor2x2(
      state,
      random,
      extraOccupiedCells: extraOccupied,
    );

    if (random.nextDouble() < goldenFoodProbability) {
      state.foodType.value = FoodType.golden;
    } else {
      state.foodType.value = FoodType.regular;
    }
    state.food = newFood;
    state.foodAge = 0.0;

    // Randomly spawn bonus
    if (state.activeBonus == null &&
        random.nextDouble() < bonusSpawnProbability) {
      spawnBonus(state);
    }
  }

  /// Spawn a bonus at a valid position
  void spawnBonus(GameState state) {
    Random random = Random();
    List<BonusType> bonusTypes;

    if (state.obstacles.isEmpty) {
      bonusTypes = [BonusType.speed, BonusType.freeze, BonusType.coin];
    } else {
      bonusTypes = [
        BonusType.speed,
        BonusType.shield,
        BonusType.freeze,
        BonusType.ghost,
      ];
    }

    final randomBonusType = bonusTypes[random.nextInt(bonusTypes.length)];

    final Set<IntVector2> extraOccupied =
        CollisionUtils.get2x2BlockCells(state.food).toSet();

    IntVector2 bonusPosition = _generateValidPositionFor2x2(
      state,
      random,
      extraOccupiedCells: extraOccupied,
    );

    state.activeBonus = Bonus(
      position: bonusPosition,
      type: randomBonusType,
      spawnTime: 0.0,
    );
  }

  /// Generate obstacles for the game level
  List<IntVector2> generateObstacles(GameState state) {
    Random random = Random();
    List<IntVector2> newObstacles = [];

    final snakeCells = CollisionUtils.getOccupiedCellsFromSnake(state);
    final foodCells = CollisionUtils.get2x2BlockCells(state.food).toSet();

    final targetObstacleCount = baseObstacles + level;

    int obstacleCount = 0;
    int attempts = 0;
    while (obstacleCount < targetObstacleCount && attempts < 1000) {
      attempts++;
      IntVector2 topLeft = IntVector2(
        random.nextInt(state.gridWidth - 3),
        random.nextInt(state.gridHeight - 3),
      );

      // Ensure even coordinates for alignment
      if (topLeft.x.isOdd) topLeft = IntVector2(topLeft.x - 1, topLeft.y);
      if (topLeft.y.isOdd) topLeft = IntVector2(topLeft.x, topLeft.y - 1);

      List<IntVector2> obstacleCells = [];
      for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
          obstacleCells.add(IntVector2(topLeft.x + x, topLeft.y + y));
        }
      }

      final occupiedCells = {
        ...snakeCells,
        ...foodCells,
        ...state.obstacles,
        ...newObstacles,
      };
      bool isOccupied = obstacleCells.any(
        (cell) => occupiedCells.contains(cell),
      );

      if (!isOccupied) {
        newObstacles.addAll(obstacleCells);
        obstacleCount++;
      }
    }
    return newObstacles;
  }

  /// Remove an obstacle block that contains the hit position
  void removeObstacleBlock(GameState state, IntVector2 hitPosition) {
    for (int i = 0; i < state.obstacles.length; i += 16) {
      if (i + 15 < state.obstacles.length) {
        final block = state.obstacles.getRange(i, i + 16);

        if (block.contains(hitPosition)) {
          state.obstacles.removeRange(i, i + 16);
          return;
        }
      }
    }
  }

  /// Generate a valid position for a 2x2 block
  IntVector2 _generateValidPositionFor2x2(
    GameState state,
    Random random, {
    Set<IntVector2>? extraOccupiedCells,
  }) {
    final occupied = CollisionUtils.getAllOccupiedCells(
      state,
      extraCells: extraOccupiedCells,
    );

    IntVector2 position;
    bool positionIsValid;
    int attempts = 0;

    // Try aligned positions first
    do {
      attempts++;
      int x = random.nextInt((state.gridWidth - 2) ~/ 2) * 2;
      int y = random.nextInt((state.gridHeight - 2) ~/ 2) * 2;
      position = IntVector2(x, y);

      positionIsValid = CollisionUtils.isBlock2x2Free(position, occupied);
    } while (!positionIsValid && attempts < 1000);

    // Fallback: try any position
    if (!positionIsValid) {
      attempts = 0;
      do {
        attempts++;
        position = IntVector2(
          random.nextInt(state.gridWidth - 1),
          random.nextInt(state.gridHeight - 1),
        );
        positionIsValid = CollisionUtils.isBlock2x2Free(position, occupied);
      } while (!positionIsValid && attempts < 2000);
    }

    return position;
  }
}
