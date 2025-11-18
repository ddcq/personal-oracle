/// Scoring configuration for Snake game
class SnakeScoring {
  // Food scores
  static const int goldenFood = 50;
  static const int regularFood = 10;
  static const int rottenFoodPenaltyBase = 10;
  static const int rottenFoodPenaltyPerLevel = 10;

  // Bonus scores
  static const int coinBonus = 20;

  // Probabilities
  static const double goldenFoodProbability = 0.15;

  // Prevent instantiation
  const SnakeScoring._();

  /// Calculate rotten food penalty based on level
  static int getRottenFoodPenalty(int level) {
    return rottenFoodPenaltyBase + (level * rottenFoodPenaltyPerLevel);
  }
}

/// Bonus configuration for Snake game
class BonusConfig {
  static const double spawnProbability = 1.0;
  static const double lifetime = 8.0; // seconds
  static const double effectDuration = 8.0; // seconds
  
  // Bonus multipliers
  static const double speedMultiplier = 0.7; // 30% faster
  static const double freezeMultiplier = 1.3; // 30% slower

  // Prevent instantiation
  const BonusConfig._();
}

/// Obstacle configuration for Snake game
class ObstacleConfig {
  static const int baseObstacles = 1;

  // Prevent instantiation
  const ObstacleConfig._();

  /// Calculate number of obstacles based on level
  static int getObstacleCount(int level) {
    return baseObstacles + level;
  }
}
