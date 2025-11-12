import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Flash effect component - white flash at the moment of impact
class FlashEffect extends PositionComponent {
  final double flashDuration;
  double _elapsed = 0;

  FlashEffect({required Vector2 position, required Vector2 size, this.flashDuration = 0.15}) : super(position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_elapsed >= flashDuration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Calculate fade out
    final progress = (_elapsed / flashDuration).clamp(0.0, 1.0);
    final opacity = (1.0 - progress) * 0.8; // Max 80% opacity

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawRect(size.toRect(), paint);
  }
}

/// Rock fragment - one quarter of the rock that flies away
class RockFragment extends SpriteComponent {
  final Vector2 velocity;
  final double fragmentDuration;
  final double rotationSpeed;
  double _elapsed = 0;
  double _rotation = 0;

  RockFragment({
    required super.sprite,
    required Vector2 position,
    required Vector2 size,
    required this.velocity,
    required this.rotationSpeed,
    this.fragmentDuration = 0.5,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_elapsed >= fragmentDuration) {
      removeFromParent();
      return;
    }

    // Move fragment
    position += velocity * dt;

    // Rotate
    _rotation += rotationSpeed * dt;
    angle = _rotation;

    // Fade out
    final progress = (_elapsed / fragmentDuration).clamp(0.0, 1.0);
    opacity = 1.0 - progress;
  }
}

/// Debris particle - small rock fragment that flies away
class DebrisParticle extends PositionComponent {
  final Vector2 velocity;
  final double particleDuration;
  final double rotationSpeed;
  final Color particleColor;
  double _elapsed = 0;
  double _rotation = 0;

  DebrisParticle({required Vector2 position, required this.velocity, required this.particleColor, this.particleDuration = 0.6, this.rotationSpeed = 5.0})
    : super(
        position: position,
        size: Vector2.all(16.0), // Increased from 4.0 to 16.0
      );

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_elapsed >= particleDuration) {
      removeFromParent();
      return;
    }

    // Apply velocity (with gravity)
    final gravity = Vector2(0, 200); // Downward gravity
    position += velocity * dt + gravity * dt * dt * 0.5;

    // Slow down velocity over time (air resistance)
    velocity.scale(0.98);

    // Rotate
    _rotation += rotationSpeed * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final progress = (_elapsed / particleDuration).clamp(0.0, 1.0);
    final opacity = 1.0 - progress;

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(_rotation);
    canvas.translate(-size.x / 2, -size.y / 2);

    final paint = Paint()
      ..color = particleColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawRect(size.toRect(), paint);
    canvas.restore();
  }
}
