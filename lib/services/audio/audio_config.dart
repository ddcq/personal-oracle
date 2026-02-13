/// Configuration constants for audio playback.
///
/// Centralizes all URLs, paths, timeouts, and volume settings
/// used throughout the audio system.
class AudioConfig {
  // Base URLs
  static const String baseUrl = 'https://ddcq.github.io';
  static const String musicPath = '/music';

  // Music files
  static const String ambientMusicFile = 'ambiance.mp3';
  static const String readingMusicFile = 'reading.mp3';

  // Volume levels
  static const double fullVolume = 1.0;
  static const double storyVolume = 0.5;

  // Timeouts
  static const Duration loadTimeout = Duration(seconds: 10);

  // Audio context configuration
  static const int maxConcurrentSoundEffects = 10;

  // Special music identifiers
  static const String muteMusicIdentifier = 'mute';

  /// Constructs the full music URL for a given path.
  static String getMusicUrl(String fileName) {
    return '$baseUrl$musicPath/$fileName';
  }

  /// Constructs the music path for a given file (used for cache keys).
  static String getMusicPath(String fileName) {
    return '$musicPath/$fileName';
  }

  /// Gets the URL for a card's music file.
  static String getCardMusicUrl(String cardId) {
    return getMusicUrl('$cardId.mp3');
  }

  /// Gets the path for a card's music file.
  static String getCardMusicPath(String cardId) {
    return getMusicPath('$cardId.mp3');
  }

  // Private constructor to prevent instantiation
  AudioConfig._();
}
