import 'package:collection/collection.dart'; // For firstWhereOrNull
import 'dart:convert';
import 'dart:math';

import 'package:oracle_d_asgard/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart'; // Import for ChangeNotifier

import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
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

  Future<void> unlockCollectibleCard(CollectibleCard card) async {
    // Modified to accept CollectibleCard
    final db = await _databaseService.database;
    await db.insert('collectible_cards', {
      'card_id': card.id,
      'version': card.version.toJson(), // Save version
      'unlocked_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    notifyListeners(); // Notify listeners
  }

  Future<bool> isCollectibleCardUnlocked(String cardId, CardVersion version) async {
    // Modified to accept version
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query('collectible_cards', where: 'card_id = ? AND version = ?', whereArgs: [cardId, version.toJson()]);
    return result.isNotEmpty;
  }

  Future<List<CollectibleCard>> getUnlockedCollectibleCards() async {
    // Modified return type
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query('collectible_cards');
    return result
        .map((e) {
          final cardId = e['card_id'] as String;
          final version = CardVersion.fromJson(e['version'] as String);
          // Find the corresponding CollectibleCard from allCollectibleCards
          final CollectibleCard? foundCard = allCollectibleCards.firstWhereOrNull((card) => card.id == cardId && card.version == version);
          if (foundCard == null) {
            debugPrint('Warning: Unlocked card $cardId with version $version not found in allCollectibleCards. Skipping.');
            return null; // Skip this card
          }
          return foundCard;
        })
        .whereType<CollectibleCard>()
        .toList();
  }

  Future<List<String>> getUnlockedCollectibleCardImagePaths() async {
    final unlockedCards = await getUnlockedCollectibleCards(); // Now returns CollectibleCard objects

    final unlockedImagePaths = <String>[];
    for (var card in unlockedCards) {
      // Iterate over CollectibleCard objects
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
      } else {}
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
    final result = await db.query('story_progress');

    return result;
  }

  Future<void> unlockStory(String storyId, List<String> allParts) async {
    final db = await _databaseService.database;
    await db.insert('story_progress', {
      'story_id': storyId,
      'parts_unlocked': jsonEncode(allParts),
      'unlocked_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
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

  Future<void> saveQixDifficulty(int level) async {
    final db = await _databaseService.database;
    await db.insert('game_settings', {'setting_key': 'qix_difficulty', 'setting_value': level.toString()}, conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<int> getQixDifficulty() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query('game_settings', where: 'setting_key = ?', whereArgs: ['qix_difficulty']);
    if (result.isNotEmpty) {
      return int.parse(result.first['setting_value'] as String);
    } else {
      return 0; // Default difficulty
    }
  }

  Future<void> saveSnakeDifficulty(int level) async {
    final db = await _databaseService.database;
    await db.insert('game_settings', {'setting_key': 'snake_difficulty', 'setting_value': level.toString()}, conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<int> getSnakeDifficulty() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query('game_settings', where: 'setting_key = ?', whereArgs: ['snake_difficulty']);
    if (result.isNotEmpty) {
      return int.parse(result.first['setting_value'] as String);
    } else {
      return 0; // Default difficulty
    }
  }

  Future<void> saveWordSearchDifficulty(int level) async {
    final db = await _databaseService.database;
    await db.insert('game_settings', {
      'setting_key': 'word_search_difficulty',
      'setting_value': level.toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<int> getWordSearchDifficulty() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query('game_settings', where: 'setting_key = ?', whereArgs: ['word_search_difficulty']);
    if (result.isNotEmpty) {
      return int.parse(result.first['setting_value'] as String);
    } else {
      return 1; // Default difficulty
    }
  }

  Future<void> saveProfileName(String name) async {
    final db = await _databaseService.database;
    await db.insert('game_settings', {'setting_key': 'profile_name', 'setting_value': name}, conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<String?> getProfileName() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query('game_settings', where: 'setting_key = ?', whereArgs: ['profile_name']);
    if (result.isNotEmpty) {
      return result.first['setting_value'] as String?;
    }
    return null;
  }

  Future<void> saveProfileDeityIcon(String deityId) async {
    final db = await _databaseService.database;
    await db.insert('game_settings', {'setting_key': 'profile_deity_icon', 'setting_value': deityId}, conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<String?> getProfileDeityIcon() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query('game_settings', where: 'setting_key = ?', whereArgs: ['profile_deity_icon']);
    if (result.isNotEmpty) {
      return result.first['setting_value'] as String?;
    }
    return null;
  }

  Future<Map<String, dynamic>> getUnearnedContent() async {
    final allMythStories = getMythStories().skip(1).toList();
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

    final List<MythStory> unearnedMythStories = [];
    for (var story in allMythStories) {
      final List<String> partsUnlockedForStory = unlockedStoryParts[story.id] ?? [];
      if (partsUnlockedForStory.isEmpty) {
        // Only add stories with no unlocked chapters
        unearnedMythStories.add(story);
      }
    }

    return {'unearned_collectible_cards': unearnedCollectibleCards, 'unearned_myth_stories': unearnedMythStories};
  }

  Future<MythStory?> getRandomUnearnedMythStory() async {
    final unearnedContent = await getUnearnedContent();
    final unearnedMythStories = unearnedContent['unearned_myth_stories'] as List<MythStory>;

    if (unearnedMythStories.isNotEmpty) {
      final random = Random();
      return unearnedMythStories[random.nextInt(unearnedMythStories.length)];
    }
    return null;
  }

  Future<MythStory?> selectRandomUnearnedMythStory(MythStory story) async {
    final unlockedStoryProgress = await getUnlockedStoryProgress();
    final Map<String, List<String>> unlockedStoryParts = {};
    for (var progress in unlockedStoryProgress) {
      unlockedStoryParts[progress['story_id'] as String] = List<String>.from(jsonDecode(progress['parts_unlocked']));
    }

    final List<String> partsUnlockedForStory = unlockedStoryParts[story.id] ?? [];
    MythCard? firstUnearnedChapter;

    for (var mythCard in story.correctOrder) {
      if (!partsUnlockedForStory.contains(mythCard.id)) {
        firstUnearnedChapter = mythCard;
        break;
      }
    }

    if (firstUnearnedChapter != null) {
      await unlockStoryPart(story.id, firstUnearnedChapter.id);
      return story;
    }
    return null;
  }

  Future<CollectibleCard?> getRandomUnearnedCollectibleCard() async {
    final unearnedContent = await getUnearnedContent();
    final unearnedCards = unearnedContent['unearned_collectible_cards'] as List<CollectibleCard>;

    if (unearnedCards.isNotEmpty) {
      final random = Random();
      return unearnedCards[random.nextInt(unearnedCards.length)];
    } else {
      debugPrint('All collectible cards already earned. No new card awarded.');
      return null;
    }
  }

  Future<CollectibleCard?> selectRandomUnearnedCollectibleCard() async {
    final selectedCard = await getRandomUnearnedCollectibleCard();
    if (selectedCard != null) {
      await unlockCollectibleCard(selectedCard);
      return selectedCard;
    }
    return null;
  }
}
