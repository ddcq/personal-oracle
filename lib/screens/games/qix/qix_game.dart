
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
    player.gridPosition = Vector2(0, 0); // Start at the top-left edge
    player.targetGridPosition = player.gridPosition.clone();
    player.setDirection(Direction.right); // Start moving right along the edge automatically

    add(arena);
    add(player);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        player.setDirection(Direction.left, isManual: true);
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        player.setDirection(Direction.right, isManual: true);
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        player.setDirection(Direction.up, isManual: true);
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        player.setDirection(Direction.down, isManual: true);
      }
    }
    return KeyEventResult.handled;
  }
}
