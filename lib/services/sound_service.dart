import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/cache_service.dart';

enum MusicType { mainMenu, story, card, none }

class SoundService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;
  bool _isFxMuted = false; // New property for FX mute state
  MusicType _currentMusic = MusicType.none;
  MusicType _previousMusic = MusicType.none;
  String? currentCardId;

  SoundService() {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);

    // Listen for player completion to auto-resume previous music for cards
    _audioPlayer.onPlayerComplete.listen((_) {
      if (_currentMusic == MusicType.card && _previousMusic != MusicType.none) {
        resumePreviousMusic();
      }
    });
  }

  bool get isMuted => _isMuted;
  bool get isFxMuted => _isFxMuted; // Getter for FX mute state

  void setFxMuted(bool muted) {
    _isFxMuted = muted;
    notifyListeners();
  }

  Future<void> playMainMenuMusic() async {
    if (!_isMuted) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.setReleaseMode(
          ReleaseMode.loop,
        ); // Ensure looping for menu music
        await _audioPlayer.setVolume(1.0);
        await _audioPlayer
            .play(AssetSource('audio/ambiance.mp3'))
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                debugPrint('Main menu music loading timeout');
              },
            );
        _currentMusic = MusicType.mainMenu;
        currentCardId = null;
      } catch (e) {
        debugPrint('Error loading main menu music: $e');
      }
    }
    notifyListeners();
  }

  Future<void> playStoryMusic() async {
    if (!_isMuted) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.setReleaseMode(
          ReleaseMode.loop,
        ); // Ensure looping for story music
        await _audioPlayer.setVolume(0.5);
        await _audioPlayer
            .play(AssetSource('audio/reading.mp3'))
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                debugPrint('Story music loading timeout');
              },
            );
        _currentMusic = MusicType.story;
        currentCardId = null;
      } catch (e) {
        debugPrint('Error loading story music: $e');
      }
    }
  }

  Future<void> playCardMusic(String cardId) async {
    if (!_isMuted) {
      try {
        if (_currentMusic != MusicType.card) {
          _previousMusic = _currentMusic;
        }
        await _audioPlayer.stop();
        final musicPath = '/music/$cardId.mp3';
        final musicUrl = 'https://ddcq.github.io$musicPath';
        final cacheService = getIt<CacheService>();
        final cacheManager = DefaultCacheManager();

        var fileInfo = await cacheManager.getFileFromCache(musicUrl);
        if (fileInfo == null) {
          debugPrint('Downloading music: $musicUrl');
          fileInfo = await cacheManager.downloadFile(musicUrl);
          final version = cacheService.getVersionFor(musicPath);
          if (version != null) {
            await cacheService.setVersionFor(musicPath, version);
          }
        }

        // Set release mode to stop (not loop) for card music
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);

        // Ajout d'un timeout de 10 secondes pour éviter les blocages
        await _audioPlayer
            .play(DeviceFileSource(fileInfo.file.path))
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                debugPrint('Card music loading timeout for $cardId');
                // En cas de timeout, on reprend la musique précédente
                if (_previousMusic != MusicType.none) {
                  resumePreviousMusic();
                }
              },
            );
        _currentMusic = MusicType.card;
        currentCardId = cardId;
      } catch (e) {
        debugPrint('Error loading card music for $cardId: $e');
        // En cas d'erreur, on reprend la musique précédente
        if (_previousMusic != MusicType.none) {
          await resumePreviousMusic();
        }
      }
    }
    notifyListeners();
  }

  Future<void> resumePreviousMusic() async {
    if (!_isMuted) {
      if (_previousMusic == MusicType.mainMenu) {
        await playMainMenuMusic();
      } else if (_previousMusic == MusicType.story) {
        await playStoryMusic();
      } else {
        await _audioPlayer.stop(); // If no previous music, just stop
      }
      _currentMusic = _previousMusic;
      _previousMusic = MusicType.none;
    }
  }

  void pauseMusic() {
    _audioPlayer.pause();
  }

  Future<void> resumeMusic() async {
    if (!_isMuted) {
      try {
        if (_currentMusic != MusicType.none) {
          await _audioPlayer.resume();
        }
      } catch (e) {
        debugPrint('Error resuming music: $e');
      }
    }
  }

  void setMuted(bool muted) {
    _isMuted = muted;
    if (_isMuted) {
      _audioPlayer.stop();
      _currentMusic = MusicType.none;
      currentCardId = null;
    } else {
      playMainMenuMusic();
    }
    notifyListeners();
  }

  Future<void> playSoundEffect(String assetPath) async {
    if (!_isFxMuted) { // Check _isFxMuted instead of _isMuted
      try {
        // Create a new AudioPlayer for each sound effect to allow overlapping
        final player = AudioPlayer();
        await player.play(AssetSource(assetPath));

        // Dispose the player when the sound finishes
        player.onPlayerComplete.listen((_) {
          player.dispose();
        });
      } catch (e) {
        debugPrint('Error playing sound effect $assetPath: $e');
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
