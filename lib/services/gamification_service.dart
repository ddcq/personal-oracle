import 'dart:convert';

import 'package:oracle_d_asgard/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart'; // Import for ChangeNotifier
import 'package:oracle_d_asgard/data/stories_data.dart' show getCollectibleCards, getMythStories;
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';


class GamificationService with ChangeNotifier {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;

  final DatabaseService _databaseService = DatabaseService();

  GamificationService._internal();

  Future<void> saveGameScore(String gameName, int score) async {
    final db = await _databaseService.database;
    await db.insert('game_scores', {
      'game_name': gameName,
      'score': score,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners(); // Notify listeners after saving
  }

  Future<List<Map<String, dynamic>>> getGameScores(String gameName) async {
    final db = await _databaseService.database;
    return await db.query('game_scores', where: 'game_name = ?', whereArgs: [gameName], orderBy: 'score DESC');
  }

  Future<void> unlockTrophy(String trophyId) async {
    final db = await _databaseService.database;
    await db.insert(
      'player_trophies',
      {'trophy_id': trophyId, 'unlocked_at': DateTime.now().millisecondsSinceEpoch},
      conflictAlgorithm: ConflictAlgorithm.ignore, // Avoid duplicate entries
    );
    notifyListeners(); // Notify listeners
  }

  Future<bool> isTrophyUnlocked(String trophyId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query('player_trophies', where: 'trophy_id = ?', whereArgs: [trophyId]);
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getUnlockedTrophies() async {
    final db = await _databaseService.database;
    return await db.query('player_trophies');
  }

  Future<void> unlockCollectibleCard(String cardId) async {
    final db = await _databaseService.database;
    await db.insert('collectible_cards', {
      'card_id': cardId,
      'unlocked_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    notifyListeners(); // Notify listeners
  }

  Future<bool> isCollectibleCardUnlocked(String cardId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query('collectible_cards', where: 'card_id = ?', whereArgs: [cardId]);
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getUnlockedCollectibleCards() async {
    final db = await _databaseService.database;
    return await db.query('collectible_cards');
  }

  Future<List<String>> getUnlockedCollectibleCardImagePaths() async {
    final unlockedCards = await getUnlockedCollectibleCards();
    final allCollectibleCards = getCollectibleCards();

    final unlockedImagePaths = <String>[];
    for (var unlockedCardData in unlockedCards) {
      final cardId = unlockedCardData['card_id'];
      final card = allCollectibleCards.firstWhere(
        (c) => c.id == cardId,
        orElse: () => throw Exception('Card with ID $cardId not found in getCollectibleCards()'),
      );
      unlockedImagePaths.add(card.imagePath);
    }
    return unlockedImagePaths;
  }

  Future<void> unlockStoryPart(String storyId, String partId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> existing = await db.query('story_progress', where: 'story_id = ?', whereArgs: [storyId]);

    if (existing.isNotEmpty) {
      final List<dynamic> parts = jsonDecode(existing.first['parts_unlocked']);
      if (!parts.contains(partId)) {
        parts.add(partId);
        await db.update('story_progress', {'parts_unlocked': jsonEncode(parts)}, where: 'story_id = ?', whereArgs: [storyId]);
      }
    } else {
      await db.insert('story_progress', {
        'story_id': storyId,
        'parts_unlocked': jsonEncode([partId]),
        'unlocked_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getStoryProgress(String storyId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query('story_progress', where: 'story_id = ?', whereArgs: [storyId]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getUnlockedStoryProgress() async {
    final db = await _databaseService.database;
    return await db.query('story_progress');
  }

  Future<void> saveQuizResult(String deityName) async {
    final db = await _databaseService.database;
    await db.insert('quiz_results', {
      'deity_name': deityName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getQuizResults() async {
    final db = await _databaseService.database;
    return await db.query('quiz_results', orderBy: 'timestamp DESC');
  }

  Future<Map<String, dynamic>> getUnearnedContent({String? tag}) async {
    final allCollectibleCards = getCollectibleCards();
    final allMythStories = getMythStories();
    final unlockedCollectibleCards = await getUnlockedCollectibleCards();
    final unlockedStoryProgress = await getUnlockedStoryProgress();

    final Set<String> unlockedCollectibleCardIds = unlockedCollectibleCards.map((c) => c['card_id'] as String).toSet();
    final Map<String, List<String>> unlockedStoryParts = {};
    for (var progress in unlockedStoryProgress) {
      unlockedStoryParts[progress['story_id'] as String] = List<String>.from(jsonDecode(progress['parts_unlocked']));
    }

    // Filter CollectibleCards
    final List<CollectibleCard> unearnedCollectibleCards = [];
    for (var card in allCollectibleCards) {
      if (!unlockedCollectibleCardIds.contains(card.id)) {
        if (tag == null || card.tags.contains(tag)) {
          unearnedCollectibleCards.add(card);
        }
      }
    }

    // Process MythStories
    final List<Map<String, dynamic>> nextMythCardsToEarn = [];
    for (var story in allMythStories) {
      if (tag != null && !story.tags.contains(tag)) {
        continue; // Skip story if it doesn't match the tag
      }

      final List<String> partsUnlockedForStory = unlockedStoryParts[story.title] ?? [];
      MythCard? nextCard;

      for (var mythCard in story.correctOrder) {
        // A MythCard is "earned" if its corresponding story part is unlocked.
        // Assuming mythCard.id corresponds to a story part ID.
        // This might need clarification: is a MythCard earned when its story part is unlocked,
        // or when the player completes the game associated with it?
        // Based on the request "renvoi la prochaine MythCard à gagner dans l'ordre de l'histoire pour chaque MythStory non complétée",
        // it implies checking unlocked story parts.
        if (!partsUnlockedForStory.contains(mythCard.id)) {
          nextCard = mythCard;
          break; // Found the first unearned card in this story
        }
      }

      if (nextCard != null) {
        nextMythCardsToEarn.add({
          'story_title': story.title,
          'next_myth_card': nextCard,
        });
      }
    }

    return {
      'unearned_collectible_cards': unearnedCollectibleCards,
      'next_myth_cards_to_earn': nextMythCardsToEarn,
    };
  }
}
