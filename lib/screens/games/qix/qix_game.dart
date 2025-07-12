
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'arena.dart';
import 'player.dart';


class QixGame extends FlameGame with KeyboardEvents {
  late final ArenaComponent arena;
  late final Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    const double gridSize = 100;
    final double cellSize = size.x / gridSize;

    arena = ArenaComponent(gridSize: gridSize, cellSize: cellSize);
    player = Player(
      gridSize: gridSize,
      cellSize: cellSize,
    );
    player.gridPosition = Vector2(gridSize / 2, 0); // Start at the top edge
    player.targetGridPosition = player.gridPosition.clone();

    add(arena);
    add(player);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      player.setDirection(Direction.left);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      player.setDirection(Direction.right);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      player.setDirection(Direction.up);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      player.setDirection(Direction.down);
    } else {
      player.setDirection(null);
    }
    return KeyEventResult.handled;
  }
}
