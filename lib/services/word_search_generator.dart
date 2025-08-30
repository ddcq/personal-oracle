import 'dart:math';

/// Represents the result of the word search generation.
class WordSearchGridResult {
  /// The generated grid, with all cells filled.
  final List<List<String>> grid;

  /// The list of words that were successfully placed in the grid.
  final List<String> placedWords;

  /// The secret word used to fill the remaining empty cells.
  final String secretWordUsed;

  WordSearchGridResult({
    required this.grid,
    required this.placedWords,
    required this.secretWordUsed,
  });
}

/// Generates a word search grid based on a specific set of rules.
WordSearchGridResult generateWordSearchGrid({
  required List<String> wordsToPlace,
  required List<String> secretWords,
  required int width,
  required int height,
}) {
  final random = Random();
  int attempts = 0;

  while (attempts < 50) {
    attempts++;

    final grid = List.generate(height, (_) => List<String?>.filled(width, null));
    final availableWords = wordsToPlace.toSet().toList();
    final placedWords = <String>[];

    final directions = [
      _Direction(1, 0), _Direction(-1, 0), _Direction(0, 1), _Direction(0, -1),
      _Direction(1, 1), _Direction(-1, -1), _Direction(1, -1), _Direction(-1, 1),
    ];

    int emptyCells = width * height;
    while (emptyCells > 11 && availableWords.isNotEmpty) {
      bool wordWasPlaced = false;
      availableWords.shuffle(random);

      for (final word in List.of(availableWords)) {
        final possiblePlacements = <_Placement>[];
        final isFirstWord = placedWords.isEmpty;

        for (var r = 0; r < height; r++) {
          for (var c = 0; c < width; c++) {
            for (final dir in directions) {
              if (_canPlaceWordAt(grid, word, r, c, dir, width, height, isFirstWord: isFirstWord)) {
                possiblePlacements.add(_Placement(r, c, dir));
              }
            }
          }
        }

        if (possiblePlacements.isNotEmpty) {
          final placement = possiblePlacements[random.nextInt(possiblePlacements.length)];
          for (var i = 0; i < word.length; i++) {
            grid[placement.row + i * placement.dir.dy][placement.col + i * placement.dir.dx] = word[i];
          }
          placedWords.add(word);
          availableWords.remove(word);
          wordWasPlaced = true;
          break;
        }
      }

      if (!wordWasPlaced) break;

      int currentEmpty = 0;
      for (var r = 0; r < height; r++) {
        for (var c = 0; c < width; c++) {
          if (grid[r][c] == null) currentEmpty++;
        }
      }
      emptyCells = currentEmpty;
    }

    int finalEmptyCellCount = 0;
    for (var r = 0; r < height; r++) {
      for (var c = 0; c < width; c++) {
        if (grid[r][c] == null) finalEmptyCellCount++;
      }
    }

    if (finalEmptyCellCount < 11) {
      final secretWord = secretWords.firstWhere((sw) => sw.isNotEmpty && sw.length <= finalEmptyCellCount, orElse: () => "DEFAULT");
      int secretLetterIndex = 0;
      for (var r = 0; r < height; r++) {
        for (var c = 0; c < width; c++) {
          if (grid[r][c] == null) {
            grid[r][c] = secretWord[secretLetterIndex % secretWord.length];
            secretLetterIndex++;
          }
        }
      }
      final finalGrid = grid.map((row) => row.map((cell) => cell!).toList()).toList();
      return WordSearchGridResult(grid: finalGrid, placedWords: placedWords, secretWordUsed: secretWord);
    }
  }

  return generateWordSearchGrid(wordsToPlace: [], secretWords: secretWords, width: width, height: height);
}


bool _canPlaceWordAt(
  List<List<String?>> grid,
  String word,
  int row,
  int col,
  _Direction dir,
  int width,
  int height, {
  required bool isFirstWord,
}) {
  bool sharesLetter = false;
  int overlapCount = 0;
  int newLettersCount = 0;

  for (var i = 0; i < word.length; i++) {
    final r = row + i * dir.dy;
    final c = col + i * dir.dx;

    if (r < 0 || r >= height || c < 0 || c >= width) return false;

    final existingLetter = grid[r][c];
    if (existingLetter != null) {
      if (existingLetter != word[i]) {
        return false;
      } else {
        sharesLetter = true;
        overlapCount++;
      }
    } else {
      newLettersCount++;
    }
  }

  if (overlapCount > 3) return false;

  // A word is only valid if it places at least one new letter on the board.
  // This rule implicitly handles the first word correctly, as all its letters are new.
  if (!isFirstWord && newLettersCount == 0) {
    return false;
  }

  return isFirstWord || sharesLetter;
}

class _Direction {
  final int dx, dy;
  _Direction(this.dx, this.dy);
}

class _Placement {
  final int row, col;
  final _Direction dir;
  _Placement(this.row, this.col, this.dir);
}
