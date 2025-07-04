import 'package:personal_oracle/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart'; // Import for ChangeNotifier

class GamificationService with ChangeNotifier {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;

  final DatabaseService _databaseService = DatabaseService();

  GamificationService._internal();

  Future<void> saveGameScore(String gameName, int score) async {
    final db = await _databaseService.database;
    await db.insert(
      'game_scores',
      {
        'game_name': gameName,
        'score': score,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners(); // Notify listeners after saving
  }

  Future<List<Map<String, dynamic>>> getGameScores(String gameName) async {
    final db = await _databaseService.database;
    return await db.query(
      'game_scores',
      where: 'game_name = ?',
      whereArgs: [gameName],
      orderBy: 'score DESC',
    );
  }

  Future<void> unlockTrophy(String trophyId) async {
    final db = await _databaseService.database;
    await db.insert(
      'player_trophies',
      {
        'trophy_id': trophyId,
        'unlocked_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // Avoid duplicate entries
    );
    notifyListeners(); // Notify listeners
  }

  Future<bool> isTrophyUnlocked(String trophyId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query(
      'player_trophies',
      where: 'trophy_id = ?',
      whereArgs: [trophyId],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getUnlockedTrophies() async {
    final db = await _databaseService.database;
    return await db.query('player_trophies');
  }

  Future<void> unlockCollectibleCard(String cardId) async {
    final db = await _databaseService.database;
    await db.insert(
      'collectible_cards',
      {
        'card_id': cardId,
        'unlocked_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    notifyListeners(); // Notify listeners
  }

  Future<bool> isCollectibleCardUnlocked(String cardId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query(
      'collectible_cards',
      where: 'card_id = ?',
      whereArgs: [cardId],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getUnlockedCollectibleCards() async {
    final db = await _databaseService.database;
    return await db.query('collectible_cards');
  }

  Future<void> unlockStory(String storyId) async {
    final db = await _databaseService.database;
    await db.insert(
      'unlocked_stories',
      {
        'story_id': storyId,
        'unlocked_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    notifyListeners(); // Notify listeners
  }

  Future<bool> isStoryUnlocked(String storyId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query(
      'unlocked_stories',
      where: 'story_id = ?',
      whereArgs: [storyId],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getUnlockedStories() async {
    final db = await _databaseService.database;
    return await db.query('unlocked_stories');
  }
}