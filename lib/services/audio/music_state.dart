/// Represents the type of music currently playing.
enum MusicType { mainMenu, story, card, none }

/// Manages the state of music playback.
///
/// Tracks current and previous music types, mute states,
/// and card/ambient music selections.
class MusicState {
  MusicType _currentMusic = MusicType.none;
  MusicType _previousMusic = MusicType.none;

  bool _isMuted = false;
  bool _isFxMuted = false;
  bool _isReadingPageMusicMuted = false;

  String? _currentCardId;
  String? _readingPageMusicCardId;
  String? _currentAmbientMusicCardId;

  // Getters
  MusicType get currentMusic => _currentMusic;
  MusicType get previousMusic => _previousMusic;

  bool get isMuted => _isMuted;
  bool get isFxMuted => _isFxMuted;
  bool get isReadingPageMusicMuted => _isReadingPageMusicMuted;

  String? get currentCardId => _currentCardId;
  String? get readingPageMusicCardId => _readingPageMusicCardId;
  String? get currentAmbientMusicCardId => _currentAmbientMusicCardId;

  // State mutations
  void setCurrentMusic(MusicType type) {
    _currentMusic = type;
  }

  void setPreviousMusic(MusicType type) {
    _previousMusic = type;
  }

  void savePreviousMusic() {
    if (_currentMusic != MusicType.card) {
      _previousMusic = _currentMusic;
    }
  }

  void clearPreviousMusic() {
    _previousMusic = MusicType.none;
  }

  void setMuted(bool muted) {
    _isMuted = muted;
    if (_isMuted) {
      _currentMusic = MusicType.none;
      _currentCardId = null;
    }
  }

  void setFxMuted(bool muted) {
    _isFxMuted = muted;
  }

  void setReadingPageMusicMuted(bool muted) {
    _isReadingPageMusicMuted = muted;
    if (muted) {
      _readingPageMusicCardId = null;
    }
  }

  void setCurrentCardId(String? cardId) {
    _currentCardId = cardId;
  }

  void setReadingPageMusicCardId(String? cardId) {
    _readingPageMusicCardId = cardId;
    if (cardId != null) {
      _isReadingPageMusicMuted = false;
    }
  }

  void setAmbientMusicCardId(String? cardId) {
    _currentAmbientMusicCardId = cardId;
  }

  /// Checks if music playback should be allowed based on current state.
  bool get shouldPlayMusic => !_isMuted;

  /// Checks if story music should play (not muted globally or specifically).
  bool get shouldPlayStoryMusic =>
      !_isMuted && !_isReadingPageMusicMuted;

  /// Checks if there's a previous music type to restore.
  bool get hasPreviousMusic => _previousMusic != MusicType.none;

  /// Returns true if currently playing any music.
  bool get isPlayingMusic => _currentMusic != MusicType.none;

  @override
  String toString() {
    return 'MusicState(current: $_currentMusic, previous: $_previousMusic, '
        'muted: $_isMuted, fxMuted: $_isFxMuted, '
        'cardId: $_currentCardId)';
  }
}
