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

  final GamificationService _gamificationService = GamificationService();

  MythStory get selectedStory => _selectedStory;
  List<MythCard> get shuffledCards => _shuffledCards;
  bool get validated => _validated;
  int? get draggedIndex => _draggedIndex;
  bool get showIncorrectOrderPopup => _showIncorrectOrderPopup;
  bool get showVictoryPopup => _showVictoryPopup; // Getter for new property
  MythCard? get selectedMythCard => _selectedMythCard; 
  CollectibleCard? get rewardCard => _rewardCard; // Getter for new property

  void initializeGame() {
    loadNewStory();
  }

  void loadNewStory() {
    final stories = getMythStories();
    _selectedStory = stories[Random().nextInt(stories.length)];
    _shuffledCards = List<MythCard>.from(_selectedStory.correctOrder);
    _shuffledCards.shuffle();
    _validated = false;
    _selectedMythCard = _shuffledCards.isNotEmpty ? _shuffledCards.first : null; 
    _showVictoryPopup = false; // Reset on new game
    _rewardCard = null; // Reset on new game
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
      final random = Random();
      final rewardType = random.nextInt(2); // 0 for story part, 1 for collectible card

      if (rewardType == 0) {
        // Unlock story part
        final progress = await _gamificationService.getStoryProgress(_selectedStory.title);
        final unlockedParts = progress != null ? jsonDecode(progress['parts_unlocked']) : [];

        for (var card in _selectedStory.correctOrder) {
          if (!unlockedParts.contains(card.id)) {
            await _gamificationService.unlockStoryPart(_selectedStory.title, card.id);
            break; // Unlock only one part per victory
          }
        }
        _showVictoryPopup = true; // Show victory popup for story part
        _rewardCard = null; // No specific card to show for story part
      } else {
        // Unlock collectible card
        final availableCards = _selectedStory.collectibleCards;
        if (availableCards.isNotEmpty) {
          final unearnedContent = await _gamificationService.getUnearnedContent();
          final List<CollectibleCard> trulyWinnableCards = (unearnedContent['unearned_collectible_cards'] as List).cast<CollectibleCard>();

          final List<CollectibleCard> winnableCardsFromThisStory = trulyWinnableCards.where((winnableCard) {
            return availableCards.any((storyCard) =>
                storyCard.id == winnableCard.id && storyCard.version == winnableCard.version);
          }).toList();


          if (winnableCardsFromThisStory.isNotEmpty) {
            final cardToUnlock = winnableCardsFromThisStory[random.nextInt(winnableCardsFromThisStory.length)];
            await _gamificationService.unlockCollectibleCard(cardToUnlock); // Pass the CollectibleCard object
            _rewardCard = cardToUnlock; // Set the reward card
          }
        }
        _showVictoryPopup = true; // Show victory popup for collectible card
      }
    } else {
      _showIncorrectOrderPopup = true;
    }
    notifyListeners();
  }

  void incorrectOrderPopupShown() {
    _showIncorrectOrderPopup = false;
  }

  void victoryPopupShown() { // New method
    _showVictoryPopup = false;
    _rewardCard = null; // Clear reward card after shown
  }

  void resetGame() {
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

  BoxBorder? getCardBorder(int index) {
    if (!_validated) return null;
    final correct = isCardCorrect(index);
    return Border.all(color: correct ? Colors.green : Colors.red, width: 4);
  }
}