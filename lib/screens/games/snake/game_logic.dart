import 'package:flutter/foundation.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;
import 'package:oracle_d_asgard/screens/games/snake/snake_segment.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_flame_game.dart';
import 'package:oracle_d_asgard/screens/games/snake/models/snake_models.dart';
import 'package:oracle_d_asgard/screens/games/snake/models/snake_game_state.dart';
import 'package:oracle_d_asgard/screens/games/snake/utils/direction_utils.dart';
import 'package:oracle_d_asgard/screens/games/snake/utils/collision_utils.dart';
import 'package:oracle_d_asgard/screens/games/snake/managers/spawn_manager.dart';

// ==========================================
// GAME LOGIC
// ==========================================
class GameLogic {
  static const int _scoreGoldenFood = 50;
  static const int _scoreRegularFood = 10;
  static const int _scoreRottenFoodPenaltyBase = 10;
  static const int _scoreRottenFoodPenaltyPerLevel = 10;
  static const double bonusSpawnProbability = 1;
  static const double bonusLifetime = 8.0;
  static const double bonusEffectDuration = 8.0;
  static const double speedBonusMultiplier =
      0.7; // 30% faster (multiply time by 0.7)
  static const double freezeBonusMultiplier =
      1.3; // 30% slower (multiply time by 1.3)

  VoidCallback? onRottenFoodEaten;
  VoidCallback? onConfettiTrigger;
  VoidCallback? onBonusCollected;
  late int level;
  late SpawnManager spawnManager;

  GameLogic({required this.level}) {
    spawnManager = SpawnManager(level: level);
  }

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
    if (state.pendingDirection != null &&
        state.movesSinceDirectionChange >= 2) {
      state.nextDirection = state.pendingDirection!;
      state.pendingDirection = null;
    }

    IntVector2 headPos = state.snake.first.position;
    IntVector2 newHeadPos = DirectionUtils.getNewHeadPosition(
      headPos,
      state.direction,
    );

    final currentSnakePositions = state.snake.map((s) => s.position).toList();

    // Check for bonus effects
    bool hasGhostEffect = state.activeBonusEffects.any(
      (effect) => effect.type == BonusType.ghost,
    );
    bool hasShieldEffect = state.activeBonusEffects.any(
      (effect) => effect.type == BonusType.shield,
    );

    // Shield takes priority over ghost if both are active
    bool ignoreObstacles = hasShieldEffect || hasGhostEffect;

    // Check collision (ignore obstacles if ghost or shield is active)
    if (CollisionUtils.isCollision(
      state,
      newHeadPos,
      currentSnakePositions,
      ignoreObstacles: ignoreObstacles,
    )) {
      state.pendingGameOver = true;
    }

    // Handle shield effect - destroy obstacles on collision
    if (hasShieldEffect) {
      final headCells = CollisionUtils.get2x2BlockCells(newHeadPos);
      for (final cell in headCells) {
        if (state.obstacles.contains(cell)) {
          spawnManager.removeObstacleBlock(state, cell);
          state.pendingGameOver = false;
          break;
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
      oldHeadSubPattern = _getPattern(
        newHeadPos,
        state.snake.first.position,
        state.snake[1].position,
      );
    } else {
      // If the snake was just a head, it becomes a straight body segment.
      final dx = newHeadPos.x - state.snake.first.position.x;
      final dy = newHeadPos.y - state.snake.first.position.y;
      oldHeadSubPattern = '${-dx},${-dy},$dx,$dy';
    }
    newSnake.add(
      SnakeSegment(
        position: state.snake.first.position,
        type: 'body',
        subPattern: oldHeadSubPattern,
      ),
    );

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


  bool _handleFoodConsumption(GameState state, IntVector2 newHeadPos) {
    if (CollisionUtils.do2x2BlocksOverlap(newHeadPos, state.food)) {
      state.foodJustEaten = true;
      final soundService = getIt<SoundService>();
      
      if (state.foodType.value == FoodType.golden) {
        state.score += _scoreGoldenFood;
        soundService.playSoundEffect('audio/scale.mp3');
      } else if (state.foodType.value == FoodType.regular) {
        state.score += _scoreRegularFood;
        soundService.playSoundEffect('audio/poc.mp3');
      } else if (state.foodType.value == FoodType.rotten) {
        state.score -=
            (_scoreRottenFoodPenaltyBase +
            (level * _scoreRottenFoodPenaltyPerLevel));
        soundService.playSoundEffect('audio/dramatic.mp3');
        onRottenFoodEaten?.call();
      }

      if (state.score >= SnakeFlameGame.victoryScoreThreshold &&
          state.foodType.value != FoodType.rotten) {
        onConfettiTrigger?.call();
      }
      return true;
    }
    return false;
  }

  bool _handleBonusCollection(GameState state, IntVector2 newHeadPos) {
    if (state.activeBonus != null &&
        CollisionUtils.do2x2BlocksOverlap(
          newHeadPos,
          state.activeBonus!.position,
        )) {
      final bonusType = state.activeBonus!.type;
      final soundService = getIt<SoundService>();

      if (bonusType == BonusType.coin) {
        state.score += 20;
        state.activeBonus = null;
        soundService.playSoundEffect('audio/coin.mp3');
        onBonusCollected?.call();
        state.bonusJustCollected = true;
        return true;
      }

      final existingEffectIndex = state.activeBonusEffects.indexWhere(
        (e) => e.type == bonusType,
      );

      if (existingEffectIndex != -1) {
        state.activeBonusEffects[existingEffectIndex] = ActiveBonusEffect(
          type: bonusType,
          activationTime: 0.0,
        );
      } else {
        if (bonusType == BonusType.shield) {
          final ghostIndex = state.activeBonusEffects.indexWhere(
            (e) => e.type == BonusType.ghost,
          );
          if (ghostIndex != -1) {
            state.activeBonusEffects.removeAt(ghostIndex);
            state.collectedBonuses.remove(BonusType.ghost);
          }
        }

        state.collectedBonuses.add(bonusType);
        state.activeBonusEffects.add(
          ActiveBonusEffect(type: bonusType, activationTime: 0.0),
        );
      }

      state.activeBonus = null;
      soundService.playSoundEffect('audio/coin.mp3');
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
    spawnManager.generateNewFood(state);
  }

  void spawnBonus(GameState state) {
    spawnManager.spawnBonus(state);
  }

  List<IntVector2> generateObstacles(GameState state) {
    return spawnManager.generateObstacles(state);
  }

  String _getPattern(
    IntVector2 prevPos,
    IntVector2 currentPos,
    IntVector2 nextPos,
  ) {
    final prevRelative = prevPos - currentPos;
    final nextRelative = nextPos - currentPos;
    return '${prevRelative.x},${prevRelative.y},${nextRelative.x},${nextRelative.y}';
  }

  void changeDirection(
    GameState state,
    dp.Direction newDirection, {
    bool isRetroactive = false,
  }) {
    if (!state.isGameRunning || state.isGameOver) return;

    final effectiveDirection = state.nextDirection;

    final bool isOppositeToNext = DirectionUtils.isOppositeDirection(
      effectiveDirection,
      newDirection,
    );

    if (isOppositeToNext) {
      if (state.snake.length <= 2) {
        state.nextDirection = newDirection;
        state.pendingDirection = null;
        return;
      }
      return;
    }

    if (state.pendingDirection != null &&
        DirectionUtils.isOppositeDirection(state.pendingDirection!, newDirection)) {
      return;
    }

    if (state.movesSinceDirectionChange < 1 &&
        state.nextDirection != newDirection) {
      if (state.pendingDirection != newDirection) {
        state.pendingDirection = newDirection;
      }
      return;
    }

    state.nextDirection = newDirection;
    state.pendingDirection = null;
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
}
