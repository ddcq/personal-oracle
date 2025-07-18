import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'arena.dart';
import 'player.dart';
import 'constants.dart';

class QixGame extends FlameGame with KeyboardEvents {
  late final ArenaComponent arena;
  late final Player player;
  final ValueNotifier<double> filledPercentageNotifier = ValueNotifier<double>(0.0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final double gridSize = kGridSize.toDouble();
    final double cellSize = (size.x < size.y ? size.x : size.y) / gridSize;

    arena = ArenaComponent(gridSize: gridSize, cellSize: cellSize);
    player = Player(gridSize: gridSize, cellSize: cellSize);
    player.gridPosition = Vector2(0, 0); // Start at the top-left edge
    player.targetGridPosition = player.gridPosition.clone();
    player.setDirection(
      Direction.right,
    ); // Start moving right along the edge automatically

    add(arena);
    add(player);
    arena.calculateFilledPercentage();
  }

  void updateFilledPercentage(double percentage) {
    filledPercentageNotifier.value = percentage;
  }

  void onPlayerStateChanged(PlayerState newState) {
    if (newState == PlayerState.onEdge) {
      arena.fillArea(player.currentPath, player.pathStartGridPosition!, player.gridPosition);
      arena.endPath();
      player.currentPath.clear();
      player.pathStartGridPosition = null;
    }
  }

  void handleDirectionChange(Direction direction) {
    Direction? newDirection;
    switch (direction) {
      case Direction.up:
        newDirection = Direction.up;
        break;
      case Direction.down:
        newDirection = Direction.down;
        break;
      case Direction.left:
        newDirection = Direction.left;
        break;
      case Direction.right:
        newDirection = Direction.right;
        break;
    }
    player.setDirection(newDirection, isManual: true);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
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
