import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oracle_d_asgard/screens/games/qix/arena.dart';
import 'package:oracle_d_asgard/screens/games/qix/player.dart';

class QixGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  static const double arenaSize = 30.0; // 30x30 grid
  static const double cellSize = 20.0; // Size of each grid cell in pixels

  late PlayerComponent player;
  late ArenaComponent arena;

  @override
  Future<void> onLoad() async {
    // Set up camera to view the 30x30 grid
    camera.viewfinder.zoom = 1.0;
    camera.viewfinder.position = Vector2(arenaSize * cellSize / 2, arenaSize * cellSize / 2);
    camera.viewfinder.anchor = Anchor.center;

    arena = ArenaComponent(
      gridSize: arenaSize,
      cellSize: cellSize,
      gameRef: this,
    );
    add(arena);

    player = PlayerComponent(
      gridSize: arenaSize,
      cellSize: cellSize,
      gameRef: this,
    );
    add(player);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        player.move(Direction.up);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        player.move(Direction.down);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        player.move(Direction.left);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        player.move(Direction.right);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }
}

enum Direction { up, down, left, right }