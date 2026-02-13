/// Configuration constants for game reward calculations.
///
/// This class centralizes all magic numbers used for reward calculations,
/// making them easier to tune and understand.
class GameRewardConfig {
  // Base rewards
  static const int baseGameReward = 50;
  static const int bonusPerLevel = 10;

  // Snake game rewards
  static const int snakeScoreDivisor = 20;
  static const int snakeCoinMultiplier = 10;

  // Asgard Wall rewards
  static const int asgardWallMinScore = 100;
  static const int asgardWallScoreDivisor = 20;
  static const int asgardWallCoinMultiplier = 10;

  // Cache configuration
  static const Duration settingsCacheDuration = Duration(seconds: 30);
  static const Duration progressCacheDuration = Duration(seconds: 10);

  // Visual Novel
  static const int maxVisualNovelEndings = 20;

  // Private constructor to prevent instantiation
  GameRewardConfig._();
}
