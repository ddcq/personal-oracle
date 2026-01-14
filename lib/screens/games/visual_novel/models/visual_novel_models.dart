/// Models for the Visual Novel game based on Norse Mythology
library;

/// Represents the emotional state of Loki
class EmotionalState {
  int pride; // Fierté
  int bitterness; // Amertume
  int loyalty; // Loyauté
  int lucidity; // Lucidité

  EmotionalState({
    this.pride = 50,
    this.bitterness = 30,
    this.loyalty = 70,
    this.lucidity = 40,
  });

  /// Update emotional state based on choice consequence
  void updateEmotion(EmotionalConsequence consequence) {
    pride = (pride + consequence.prideChange).clamp(0, 100);
    bitterness = (bitterness + consequence.bitternessChange).clamp(0, 100);
    loyalty = (loyalty + consequence.loyaltyChange).clamp(0, 100);
    lucidity = (lucidity + consequence.lucidityChange).clamp(0, 100);
  }

  EmotionalState copy() {
    return EmotionalState(
      pride: pride,
      bitterness: bitterness,
      loyalty: loyalty,
      lucidity: lucidity,
    );
  }
}

/// Represents consequences of player choices on emotional state
class EmotionalConsequence {
  final int prideChange;
  final int bitternessChange;
  final int loyaltyChange;
  final int lucidityChange;

  const EmotionalConsequence({
    this.prideChange = 0,
    this.bitternessChange = 0,
    this.loyaltyChange = 0,
    this.lucidityChange = 0,
  });
}

/// Represents a player choice with its text and consequences
class Choice {
  final String id;
  final String text; // Text to display for the choice
  final String description; // Detailed description of what the choice means
  final EmotionalConsequence consequence; // How this choice affects emotions
  final String? nextSceneId; // Optional scene to jump to after this choice

  const Choice({
    required this.id,
    required this.text,
    required this.description,
    required this.consequence,
    this.nextSceneId,
  });
}

/// Type of scene content
enum SceneType {
  narrative, // Pure narrative text
  dialogue, // Character dialogue with multiple speakers
  choice, // Player choice moment
  climax, // Important story moment
}

/// Represents a single dialogue line
class DialogueLine {
  final String speaker; // Character name
  final String text; // What they say
  final String? characterImage; // Character sprite for this line

  const DialogueLine({
    required this.speaker,
    required this.text,
    this.characterImage,
  });
}

/// Represents a single scene in the visual novel
class Scene {
  final String id;
  final SceneType type;
  final String title; // Scene title
  final String content; // Main text content (for non-dialogue scenes)
  final List<DialogueLine>? dialogues; // Dialogue lines (for dialogue scenes)
  final String? speaker; // Who is speaking (if single dialogue)
  final List<Choice>? choices; // Available choices (if choice scene)
  final String? backgroundImage; // Background image path
  final String? characterImage; // Character sprite path (fallback)
  final String? musicPath; // Background music path
  final String? nextSceneId; // Next scene (if no choices)

  const Scene({
    required this.id,
    required this.type,
    required this.title,
    this.content = '',
    this.dialogues,
    this.speaker,
    this.choices,
    this.backgroundImage,
    this.characterImage,
    this.musicPath,
    this.nextSceneId,
  });

  bool get hasDialogues => dialogues != null && dialogues!.isNotEmpty;
}

/// Represents an act/chapter in the story
class Act {
  final int number;
  final String title;
  final String description;
  final List<String> sceneIds; // List of scene IDs in this act
  final bool isUnlocked;

  const Act({
    required this.number,
    required this.title,
    required this.description,
    required this.sceneIds,
    this.isUnlocked = false,
  });
}

/// Complete story structure with all acts
class Story {
  final String title;
  final String description;
  final List<Act> acts;
  final Map<String, Scene> scenes; // Map of scene ID to scene

  const Story({
    required this.title,
    required this.description,
    required this.acts,
    required this.scenes,
  });

  /// Get a scene by ID
  Scene? getScene(String sceneId) => scenes[sceneId];

  /// Get the act that contains a given scene
  Act? getActForScene(String sceneId) {
    for (final act in acts) {
      if (act.sceneIds.contains(sceneId)) {
        return act;
      }
    }
    return null;
  }
}

/// Game state and progress tracking
class VisualNovelGameState {
  final String currentSceneId;
  final EmotionalState emotionalState;
  final Map<String, bool> choicesMade; // Track which choices player has made
  final Set<String> unlockedActs;
  final Set<String> visitedScenes;
  final DateTime lastPlayed;

  VisualNovelGameState({
    required this.currentSceneId,
    required this.emotionalState,
    this.choicesMade = const {},
    this.unlockedActs = const {},
    this.visitedScenes = const {},
    DateTime? lastPlayed,
  }) : lastPlayed = lastPlayed ?? DateTime.now();

  /// Create a copy with updated fields
  VisualNovelGameState copyWith({
    String? currentSceneId,
    EmotionalState? emotionalState,
    Map<String, bool>? choicesMade,
    Set<String>? unlockedActs,
    Set<String>? visitedScenes,
  }) {
    return VisualNovelGameState(
      currentSceneId: currentSceneId ?? this.currentSceneId,
      emotionalState: emotionalState ?? this.emotionalState,
      choicesMade: choicesMade ?? Map.from(this.choicesMade),
      unlockedActs: unlockedActs ?? Set.from(this.unlockedActs),
      visitedScenes: visitedScenes ?? Set.from(this.visitedScenes),
      lastPlayed: DateTime.now(),
    );
  }
}

/// Relationships with key characters
class Relationships {
  int odinRelation; // Relationship with Odin (-100 to 100)
  int thorRelation; // Relationship with Thor (-100 to 100)
  int sifRelation; // Relationship with Sif (-100 to 100)

  Relationships({
    this.odinRelation = 20, // Starts with respect but distance
    this.thorRelation = -10, // Starts with suspicion
    this.sifRelation = 0, // Neutral
  });

  void updateRelationship(String character, int change) {
    switch (character.toLowerCase()) {
      case 'odin':
        odinRelation = (odinRelation + change).clamp(-100, 100);
        break;
      case 'thor':
        thorRelation = (thorRelation + change).clamp(-100, 100);
        break;
      case 'sif':
        sifRelation = (sifRelation + change).clamp(-100, 100);
        break;
    }
  }

  Relationships copy() {
    return Relationships(
      odinRelation: odinRelation,
      thorRelation: thorRelation,
      sifRelation: sifRelation,
    );
  }
}