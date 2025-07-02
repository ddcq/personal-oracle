class Coordinate {
  int x;
  int y;
  Coordinate(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinate && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

// Représente un point avec une direction (similaire à 'pointEnMouvement')
class MovingPoint {
  Coordinate pos;
  double dirX;
  double dirY;
  MovingPoint(this.pos, this.dirX, this.dirY);
}

// Représente une barre en mouvement (similaire à 'barre')
class Bar {
  MovingPoint p1;
  MovingPoint p2;
  Bar(this.p1, this.p2);
}