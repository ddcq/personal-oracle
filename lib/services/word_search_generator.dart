import 'dart:math';

import 'package:oracle_d_asgard/utils/random_picker.dart';

/// Represents the result of the word search generation.
class WordSearchGridResult {
  final List<List<String>> grid;
  final List<String> placedWords;
  final String secretWordUsed;

  WordSearchGridResult({
    required this.grid,
    required this.placedWords,
    required this.secretWordUsed,
  });
}

/// Generates a word search grid based on a specific set of rules.
WordSearchGridResult generateWordSearchGrid({
  required List<String> longWords,
  required List<String> shortWords,
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
    final placedWords = <String>[];
    int emptyCells = width * height;

    final availableLongWords = longWords.toSet().toList();
    final availableShortWords = shortWords.toSet().toList();

    // --- Placement loop for long words ---
    bool wordWasPlacedInPass = true;
    while (wordWasPlacedInPass) {
      wordWasPlacedInPass = false;
      availableLongWords.shuffle(random);
      for (final word in List.of(availableLongWords)) {
        int placedCount = _tryPlaceWord(grid, word, placedWords, directions, width, height, random, emptyCells);
        if (placedCount > 0) {
          emptyCells -= placedCount;
          availableLongWords.remove(word);
          wordWasPlacedInPass = true;
          break; // Restart the loop with the shuffled list
        }
      }
    }

    // --- Placement loop for short words ---
    wordWasPlacedInPass = true;
    while (wordWasPlacedInPass) {
      wordWasPlacedInPass = false;
      availableShortWords.shuffle(random);
      for (final word in List.of(availableShortWords)) {
        int placedCount = _tryPlaceWord(grid, word, placedWords, directions, width, height, random, emptyCells);
        if (placedCount > 0) {
          emptyCells -= placedCount;
          availableShortWords.remove(word);
          wordWasPlacedInPass = true;
          break; // Restart the loop with the shuffled list
        }
      }
    }

    if (emptyCells < 11) {
      final List<String> fittingWords = secretWords.where((sw) => sw.isNotEmpty && sw.length <= emptyCells).toList();

      final String secretWord;
      if (fittingWords.isNotEmpty) {
        final int maxLength = fittingWords.fold(0, (maxLen, word) => max(maxLen, word.length));
        final List<String> longestFittingWords = fittingWords.where((sw) => sw.length == maxLength).toList();
        secretWord = longestFittingWords[random.nextInt(longestFittingWords.length)];
      } else {
        secretWord = "DEFAULT";
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

      if (_isGridValid(finalGrid, placedWords, directions, width, height)) {
        return WordSearchGridResult(grid: finalGrid, placedWords: placedWords, secretWordUsed: secretWord);
      }
    }
  }

  // --- Final Fallback ---
  final finalFallbackGrid = List.generate(height, (_) => List.generate(width, (_) => '?'));
  return WordSearchGridResult(grid: finalFallbackGrid, placedWords: [], secretWordUsed: "");
}

bool _isGridValid(List<List<String>> grid, List<String> placedWords, List<_Direction> directions, int width, int height) {
  for (final word in placedWords) {
    int occurrences = 0;
    for (var r = 0; r < height; r++) {
      for (var c = 0; c < width; c++) {
        for (final dir in directions) {
          String currentWord = '';
          for (var i = 0; i < word.length; i++) {
            final newR = r + i * dir.dy;
            final newC = c + i * dir.dx;
            if (newR >= 0 && newR < height && newC >= 0 && newC < width) {
              currentWord += grid[newR][newC];
            } else {
              break;
            }
          }
          if (currentWord == word) {
            occurrences++;
          }
        }
      }
    }
    if (occurrences != 1) return false;
  }
  return true;
}

int _tryPlaceWord(
  List<List<String?>> grid,
  String word,
  List<String> placedWords,
  List<_Direction> directions,
  int width,
  int height,
  Random random,
  int emptyCells,
) {
  final possiblePlacements = <_Placement>[];
  final isFirstWord = placedWords.isEmpty;

  for (var r = 0; r < height; r++) {
    for (var c = 0; c < width; c++) {
      final directionPicker = UniqueRandomPicker(directions);
      while(directionPicker.isNotEmpty) {
        final dir = directionPicker.pick()!;
        if (_canPlaceWordAt(grid, word, r, c, dir, width, height, isFirstWord: isFirstWord)) {
          possiblePlacements.add(_Placement(r, c, dir));
        }
      }
    }
  }

  final placementPicker = UniqueRandomPicker(possiblePlacements);

  while (placementPicker.isNotEmpty) {
    final placement = placementPicker.pick()!;
    int newLetters = _calculateNewLetters(grid, word, placement);

    if (emptyCells - newLetters < 3) {
      continue;
    }

    for (var i = 0; i < word.length; i++) {
      grid[placement.row + i * placement.dir.dy][placement.col + i * placement.dir.dx] = word[i];
    }
    placedWords.add(word);
    return newLetters;
  }

  return 0;
}

int _calculateNewLetters(List<List<String?>> grid, String word, _Placement placement) {
  int newLettersCount = 0;
  for (var i = 0; i < word.length; i++) {
    final r = placement.row + i * placement.dir.dy;
    final c = placement.col + i * placement.dir.dx;
    if (grid[r][c] == null) {
      newLettersCount++;
    }
  }
  return newLettersCount;
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
  if (!isFirstWord && newLettersCount == 0) return false;

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
