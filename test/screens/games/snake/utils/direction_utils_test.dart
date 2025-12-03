import 'package:flutter_test/flutter_test.dart';
import 'package:oracle_d_asgard/screens/games/snake/utils/direction_utils.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' as dp;

void main() {
  group('DirectionUtils', () {
    group('getNewHeadPosition', () {
      test('should move up correctly', () {
        final position = IntVector2(5, 5);
        final newPosition = DirectionUtils.getNewHeadPosition(
          position,
          dp.Direction.up,
        );
        expect(newPosition, IntVector2(5, 4));
      });

      test('should move down correctly', () {
        final position = IntVector2(5, 5);
        final newPosition = DirectionUtils.getNewHeadPosition(
          position,
          dp.Direction.down,
        );
        expect(newPosition, IntVector2(5, 6));
      });

      test('should move left correctly', () {
        final position = IntVector2(5, 5);
        final newPosition = DirectionUtils.getNewHeadPosition(
          position,
          dp.Direction.left,
        );
        expect(newPosition, IntVector2(4, 5));
      });

      test('should move right correctly', () {
        final position = IntVector2(5, 5);
        final newPosition = DirectionUtils.getNewHeadPosition(
          position,
          dp.Direction.right,
        );
        expect(newPosition, IntVector2(6, 5));
      });
    });

    group('getPreviousPosition', () {
      test('should calculate previous position for up direction', () {
        final position = IntVector2(4, 4);
        final previous = DirectionUtils.getPreviousPosition(
          position,
          dp.Direction.up,
        );
        expect(previous, IntVector2(4, 6));
      });

      test('should calculate previous position for right direction', () {
        final position = IntVector2(4, 4);
        final previous = DirectionUtils.getPreviousPosition(
          position,
          dp.Direction.right,
        );
        expect(previous, IntVector2(2, 4));
      });
    });

    group('isOppositeDirection', () {
      test('should detect up-down as opposite', () {
        expect(
          DirectionUtils.isOppositeDirection(
            dp.Direction.up,
            dp.Direction.down,
          ),
          isTrue,
        );
      });

      test('should detect down-up as opposite', () {
        expect(
          DirectionUtils.isOppositeDirection(
            dp.Direction.down,
            dp.Direction.up,
          ),
          isTrue,
        );
      });

      test('should detect left-right as opposite', () {
        expect(
          DirectionUtils.isOppositeDirection(
            dp.Direction.left,
            dp.Direction.right,
          ),
          isTrue,
        );
      });

      test('should detect right-left as opposite', () {
        expect(
          DirectionUtils.isOppositeDirection(
            dp.Direction.right,
            dp.Direction.left,
          ),
          isTrue,
        );
      });

      test('should not detect up-right as opposite', () {
        expect(
          DirectionUtils.isOppositeDirection(
            dp.Direction.up,
            dp.Direction.right,
          ),
          isFalse,
        );
      });

      test('should not detect same direction as opposite', () {
        expect(
          DirectionUtils.isOppositeDirection(dp.Direction.up, dp.Direction.up),
          isFalse,
        );
      });
    });

    group('getInitialPattern', () {
      test('should return correct pattern for up', () {
        final pattern = DirectionUtils.getInitialPattern(dp.Direction.up);
        expect(pattern, '0,1,0,-1');
      });

      test('should return correct pattern for down', () {
        final pattern = DirectionUtils.getInitialPattern(dp.Direction.down);
        expect(pattern, '0,-1,0,1');
      });

      test('should return correct pattern for left', () {
        final pattern = DirectionUtils.getInitialPattern(dp.Direction.left);
        expect(pattern, '1,0,-1,0');
      });

      test('should return correct pattern for right', () {
        final pattern = DirectionUtils.getInitialPattern(dp.Direction.right);
        expect(pattern, '-1,0,1,0');
      });
    });

    group('calculateStraightDistanceWithObstacles', () {
      test('should calculate distance without obstacles', () {
        final start = IntVector2(0, 0);
        final distance = DirectionUtils.calculateStraightDistanceWithObstacles(
          start,
          dp.Direction.right,
          20,
          20,
          [],
        );
        expect(distance, 9); // (20-2)/2 = 9
      });

      test('should stop at obstacle', () {
        final start = IntVector2(0, 0);
        final obstacles = [IntVector2(4, 0)]; // Obstacle at (4,0)
        final distance = DirectionUtils.calculateStraightDistanceWithObstacles(
          start,
          dp.Direction.right,
          20,
          20,
          obstacles,
        );
        expect(distance, lessThan(9));
      });

      test('should return 0 when blocked immediately', () {
        final start = IntVector2(0, 0);
        final obstacles = [IntVector2(2, 0), IntVector2(2, 1)];
        final distance = DirectionUtils.calculateStraightDistanceWithObstacles(
          start,
          dp.Direction.right,
          20,
          20,
          obstacles,
        );
        expect(distance, 0);
      });
    });
  });
}
