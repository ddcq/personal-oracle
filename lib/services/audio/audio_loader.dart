import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/cache_service.dart';
import 'package:oracle_d_asgard/services/audio/audio_config.dart';

/// Result of an audio load operation.
class AudioLoadResult {
  final bool success;
  final String? errorMessage;

  const AudioLoadResult.success()
      : success = true,
        errorMessage = null;

  const AudioLoadResult.error(this.errorMessage) : success = false;
}

/// Handles loading and playing audio files across web and native platforms.
///
/// This class encapsulates the platform-specific logic for loading audio:
/// - Web: Direct URL streaming
/// - Native: Cache-first with download fallback
class AudioLoader {
  final CacheService? _cacheService;
  final DefaultCacheManager? _cacheManager;

  AudioLoader()
      : _cacheService = kIsWeb ? null : getIt<CacheService>(),
        _cacheManager = kIsWeb ? null : DefaultCacheManager();

  /// Plays audio from a URL with automatic platform-specific handling.
  ///
  /// On web, streams directly from [musicUrl].
  /// On native, attempts to load from cache first, downloading if needed.
  ///
  /// Returns [AudioLoadResult] indicating success or failure.
  Future<AudioLoadResult> playFromUrl({
    required AudioPlayer player,
    required String musicUrl,
    required String musicPath,
    Duration timeout = AudioConfig.loadTimeout,
  }) async {
    try {
      if (kIsWeb) {
        return await _playFromWeb(
          player: player,
          musicUrl: musicUrl,
          timeout: timeout,
        );
      } else {
        return await _playFromNative(
          player: player,
          musicUrl: musicUrl,
          musicPath: musicPath,
          timeout: timeout,
        );
      }
    } catch (e) {
      debugPrint('Error loading audio from $musicUrl: $e');
      return AudioLoadResult.error('Failed to load audio: $e');
    }
  }

  /// Plays audio directly from URL (web only).
  Future<AudioLoadResult> _playFromWeb({
    required AudioPlayer player,
    required String musicUrl,
    required Duration timeout,
  }) async {
    try {
      await player.play(UrlSource(musicUrl)).timeout(
        timeout,
        onTimeout: () {
          debugPrint('Audio loading timeout: $musicUrl');
        },
      );
      return const AudioLoadResult.success();
    } catch (e) {
      return AudioLoadResult.error('Web playback failed: $e');
    }
  }

  /// Plays audio from cache or downloads if needed (native only).
  Future<AudioLoadResult> _playFromNative({
    required AudioPlayer player,
    required String musicUrl,
    required String musicPath,
    required Duration timeout,
  }) async {
    // Assert non-null on native platforms (checked by caller)
    final cacheManager = _cacheManager!;
    final cacheService = _cacheService!;

    try {
      // Attempt to get from cache first
      var fileInfo = await cacheManager.getFileFromCache(musicUrl);

      // Download if not cached
      if (fileInfo == null) {
        debugPrint('Downloading audio: $musicUrl');
        fileInfo = await cacheManager.downloadFile(musicUrl);

        // Update version info if available
        final version = cacheService.getVersionFor(musicPath);
        if (version != null) {
          await cacheService.setVersionFor(musicPath, version);
        }
      }

      // Play from cached file
      await player.play(DeviceFileSource(fileInfo.file.path)).timeout(
        timeout,
        onTimeout: () {
          debugPrint('Audio loading timeout: $musicUrl');
        },
      );

      return const AudioLoadResult.success();
    } catch (e) {
      return AudioLoadResult.error('Native playback failed: $e');
    }
  }

  /// Configures a player with common settings.
  Future<void> configurePlayer({
    required AudioPlayer player,
    required ReleaseMode releaseMode,
    required double volume,
  }) async {
    await player.setReleaseMode(releaseMode);
    await player.setVolume(volume);
  }
}
