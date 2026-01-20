import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/cache_service.dart';

enum MusicType { mainMenu, story, card, none }

class SoundService with ChangeNotifier {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final List<AudioPlayer> _fxPlayers = [];
  bool _isMuted = false;
  bool _isFxMuted = false;
  String? _readingPageMusicCardId;
  bool _isReadingPageMusicMuted = false;
  MusicType _currentMusic = MusicType.none;
  MusicType _previousMusic = MusicType.none;
  String? currentCardId;
  String? _currentAmbientMusicCardId;

  SoundService() {
    // Constructor is now minimal
  }

  Future<void> init() async {
    _musicPlayer.setReleaseMode(ReleaseMode.loop);

    _musicPlayer.onPlayerComplete.listen((_) {
      if (_currentMusic == MusicType.card && _previousMusic != MusicType.none) {
        resumePreviousMusic();
      }
    });

    // Configure the audio context for mixing sounds
    final audioContext = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {AVAudioSessionOptions.mixWithOthers},
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.none,
      ),
    );

    try {
      await AudioPlayer.global.setAudioContext(audioContext);
    } catch (e) {
      debugPrint('Error setting audio context: $e');
    }
  }

  bool get isMuted => _isMuted;
  bool get isFxMuted => _isFxMuted;
  bool get isReadingPageMusicMuted => _isReadingPageMusicMuted;
  String? get readingPageMusicCardId => _readingPageMusicCardId;
  String? get currentAmbientMusicCardId => _currentAmbientMusicCardId;

  void setFxMuted(bool muted) {
    _isFxMuted = muted;
    notifyListeners();
  }

  Future<void> playMainMenuMusic() async {
    if (!_isMuted) {
      try {
        await _musicPlayer.stop();
        await _musicPlayer.setReleaseMode(ReleaseMode.loop);
        await _musicPlayer.setVolume(1.0);

        if (_currentAmbientMusicCardId != null) {
          await _playAmbientMusicFromCard(_currentAmbientMusicCardId!);
        } else {
          await _playDefaultAmbientMusic();
        }
        _currentMusic = MusicType.mainMenu;
        currentCardId = _currentAmbientMusicCardId;
      } catch (e) {
        debugPrint('Error loading main menu music: $e');
      }
    }
    notifyListeners();
  }

  Future<void> _playDefaultAmbientMusic() async {
    final musicPath = '/music/ambiance.mp3';
    final musicUrl = 'https://ddcq.github.io$musicPath';
    final cacheService = getIt<CacheService>();
    final cacheManager = DefaultCacheManager();

    var fileInfo = await cacheManager.getFileFromCache(musicUrl);
    if (fileInfo == null) {
      debugPrint('Downloading default ambient music: $musicUrl');
      fileInfo = await cacheManager.downloadFile(musicUrl);
      final version = cacheService.getVersionFor(musicPath);
      if (version != null) {
        await cacheService.setVersionFor(musicPath, version);
      }
    }

    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(1.0);
    await _musicPlayer
        .play(DeviceFileSource(fileInfo.file.path))
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            debugPrint('Default ambient music loading timeout');
          },
        );
  }

  Future<void> _playAmbientMusicFromCard(String cardId) async {
    final musicPath = '/music/$cardId.mp3';
    final musicUrl = 'https://ddcq.github.io$musicPath';
    final cacheService = getIt<CacheService>();
    final cacheManager = DefaultCacheManager();

    var fileInfo = await cacheManager.getFileFromCache(musicUrl);
    if (fileInfo == null) {
      debugPrint('Downloading ambient music: $musicUrl');
      fileInfo = await cacheManager.downloadFile(musicUrl);
      final version = cacheService.getVersionFor(musicPath);
      if (version != null) {
        await cacheService.setVersionFor(musicPath, version);
      }
    }

    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(1.0);
    await _musicPlayer
        .play(DeviceFileSource(fileInfo.file.path))
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            debugPrint('Ambient card music loading timeout');
          },
        );
  }

  void setAmbientMusicByCardId(String? cardId) {
    _currentAmbientMusicCardId = cardId;
    if (_currentMusic == MusicType.mainMenu) {
      playMainMenuMusic();
    }
    notifyListeners();
  }

  Future<void> playStoryMusic() async {
    if (!_isMuted && !_isReadingPageMusicMuted) {
      try {
        await _musicPlayer.stop();
        await _musicPlayer.setReleaseMode(ReleaseMode.loop);
        await _musicPlayer.setVolume(0.5);

        if (_readingPageMusicCardId != null) {
          await playStoryMusicFromCard(_readingPageMusicCardId!);
        } else {
          await _playDefaultReadingMusic();
          _currentMusic = MusicType.story;
          currentCardId = null;
        }
      } catch (e) {
        debugPrint('Error loading story music: $e');
      }
    } else if (_isReadingPageMusicMuted) {
      await _musicPlayer.stop();
    }
  }

  Future<void> _playDefaultReadingMusic() async {
    final musicPath = '/music/reading.mp3';
    final musicUrl = 'https://ddcq.github.io$musicPath';
    final cacheService = getIt<CacheService>();
    final cacheManager = DefaultCacheManager();

    var fileInfo = await cacheManager.getFileFromCache(musicUrl);
    if (fileInfo == null) {
      debugPrint('Downloading default reading music: $musicUrl');
      fileInfo = await cacheManager.downloadFile(musicUrl);
      final version = cacheService.getVersionFor(musicPath);
      if (version != null) {
        await cacheService.setVersionFor(musicPath, version);
      }
    }

    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(0.5);
    await _musicPlayer
        .play(DeviceFileSource(fileInfo.file.path))
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            debugPrint('Default reading music loading timeout');
          },
        );
  }

  Future<void> playStoryMusicFromCard(String cardId) async {
    if (!_isMuted && !_isReadingPageMusicMuted) {
      try {
        await _musicPlayer.stop();
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

        await _musicPlayer.setReleaseMode(ReleaseMode.loop);
        await _musicPlayer.setVolume(0.5);
        await _musicPlayer
            .play(DeviceFileSource(fileInfo.file.path))
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                debugPrint('Card music loading timeout');
              },
            );
        _currentMusic = MusicType.story;
      } catch (e) {
        debugPrint('Error loading card music for story: $e');
      }
    }
  }

  void setReadingPageMusic(String? assetPath) {
    if (assetPath == 'mute' || assetPath == null) {
      _isReadingPageMusicMuted = true;
      _readingPageMusicCardId = null;
      if (_currentMusic == MusicType.story) {
        _musicPlayer.stop();
      }
    } else {
      _isReadingPageMusicMuted = false;
      _readingPageMusicCardId = null;
      if (_currentMusic == MusicType.story) {
        playStoryMusic();
      }
    }
    notifyListeners();
  }

  void setReadingPageMusicByCardId(String cardId) {
    _isReadingPageMusicMuted = false;
    _readingPageMusicCardId = cardId;
    if (_currentMusic == MusicType.story) {
      playStoryMusicFromCard(cardId);
    }
    notifyListeners();
  }

  Future<void> playCardMusic(String cardId, {bool asAmbient = false}) async {
    if (!_isMuted) {
      try {
        if (_currentMusic != MusicType.card && !asAmbient) {
          _previousMusic = _currentMusic;
        }
        await _musicPlayer.stop();
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

        if (asAmbient) {
          await _musicPlayer.setReleaseMode(ReleaseMode.loop);
        } else {
          await _musicPlayer.setReleaseMode(ReleaseMode.stop);
        }

        await _musicPlayer
            .play(DeviceFileSource(fileInfo.file.path))
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                debugPrint('Card music loading timeout for $cardId');
                if (_previousMusic != MusicType.none && !asAmbient) {
                  resumePreviousMusic();
                }
              },
            );
        _currentMusic = asAmbient ? MusicType.mainMenu : MusicType.card;
        currentCardId = cardId;
      } catch (e) {
        debugPrint('Error loading card music for $cardId: $e');
        if (_previousMusic != MusicType.none && !asAmbient) {
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
        await _musicPlayer.stop();
      }
      _currentMusic = _previousMusic;
      _previousMusic = MusicType.none;
    }
  }

  void pauseMusic() {
    _musicPlayer.pause();
  }

  Future<void> resumeMusic() async {
    if (!_isMuted) {
      try {
        if (_currentMusic != MusicType.none) {
          await _musicPlayer.resume();
        }
      } catch (e) {
        debugPrint('Error resuming music: $e');
      }
    }
  }

  void setMuted(bool muted) {
    _isMuted = muted;
    if (_isMuted) {
      _musicPlayer.stop();
      _currentMusic = MusicType.none;
      currentCardId = null;
    } else {
      playMainMenuMusic();
    }
    notifyListeners();
  }

  Future<void> playSoundEffect(String assetPath) async {
    if (!_isFxMuted) {
      try {
        // Find an available player or create a new one
        AudioPlayer? player = _fxPlayers.firstWhere(
          (p) =>
              p.state == PlayerState.completed ||
              p.state == PlayerState.stopped,
          orElse: () {
            final newPlayer = AudioPlayer();
            _fxPlayers.add(newPlayer);
            return newPlayer;
          },
        );

        await player.setReleaseMode(ReleaseMode.release);
        await player.play(AssetSource(assetPath));
      } catch (e) {
        debugPrint('Error playing sound effect $assetPath: $e');
      }
    }
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    for (final player in _fxPlayers) {
      player.dispose();
    }
    _fxPlayers.clear();
    super.dispose();
  }
}
