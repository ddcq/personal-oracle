import 'dart:ui' as ui;
import 'package:flame/components.dart';

enum CharacterDirection { down, left, right, up }

class AnimatedCharacterComponent extends PositionComponent with HasGameReference {
  final ui.Image characterSpriteSheet;
  final int characterIndex; // 0-7 (4 characters per row, 2 rows)
  CharacterDirection direction;
  final double animationSpeed; // seconds per frame

  int _currentFrame = 0;
  final List<int> _animationSequence = [0, 1, 2, 1]; // 0, 1, 2, 1, 0, 1, 2, ...
  int _sequenceIndex = 0;
  double _animationTimer = 0;

  AnimatedCharacterComponent({
    required this.characterSpriteSheet,
    required this.characterIndex,
    this.direction = CharacterDirection.down,
    this.animationSpeed = 0.15,
    super.size,
    super.position,
    super.anchor,
  });

  @override
  void update(double dt) {
    super.update(dt);

    _animationTimer += dt;
    if (_animationTimer >= animationSpeed) {
      _animationTimer = 0;
      _sequenceIndex = (_sequenceIndex + 1) % _animationSequence.length;
      _currentFrame = _animationSequence[_sequenceIndex];
    }
  }

  @override
  void render(ui.Canvas canvas) {
    // Sprite sheet dimensions
    const double frameWidth = 32;
    const double frameHeight = 32;

    // Calculate character's base X and Y offset on the sprite sheet
    final int charRow = characterIndex ~/ 4; // 0 for top row, 1 for bottom row
    final int charCol = characterIndex % 4; // 0-3 for columns

    final double charOffsetX = charCol * (frameWidth * 3); // Each character block is 3 frames wide
    final double charOffsetY = charRow * (frameHeight * 4); // Each character block is 4 rows high

    // Calculate animation row offset based on direction
    double directionOffsetY = 0;
    switch (direction) {
      case CharacterDirection.down:
        directionOffsetY = 0; // First row for 'down'
        break;
      case CharacterDirection.left:
        directionOffsetY = frameHeight; // Second row for 'left'
        break;
      case CharacterDirection.right:
        directionOffsetY = frameHeight * 2; // Third row for 'right'
        break;
      case CharacterDirection.up:
        directionOffsetY = frameHeight * 3; // Fourth row for 'up'
        break;
    }

    // Calculate the source rectangle for the current frame
    final ui.Rect sourceRect = ui.Rect.fromLTWH(charOffsetX + (_currentFrame * frameWidth), charOffsetY + directionOffsetY, frameWidth, frameHeight);

    // Destination rectangle (where to draw on the canvas)
    final ui.Rect destRect = ui.Rect.fromLTWH(0, 0, size.x, size.y);

    canvas.drawImageRect(characterSpriteSheet, sourceRect, destRect, ui.Paint());
  }
}
