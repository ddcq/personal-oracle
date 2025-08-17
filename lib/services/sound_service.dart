import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;

  SoundService() {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  bool get isMuted => _isMuted;

  Future<void> playMainMenuMusic() async {
    if (!_isMuted) {
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('ambiance.mp3'));
    }
  }

  Future<void> playStoryMusic() async {
    if (!_isMuted) {
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(0.5);
      await _audioPlayer.play(AssetSource('reading.mp3'));
    }
  }

  void stopMusic() {
    _audioPlayer.stop();
  }

  void setMuted(bool muted) {
    _isMuted = muted;
    if (_isMuted) {
      _audioPlayer.stop();
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
