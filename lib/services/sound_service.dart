import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

enum MusicType {
  mainMenu,
  story,
  none,
}

class SoundService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;
  MusicType _currentMusic = MusicType.none;

  SoundService() {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  bool get isMuted => _isMuted;

  Future<void> playMainMenuMusic() async {
    if (!_isMuted) {
      await _audioPlayer.stop(); // Still stop before playing new music
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('audio/ambiance.mp3'));
      _currentMusic = MusicType.mainMenu;
    }
  }

  Future<void> playStoryMusic() async {
    if (!_isMuted) {
      await _audioPlayer.stop(); // Still stop before playing new music
      await _audioPlayer.setVolume(0.5);
      await _audioPlayer.play(AssetSource('audio/reading.mp3'));
      _currentMusic = MusicType.story;
    }
  }

  void pauseMusic() { // Renamed from stopMusic to pauseMusic
    _audioPlayer.pause();
  }

  Future<void> resumeMusic() async {
    if (!_isMuted) {
      if (_currentMusic != MusicType.none) { // Only resume if music was playing
        await _audioPlayer.resume();
      }
    }
  }

  void setMuted(bool muted) {
    _isMuted = muted;
    if (_isMuted) {
      _audioPlayer.stop(); // When muted, truly stop
      _currentMusic = MusicType.none; // Reset current music when muted
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
