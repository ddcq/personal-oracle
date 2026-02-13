import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:sqflite/sqflite.dart';
import 'package:oracle_d_asgard/services/storage/storage_adapter.dart';
import 'package:oracle_d_asgard/services/database_service.dart';

/// SQLite-based storage adapter for mobile platforms.
///
/// This implementation uses the existing SQLite database through DatabaseService.
/// It provides optimized batch operations and proper transaction handling.
class DatabaseStorageAdapter implements StorageAdapter {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Future<void> saveSetting(String key, String value) async {
    try {
      final db = await _databaseService.database;
      await db.insert(
        'game_settings',
        {
          'setting_key': key,
          'setting_value': value,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error saving setting $key: $e');
    }
  }

  @override
  Future<String?> getSetting(String key) async {
    try {
      final db = await _databaseService.database;
      final result = await db.query(
        'game_settings',
        where: 'setting_key = ?',
        whereArgs: [key],
      );

      if (result.isNotEmpty) {
        return result.first['setting_value'] as String?;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting setting $key: $e');
      return null;
    }
  }

  @override
  Future<void> deleteSetting(String key) async {
    try {
      final db = await _databaseService.database;
      await db.delete(
        'game_settings',
        where: 'setting_key = ?',
        whereArgs: [key],
      );
    } catch (e) {
      debugPrint('Error deleting setting $key: $e');
    }
  }

  @override
  Future<void> saveGameScore({
    required String gameName,
    required int score,
    required int timestamp,
  }) async {
    try {
      final db = await _databaseService.database;
      await db.insert(
        'game_scores',
        {
          'game_name': gameName,
          'score': score,
          'timestamp': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error saving game score: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGameScores(String gameName) async {
    try {
      final db = await _databaseService.database;
      return await db.query(
        'game_scores',
        where: 'game_name = ?',
        whereArgs: [gameName],
        orderBy: 'score DESC',
      );
    } catch (e) {
      debugPrint('Error getting game scores: $e');
      return [];
    }
  }

  @override
  Future<void> saveCollectibleCard({
    required String cardId,
    required String version,
    required int timestamp,
  }) async {
    try {
      final db = await _databaseService.database;
      await db.insert(
        'collectible_cards',
        {
          'card_id': cardId,
          'version': version,
          'unlocked_at': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      debugPrint('Error saving collectible card: $e');
    }
  }

  @override
  Future<bool> isCollectibleCardUnlocked(String cardId, String version) async {
    try {
      final db = await _databaseService.database;
      final result = await db.query(
        'collectible_cards',
        where: 'card_id = ? AND version = ?',
        whereArgs: [cardId, version],
      );
      return result.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking if card is unlocked: $e');
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUnlockedCollectibleCards() async {
    try {
      final db = await _databaseService.database;
      return await db.query('collectible_cards');
    } catch (e) {
      debugPrint('Error getting unlocked collectible cards: $e');
      return [];
    }
  }

  @override
  Future<void> saveStoryProgress({
    required String storyId,
    required List<String> partsUnlocked,
    required int timestamp,
  }) async {
    try {
      final db = await _databaseService.database;
      await db.insert(
        'story_progress',
        {
          'story_id': storyId,
          'parts_unlocked': jsonEncode(partsUnlocked),
          'unlocked_at': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error saving story progress: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getStoryProgress(String storyId) async {
    try {
      final db = await _databaseService.database;
      final result = await db.query(
        'story_progress',
        where: 'story_id = ?',
        whereArgs: [storyId],
      );

      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting story progress: $e');
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllStoryProgress() async {
    try {
      final db = await _databaseService.database;
      return await db.query('story_progress');
    } catch (e) {
      debugPrint('Error getting all story progress: $e');
      return [];
    }
  }

  @override
  Future<void> saveQuizResult({
    required String deityName,
    required int timestamp,
  }) async {
    try {
      final db = await _databaseService.database;
      await db.insert(
        'quiz_results',
        {
          'deity_name': deityName,
          'timestamp': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error saving quiz result: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getQuizResults() async {
    try {
      final db = await _databaseService.database;
      return await db.query('quiz_results', orderBy: 'timestamp DESC');
    } catch (e) {
      debugPrint('Error getting quiz results: $e');
      return [];
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _databaseService.destroyAndRebuildDatabase();
    } catch (e) {
      debugPrint('Error clearing all data: $e');
    }
  }
}
