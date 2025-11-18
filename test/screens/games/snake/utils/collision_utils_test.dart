import 'package:flutter_test/flutter_test.dart';
import 'package:oracle_d_asgard/screens/games/snake/utils/collision_utils.dart';
import 'package:oracle_d_asgard/screens/games/snake/models/snake_game_state.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

void main() {
  group('CollisionUtils', () {
    group('isBlock2x2Free', () {
      test('should return true for empty position', () {
        final position = IntVector2(5, 5);
        final occupied = <IntVector2>{};
        
        expect(CollisionUtils.isBlock2x2Free(position, occupied), isTrue);
      });

      test('should return false when top-left is occupied', () {
        final position = IntVector2(5, 5);
        final occupied = {IntVector2(5, 5)};
        
        expect(CollisionUtils.isBlock2x2Free(position, occupied), isFalse);
      });

      test('should return false when any cell is occupied', () {
        final position = IntVector2(5, 5);
        final occupied = {IntVector2(6, 6)};
        
        expect(CollisionUtils.isBlock2x2Free(position, occupied), isFalse);
      });

      test('should return true when nearby cells are occupied but not 2x2 block', () {
        final position = IntVector2(5, 5);
        final occupied = {IntVector2(4, 4), IntVector2(7, 7)};
        
        expect(CollisionUtils.isBlock2x2Free(position, occupied), isTrue);
      });
    });

    group('get2x2BlockCells', () {
      test('should return all 4 cells of a 2x2 block', () {
        final topLeft = IntVector2(5, 5);
        final cells = CollisionUtils.get2x2BlockCells(topLeft);
        
        expect(cells.length, 4);
        expect(cells, contains(IntVector2(5, 5)));
        expect(cells, contains(IntVector2(6, 5)));
        expect(cells, contains(IntVector2(5, 6)));
        expect(cells, contains(IntVector2(6, 6)));
      });
    });

    group('do2x2BlocksOverlap', () {
      test('should detect overlap when blocks are identical', () {
        final pos1 = IntVector2(5, 5);
        final pos2 = IntVector2(5, 5);
        
        expect(CollisionUtils.do2x2BlocksOverlap(pos1, pos2), isTrue);
      });

      test('should detect overlap when blocks partially overlap', () {
        final pos1 = IntVector2(5, 5);
        final pos2 = IntVector2(6, 6);
        
        expect(CollisionUtils.do2x2BlocksOverlap(pos1, pos2), isTrue);
      });

      test('should not detect overlap when blocks are separated', () {
        final pos1 = IntVector2(5, 5);
        final pos2 = IntVector2(10, 10);
        
        expect(CollisionUtils.do2x2BlocksOverlap(pos1, pos2), isFalse);
      });

      test('should not detect overlap when blocks are exactly 2 cells apart', () {
        final pos1 = IntVector2(5, 5);
        final pos2 = IntVector2(7, 5);
        
        expect(CollisionUtils.do2x2BlocksOverlap(pos1, pos2), isFalse);
      });
    });

    group('isCollision', () {
      late GameState state;

      setUp(() {
        state = GameState.initial(gridWidth: 20, gridHeight: 20);
      });

      test('should detect wall collision - left', () {
        final newHeadPos = IntVector2(-1, 5);
        final snakePositions = [IntVector2(0, 5)];
        
        expect(
          CollisionUtils.isCollision(
            state,
            newHeadPos,
            snakePositions,
          ),
          isTrue,
        );
      });

      test('should detect wall collision - right', () {
        final newHeadPos = IntVector2(19, 5);
        final snakePositions = [IntVector2(18, 5)];
        
        expect(
          CollisionUtils.isCollision(
            state,
            newHeadPos,
            snakePositions,
          ),
          isTrue,
        );
      });

      test('should detect wall collision - top', () {
        final newHeadPos = IntVector2(5, -1);
        final snakePositions = [IntVector2(5, 0)];
        
        expect(
          CollisionUtils.isCollision(
            state,
            newHeadPos,
            snakePositions,
          ),
          isTrue,
        );
      });

      test('should detect wall collision - bottom', () {
        final newHeadPos = IntVector2(5, 19);
        final snakePositions = [IntVector2(5, 18)];
        
        expect(
          CollisionUtils.isCollision(
            state,
            newHeadPos,
            snakePositions,
          ),
          isTrue,
        );
      });

      test('should detect self-collision', () {
        final newHeadPos = IntVector2(5, 5);
        final snakePositions = [
          IntVector2(3, 5),
          IntVector2(4, 5),
          IntVector2(5, 5), // Body part
        ];
        
        expect(
          CollisionUtils.isCollision(
            state,
            newHeadPos,
            snakePositions,
          ),
          isTrue,
        );
      });

      test('should not collide with first two segments (head and neck)', () {
        final newHeadPos = IntVector2(5, 5);
        final snakePositions = [
          IntVector2(4, 5),
          IntVector2(5, 5),
        ];
        
        expect(
          CollisionUtils.isCollision(
            state,
            newHeadPos,
            snakePositions,
          ),
          isFalse,
        );
      });

      test('should detect obstacle collision', () {
        state.obstacles.add(IntVector2(5, 5));
        final newHeadPos = IntVector2(5, 5);
        final snakePositions = [IntVector2(3, 5)];
        
        expect(
          CollisionUtils.isCollision(
            state,
            newHeadPos,
            snakePositions,
          ),
          isTrue,
        );
      });

      test('should ignore obstacles when flag is set', () {
        state.obstacles.add(IntVector2(5, 5));
        final newHeadPos = IntVector2(5, 5);
        final snakePositions = [IntVector2(3, 5)];
        
        expect(
          CollisionUtils.isCollision(
            state,
            newHeadPos,
            snakePositions,
            ignoreObstacles: true,
          ),
          isFalse,
        );
      });
    });
  });
}
