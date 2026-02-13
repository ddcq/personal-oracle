import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oracle_d_asgard/services/storage/storage_adapter.dart';

/// Web-based storage adapter using SharedPreferences for data persistence.
///
/// This implementation stores all data as JSON strings in browser localStorage.
/// It's optimized for web platforms where SQLite is not available.
class WebStorageAdapter implements StorageAdapter {
  static const String _settingsPrefix = 'setting_';
  static const String _gameScoresPrefix = 'game_scores_';
  static const String _collectibleCardsKey = 'unlocked_cards';
  static const String _storyProgressPrefix = 'story_progress_';
  static const String _allStoryProgressKey = 'all_story_progress';
  static const String _quizResultsKey = 'quiz_results';

  @override
  Future<void> saveSetting(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_settingsPrefix$key', value);
    } catch (e) {
      debugPrint('Error saving setting $key: $e');
    }
  }

  @override
  Future<String?> getSetting(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('$_settingsPrefix$key');
    } catch (e) {
      debugPrint('Error getting setting $key: $e');
      return null;
    }
  }

  @override
  Future<void> deleteSetting(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_settingsPrefix$key');
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
      final prefs = await SharedPreferences.getInstance();
      final key = '$_gameScoresPrefix$gameName';

      // Get existing scores
      final scoresJson = prefs.getString(key);
      List<Map<String, dynamic>> scores = [];
      if (scoresJson != null) {
        scores = List<Map<String, dynamic>>.from(jsonDecode(scoresJson));
      }

      // Add new score
      scores.add({
        'game_name': gameName,
        'score': score,
        'timestamp': timestamp,
      });

      // Sort by score descending and keep top 100
      scores.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
      if (scores.length > 100) {
        scores = scores.sublist(0, 100);
      }

      await prefs.setString(key, jsonEncode(scores));
    } catch (e) {
      debugPrint('Error saving game score: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGameScores(String gameName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_gameScoresPrefix$gameName';
      final scoresJson = prefs.getString(key);

      if (scoresJson != null) {
        return List<Map<String, dynamic>>.from(jsonDecode(scoresJson));
      }
      return [];
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
      final prefs = await SharedPreferences.getInstance();
      final cardsJson = prefs.getString(_collectibleCardsKey);
      List<Map<String, dynamic>> cards = [];

      if (cardsJson != null) {
        cards = List<Map<String, dynamic>>.from(jsonDecode(cardsJson));
      }

      // Check if card already exists
      final exists = cards.any(
        (c) => c['card_id'] == cardId && c['version'] == version,
      );

      if (!exists) {
        cards.add({
          'card_id': cardId,
          'version': version,
          'unlocked_at': timestamp,
        });
        await prefs.setString(_collectibleCardsKey, jsonEncode(cards));
      }
    } catch (e) {
      debugPrint('Error saving collectible card: $e');
    }
  }

  @override
  Future<bool> isCollectibleCardUnlocked(String cardId, String version) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJson = prefs.getString(_collectibleCardsKey);

      if (cardsJson != null) {
        final cards = List<Map<String, dynamic>>.from(jsonDecode(cardsJson));
        return cards.any(
          (c) => c['card_id'] == cardId && c['version'] == version,
        );
      }
      return false;
    } catch (e) {
      debugPrint('Error checking if card is unlocked: $e');
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUnlockedCollectibleCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJson = prefs.getString(_collectibleCardsKey);

      if (cardsJson != null) {
        return List<Map<String, dynamic>>.from(jsonDecode(cardsJson));
      }
      return [];
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
      final prefs = await SharedPreferences.getInstance();

      // Save individual story progress
      final storyData = {
        'story_id': storyId,
        'parts_unlocked': jsonEncode(partsUnlocked),
        'unlocked_at': timestamp,
      };
      await prefs.setString(
        '$_storyProgressPrefix$storyId',
        jsonEncode(storyData),
      );

      // Update the all stories progress list
      final allProgressJson = prefs.getString(_allStoryProgressKey);
      List<Map<String, dynamic>> allProgress = [];

      if (allProgressJson != null) {
        allProgress = List<Map<String, dynamic>>.from(
          jsonDecode(allProgressJson),
        );
      }

      // Remove existing entry for this story if it exists
      allProgress.removeWhere((p) => p['story_id'] == storyId);
      allProgress.add(storyData);

      await prefs.setString(_allStoryProgressKey, jsonEncode(allProgress));
    } catch (e) {
      debugPrint('Error saving story progress: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getStoryProgress(String storyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString('$_storyProgressPrefix$storyId');

      if (progressJson != null) {
        return Map<String, dynamic>.from(jsonDecode(progressJson));
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
      final prefs = await SharedPreferences.getInstance();
      final allProgressJson = prefs.getString(_allStoryProgressKey);

      if (allProgressJson != null) {
        return List<Map<String, dynamic>>.from(jsonDecode(allProgressJson));
      }
      return [];
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
      final prefs = await SharedPreferences.getInstance();
      final resultsJson = prefs.getString(_quizResultsKey);
      List<Map<String, dynamic>> results = [];

      if (resultsJson != null) {
        results = List<Map<String, dynamic>>.from(jsonDecode(resultsJson));
      }

      results.add({
        'deity_name': deityName,
        'timestamp': timestamp,
      });

      // Sort by timestamp descending
      results.sort((a, b) =>
          (b['timestamp'] as int).compareTo(a['timestamp'] as int));

      await prefs.setString(_quizResultsKey, jsonEncode(results));
    } catch (e) {
      debugPrint('Error saving quiz result: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getQuizResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resultsJson = prefs.getString(_quizResultsKey);

      if (resultsJson != null) {
        return List<Map<String, dynamic>>.from(jsonDecode(resultsJson));
      }
      return [];
    } catch (e) {
      debugPrint('Error getting quiz results: $e');
      return [];
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('Error clearing all data: $e');
    }
  }
}
