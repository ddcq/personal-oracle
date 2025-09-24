

import 'package:flutter/material.dart'; // For Offset
import 'package:flame/components.dart'; // For Vector2

@immutable
class IntVector2 {
  final int x;
  final int y;

  const IntVector2(this.x, this.y);

  IntVector2 clone() {
    return IntVector2(x, y);
  }

  // Opérations arithmétiques
  IntVector2 operator +(IntVector2 other) => IntVector2(x + other.x, y + other.y);
  IntVector2 operator -(IntVector2 other) => IntVector2(x - other.x, y - other.y);
  IntVector2 operator *(IntVector2 other) => IntVector2(x * other.x, y * other.y);

  IntVector2 operator -() => IntVector2(-x, -y);

  // Comparaison
  @override
  bool operator ==(Object other) => identical(this, other) || other is IntVector2 && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  // Utilitaires
  double get magnitude => (x * x + y * y).toDouble();
  int get magnitudeSquared => (x * x + y * y); // Utile pour les comparaisons de distance sans racine carrée

  // Clamp the vector within given bounds
  IntVector2 clamp(int minX, int maxX, int minY, int maxY) {
    return IntVector2(x.clamp(minX, maxX), y.clamp(minY, maxY));
  }

  // Check if the vector is within given bounds
  bool isInBounds(int minX, int maxX, int minY, int maxY) {
    return x >= minX && x <= maxX && y >= minY && y <= maxY;
  }

  // Calculate the squared Euclidean distance to another IntVector2
  int distanceSquaredTo(IntVector2 other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return dx * dx + dy * dy;
  }

  // Retourne les 4 voisins directs (haut, bas, gauche, droite)
  List<IntVector2> get cardinalNeighbors => [
    IntVector2(x, y - 1), // Haut
    IntVector2(x, y + 1), // Bas
    IntVector2(x - 1, y), // Gauche
    IntVector2(x + 1, y), // Droite
  ];

  // Retourne les 8 voisins (incluant les diagonales)
  List<IntVector2> get allNeighbors => [
    IntVector2(x - 1, y - 1),
    IntVector2(x, y - 1),
    IntVector2(x + 1, y - 1),
    IntVector2(x - 1, y),
    IntVector2(x + 1, y),
    IntVector2(x - 1, y + 1),
    IntVector2(x, y + 1),
    IntVector2(x + 1, y + 1),
  ];

  // Conversion vers Offset (si nécessaire pour l’affichage Flutter)
  Offset toOffset() => Offset(x.toDouble(), y.toDouble());

  @override
  @override
  String toString() => 'IntVector2(x: $x, y: $y)';
}

extension IntVector2Extension on IntVector2 {
  Vector2 toVector2() => Vector2(x.toDouble(), y.toDouble());
}
