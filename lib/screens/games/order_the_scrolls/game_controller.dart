import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/data/stories_data.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/services/video_cache_service.dart';

import 'package:oracle_d_asgard/locator.dart';

class GameController extends ChangeNotifier {
  late MythStory _selectedStory;
  late List<MythCard> _shuffledCards;
  bool _validated = false;
  int? _draggedIndex;
  bool _showIncorrectOrderPopup = false;
  bool _showVictoryPopup = false; // New property
  MythCard? _selectedMythCard;
  CollectibleCard? _rewardCard; // New property for reward card
  MythCard?
  _nextChapterToUnlock; // The specific chapter to unlock if a story part is the reward
  bool _allChaptersEarned =
      false; // Flag to indicate if all story chapters have been earned
  MythCard?
  _unlockedStoryChapter; // The specific story chapter that was unlocked
  List<bool?> _placementResults = []; // To store correctness of each card

  GameController() {
    _selectedStory = getMythStories().first; // Initialize with the dummy story
    _shuffledCards = List<MythCard>.from(
      _selectedStory.correctOrder,
    ); // Initialize with dummy story's cards
    _placementResults = List<bool?>.filled(_shuffledCards.length, null);
  }

  final GamificationService _gamificationService = getIt<GamificationService>();

  MythStory get selectedStory => _selectedStory;
  List<MythCard> get shuffledCards => _shuffledCards;
  bool get validated => _validated;
  int? get draggedIndex => _draggedIndex;
  bool get showIncorrectOrderPopup => _showIncorrectOrderPopup;
  bool get showVictoryPopup => _showVictoryPopup; // Getter for new property
  MythCard? get selectedMythCard => _selectedMythCard;
  CollectibleCard? get rewardCard => _rewardCard; // Getter for new property
  MythCard? get unlockedStoryChapter =>
      _unlockedStoryChapter; // Getter for unlocked story chapter
  List<bool?> get placementResults => _placementResults;

  Future<void> loadNewStory() async {
    final allStories = getMythStories().skip(1).toList();
    final selected = await _findNextEarnableStoryAndChapter(allStories);

    if (selected != null) {
      _selectedStory = selected['story'];
      _nextChapterToUnlock = selected['chapter'];
      _allChaptersEarned = false;
    } else {
      final random = Random();
      _selectedStory = allStories[random.nextInt(allStories.length)];
      _nextChapterToUnlock = null;
      _allChaptersEarned = true;
    }

    if (_allChaptersEarned) {
      final unearnedContent = await _gamificationService.getUnearnedContent();
      final cards = unearnedContent.collectibleCards;
      if (cards.isNotEmpty) {
        _rewardCard = cards[Random().nextInt(cards.length)];
        if (_rewardCard?.videoUrl != null &&
            _rewardCard!.videoUrl!.isNotEmpty) {
          getIt<VideoCacheService>().preloadVideo(_rewardCard!.videoUrl!);
        }
      } else {
        _rewardCard = null;
      }
      _unlockedStoryChapter = null;
    } else {
      _unlockedStoryChapter = _nextChapterToUnlock;
      _rewardCard = null;
    }

    _shuffledCards = List<MythCard>.from(_selectedStory.correctOrder);
    _shuffledCards.shuffle();
    _validated = false;
    _selectedMythCard = _shuffledCards.isNotEmpty ? _shuffledCards.first : null;
    _showVictoryPopup = false; // Reset on new game
    _placementResults = List<bool?>.filled(_shuffledCards.length, null);
    notifyListeners();
  }

  Future<Map<String, dynamic>?> _findNextEarnableStoryAndChapter(
    List<MythStory> allStories,
  ) async {
    final List<Map<String, dynamic>> earnableChapters = [];

    for (var story in allStories) {
      final progress = await _gamificationService.getStoryProgress(story.id);
      final unlockedParts = progress != null
          ? jsonDecode(progress['parts_unlocked'])
          : [];

      // Find the next unearned chapter in order
      MythCard? nextChapterToEarn;
      for (var chapter in story.correctOrder) {
        if (!unlockedParts.contains(chapter.id)) {
          nextChapterToEarn = chapter;
          break;
        }
      }

      if (nextChapterToEarn != null) {
        earnableChapters.add({'story': story, 'chapter': nextChapterToEarn});
      }
    }

    if (earnableChapters.isNotEmpty) {
      final random = Random();
      return earnableChapters[random.nextInt(earnableChapters.length)];
    }
    return null;
  }

  void reorderCards(int fromIndex, int toIndex) {
    if (fromIndex != toIndex) {
      final item = _shuffledCards.removeAt(fromIndex);
      _shuffledCards.insert(toIndex, item);
      _draggedIndex = null;
      clearPlacementResults();
      notifyListeners();
    }
  }

  void moveCardUp(int index) {
    if (index > 0) {
      final item = _shuffledCards.removeAt(index);
      _shuffledCards.insert(index - 1, item);
      clearPlacementResults();
      notifyListeners();
    }
  }

  void moveCardDown(int index) {
    if (index < _shuffledCards.length - 1) {
      final item = _shuffledCards.removeAt(index);
      _shuffledCards.insert(index + 1, item);
      clearPlacementResults();
      notifyListeners();
    }
  }

  void setDraggedIndex(int? index) {
    _draggedIndex = index;
    notifyListeners();
  }

  void selectMythCard(MythCard card) {
    _selectedMythCard = card;
    clearPlacementResults();
    notifyListeners();
  }

  void validateOrder() async {
    _validated = true;
    if (isOrderCompletelyCorrect()) {
      if (_rewardCard != null) {
        await _gamificationService.unlockCollectibleCard(_rewardCard!);
      } else if (_unlockedStoryChapter != null) {
        await _gamificationService.unlockStoryPart(
          _selectedStory.id,
          _unlockedStoryChapter!.id,
        );
      }
      const coinsEarned = 50;
      await _gamificationService.addCoins(coinsEarned);
      _showVictoryPopup = true;
    } else {
      _showIncorrectOrderPopup = true;
      for (int i = 0; i < _shuffledCards.length; i++) {
        _placementResults[i] = isCardCorrect(i);
      }
    }
    notifyListeners();
  }

  void incorrectOrderPopupShown() {
    _showIncorrectOrderPopup = false;
    notifyListeners();
  }

  void victoryPopupShown() {
    // New method
    _showVictoryPopup = false;
    _rewardCard = null; // Clear reward card after shown
    _unlockedStoryChapter = null; // Clear unlocked story chapter after shown
  }

  void clearPlacementResults() {
    if (_placementResults.any((result) => result != null)) {
      _placementResults = List<bool?>.filled(_shuffledCards.length, null);
      notifyListeners();
    }
  }

  Future<void> resetGame() async {
    loadNewStory();
  }

  bool isCardCorrect(int index) {
    if (!_validated) return false;
    return _shuffledCards[index].id == _selectedStory.correctOrder[index].id;
  }

  bool isOrderCompletelyCorrect() {
    if (!_validated) return false;
    return _shuffledCards.asMap().entries.every(
      (e) => e.value.id == _selectedStory.correctOrder[e.key].id,
    );
  }
}
