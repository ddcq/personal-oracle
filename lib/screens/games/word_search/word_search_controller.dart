import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/data/norse_riddles.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/services/word_search_generator.dart';
import 'package:oracle_d_asgard/utils/game_utils.dart';
import 'package:oracle_d_asgard/utils/text_utils.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';

enum GamePhase { searchingWords, unscramblingSecret, victory }

class WordSearchController with ChangeNotifier {
  final GamificationService _gamificationService = getIt<GamificationService>();
  final Random _random = Random();

  // Game Level
  late int level;

  // Game State
  bool isLoading = true;
  GamePhase gamePhase = GamePhase.searchingWords;

  // Game Data
  WordSearchGridResult _gridResult = WordSearchGridResult(
    grid: [],
    placedWords: [],
    secretWordUsed: '',
  );
  MythCard? _mythCard = MythCard(
    id: 'default',
    title: 'Default',
    imagePath: '',
    description: '',
    detailedStory: '',
  );
  String _instructionClue = '';
  List<String> _sortedWordsToFind = [];
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
  List<String> get wordsToFind =>
      _sortedWordsToFind; // Now returns the pre-sorted list
  String get secretWord => _gridResult.secretWordUsed;
  MythCard get mythCard => _mythCard!;
  String get instructionClue => _instructionClue;
  NextChapter? get unlockedChapter => _nextChapter;
  bool get isGameWon => gamePhase == GamePhase.victory;

  WordSearchController() {
    _initialize();
  }

  Future<void> _initialize() async {
    isLoading = true;
    notifyListeners();

    level = await _gamificationService.getWordSearchDifficulty();
    int generationAttempts = 0;
    const maxGenerationAttempts = 10; // Limit attempts to find a valid grid

    bool gridGenerated = false;
    do {
      generationAttempts++;
      if (generationAttempts > maxGenerationAttempts) {
        _handleGenerationFailure(
          'Impossible de générer une grille. Réessayez plus tard.',
        );
        return;
      }

      _nextChapter = await _selectNextChapterToWin();
      _nextChapter ??= await selectRandomChapterFromAllStories();

      _mythCard = _nextChapter!.chapter;
      final wordsToPlace = _extractAndNormalizeWords(_mythCard!);

      if (wordsToPlace.isEmpty) {
        continue; // Restart the do-while loop with a new myth card
      }

      final longWords = wordsToPlace.where((word) => word.length >= 5).toList();
      final shortWords = wordsToPlace
          .where((word) => word.length == 4)
          .toList();

      if (longWords.isEmpty) {
        continue;
      }

      final secretWords =
          norseRiddles.map((r) => normalizeForWordSearch(r.name)).toList()
            ..sort((a, b) => b.length.compareTo(a.length));

      final height = 5 + level;
      final width = 3 + level;

      _gridResult = generateWordSearchGrid(
        longWords: longWords,
        shortWords: shortWords,
        secretWords: secretWords,
        width: width,
        height: height,
        stopWords: _stopWords,
      );

      gridGenerated = _gridResult.placedWords.isNotEmpty;
    } while (!gridGenerated);

    _sortedWordsToFind = List<String>.from(_gridResult.placedWords);
    _sortedWordsToFind.sort();

    _selectRiddle();

    isLoading = false;
    notifyListeners();
  }

  void _handleGenerationFailure(String message) {
    isLoading = false;
    _instructionClue = message;
    notifyListeners();
  }

  Future<NextChapter?> _selectNextChapterToWin() async {
    return await selectNextChapterToWin(_gamificationService);
  }

  List<String> _extractAndNormalizeWords(MythCard mythCard) {
    return extractWordsFromMythCard(
      mythCard,
    ).map(normalizeForWordSearch).toSet().toList();
  }

  void _selectRiddle() {
    final secretWordName = _gridResult.secretWordUsed;
    final riddle = norseRiddles.firstWhere(
      (r) => normalizeForWordSearch(r.name) == secretWordName,
      orElse: () =>
          const NorseRiddle(name: '?', clues: ['word_search_default_clue']),
    );
    _instructionClue = riddle.clues[_random.nextInt(riddle.clues.length)].tr();
  }

  static const Set<String> _stopWords = {
    'MAIS',
    'DONC',
    'POUR',
    'AVEC',
    'SANS',
    'SOUS',
    'DANS',
    'QUOI',
    'DONT',
    'NOUS',
    'VOUS',
    'ILS',
    'CETTE',
    'NOTRE',
    'VOTRE',
    'LEUR',
    'PLUS',
    'MOINS',
    'BIEN',
    'TRES',
    'TOUT',
    'TOUS',
    'TOUTE',
    'TOUTES',
    'RIEN',
    'PERSONNE',
    'AUCUN',
    'AUCUNE',
    'AUTRE',
    'AUTRES',
    'MEME',
    'MEMES',
    'COMME',
    'ALORS',
    'AUSSI',
    'ENCORE',
    'JAMAIS',
    'TOUJOURS',
    'SOUVENT',
    'PARFOIS',
    'DEPUIS',
    'AVANT',
    'APRES',
    'PENDANT',
    'ENTRE',
    'VERS',
    'CONTRE',
    'CHEZ',
    'JUSQUE',
    'SELON',
    'MALGRE',
    'PARMI',
    'HORS',
    'SAUF',
    'VOICI',
    'VOILA',
    // verbes
    'ETRE', 'AVOIR', 'FAIRE', 'ALLER', 'POUVOIR',
    'SOMMES',
    'ETES',
    'SONT',
    'ETAIS',
    'ETAIT',
    'ETIONS',
    'ETIEZ',
    'ETAIENT',
    'FUMES',
    'FUTES',
    'FURENT',
    'SERAI',
    'SERAS',
    'SERA',
    'SERONS',
    'SEREZ',
    'SERONT',
    'SOIS',
    'SOIT',
    'SOYONS',
    'SOYEZ',
    'SOIENT',
    'ETANT',
    'AVONS',
    'AVEZ',
    'ONT',
    'AVAIS',
    'AVAIT',
    'AVIONS',
    'AVIEZ',
    'AVAIENT',
    'EUMES',
    'EUTES',
    'EURENT',
    'AURAI',
    'AURAS',
    'AURA',
    'AURONS',
    'AUREZ',
    'AURONT',
    'AIES',
    'AYONS',
    'AYEZ',
    'AIENT',
    'AYANT',
    'FAIS',
    'FAIT',
    'FAISONS',
    'FAITES',
    'FONT',
    'FAISAIS',
    'FAISAIT',
    'FAISIONS',
    'FAISIEZ',
    'FAISAIENT',
    'FIMES',
    'FITES',
    'FIRENT',
    'FERAI',
    'FERAS',
    'FERA',
    'FERONS',
    'FEREZ',
    'FERONT',
    'ALLONS',
    'ALLEZ',
    'VONT',
    'ALLAIS',
    'ALLAIT',
    'ALLIONS',
    'ALLIEZ',
    'ALLAIENT',
    'ALLAI',
    'ALLAS',
    'ALLA',
    'ALLAMES',
    'ALLATES',
    'ALLERENT',
    'IRAI',
    'IRAS',
    'IRA',
    'IRONS',
    'IREZ',
    'IRONT',
    'PEUX',
    'PEUT',
    'POUVONS',
    'POUVEZ',
    'PEUVENT',
    'POUVAIS',
    'POUVAIT',
    'POUVIONS',
    'POUVIEZ',
    'POUVAIENT',
    'PUMES',
    'PUTES',
    'PURENT',
    'POURRAI',
    'POURRAS',
    'POURRA',
    'POURRONS',
    'POURREZ',
    'POURRONT',
    // autres
    'AINSI',
    'CEPENDANT',
    'CHAQUE',
    'COMMENT',
    'ENFIN',
    'ENSUITE',
    'PARCE',
    'QUAND',
    'QUEL',
    'QUELLE',
    'QUELLES',
    'QUELS',
    'TANDIS',
    'TANT',
    'TELLE',
    'TELLES',
    'TELS',
  };

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
    final _SelectionStepsResult stepsResult = _calculateSelectionSteps(
      startOffset,
      offset,
    );

    final newSelection = _generateNewSelection(
      startOffset,
      stepsResult.direction,
      stepsResult.steps,
    );
    currentSelection.clear();
    currentSelection.addAll(newSelection);
    notifyListeners();
  }

  _SelectionStepsResult _calculateSelectionSteps(
    Offset startOffset,
    Offset endOffset,
  ) {
    final deltaX = endOffset.dx - startOffset.dx;
    final deltaY = endOffset.dy - startOffset.dy;
    final direction = _snapAngleToDirection(atan2(deltaY, deltaX));
    int steps = (direction.dx == 0)
        ? deltaY.abs().toInt()
        : (direction.dy == 0)
        ? deltaX.abs().toInt()
        : max(deltaX.abs(), deltaY.abs()).toInt();
    return _SelectionStepsResult(direction, steps);
  }

  List<Offset> _generateNewSelection(
    Offset startOffset,
    _Direction direction,
    int steps,
  ) {
    return [
      for (var i = 0; i <= steps; i++)
        Offset(
          startOffset.dx + direction.dx * i,
          startOffset.dy + direction.dy * i,
        ),
    ];
  }

  void endSelection() {
    if (currentSelection.length < 2) {
      currentSelection.clear();
      notifyListeners();
      return;
    }
    String selectedWord = currentSelection
        .map((offset) => grid[offset.dy.toInt()][offset.dx.toInt()])
        .join('');
    _checkAndConfirmWord(selectedWord);

    currentSelection.clear();
    notifyListeners();
  }

  void _checkAndConfirmWord(String selectedWord) {
    String reversedSelectedWord = selectedWord.split('').reversed.join('');

    if (wordsToFind.contains(selectedWord)) {
      _confirmWord(selectedWord);
    } else if (wordsToFind.contains(reversedSelectedWord)) {
      _confirmWord(reversedSelectedWord);
    }
  }

  void _confirmWord(String word) {
    foundWords.add(word);
    confirmedSelection.addAll(currentSelection);
    getIt<SoundService>().playSoundEffect('audio/coin.mp3');
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
      await _gamificationService.unlockStoryPart(
        _nextChapter!.story.id,
        _nextChapter!.chapter.id,
      );
      if (level < 10) {
        await _gamificationService.saveWordSearchDifficulty(level + 1);
      }
    }
    gamePhase = GamePhase.victory;
    notifyListeners();
  }

  // --- Helpers ---
  _Direction _snapAngleToDirection(double angle) {
    final int snappedAngleDegrees = ((angle * 180 / pi) / 45).round() * 45;
    switch (snappedAngleDegrees % 360) {
      case 0:
        return _Direction(1, 0); // E
      case 45:
        return _Direction(1, 1); // SE
      case 90:
        return _Direction(0, 1); // S
      case 135:
        return _Direction(-1, 1); // SW
      case 180:
        return _Direction(-1, 0); // W
      case 225:
        return _Direction(-1, -1); // NW
      case 270:
        return _Direction(0, -1); // N
      case 315:
        return _Direction(1, -1); // NE
      default:
        return _Direction(1, 0);
    }
  }

  void resetGame() {
    isLoading = true;
    gamePhase = GamePhase.searchingWords;
    foundWords.clear();
    currentSelection.clear();
    confirmedSelection.clear();
    currentSecretWordGuess = '';
    isSecretWordError = false;
    _initialize();
  }
}

class _Direction {
  final int dx, dy;
  _Direction(this.dx, this.dy);
}

class _SelectionStepsResult {
  final _Direction direction;
  final int steps;

  _SelectionStepsResult(this.direction, this.steps);
}
