import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui; // For Image
import 'arena.dart';
import 'player.dart';
import 'constants.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

class QixGame extends FlameGame with KeyboardEvents {
  late final ArenaComponent arena;
  late final Player player;
  late ui.Image characterSpriteSheet;
  final ValueNotifier<double> filledPercentageNotifier = ValueNotifier<double>(0.0);
  final VoidCallback onGameOver;
  final Function(CollectibleCard?) onWin;
  final String? _rewardCardImagePath;
  final CollectibleCard? _rewardCard;

  QixGame({required this.onGameOver, required this.onWin, String? rewardCardImagePath, CollectibleCard? rewardCard}) : _rewardCardImagePath = rewardCardImagePath, _rewardCard = rewardCard;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    characterSpriteSheet = await images.load('characters.png');

    final int gridSize = kGridSize;
    final double cellSize = (size.x < size.y ? size.x : size.y) / gridSize;

    arena = ArenaComponent(gridSize: gridSize, cellSize: cellSize, rewardCardImagePath: _rewardCardImagePath);
    player = Player(gridSize: gridSize, cellSize: cellSize, characterSpriteSheet: characterSpriteSheet, arena: arena, onPlayerStateChanged: onPlayerStateChanged);
    player.gridPosition = IntVector2(0, 0); // Start at the top-left edge
    player.targetGridPosition = IntVector2(player.gridPosition.x, player.gridPosition.y);
    player.setDirection(Direction.right); // Start moving right along the edge automatically

    add(arena);
    add(player);
    arena.calculateFilledPercentage();
  }

  void updateFilledPercentage(double percentage) {
    filledPercentageNotifier.value = percentage;
    if (percentage >= kWinPercentage) {
      win();
    }
  }

  void onPlayerStateChanged(PlayerState newState) {
    if (newState == PlayerState.onEdge) {
      arena.fillArea(player.currentPath, player.pathStartGridPosition!, player.gridPosition);
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

  void win() {
    pauseEngine();
    onWin(_rewardCard);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    if (event is KeyDownEvent) {
      Direction? newDirection;
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        newDirection = Direction.left;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        newDirection = Direction.right;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        newDirection = Direction.up;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        newDirection = Direction.down;
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
