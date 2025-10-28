import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

enum MusicType { mainMenu, story, card, none }

class SoundService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;
  MusicType _currentMusic = MusicType.none;
  MusicType _previousMusic = MusicType.none;

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

  Future<void> playMainMenuMusic() async {
    if (!_isMuted) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Ensure looping for menu music
        await _audioPlayer.setVolume(1.0);
        await _audioPlayer.play(AssetSource('audio/ambiance.mp3')).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            debugPrint('Main menu music loading timeout');
          },
        );
        _currentMusic = MusicType.mainMenu;
      } catch (e) {
        debugPrint('Error loading main menu music: $e');
      }
    }
  }

  Future<void> playStoryMusic() async {
    if (!_isMuted) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Ensure looping for story music
        await _audioPlayer.setVolume(0.5);
        await _audioPlayer.play(AssetSource('audio/reading.mp3')).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            debugPrint('Story music loading timeout');
          },
        );
        _currentMusic = MusicType.story;
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
        final musicUrl = 'https://ddcq.github.io/music/$cardId.mp3';

        // Set release mode to stop (not loop) for card music
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);

        // Ajout d'un timeout de 10 secondes pour éviter les blocages
        await _audioPlayer
            .play(UrlSource(musicUrl))
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
      } catch (e) {
        debugPrint('Error loading card music for $cardId: $e');
        // En cas d'erreur, on reprend la musique précédente
        if (_previousMusic != MusicType.none) {
          await resumePreviousMusic();
        }
      }
    }
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
    } else {
      playMainMenuMusic();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
