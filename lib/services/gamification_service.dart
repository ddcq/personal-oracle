import 'package:collection/collection.dart'; // For firstWhereOrNull
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart' show ChangeNotifier, debugPrint; // Import for ChangeNotifier
import 'package:oracle_d_asgard/services/storage/storage_factory.dart';
import 'package:oracle_d_asgard/services/storage/storage_adapter.dart';
import 'package:oracle_d_asgard/services/game_reward_config.dart';

import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/models/unearned_content.dart';
import 'package:oracle_d_asgard/data/collectible_cards_data.dart';
import 'package:oracle_d_asgard/data/stories_data.dart';
import 'package:oracle_d_asgard/models/card_version.dart'; // Import CardVersion

class GamificationService with ChangeNotifier {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;

  late final StorageAdapter _storage;

  // Cache for frequently accessed settings
  final Map<String, dynamic> _settingsCache = {};
  DateTime? _settingsCacheTime;

  // Cache for progress data (shorter TTL as it changes more often)
  UnearnedContent? _unearnedContentCache;
  DateTime? _unearnedContentCacheTime;

  GamificationService._internal() {
    _storage = StorageFactory.getAdapter();
  }

  static const String _playerCoinsKey = 'player_coins';

  /// Checks if the settings cache is still valid.
  bool get _isSettingsCacheValid {
    if (_settingsCacheTime == null) return false;
    return DateTime.now().difference(_settingsCacheTime!) <
        GameRewardConfig.settingsCacheDuration;
  }

  /// Checks if the unearned content cache is still valid.
  bool get _isUnearnedContentCacheValid {
    if (_unearnedContentCacheTime == null) return false;
    return DateTime.now().difference(_unearnedContentCacheTime!) <
        GameRewardConfig.progressCacheDuration;
  }

  /// Invalidates all caches. Call this after any mutation operation.
  void _invalidateCache() {
    _settingsCache.clear();
    _settingsCacheTime = null;
    _unearnedContentCache = null;
    _unearnedContentCacheTime = null;
  }

  /// Gets a setting from cache or storage.
  Future<String?> _getCachedSetting(String key) async {
    if (_isSettingsCacheValid && _settingsCache.containsKey(key)) {
      return _settingsCache[key] as String?;
    }

    final value = await _storage.getSetting(key);
    _settingsCache[key] = value;
    _settingsCacheTime = DateTime.now();
    return value;
  }

  /// Saves a setting and invalidates the cache.
  Future<void> _saveSetting(String key, String value) async {
    await _storage.saveSetting(key, value);
    _settingsCache[key] = value;
    _settingsCacheTime = DateTime.now();
  }

  Future<void> saveGameScore(String gameName, int score) async {
    await _storage.saveGameScore(
      gameName: gameName,
      score: score,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _invalidateCache(); // Scores might affect progress
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getGameScores(String gameName) async {
    return await _storage.getGameScores(gameName);
  }

  Future<void> saveCoins(int amount) async {
    await _saveSetting(_playerCoinsKey, amount.toString());
    notifyListeners();
  }

  Future<int> getCoins() async {
    final value = await _getCachedSetting(_playerCoinsKey);
    return value != null ? int.tryParse(value) ?? 0 : 0;
  }

  Future<void> unlockCollectibleCard(CollectibleCard card) async {
    final isUnlocked = await _storage.isCollectibleCardUnlocked(
      card.id,
      card.version.toJson(),
    );

    if (!isUnlocked) {
      await _storage.saveCollectibleCard(
        cardId: card.id,
        version: card.version.toJson(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      _invalidateCache(); // Card unlock affects unearned content
      notifyListeners();
    }
  }

  Future<bool> isCollectibleCardUnlocked(
    String cardId,
    CardVersion version,
  ) async {
    return await _storage.isCollectibleCardUnlocked(cardId, version.toJson());
  }

  Future<List<CollectibleCard>> getUnlockedCollectibleCards() async {
    final result = await _storage.getUnlockedCollectibleCards();

    return result
        .map((e) {
          final cardId = e['card_id'] as String;
          final version = CardVersion.fromJson(e['version'] as String);
          // Find the corresponding CollectibleCard from allCollectibleCards
          final CollectibleCard? foundCard = allCollectibleCards
              .firstWhereOrNull(
                (card) => card.id == cardId && card.version == version,
              );
          if (foundCard == null) {
            debugPrint(
              'Warning: Unlocked card $cardId with version $version not found in allCollectibleCards. Skipping.',
            );
            return null; // Skip this card
          }
          return foundCard;
        })
        .whereType<CollectibleCard>()
        .toList();
  }

  Future<List<String>> getUnlockedCollectibleCardImagePaths() async {
    final unlockedCards =
        await getUnlockedCollectibleCards(); // Now returns CollectibleCard objects

    final unlockedImagePaths = <String>[];
    for (var card in unlockedCards) {
      // Iterate over CollectibleCard objects
      unlockedImagePaths.add(card.imagePath);
    }
    return unlockedImagePaths;
  }

  Future<void> unlockStoryPart(String storyId, String partId) async {
    final existing = await _storage.getStoryProgress(storyId);

    List<String> parts = [];
    if (existing != null) {
      parts = List<String>.from(jsonDecode(existing['parts_unlocked']));
      if (parts.contains(partId)) {
        return; // Already unlocked, no need to save
      }
    }

    parts.add(partId);
    await _storage.saveStoryProgress(
      storyId: storyId,
      partsUnlocked: parts,
      timestamp: existing?['unlocked_at'] ?? DateTime.now().millisecondsSinceEpoch,
    );
    _invalidateCache(); // Story progress affects unearned content
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getStoryProgress(String storyId) async {
    return await _storage.getStoryProgress(storyId);
  }

  Future<List<Map<String, dynamic>>> getUnlockedStoryProgress() async {
    return await _storage.getAllStoryProgress();
  }

  Future<void> unlockStory(String storyId, List<String> allParts) async {
    await _storage.saveStoryProgress(
      storyId: storyId,
      partsUnlocked: allParts,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _invalidateCache();
    notifyListeners();
  }

  Future<void> saveQuizResult(String deityName) async {
    await _storage.saveQuizResult(
      deityName: deityName,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getQuizResults() async {
    return await _storage.getQuizResults();
  }

  Future<void> saveQixDifficulty(int level) async {
    await _saveSetting('qix_difficulty', level.toString());
    notifyListeners();
  }

  Future<int> getQixDifficulty() async {
    final value = await _getCachedSetting('qix_difficulty');
    return value != null ? int.tryParse(value) ?? 0 : 0;
  }

  Future<void> saveSnakeDifficulty(int level) async {
    await _saveSetting('snake_difficulty', level.toString());
    notifyListeners();
  }

  Future<int> getSnakeDifficulty() async {
    final value = await _getCachedSetting('snake_difficulty');
    return value != null ? int.tryParse(value) ?? 0 : 0;
  }

  Future<void> saveWordSearchDifficulty(int level) async {
    await _saveSetting('word_search_difficulty', level.toString());
    notifyListeners();
  }

  Future<int> getWordSearchDifficulty() async {
    final value = await _getCachedSetting('word_search_difficulty');
    return value != null ? int.tryParse(value) ?? 1 : 1;
  }

  Future<void> savePuzzleDifficulty(int level) async {
    await _saveSetting('puzzle_difficulty', level.toString());
    notifyListeners();
  }

  Future<int> getPuzzleDifficulty() async {
    final value = await _getCachedSetting('puzzle_difficulty');
    return value != null ? int.tryParse(value) ?? 1 : 1;
  }

  Future<void> saveNorseQuizLevel(int level) async {
    await _saveSetting('norse_quiz_level', level.toString());
    notifyListeners();
  }

  Future<int> getNorseQuizLevel() async {
    final value = await _getCachedSetting('norse_quiz_level');
    return value != null ? int.tryParse(value) ?? 1 : 1;
  }

  Future<void> saveProfileName(String name) async {
    await _saveSetting('profile_name', name);
    notifyListeners();
  }

  Future<String?> getProfileName() async {
    return await _getCachedSetting('profile_name');
  }

  Future<void> saveProfileDeityIcon(String deityId) async {
    await _saveSetting('profile_deity_icon', deityId);
    notifyListeners();
  }

  Future<String?> getProfileDeityIcon() async {
    return await _getCachedSetting('profile_deity_icon');
  }

  /// Builds a map of unlocked story parts for quick lookup.
  ///
  /// This helper method is extracted to avoid duplication between
  /// getUnearnedContent() and selectRandomUnearnedMythStory().
  Future<Map<String, List<String>>> _getUnlockedStoryPartsMap() async {
    final unlockedStoryProgress = await getUnlockedStoryProgress();
    final Map<String, List<String>> unlockedStoryParts = {};

    for (var progress in unlockedStoryProgress) {
      unlockedStoryParts[progress['story_id'] as String] =
          List<String>.from(jsonDecode(progress['parts_unlocked']));
    }

    return unlockedStoryParts;
  }

  /// Gets all content (cards and stories) that the player has not yet earned.
  ///
  /// This method uses caching to avoid expensive calculations on every call.
  /// The cache is invalidated whenever cards are unlocked or story progress changes.
  Future<UnearnedContent> getUnearnedContent() async {
    // Return cached result if still valid
    if (_isUnearnedContentCacheValid && _unearnedContentCache != null) {
      return _unearnedContentCache!;
    }

    final allMythStories = getMythStories().skip(1).toList();
    final unlockedCollectibleCards = await getUnlockedCollectibleCards();
    final unlockedStoryParts = await _getUnlockedStoryPartsMap();

    // Build version lookup map for O(1) access
    final Map<String, Set<CardVersion>> unlockedCardVersions = {};
    for (var card in unlockedCollectibleCards) {
      unlockedCardVersions.putIfAbsent(card.id, () => {}).add(card.version);
    }

    // Optimized filtering with single pass - O(n) instead of O(n²)
    final unearnedCollectibleCards = allCollectibleCards.where((card) {
      final versions = unlockedCardVersions[card.id];

      // No versions unlocked - can earn chibi
      if (versions == null || versions.isEmpty) {
        return card.version == CardVersion.chibi;
      }

      // Check eligibility based on version progression: chibi → premium → epic
      return switch (card.version) {
        CardVersion.chibi => !versions.contains(CardVersion.chibi),
        CardVersion.premium => versions.contains(CardVersion.chibi) &&
                               !versions.contains(CardVersion.premium),
        CardVersion.epic => versions.contains(CardVersion.premium) &&
                           !versions.contains(CardVersion.epic),
      };
    }).toList();

    // Filter stories that are not fully unlocked
    final unearnedMythStories = allMythStories.where((story) {
      final partsUnlocked = unlockedStoryParts[story.id]?.length ?? 0;
      return partsUnlocked < story.correctOrder.length;
    }).toList();

    // Cache the result
    _unearnedContentCache = UnearnedContent(
      collectibleCards: unearnedCollectibleCards,
      mythStories: unearnedMythStories,
    );
    _unearnedContentCacheTime = DateTime.now();

    return _unearnedContentCache!;
  }

  Future<MythStory?> getRandomUnearnedMythStory() async {
    final unearnedContent = await getUnearnedContent();

    if (unearnedContent.mythStories.isNotEmpty) {
      final random = Random();
      return unearnedContent.mythStories[
          random.nextInt(unearnedContent.mythStories.length)];
    }
    return null;
  }

  Future<MythStory?> selectRandomUnearnedMythStory(MythStory story) async {
    final unlockedStoryParts = await _getUnlockedStoryPartsMap();
    final partsUnlockedForStory = unlockedStoryParts[story.id] ?? [];

    // Find first unearned chapter
    final firstUnearnedChapter = story.correctOrder.firstWhereOrNull(
      (mythCard) => !partsUnlockedForStory.contains(mythCard.id),
    );

    if (firstUnearnedChapter != null) {
      await unlockStoryPart(story.id, firstUnearnedChapter.id);
      return story;
    }
    return null;
  }

  Future<CollectibleCard?> getRandomUnearnedCollectibleCard() async {
    final unearnedContent = await getUnearnedContent();

    if (unearnedContent.collectibleCards.isNotEmpty) {
      final random = Random();
      return unearnedContent.collectibleCards[
          random.nextInt(unearnedContent.collectibleCards.length)];
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

  Future<int> getUnlockedChapterCountForStory(String storyId) async {
    final progress = await _storage.getStoryProgress(storyId);
    if (progress != null) {
      final List<dynamic> parts = jsonDecode(progress['parts_unlocked']);
      return parts.length;
    }
    return 0;
  }

  Future<void> addCoins(int amount) async {
    final currentCoins = await getCoins();
    await saveCoins(currentCoins + amount);
  }

  // Visual Novel ending tracking
  Future<bool> isVisualNovelEndingCompleted(String endingId) async {
    final value = await _getCachedSetting('vn_ending_$endingId');
    return value == 'true';
  }

  Future<void> markVisualNovelEndingCompleted(String endingId) async {
    await _saveSetting('vn_ending_$endingId', 'true');
    notifyListeners();
  }

  Future<List<String>> getCompletedVisualNovelEndings() async {
    // Note: This could be optimized with a prefix query in storage adapters
    // For now, we check all possible endings defined in GameRewardConfig
    final List<String> endings = [];

    for (int i = 1; i <= GameRewardConfig.maxVisualNovelEndings; i++) {
      final endingId = 'ending_$i';
      if (await isVisualNovelEndingCompleted(endingId)) {
        endings.add(endingId);
      }
    }

    return endings;
  }

  /// Calculates the base game reward with level bonus.
  ///
  /// No longer returns Future as this is a pure calculation.
  int calculateGameReward({int level = 1}) {
    return GameRewardConfig.baseGameReward +
        (level - 1) * GameRewardConfig.bonusPerLevel;
  }

  /// Calculates coins earned from Snake game score.
  int calculateSnakeGameCoins(int score) {
    return (score ~/ GameRewardConfig.snakeScoreDivisor) *
        GameRewardConfig.snakeCoinMultiplier;
  }

  /// Calculates coins earned from Asgard Wall game score.
  ///
  /// Players must exceed minimum score to earn coins.
  int calculateAsgardWallCoins(int score) {
    if (score <= GameRewardConfig.asgardWallMinScore) {
      return 0;
    }
    return ((score - GameRewardConfig.asgardWallMinScore) ~/
            GameRewardConfig.asgardWallScoreDivisor) *
        GameRewardConfig.asgardWallCoinMultiplier;
  }
}