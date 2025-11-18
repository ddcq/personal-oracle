import 'dart:math';

class PlacedPiece {
  final int pieceIndex;
  final int rotationIndex;
  final int x;
  final int y;
  bool isNewlyPlaced = true;

  PlacedPiece({
    required this.pieceIndex,
    required this.rotationIndex,
    required this.x,
    required this.y,
  });
}

class Segment {
  final Point<int> p1;
  final Point<int> p2;

  Segment(int x1, int y1, int x2, int y2)
      : p1 = (x1 < x2 || (x1 == x2 && y1 < y2)) ? Point(x1, y1) : Point(x2, y2),
        p2 = (x1 < x2 || (x1 == x2 && y1 < y2)) ? Point(x2, y2) : Point(x1, y1);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Segment &&
          runtimeType == other.runtimeType &&
          p1 == other.p1 &&
          p2 == other.p2;

  @override
  int get hashCode => p1.hashCode ^ p2.hashCode;
}
