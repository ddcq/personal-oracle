import 'dart:math';
import 'package:flutter/foundation.dart';

class Cell {
  bool isRevealed = false;
  bool isFlagged = false;
  bool hasMine = false;
  bool hasTreasure = false;
        int adjacentMines = 0;
      int adjacentTreasures = 0;
}

class MinesweeperController with ChangeNotifier {
  late int rows;
  late int cols;
  late int mineCount;
  late int treasureCount;

  late List<List<Cell>> board;
  bool isGameOver = false;
  bool isGameWon = false;
  int treasuresFound = 0;

  MinesweeperController({this.rows = 10, this.cols = 10, this.mineCount = 15, this.treasureCount = 5}) {
    initializeGame();
  }

  void initializeGame() {
    isGameOver = false;
    isGameWon = false;
    treasuresFound = 0;
    board = List.generate(rows, (_) => List.generate(cols, (_) => Cell()));
    _placeMinesAndTreasures();
    _calculateAdjacentMines();
    _calculateAdjacentTreasures();
    notifyListeners();
  }

  void _placeMinesAndTreasures() {
    final random = Random();
    int placedMines = 0;
    int placedTreasures = 0;

    while (placedMines < mineCount) {
      int row = random.nextInt(rows);
      int col = random.nextInt(cols);
      if (!board[row][col].hasMine) {
        board[row][col].hasMine = true;
        placedMines++;
      }
    }

    while (placedTreasures < treasureCount) {
      int row = random.nextInt(rows);
      int col = random.nextInt(cols);
      if (!board[row][col].hasMine && !board[row][col].hasTreasure) {
        board[row][col].hasTreasure = true;
        placedTreasures++;
      }
    }
  }

  void _calculateAdjacentMines() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (!board[i][j].hasMine) {
          int count = 0;
          for (int x = -1; x <= 1; x++) {
            for (int y = -1; y <= 1; y++) {
              if (x == 0 && y == 0) continue;
              int newRow = i + x;
              int newCol = j + y;
              if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && board[newRow][newCol].hasMine) {
                count++;
              }
            }
          }
          board[i][j].adjacentMines = count;
        }
      }
    }
  }

  void _calculateAdjacentTreasures() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (!board[i][j].hasTreasure) {
          int count = 0;
          for (int x = -1; x <= 1; x++) {
            for (int y = -1; y <= 1; y++) {
              if (x == 0 && y == 0) continue;
              int newRow = i + x;
              int newCol = j + y;
              if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && board[newRow][newCol].hasTreasure) {
                count++;
              }
            }
          }
          board[i][j].adjacentTreasures = count;
        }
      }
    }
  }

  void revealCell(int row, int col) {
    if (isGameOver || isGameWon || board[row][col].isFlagged) {
      return;
    }

    // If it's already revealed, and it's a treasure, then it's the second click
    if (board[row][col].isRevealed) {
      if (board[row][col].hasTreasure) {
        treasuresFound++;
        board[row][col].hasTreasure = false; // Make treasure disappear
        _updateAdjacentCounts(row, col); // Update adjacent cells
        if (treasuresFound == treasureCount) {
          isGameWon = true;
          _revealAll();
        }
        notifyListeners(); // Notify after collection
      }
      return; // Already revealed, and not a treasure, or treasure collected
    }

    // First click on an unrevealed cell
    board[row][col].isRevealed = true; // Mark as revealed

    if (board[row][col].hasMine) {
      isGameOver = true;
      _revealAll();
    } else if (board[row][col].hasTreasure) {
      // First click on a treasure, just reveal it. Do nothing else.
      // The second click will be handled by the 'if (board[row][col].isRevealed)' block above.
    } else if (board[row][col].adjacentMines == 0 && board[row][col].adjacentTreasures == 0) {
      for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
          if (x == 0 && y == 0) continue;
          int newRow = row + x;
          int newCol = col + y;
          if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
            revealCell(newRow, newCol);
          }
        }
      }
    }
    notifyListeners();
  }

  void _updateAdjacentCounts(int row, int col) {
    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        if (x == 0 && y == 0) continue;
        int newRow = row + x;
        int newCol = col + y;
        if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
          // Only decrement if the cell is not a mine or treasure itself
          if (!board[newRow][newCol].hasMine && !board[newRow][newCol].hasTreasure) {
            board[newRow][newCol].adjacentTreasures--;
          }
        }
      }
    }
  }

  void toggleFlag(int row, int col) {
    if (isGameOver || isGameWon || board[row][col].isRevealed) {
      return;
    }
    board[row][col].isFlagged = !board[row][col].isFlagged;
    notifyListeners();
  }

  void _revealAll() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        board[i][j].isRevealed = true;
      }
    }
    notifyListeners();
  }
}
