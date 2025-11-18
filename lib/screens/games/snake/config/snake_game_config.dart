/// Configuration constants for Snake game
class SnakeGameConfig {
  // Visual effects
  static const double shakeIntensity = 10.0;
  static const int shakeDurationMs = 200;
  static const int shakeIntervalMs = 50;

  // Game speed
  static const int gameSpeedInitial = 200; // milliseconds
  static const double growthAnimationPeriod = 0.15;

  // Food mechanics
  static const double foodRottingTimeBase = 12.0;
  static const double foodRottingTimeLevelFactor = 0.5;

  // Vibration durations
  static const int vibrationDurationShort = 100;
  static const int vibrationDurationMedium = 200;
  static const int vibrationDurationLong = 500;
  static const int vibrationAmplitudeHigh = 255;

  // Victory condition
  static const int victoryScoreThreshold = 100;

  // Prevent instantiation
  const SnakeGameConfig._();
}
