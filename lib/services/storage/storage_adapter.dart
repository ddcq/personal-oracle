/// Abstract storage adapter interface for platform-agnostic data persistence.
///
/// This adapter provides a unified interface for storing and retrieving data
/// across different platforms (web using SharedPreferences, mobile using SQLite).
abstract class StorageAdapter {
  // Settings operations (key-value pairs)
  Future<void> saveSetting(String key, String value);
  Future<String?> getSetting(String key);
  Future<void> deleteSetting(String key);

  // Game scores operations
  Future<void> saveGameScore({
    required String gameName,
    required int score,
    required int timestamp,
  });
  Future<List<Map<String, dynamic>>> getGameScores(String gameName);

  // Collectible cards operations
  Future<void> saveCollectibleCard({
    required String cardId,
    required String version,
    required int timestamp,
  });
  Future<bool> isCollectibleCardUnlocked(String cardId, String version);
  Future<List<Map<String, dynamic>>> getUnlockedCollectibleCards();

  // Story progress operations
  Future<void> saveStoryProgress({
    required String storyId,
    required List<String> partsUnlocked,
    required int timestamp,
  });
  Future<Map<String, dynamic>?> getStoryProgress(String storyId);
  Future<List<Map<String, dynamic>>> getAllStoryProgress();

  // Quiz results operations
  Future<void> saveQuizResult({
    required String deityName,
    required int timestamp,
  });
  Future<List<Map<String, dynamic>>> getQuizResults();

  // Clear/reset operations
  Future<void> clearAll();
}
