import 'package:oracle_d_asgard/utils/int_vector2.dart';

class SnakeSegment {
  IntVector2 position;
  String type; // e.g., "head", "body", "tail"
  String? subPattern; // e.g., "-1,0,1,0" for body/tail, null for head

  SnakeSegment({required this.position, required this.type, this.subPattern});

  SnakeSegment clone() {
    return SnakeSegment(
      position: position.clone(),
      type: type,
      subPattern: subPattern,
    );
  }
}
