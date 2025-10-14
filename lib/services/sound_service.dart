import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

enum MusicType {
  mainMenu,
  story,
  card,
  none,
}

class SoundService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;
  MusicType _currentMusic = MusicType.none;
  MusicType _previousMusic = MusicType.none;

  SoundService() {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  bool get isMuted => _isMuted;

  Future<void> playMainMenuMusic() async {
    if (!_isMuted) {
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('audio/ambiance.mp3'));
      _currentMusic = MusicType.mainMenu;
    }
  }

  Future<void> playStoryMusic() async {
    if (!_isMuted) {
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(0.5);
      await _audioPlayer.play(AssetSource('audio/reading.mp3'));
      _currentMusic = MusicType.story;
    }
  }

  Future<void> playCardMusic(String cardId) async {
    if (!_isMuted) {
      if (_currentMusic != MusicType.card) {
        _previousMusic = _currentMusic;
      }
      await _audioPlayer.stop();
      final musicUrl = 'https://ddcq.github.io/music/$cardId.mp3';
      await _audioPlayer.play(UrlSource(musicUrl));
      _currentMusic = MusicType.card;
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
      if (_currentMusic != MusicType.none) {
        await _audioPlayer.resume();
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
