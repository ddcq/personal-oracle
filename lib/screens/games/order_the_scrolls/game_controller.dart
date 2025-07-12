import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'data.dart';
import '../model.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';

class GameController extends ChangeNotifier {
  late MythStory _selectedStory;
  late List<MythCard> _shuffledCards;
  bool _validated = false;
  int? _draggedIndex;

  final GamificationService _gamificationService = GamificationService();

  MythStory get selectedStory => _selectedStory;
  List<MythCard> get shuffledCards => _shuffledCards;
  bool get validated => _validated;
  int? get draggedIndex => _draggedIndex;

  void initializeGame() {
    loadNewStory();
  }

  void loadNewStory() {
    final stories = getMythStories();
    _selectedStory = stories[Random().nextInt(stories.length)];
    _shuffledCards = List<MythCard>.from(_selectedStory.correctOrder);
    _shuffledCards.shuffle();
    _validated = false;
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

  void validateOrder() async {
    _validated = true;
    if (isOrderCompletelyCorrect()) {
      final progress = await _gamificationService.getStoryProgress(_selectedStory.title);
      final unlockedParts = progress != null ? jsonDecode(progress['parts_unlocked']) : [];

      for (var card in _selectedStory.correctOrder) {
        if (!unlockedParts.contains(card.id)) {
          await _gamificationService.unlockStoryPart(_selectedStory.title, card.id);
          break; // Unlock only one part per victory
        }
      }
    }
    notifyListeners();
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