import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'player.dart';
import 'arena.dart';
import 'qix.dart';
import 'arrow_button.dart';

class PyQixGame extends FlameGame with KeyboardEvents {
  late PlayerComponent player;
  late Arena arena;
  late QixComponent qix;

  @override
  Future<void> onLoad() async {
    final margin = 20.0;
    final controlButtonSize = Vector2.all(64);
    final controlMargin = 10.0;
    final controlHeight = controlButtonSize.y * 3 + controlMargin * 3;

    final arenaX = margin;
    final arenaY = margin;
    final arenaWidth = size.x - 2 * margin;
    final arenaHeight = size.y - margin - controlHeight - margin;

    arena = Arena(x: arenaX, y: arenaY, width: arenaWidth, height: arenaHeight);
    player = PlayerComponent(arena: arena);
    qix = QixComponent();
    qix.position = Vector2(arenaX + arenaWidth / 2, arenaY + arenaHeight / 2);
    add(player);
    add(qix);

    // Add on-screen controls
    final buttonSize = Vector2.all(64);
    final buttonMargin = 10.0;

    final centerX = size.x / 2;
    final bottomY = size.y - buttonMargin;

    // Up button
    add(ArrowButtonComponent(
      direction: ArrowDirection.up,
      position: Vector2(centerX - buttonSize.x / 2, bottomY - buttonSize.y * 3 - buttonMargin * 2),
      size: buttonSize,
      onPressed: () => player.handleKey(LogicalKeyboardKey.arrowUp),
    ));

    // Down button
    add(ArrowButtonComponent(
      direction: ArrowDirection.down,
      position: Vector2(centerX - buttonSize.x / 2, bottomY - buttonSize.y - buttonMargin),
      size: buttonSize,
      onPressed: () => player.handleKey(LogicalKeyboardKey.arrowDown),
    ));

    // Left button
    add(ArrowButtonComponent(
      direction: ArrowDirection.left,
      position: Vector2(centerX - buttonSize.x * 1.5 - buttonMargin, bottomY - buttonSize.y * 2 - buttonMargin * 2),
      size: buttonSize,
      onPressed: () => player.handleKey(LogicalKeyboardKey.arrowLeft),
    ));

    // Right button
    add(ArrowButtonComponent(
      direction: ArrowDirection.right,
      position: Vector2(centerX + buttonSize.x * 0.5 + buttonMargin, bottomY - buttonSize.y * 2 - buttonMargin * 2),
      size: buttonSize,
      onPressed: () => player.handleKey(LogicalKeyboardKey.arrowRight),
    ));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    arena.render(canvas);

    if (player.currentPath.isNotEmpty) {
      final pathPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      final path = Path();
      path.moveTo(player.currentPath.first.x, player.currentPath.first.y);
      for (var i = 1; i < player.currentPath.length; i++) {
        path.lineTo(player.currentPath[i].x, player.currentPath[i].y);
      }
      if (!player.onEdge) {
        path.lineTo(player.position.x, player.position.y);
      }
      canvas.drawPath(path, pathPaint);
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      player.handleKey(event.logicalKey);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
