import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/data/norse_riddles.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/services/word_search_generator.dart';
import 'package:oracle_d_asgard/utils/game_utils.dart';
import 'package:oracle_d_asgard/utils/text_utils.dart';

enum GamePhase { searchingWords, unscramblingSecret, victory }

class WordSearchController with ChangeNotifier {
  final GamificationService _gamificationService;
  final Random _random = Random();

  // Game Level
  late int level;

  // Game State
  bool isLoading = true;
  GamePhase gamePhase = GamePhase.searchingWords;
  
  // Game Data
  late WordSearchGridResult _gridResult;
  late MythCard _mythCard;
  late String _instructionClue;
  late List<String> _sortedWordsToFind;
  NextChapter? _nextChapter;

  // Word Search State (Phase 1)
  final Set<String> foundWords = {};
  final List<Offset> currentSelection = [];
  final Set<Offset> confirmedSelection = {};

  // Secret Word State (Phase 2)
  String currentSecretWordGuess = '';
  bool isSecretWordError = false;

  // Getters
  List<List<String>> get grid => _gridResult.grid;
  List<String> get wordsToFind => _sortedWordsToFind; // Now returns the pre-sorted list
  String get secretWord => _gridResult.secretWordUsed;
  MythCard get mythCard => _mythCard;
  String get instructionClue => _instructionClue;
  NextChapter? get unlockedChapter => _nextChapter;

  WordSearchController(this._gamificationService) {
    _initialize();
  }

  Future<void> _initialize() async {
    level = await _gamificationService.getWordSearchDifficulty();
    int generationAttempts = 0;
    const maxGenerationAttempts = 10; // Limit attempts to find a valid grid

    do {
      generationAttempts++;
      if (generationAttempts > maxGenerationAttempts) {
        isLoading = false;
        _instructionClue = "Impossible de générer une grille. Réessayez plus tard.";
        notifyListeners();
        return;
      }

      _nextChapter = await selectNextChapterToWin(_gamificationService);

      if (_nextChapter == null) {
        isLoading = false;
        _instructionClue = "Toutes les histoires ont été complétées ou ne contiennent pas de mots valides.";
        notifyListeners();
        return;
      }

      _mythCard = _nextChapter!.chapter;

      final wordsToPlace = extractWordsFromMythCard(_mythCard).map(normalizeForWordSearch).toSet().toList();
      
      // If no words can be extracted from this MythCard, try another one.
      if (wordsToPlace.isEmpty) {
        continue; // Restart the do-while loop with a new myth card
      }

      // NEW: Separate words by length
      final longWords = wordsToPlace.where((word) => word.length >= 5).toList();
      final shortWords = wordsToPlace.where((word) => word.length == 4).toList();

      // If there are not enough long words, we might not be able to generate a good grid.
      if (longWords.isEmpty) {
        continue; 
      }

      final secretWords = norseRiddles.map((r) => normalizeForWordSearch(r.name)).toList()..sort((a, b) => b.length.compareTo(a.length));

      final height = 5 + level;
      final width = 3 + level;

      _gridResult = generateWordSearchGrid(
        longWords: longWords,
        shortWords: shortWords,
        secretWords: secretWords,
        width: width,
        height: height,
      );

      // Loop continues if _gridResult.placedWords is empty.
    } while (_gridResult.placedWords.isEmpty);

    // Sort the list once and store it.
    _sortedWordsToFind = List<String>.from(_gridResult.placedWords);
    _sortedWordsToFind.sort();

    final secretWordName = _gridResult.secretWordUsed;
    final riddle = norseRiddles.firstWhere((r) => normalizeForWordSearch(r.name) == secretWordName, orElse: () => const NorseRiddle(name: '?', clues: ['Trouvez les mots cachés.']));
    _instructionClue = riddle.clues[_random.nextInt(riddle.clues.length)];

    isLoading = false;
    notifyListeners();
  }

  // --- Phase 1: Word Search Logic ---
  void startSelection(Offset offset) {
    currentSelection.clear();
    currentSelection.add(offset);
    notifyListeners();
  }

  void updateSelection(Offset offset) {
    if (currentSelection.isEmpty || currentSelection.first == offset) {
      return;
    }
    final startOffset = currentSelection.first;
    final deltaX = offset.dx - startOffset.dx, deltaY = offset.dy - startOffset.dy;
    if (deltaX == 0 && deltaY == 0) {
      return;
    }

    final direction = _snapAngleToDirection(atan2(deltaY, deltaX));
    int steps = (direction.dx == 0) ? deltaY.abs().toInt() : (direction.dy == 0) ? deltaX.abs().toInt() : max(deltaX.abs(), deltaY.abs()).toInt();

    final newSelection = [for (var i = 0; i <= steps; i++) Offset(startOffset.dx + direction.dx * i, startOffset.dy + direction.dy * i)];
    currentSelection.clear();
    currentSelection.addAll(newSelection);
    notifyListeners();
  }

  void endSelection() {
    if (currentSelection.length < 2) {
      currentSelection.clear();
      notifyListeners();
      return;
    }
    String selectedWord = currentSelection.map((offset) => grid[offset.dy.toInt()][offset.dx.toInt()]).join('');
    String reversedSelectedWord = selectedWord.split('').reversed.join('');

    if (wordsToFind.contains(selectedWord)) {
      _confirmWord(selectedWord);
    } else if (wordsToFind.contains(reversedSelectedWord)) {
      _confirmWord(reversedSelectedWord);
    }

    currentSelection.clear();
    notifyListeners();
  }

  void _confirmWord(String word) {
    foundWords.add(word);
    confirmedSelection.addAll(currentSelection);
    if (foundWords.length == wordsToFind.length) {
      gamePhase = GamePhase.unscramblingSecret;
    }
    notifyListeners(); // Notify listeners after confirming a word
  }

  // --- Phase 2: Secret Word Logic ---
  void handleGridTap(int row, int col) {
    if (isSecretWordError) {
      return;
    }

    final tappedLetter = grid[row][col];
    final targetLetter = secretWord[currentSecretWordGuess.length];

    if (tappedLetter == targetLetter) {
      currentSecretWordGuess += tappedLetter;
      if (currentSecretWordGuess.length == secretWord.length) {
        _onSecretWordSuccess();
      }
    } else {
      isSecretWordError = true;
      notifyListeners();
      Timer(const Duration(milliseconds: 500), () {
        currentSecretWordGuess = '';
        isSecretWordError = false;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void _onSecretWordSuccess() async {
    if (_nextChapter != null) {
      await _gamificationService.unlockStoryPart(_nextChapter!.story.title, _nextChapter!.chapter.id);
      if (level < 10) {
        await _gamificationService.saveWordSearchDifficulty(level + 1);
      }
    }
    gamePhase = GamePhase.victory;
    notifyListeners();
  }

  // --- Helpers ---
  _Direction _snapAngleToDirection(double angle) {
    final degrees = angle * 180 / pi;
    final normalizedDegrees = (degrees + 360) % 360;
    final snappedAngle = (normalizedDegrees / 45).round() * 45;
    switch (snappedAngle % 360) {
      case 0: return _Direction(1, 0);   // E
      case 45: return _Direction(1, 1);  // SE
      case 90: return _Direction(0, 1);  // S
      case 135: return _Direction(-1, 1); // SW
      case 180: return _Direction(-1, 0); // W
      case 225: return _Direction(-1, -1);// NW
      case 270: return _Direction(0, -1); // N
      case 315: return _Direction(1, -1); // NE
      default: return _Direction(1, 0);
    }
  }
}

class _Direction {
  final int dx, dy;
  _Direction(this.dx, this.dy);
}
