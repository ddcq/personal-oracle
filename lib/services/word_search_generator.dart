import 'dart:math';

import 'package:oracle_d_asgard/data/stories_data.dart'; // New import
import 'package:oracle_d_asgard/utils/text_utils.dart'; // New import

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

  final directions = [
    _Direction(1, 0), _Direction(-1, 0), _Direction(0, 1), _Direction(0, -1),
    _Direction(1, 1), _Direction(-1, -1), _Direction(1, -1), _Direction(-1, 1),
  ];

  while (attempts < 100) {
    attempts++;

    final grid = List.generate(height, (_) => List<String?>.filled(width, null));
    final availableWords = wordsToPlace.toSet().toList();
    final placedWords = <String>[];

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
      final List<String> fittingWords = secretWords
          .where((sw) => sw.isNotEmpty && sw.length <= finalEmptyCellCount)
          .toList();

      final String secretWord;
      if (fittingWords.isNotEmpty) {
        // Find the maximum length among fitting words
        final int maxLength = fittingWords.fold(0, (maxLen, word) => max(maxLen, word.length));
        // Filter to only include words of that maximum length
        final List<String> longestFittingWords = fittingWords
            .where((sw) => sw.length == maxLength)
            .toList();
        secretWord = longestFittingWords[random.nextInt(longestFittingWords.length)];
      } else {
        secretWord = "DEFAULT"; // Fallback if no secret word fits
      }

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

  // --- Fallback strategy: Try to generate a grid with all words from all stories ---
  final allStories = getMythStories();
  final Set<String> globalWordsToPlace = {};
  for (var story in allStories) {
    for (var card in story.correctOrder) {
      globalWordsToPlace.addAll(extractLongWordsFromMythCard(card).map(normalizeForWordSearch));
    }
  }

  final fallbackGrid = List.generate(height, (_) => List<String?>.filled(width, null));
  final fallbackPlacedWords = <String>[];
  final fallbackAvailableWords = globalWordsToPlace.toList();

  int fallbackAttempts = 0;
  while (fallbackAttempts < 10 && fallbackAvailableWords.isNotEmpty) {
    fallbackAttempts++;
    bool fallbackWordWasPlaced = false;
    fallbackAvailableWords.shuffle(random);

    for (final word in List.of(fallbackAvailableWords)) {
      final possiblePlacements = <_Placement>[];
      final isFirstWord = fallbackPlacedWords.isEmpty;

      for (var r = 0; r < height; r++) {
        for (var c = 0; c < width; c++) {
          for (final dir in directions) {
            if (_canPlaceWordAt(fallbackGrid, word, r, c, dir, width, height, isFirstWord: isFirstWord)) {
              possiblePlacements.add(_Placement(r, c, dir));
            }
          }
        }
      }

      if (possiblePlacements.isNotEmpty) {
        final placement = possiblePlacements[random.nextInt(possiblePlacements.length)];
        for (var i = 0; i < word.length; i++) {
          fallbackGrid[placement.row + i * placement.dir.dy][placement.col + i * placement.dir.dx] = word[i];
        }
        fallbackPlacedWords.add(word);
        fallbackAvailableWords.remove(word);
        fallbackWordWasPlaced = true;
        break;
      }
    }
    if (!fallbackWordWasPlaced) break;
  }

  int finalFallbackEmptyCellCount = 0;
  for (var r = 0; r < height; r++) {
    for (var c = 0; c < width; c++) {
      if (fallbackGrid[r][c] == null) finalFallbackEmptyCellCount++;
    }
  }

  if (finalFallbackEmptyCellCount < 11 && fallbackPlacedWords.isNotEmpty) {
    final List<String> fittingWords = secretWords
        .where((sw) => sw.isNotEmpty && sw.length <= finalFallbackEmptyCellCount)
        .toList();

    final String secretWord;
    if (fittingWords.isNotEmpty) {
      final int maxLength = fittingWords.fold(0, (maxLen, word) => max(maxLen, word.length));
      final List<String> longestFittingWords = fittingWords
          .where((sw) => sw.length == maxLength)
          .toList();
      secretWord = longestFittingWords[random.nextInt(longestFittingWords.length)];
    } else {
      secretWord = "DEFAULT";
    }

    int secretLetterIndex = 0;
    for (var r = 0; r < height; r++) {
      for (var c = 0; c < width; c++) {
        if (fallbackGrid[r][c] == null) {
          fallbackGrid[r][c] = secretWord[secretLetterIndex % secretWord.length];
          secretLetterIndex++;
        }
      }
    }
    final finalGrid = fallbackGrid.map((row) => row.map((cell) => cell!).toList()).toList();
    return WordSearchGridResult(grid: finalGrid, placedWords: fallbackPlacedWords, secretWordUsed: secretWord);
  }

  // --- Final Fallback: Return a mostly empty grid if all attempts fail ---
  final finalFallbackGrid = List.generate(height, (_) => List<String?>.filled(width, null));
  final placedWordsFinalFallback = <String>[];

  int emptyCellCountFinalFallback = width * height;

  final List<String> fittingWordsFinalFallback = secretWords
      .where((sw) => sw.isNotEmpty && sw.length <= emptyCellCountFinalFallback)
      .toList();

  final String secretWordFinalFallback;
  if (fittingWordsFinalFallback.isNotEmpty) {
    final int maxLength = fittingWordsFinalFallback.fold(0, (maxLen, word) => max(maxLen, word.length));
    final List<String> longestFittingWords = fittingWordsFinalFallback
        .where((sw) => sw.length == maxLength)
        .toList();
    secretWordFinalFallback = longestFittingWords[random.nextInt(longestFittingWords.length)];
  } else {
    secretWordFinalFallback = "DEFAULT";
  }

  int secretLetterIndexFinalFallback = 0;
  for (var r = 0; r < height; r++) {
    for (var c = 0; c < width; c++) {
      if (finalFallbackGrid[r][c] == null) {
        finalFallbackGrid[r][c] = secretWordFinalFallback[secretLetterIndexFinalFallback % secretWordFinalFallback.length];
        secretLetterIndexFinalFallback++;
      }
    }
  }

  final finalGridFinalFallback = finalFallbackGrid.map((row) => row.map((cell) => cell!).toList()).toList();
  return WordSearchGridResult(grid: finalGridFinalFallback, placedWords: placedWordsFinalFallback, secretWordUsed: secretWordFinalFallback);
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
    } else { // This 'else' is now correctly attached to 'if (existingLetter != null)'
      newLettersCount++;
    }
  }

  if (overlapCount > 3) return false;

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