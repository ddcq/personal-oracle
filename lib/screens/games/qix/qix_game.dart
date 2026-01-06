import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui; // For Image
import 'package:oracle_d_asgard/screens/games/qix/arena.dart';
import 'package:oracle_d_asgard/screens/games/qix/player.dart';
import 'package:oracle_d_asgard/screens/games/qix/constants.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';

class QixGame extends FlameGame with KeyboardEvents {
  late final ArenaComponent arena;
  late final Player player;
  late ui.Image characterSpriteSheet;
  late ui.Image snakeHeadImage;
  final ValueNotifier<double> filledPercentageNotifier = ValueNotifier<double>(
    0.0,
  );
  final VoidCallback onGameOver;
  final Function(int) onWin;
  final int difficulty;

  QixGame({
    required this.onGameOver,
    required this.onWin,
    required this.difficulty,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    characterSpriteSheet = await images.load('characters.png');
    snakeHeadImage = await images.load('qix/fenrir.webp');

    final int gridSize = kGridSize;
    final double cellSize = (size.x < size.y ? size.x : size.y) / gridSize;

    arena = ArenaComponent(
      gridSize: gridSize,
      cellSize: cellSize,
      snakeHeadImage: snakeHeadImage,
      difficulty: difficulty,
    );
    player = Player(
      gridSize: gridSize,
      cellSize: cellSize,
      characterSpriteSheet: characterSpriteSheet,
      arena: arena,
      onPlayerStateChanged: onPlayerStateChanged,
      onSelfIntersection: gameOver,
      difficulty: difficulty,
    );
    player.gridPosition = IntVector2(0, 0); // Start at the top-left edge
    player.targetGridPosition = IntVector2(
      player.gridPosition.x,
      player.gridPosition.y,
    );
    player.setDirection(
      Direction.right,
    ); // Start moving right along the edge automatically

    add(arena);
    add(player);
    arena.calculateFilledPercentage();
  }

  double get winPercentage {
    double calculatedPercentage =
        kBaseWinPercentage + (difficulty * kWinPercentageIncrementPerLevel);
    return calculatedPercentage.clamp(kBaseWinPercentage, kMaxWinPercentage);
  }

  void updateFilledPercentage(double percentage) {
    filledPercentageNotifier.value = percentage;
    if (percentage >= winPercentage) {
      win();
    }
  }

  void onPlayerStateChanged(PlayerState newState) {
    if (newState == PlayerState.onEdge) {
      arena.fillArea(
        player.currentPath,
        player.pathStartGridPosition!,
        player.gridPosition,
      );
      arena.endPath();
    }
  }

  void handleDirectionChange(Direction direction) {
    player.setDirection(direction, isManual: true);
  }

  void gameOver() {
    // Stop the game
    pauseEngine();
    onGameOver();
  }

  void win() async {
    pauseEngine();
    final gamificationService = getIt<GamificationService>();
    final coinsEarned = await gamificationService.calculateGameReward(level: difficulty);
    onWin(coinsEarned);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);

    final Map<LogicalKeyboardKey, Direction> keyDirectionMap = {
      LogicalKeyboardKey.arrowLeft: Direction.left,
      LogicalKeyboardKey.arrowRight: Direction.right,
      LogicalKeyboardKey.arrowUp: Direction.up,
      LogicalKeyboardKey.arrowDown: Direction.down,
    };

    if (event is KeyDownEvent) {
      Direction? newDirection;
      for (final entry in keyDirectionMap.entries) {
        if (keysPressed.contains(entry.key)) {
          newDirection = entry.value;
          break;
        }
      }
      if (newDirection != null) {
        player.setDirection(newDirection, isManual: true);
      }
    } else if (event is KeyUpEvent) {
      player.setDirection(player.currentDirection, isManual: false);
    }

    return KeyEventResult.handled;
  }
}
