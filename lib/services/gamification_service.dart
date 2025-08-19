import 'dart:convert';

import 'package:oracle_d_asgard/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart'; // Import for ChangeNotifier

import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/data/collectible_cards_data.dart';
import 'package:oracle_d_asgard/data/stories_data.dart';
import 'package:oracle_d_asgard/models/card_version.dart'; // Import CardVersion

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

  Future<void> unlockCollectibleCard(CollectibleCard card) async { // Modified to accept CollectibleCard
    final db = await _databaseService.database;
    await db.insert('collectible_cards', {
      'card_id': card.id,
      'version': card.version.toJson(), // Save version
      'unlocked_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    notifyListeners(); // Notify listeners
  }

  Future<bool> isCollectibleCardUnlocked(String cardId, CardVersion version) async { // Modified to accept version
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query(
      'collectible_cards',
      where: 'card_id = ? AND version = ?',
      whereArgs: [cardId, version.toJson()],
    );
    return result.isNotEmpty;
  }

  Future<List<CollectibleCard>> getUnlockedCollectibleCards() async { // Modified return type
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query('collectible_cards');
    return result.map((e) {
      final cardId = e['card_id'] as String;
      final version = CardVersion.fromJson(e['version'] as String);
      // Find the corresponding CollectibleCard from allCollectibleCards
      return allCollectibleCards.firstWhere(
        (card) => card.id == cardId && card.version == version,
        orElse: () => throw Exception('Unlocked card $cardId with version $version not found in allCollectibleCards'),
      );
    }).toList();
  }

  Future<List<String>> getUnlockedCollectibleCardImagePaths() async {
    final unlockedCards = await getUnlockedCollectibleCards(); // Now returns CollectibleCard objects

    final unlockedImagePaths = <String>[];
    for (var card in unlockedCards) { // Iterate over CollectibleCard objects
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
    final allMythStories = getMythStories();
    final unlockedCollectibleCards = await getUnlockedCollectibleCards(); // Now returns CollectibleCard objects
    final unlockedStoryProgress = await getUnlockedStoryProgress();

    // Create a map for quick lookup of unlocked cards by id and version
    final Map<String, Map<CardVersion, bool>> unlockedCardVersions = {};
    for (var card in unlockedCollectibleCards) {
      unlockedCardVersions.putIfAbsent(card.id, () => {});
      unlockedCardVersions[card.id]![card.version] = true;
    }

    // Filter CollectibleCards based on new logic
    final List<CollectibleCard> unearnedCollectibleCards = [];
    for (var card in allCollectibleCards) {
      final bool hasChibi = unlockedCardVersions[card.id]?[CardVersion.chibi] ?? false;
      final bool hasPremium = unlockedCardVersions[card.id]?[CardVersion.premium] ?? false;
      final bool hasEpic = unlockedCardVersions[card.id]?[CardVersion.epic] ?? false;

      if (tag != null && !card.tags.contains(tag)) {
        continue; // Skip card if it doesn't match the tag
      }

      if (card.version == CardVersion.chibi && !hasChibi) {
        unearnedCollectibleCards.add(card);
      } else if (card.version == CardVersion.premium && hasChibi && !hasPremium) {
        unearnedCollectibleCards.add(card);
      } else if (card.version == CardVersion.epic && hasPremium && !hasEpic) {
        unearnedCollectibleCards.add(card);
      }
    }

    // Process MythStories (no change here, as it's not related to card versions)
    final Map<String, List<String>> unlockedStoryParts = {};
    for (var progress in unlockedStoryProgress) {
      unlockedStoryParts[progress['story_id'] as String] = List<String>.from(jsonDecode(progress['parts_unlocked']));
    }

    final List<Map<String, dynamic>> nextMythCardsToEarn = [];
    for (var story in allMythStories) {
      if (tag != null && !story.tags.contains(tag)) {
        continue; // Skip story if it doesn't match the tag
      }

      final List<String> partsUnlockedForStory = unlockedStoryParts[story.title] ?? [];
      MythCard? nextCard;

      for (var mythCard in story.correctOrder) {
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