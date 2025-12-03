import 'package:flutter_test/flutter_test.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/logic/wall_game_logic.dart';

void main() {
  group('WallGameLogic', () {
    late WallGameLogic logic;
    late List<List<bool>> collisionBoard;

    setUp(() {
      logic = WallGameLogic();
      // Create empty collision board
      collisionBoard = List.generate(
        WallGameLogic.boardHeight,
        (index) => List.generate(WallGameLogic.boardWidth, (index) => false),
      );
    });

    group('canPlacePiece', () {
      test('should allow placement of I piece at top', () {
        final piece = [
          [true],
          [true],
          [true],
          [true],
        ];

        expect(logic.canPlacePiece(piece, 5, 0, collisionBoard), isTrue);
      });

      test('should prevent placement outside left boundary', () {
        final piece = [
          [true, true],
          [true, true],
        ];

        expect(logic.canPlacePiece(piece, -1, 5, collisionBoard), isFalse);
      });

      test('should prevent placement outside right boundary', () {
        final piece = [
          [true, true],
          [true, true],
        ];

        expect(
          logic.canPlacePiece(
            piece,
            WallGameLogic.boardWidth,
            5,
            collisionBoard,
          ),
          isFalse,
        );
      });

      test('should prevent placement outside bottom boundary', () {
        final piece = [
          [true, true],
          [true, true],
        ];

        expect(
          logic.canPlacePiece(
            piece,
            5,
            WallGameLogic.boardHeight,
            collisionBoard,
          ),
          isFalse,
        );
      });

      test('should prevent placement on occupied cell', () {
        final piece = [
          [true, true],
          [true, true],
        ];

        collisionBoard[5][5] = true;

        expect(logic.canPlacePiece(piece, 5, 5, collisionBoard), isFalse);
      });

      test('should allow placement when cells are free', () {
        final piece = [
          [true, false],
          [true, true],
        ];

        expect(logic.canPlacePiece(piece, 3, 3, collisionBoard), isTrue);
      });
    });

    group('checkWallComplete', () {
      test('should return false for empty board', () {
        expect(logic.checkWallComplete(collisionBoard), isFalse);
      });

      test('should return true when victory zone is filled', () {
        final victoryStartRow =
            WallGameLogic.boardHeight - WallGameLogic.victoryHeight;

        for (
          int row = victoryStartRow;
          row < WallGameLogic.boardHeight;
          row++
        ) {
          for (int col = 0; col < WallGameLogic.boardWidth; col++) {
            collisionBoard[row][col] = true;
          }
        }

        expect(logic.checkWallComplete(collisionBoard), isTrue);
      });

      test('should return false when victory zone has one gap', () {
        final victoryStartRow =
            WallGameLogic.boardHeight - WallGameLogic.victoryHeight;

        for (
          int row = victoryStartRow;
          row < WallGameLogic.boardHeight;
          row++
        ) {
          for (int col = 0; col < WallGameLogic.boardWidth; col++) {
            collisionBoard[row][col] = true;
          }
        }

        // Leave one gap
        collisionBoard[victoryStartRow][5] = false;

        expect(logic.checkWallComplete(collisionBoard), isFalse);
      });
    });

    group('isCellOccupied', () {
      test('should return false for empty cell', () {
        expect(logic.isCellOccupied(5, 5, collisionBoard), isFalse);
      });

      test('should return true for occupied cell', () {
        collisionBoard[5][5] = true;
        expect(logic.isCellOccupied(5, 5, collisionBoard), isTrue);
      });

      test('should return true for out of bounds (negative)', () {
        expect(logic.isCellOccupied(-1, 5, collisionBoard), isTrue);
        expect(logic.isCellOccupied(5, -1, collisionBoard), isTrue);
      });

      test('should return true for out of bounds (too large)', () {
        expect(
          logic.isCellOccupied(WallGameLogic.boardWidth, 5, collisionBoard),
          isTrue,
        );
        expect(
          logic.isCellOccupied(5, WallGameLogic.boardHeight, collisionBoard),
          isTrue,
        );
      });
    });

    group('checkInaccessibleHoles', () {
      test('should detect hole blocked on three sides', () {
        final piece = [
          [true, true, true],
        ];

        // Create walls
        collisionBoard[4][4] = true;
        collisionBoard[5][3] = true;
        collisionBoard[5][5] = true;

        // Place piece that creates inaccessible hole at (4,5)
        expect(
          logic.checkInaccessibleHoles(piece, 3, 5, collisionBoard),
          isTrue,
        );
      });

      test('should not detect accessible holes', () {
        final piece = [
          [true],
        ];

        expect(
          logic.checkInaccessibleHoles(piece, 5, 5, collisionBoard),
          isFalse,
        );
      });
    });
  });
}
