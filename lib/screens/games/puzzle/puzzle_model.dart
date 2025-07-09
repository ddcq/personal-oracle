import 'dart:ui'; // Offset et Size sont ok, car ils sont de bas niveau (dart:ui)

class PuzzlePieceData {
  final int id;
  Offset currentPosition;
  final Offset targetPosition;
  final Size size;
  bool isLocked;

  PuzzlePieceData({
    required this.id,
    required this.currentPosition,
    required this.targetPosition,
    required this.size,
    this.isLocked = false,
  });
}
