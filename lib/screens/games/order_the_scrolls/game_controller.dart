import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/data/stories_data.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';

class GameController extends ChangeNotifier {
  late MythStory _selectedStory;
  late List<MythCard> _shuffledCards;
  bool _validated = false;
  int? _draggedIndex;
  bool _showIncorrectOrderPopup = false;
  bool _showVictoryPopup = false; // New property
  MythCard? _selectedMythCard;
  CollectibleCard? _rewardCard; // New property for reward card
  MythCard? _nextChapterToUnlock; // The specific chapter to unlock if a story part is the reward
  bool _allChaptersEarned = false; // Flag to indicate if all story chapters have been earned
  MythCard? _unlockedStoryChapter; // The specific story chapter that was unlocked

  GameController() {
    _selectedStory = getMythStories().first; // Initialize with the dummy story
    _shuffledCards = List<MythCard>.from(_selectedStory.correctOrder); // Initialize with dummy story's cards
  }

  final GamificationService _gamificationService = GamificationService();

  MythStory get selectedStory => _selectedStory;
  List<MythCard> get shuffledCards => _shuffledCards;
  bool get validated => _validated;
  int? get draggedIndex => _draggedIndex;
  bool get showIncorrectOrderPopup => _showIncorrectOrderPopup;
  bool get showVictoryPopup => _showVictoryPopup; // Getter for new property
  MythCard? get selectedMythCard => _selectedMythCard;
  CollectibleCard? get rewardCard => _rewardCard; // Getter for new property
  MythCard? get unlockedStoryChapter => _unlockedStoryChapter; // Getter for unlocked story chapter

  Future<void> initializeGame() async {
    loadNewStory();
  }

  Future<void> loadNewStory() async {
    final allStories = getMythStories();
    final List<Map<String, dynamic>> earnableChapters = [];

    for (var story in allStories) {
      final progress = await _gamificationService.getStoryProgress(story.title);
      final unlockedParts = progress != null ? jsonDecode(progress['parts_unlocked']) : [];

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

    final random = Random();
    if (earnableChapters.isNotEmpty) {
      final selected = earnableChapters[random.nextInt(earnableChapters.length)];
      _selectedStory = selected['story'];
      _nextChapterToUnlock = selected['chapter'];
      _allChaptersEarned = false;
    } else {
      _selectedStory = allStories[random.nextInt(allStories.length)];
      _nextChapterToUnlock = null;
      _allChaptersEarned = true;
    }
    _rewardCard = null;

    _shuffledCards = List<MythCard>.from(_selectedStory.correctOrder);
    _shuffledCards.shuffle();
    _validated = false;
    _selectedMythCard = _shuffledCards.isNotEmpty ? _shuffledCards.first : null;
    _showVictoryPopup = false; // Reset on new game
    notifyListeners();
  }

  void reorderCards(int fromIndex, int toIndex) {
    if (fromIndex != toIndex) {
      final item = _shuffledCards.removeAt(fromIndex);
      _shuffledCards.insert(toIndex, item);
      _draggedIndex = null;
      notifyListeners();
    }
  }

  void setDraggedIndex(int? index) {
    _draggedIndex = index;
    notifyListeners();
  }

  void selectMythCard(MythCard card) {
    _selectedMythCard = card;
    notifyListeners();
  }

  void validateOrder() async {
    _validated = true;
    if (isOrderCompletelyCorrect()) {
      if (_allChaptersEarned) {
        final unearnedContent = await _gamificationService.getUnearnedContent();
        final cards = (unearnedContent['unearned_collectible_cards'] as List).cast<CollectibleCard>();
        if (cards.isNotEmpty) {
          final card = cards[Random().nextInt(cards.length)];
          await _gamificationService.unlockCollectibleCard(card);
          _rewardCard = card;
        }
      } else if (_nextChapterToUnlock != null) {
        await _gamificationService.unlockStoryPart(_selectedStory.title, _nextChapterToUnlock!.id);
        _unlockedStoryChapter = _nextChapterToUnlock;
        _rewardCard = null;
      }
      _showVictoryPopup = true;
    } else {
      _showIncorrectOrderPopup = true;
    }
    notifyListeners();
  }

  void incorrectOrderPopupShown() {
    _showIncorrectOrderPopup = false;
  }

  void victoryPopupShown() {
    // New method
    _showVictoryPopup = false;
    _rewardCard = null; // Clear reward card after shown
    _unlockedStoryChapter = null; // Clear unlocked story chapter after shown
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
    return _shuffledCards.asMap().entries.every((e) => e.value.id == _selectedStory.correctOrder[e.key].id);
  }

  BoxBorder? getCardBorder(int index) {
    if (!_validated) return null;
    final correct = isCardCorrect(index);
    return Border.all(color: correct ? Colors.green : Colors.red, width: 4);
  }
}
