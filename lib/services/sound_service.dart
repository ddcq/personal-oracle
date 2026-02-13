import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, debugPrint;
import 'package:oracle_d_asgard/services/audio/audio_config.dart';
import 'package:oracle_d_asgard/services/audio/audio_loader.dart';
import 'package:oracle_d_asgard/services/audio/music_state.dart';

export 'package:oracle_d_asgard/services/audio/music_state.dart' show MusicType;

/// Service for managing music and sound effects playback.
///
/// This service handles:
/// - Background music (main menu, story reading, card music)
/// - Sound effects with pooling
/// - Mute/unmute state
/// - Platform-specific audio loading (web vs native)
class SoundService with ChangeNotifier {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final List<AudioPlayer> _fxPlayers = [];
  final MusicState _state = MusicState();
  final AudioLoader _audioLoader = AudioLoader();

  SoundService() {
    // Constructor is now minimal
  }

  Future<void> init() async {
    _musicPlayer.setReleaseMode(ReleaseMode.loop);

    _musicPlayer.onPlayerComplete.listen((_) {
      if (_state.currentMusic == MusicType.card && _state.hasPreviousMusic) {
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

  // Getters delegating to state
  bool get isMuted => _state.isMuted;
  bool get isFxMuted => _state.isFxMuted;
  bool get isReadingPageMusicMuted => _state.isReadingPageMusicMuted;
  String? get readingPageMusicCardId => _state.readingPageMusicCardId;
  String? get currentAmbientMusicCardId => _state.currentAmbientMusicCardId;
  String? get currentCardId => _state.currentCardId;

  void setFxMuted(bool muted) {
    _state.setFxMuted(muted);
    notifyListeners();
  }

  /// Generic helper to play music with unified web/native handling.
  Future<void> _playMusic({
    required String fileName,
    required ReleaseMode releaseMode,
    required double volume,
    required MusicType musicType,
    String? cardId,
  }) async {
    if (!_state.shouldPlayMusic) return;

    try {
      await _musicPlayer.stop();
      await _audioLoader.configurePlayer(
        player: _musicPlayer,
        releaseMode: releaseMode,
        volume: volume,
      );

      final musicUrl = AudioConfig.getMusicUrl(fileName);
      final musicPath = AudioConfig.getMusicPath(fileName);

      final result = await _audioLoader.playFromUrl(
        player: _musicPlayer,
        musicUrl: musicUrl,
        musicPath: musicPath,
      );

      if (result.success) {
        _state.setCurrentMusic(musicType);
        _state.setCurrentCardId(cardId);
      } else {
        debugPrint('Failed to play music: ${result.errorMessage}');
      }
    } catch (e) {
      debugPrint('Error playing music ($fileName): $e');
    }
  }

  Future<void> playMainMenuMusic() async {
    if (_state.shouldPlayMusic) {
      try {
        final fileName = _state.currentAmbientMusicCardId != null
            ? '${_state.currentAmbientMusicCardId}.mp3'
            : AudioConfig.ambientMusicFile;

        await _playMusic(
          fileName: fileName,
          releaseMode: ReleaseMode.loop,
          volume: AudioConfig.fullVolume,
          musicType: MusicType.mainMenu,
          cardId: _state.currentAmbientMusicCardId,
        );
      } catch (e) {
        debugPrint('Error loading main menu music: $e');
      }
    }
    notifyListeners();
  }

  void setAmbientMusicByCardId(String? cardId) {
    _state.setAmbientMusicCardId(cardId);
    if (_state.currentMusic == MusicType.mainMenu) {
      playMainMenuMusic();
    }
    notifyListeners();
  }

  Future<void> playStoryMusic() async {
    if (_state.shouldPlayStoryMusic) {
      try {
        final fileName = _state.readingPageMusicCardId != null
            ? '${_state.readingPageMusicCardId}.mp3'
            : AudioConfig.readingMusicFile;

        await _playMusic(
          fileName: fileName,
          releaseMode: ReleaseMode.loop,
          volume: AudioConfig.storyVolume,
          musicType: MusicType.story,
          cardId: _state.readingPageMusicCardId,
        );
      } catch (e) {
        debugPrint('Error loading story music: $e');
      }
    } else if (_state.isReadingPageMusicMuted) {
      await _musicPlayer.stop();
    }
  }

  Future<void> playStoryMusicFromCard(String cardId) async {
    if (_state.shouldPlayStoryMusic) {
      try {
        await _playMusic(
          fileName: '$cardId.mp3',
          releaseMode: ReleaseMode.loop,
          volume: AudioConfig.storyVolume,
          musicType: MusicType.story,
          cardId: cardId,
        );
      } catch (e) {
        debugPrint('Error loading card music for story: $e');
      }
    }
  }

  void setReadingPageMusic(String? assetPath) {
    if (assetPath == AudioConfig.muteMusicIdentifier || assetPath == null) {
      _state.setReadingPageMusicMuted(true);
      if (_state.currentMusic == MusicType.story) {
        _musicPlayer.stop();
      }
    } else {
      _state.setReadingPageMusicMuted(false);
      _state.setReadingPageMusicCardId(null);
      if (_state.currentMusic == MusicType.story) {
        playStoryMusic();
      }
    }
    notifyListeners();
  }

  void setReadingPageMusicByCardId(String cardId) {
    _state.setReadingPageMusicCardId(cardId);
    if (_state.currentMusic == MusicType.story) {
      playStoryMusicFromCard(cardId);
    }
    notifyListeners();
  }

  Future<void> playCardMusic(String cardId, {bool asAmbient = false}) async {
    if (_state.shouldPlayMusic) {
      try {
        // Save previous music if playing one-time card music
        if (!asAmbient) {
          _state.savePreviousMusic();
        }

        await _playMusic(
          fileName: '$cardId.mp3',
          releaseMode: asAmbient ? ReleaseMode.loop : ReleaseMode.stop,
          volume: AudioConfig.fullVolume,
          musicType: asAmbient ? MusicType.mainMenu : MusicType.card,
          cardId: cardId,
        );
      } catch (e) {
        debugPrint('Error loading card music for $cardId: $e');
        if (_state.hasPreviousMusic && !asAmbient) {
          await resumePreviousMusic();
        }
      }
    }
    notifyListeners();
  }

  Future<void> resumePreviousMusic() async {
    if (_state.shouldPlayMusic && _state.hasPreviousMusic) {
      final previousType = _state.previousMusic;

      switch (previousType) {
        case MusicType.mainMenu:
          await playMainMenuMusic();
          break;
        case MusicType.story:
          await playStoryMusic();
          break;
        default:
          await _musicPlayer.stop();
      }

      _state.setCurrentMusic(previousType);
      _state.clearPreviousMusic();
    }
  }

  void pauseMusic() {
    _musicPlayer.pause();
  }

  Future<void> resumeMusic() async {
    if (_state.shouldPlayMusic && _state.isPlayingMusic) {
      try {
        await _musicPlayer.resume();
      } catch (e) {
        debugPrint('Error resuming music: $e');
      }
    }
  }

  void setMuted(bool muted) {
    _state.setMuted(muted);

    if (muted) {
      _musicPlayer.stop();
    } else {
      playMainMenuMusic();
    }

    notifyListeners();
  }

  /// Plays a sound effect from assets.
  ///
  /// Uses a pool of AudioPlayers for concurrent playback.
  /// Maximum concurrent effects is defined in AudioConfig.
  Future<void> playSoundEffect(String assetPath) async {
    if (_state.isFxMuted) return;

    try {
      // Find an available player or create a new one (up to max limit)
      AudioPlayer? player = _fxPlayers.firstWhere(
        (p) =>
            p.state == PlayerState.completed ||
            p.state == PlayerState.stopped,
        orElse: () {
          if (_fxPlayers.length >= AudioConfig.maxConcurrentSoundEffects) {
            // Reuse oldest player if at limit
            return _fxPlayers.first;
          }

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
