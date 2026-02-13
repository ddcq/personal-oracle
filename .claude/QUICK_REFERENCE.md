# 🚀 Quick Reference - Optimisations

Guide de référence rapide pour les développeurs utilisant le code optimisé.

---

## 📦 GamificationService - Nouvelles APIs

### ✅ UnearnedContent (Type-Safe)

```dart
// Ancien code ❌
final content = await gamificationService.getUnearnedContent();
final cards = content['unearned_collectible_cards'] as List<CollectibleCard>;

// Nouveau code ✅
final content = await gamificationService.getUnearnedContent();
final cards = content.collectibleCards;  // Type-safe !

// Helpers disponibles
if (content.isEmpty) { /* Tout débloqué */ }
if (content.isNotEmpty) { /* Reste du contenu */ }
```

### ⚙️ Configuration des Récompenses

```dart
// Ne plus hardcoder les valeurs !
// Utiliser GameRewardConfig

// Récompenses
GameRewardConfig.baseGameReward         // 50
GameRewardConfig.bonusPerLevel          // 10

// Snake
GameRewardConfig.snakeScoreDivisor      // 20
GameRewardConfig.snakeCoinMultiplier    // 10

// Asgard Wall
GameRewardConfig.asgardWallMinScore     // 100
GameRewardConfig.asgardWallScoreDivisor // 20
GameRewardConfig.asgardWallCoinMultiplier // 10

// Cache
GameRewardConfig.settingsCacheDuration  // 30 secondes
GameRewardConfig.progressCacheDuration  // 10 secondes
```

### 🎯 Calculs Simplifiés

```dart
// Plus besoin d'await ! Méthode synchrone
final reward = gamificationService.calculateGameReward(level: 5);
final snakeCoins = gamificationService.calculateSnakeGameCoins(score);
final wallCoins = gamificationService.calculateAsgardWallCoins(score);
```

---

## 🎵 SoundService - Nouvelles APIs

### ⚙️ Configuration Audio

```dart
// URLs et paths
AudioConfig.baseUrl                 // 'https://ddcq.github.io'
AudioConfig.musicPath               // '/music'
AudioConfig.ambientMusicFile        // 'ambiance.mp3'
AudioConfig.readingMusicFile        // 'reading.mp3'

// Helpers
AudioConfig.getMusicUrl('song.mp3')        // URL complète
AudioConfig.getCardMusicUrl('thor')        // URL pour carte
AudioConfig.getMusicPath('song.mp3')       // Path pour cache

// Volumes
AudioConfig.fullVolume              // 1.0
AudioConfig.storyVolume             // 0.5

// Timeouts & Limits
AudioConfig.loadTimeout             // 10 secondes
AudioConfig.maxConcurrentSoundEffects // 10
```

### 🎮 État de la Musique

```dart
final soundService = getIt<SoundService>();

// Getters d'état
soundService.isMuted                    // bool
soundService.isFxMuted                  // bool
soundService.isReadingPageMusicMuted    // bool
soundService.currentCardId              // String?
soundService.readingPageMusicCardId     // String?
soundService.currentAmbientMusicCardId  // String?
```

### 🎵 Contrôle Musique

```dart
// Jouer musiques
await soundService.playMainMenuMusic();
await soundService.playStoryMusic();
await soundService.playCardMusic('thor');
await soundService.playCardMusic('odin', asAmbient: true);

// Contrôles
soundService.pauseMusic();
await soundService.resumeMusic();
await soundService.resumePreviousMusic();

// Configuration
soundService.setMuted(true);
soundService.setFxMuted(true);
soundService.setAmbientMusicByCardId('loki');
soundService.setReadingPageMusic('mute');
soundService.setReadingPageMusicByCardId('freya');

// Sound effects (avec pool automatique)
await soundService.playSoundEffect('sounds/click.mp3');
```

---

## 💾 Storage System

### 📝 Storage Adapter (Abstraction)

```dart
// Utilisé en interne, pas besoin d'appeler directement
// Mais si vous avez besoin:

final storage = StorageFactory.getAdapter();

// Settings
await storage.saveSetting('key', 'value');
final value = await storage.getSetting('key');
await storage.deleteSetting('key');

// Game scores
await storage.saveGameScore(
  gameName: 'snake',
  score: 100,
  timestamp: DateTime.now().millisecondsSinceEpoch,
);
final scores = await storage.getGameScores('snake');

// Collectible cards
await storage.saveCollectibleCard(
  cardId: 'thor',
  version: 'epic',
  timestamp: DateTime.now().millisecondsSinceEpoch,
);
final isUnlocked = await storage.isCollectibleCardUnlocked('thor', 'epic');

// Story progress
await storage.saveStoryProgress(
  storyId: 'ragnarok',
  partsUnlocked: ['part1', 'part2'],
  timestamp: DateTime.now().millisecondsSinceEpoch,
);
final progress = await storage.getStoryProgress('ragnarok');
```

---

## 🎯 Patterns Courants

### Pattern 1: Vérifier et Débloquer Contenu

```dart
// Vérifier si carte débloquée
final isUnlocked = await gamificationService.isCollectibleCardUnlocked(
  'thor',
  CardVersion.epic,
);

if (!isUnlocked) {
  // Débloquer
  await gamificationService.unlockCollectibleCard(thorCard);

  // Ajouter récompense
  await gamificationService.addCoins(100);
}
```

### Pattern 2: Jouer Musique avec Fallback

```dart
// Essayer de jouer musique spécifique, fallback sur défaut
try {
  await soundService.playCardMusic('thor');
} catch (e) {
  await soundService.playMainMenuMusic();
}
```

### Pattern 3: Obtenir Contenu Non-Gagné

```dart
final content = await gamificationService.getUnearnedContent();

// Vérifier s'il reste quelque chose
if (content.isEmpty) {
  print('🎉 Tout débloqué !');
  return;
}

// Choisir aléatoirement
if (content.collectibleCards.isNotEmpty) {
  final random = Random();
  final card = content.collectibleCards[
    random.nextInt(content.collectibleCards.length)
  ];
  await gamificationService.unlockCollectibleCard(card);
}
```

### Pattern 4: Calculer Récompenses

```dart
// Récompense de base avec bonus de niveau
final reward = gamificationService.calculateGameReward(level: playerLevel);

// Pièces Snake basées sur score
final coins = gamificationService.calculateSnakeGameCoins(finalScore);

// Ajouter au total
await gamificationService.addCoins(coins);
```

---

## 🐛 Résolution de Problèmes

### Erreur: "The operator '[]' isn't defined"

```dart
// ❌ Ancien code
final cards = content['unearned_collectible_cards'];

// ✅ Nouveau code
final cards = content.collectibleCards;
```

### Erreur: "calculateGameReward returns Future<int>"

```dart
// ❌ Ancien code
final reward = await gamificationService.calculateGameReward();

// ✅ Nouveau code (pas d'await, c'est synchrone maintenant)
final reward = gamificationService.calculateGameReward();
```

### Warning: "Unnecessary cast"

```dart
// ❌ Cast inutile
final cards = content.collectibleCards as List<CollectibleCard>;

// ✅ Déjà typé
final cards = content.collectibleCards;
```

---

## 📊 Cache - Timing & Invalidation

### Durée de Cache

```dart
// Settings (coins, difficultés, profil)
// TTL: 30 secondes
// Invalidé: sur mutation

// Progress (cartes, histoires)
// TTL: 10 secondes
// Invalidé: sur déblocage
```

### Quand le Cache est Invalidé

Le cache est automatiquement invalidé lors de:
- `saveGameScore()` - Peut affecter progression
- `unlockCollectibleCard()` - Change contenu disponible
- `unlockStoryPart()` / `unlockStory()` - Change progression
- Toutes les méthodes `save*()` - Invalide cache settings

**Vous n'avez rien à faire !** Le cache se gère automatiquement. ✨

---

## 🎓 Best Practices

### ✅ DO

```dart
// Utiliser les configs centralisées
final url = AudioConfig.getMusicUrl('song.mp3');
final reward = GameRewardConfig.baseGameReward;

// Utiliser l'API type-safe
final content = await gamificationService.getUnearnedContent();
final cards = content.collectibleCards;

// Faire confiance au cache
// Pas besoin de cacher manuellement, c'est géré !
final coins = await gamificationService.getCoins();
```

### ❌ DON'T

```dart
// Ne pas hardcoder les valeurs
const baseReward = 50;  // ❌ Utiliser GameRewardConfig

// Ne pas utiliser l'ancienne API
content['unearned_collectible_cards']  // ❌ Utiliser .collectibleCards

// Ne pas bypasser le cache
// Le cache est là pour optimiser, utilisez-le !

// Ne pas créer des AudioPlayers manuellement pour FX
// Utiliser soundService.playSoundEffect() qui gère le pool
```

---

## 🔗 Liens Utiles

### Documentation Détaillée
- `STORAGE_ADAPTER_REFACTORING.md` - Pattern Storage
- `PERFORMANCE_OPTIMIZATIONS.md` - Cache et algos
- `SOUNDSERVICE_REFACTORING.md` - Architecture audio
- `MIGRATION_GUIDE.md` - Guide migration API
- `OPTIMIZATIONS_SUMMARY.md` - Vue d'ensemble

### Fichiers Clés
```
lib/services/
├── gamification_service.dart       - Service principal
├── sound_service.dart              - Gestion audio
├── game_reward_config.dart         - Config récompenses
├── storage/
│   ├── storage_adapter.dart
│   ├── web_storage_adapter.dart
│   └── database_storage_adapter.dart
└── audio/
    ├── audio_config.dart
    ├── audio_loader.dart
    └── music_state.dart

lib/models/
└── unearned_content.dart           - Classe type-safe
```

---

## 🆘 Besoin d'Aide ?

### Questions Fréquentes

**Q: Le cache ralentit-il l'app ?**
A: Non ! Le cache accélère 80-95% des opérations. TTL court (10-30s).

**Q: Dois-je invalider le cache manuellement ?**
A: Non ! C'est automatique lors des mutations.

**Q: Puis-je désactiver le cache ?**
A: Oui, mais pourquoi ? Modifier `GameRewardConfig.*CacheDuration` si besoin.

**Q: L'ancienne API fonctionne-t-elle toujours ?**
A: Non, migrée vers UnearnedContent type-safe. Voir MIGRATION_GUIDE.md

**Q: Comment ajouter une nouvelle musique ?**
A: Juste appeler `soundService.playCardMusic('new_song')` - tout est automatique !

---

## ⚡ Tips de Performance

### 1. Lectures Répétées
```dart
// ✅ Bon - le cache gère automatiquement
for (int i = 0; i < 10; i++) {
  final coins = await getCoins();  // Cache hit après la 1ère
}

// ❌ Mauvais - bypasser le service
// Ne pas accéder directement au storage !
```

### 2. Batch Checks
```dart
// ✅ Bon - obtenir tout le contenu une fois
final content = await getUnearnedContent();
for (var card in allCards) {
  if (content.collectibleCards.contains(card)) {
    // ...
  }
}

// ❌ Mauvais - check individuel
for (var card in allCards) {
  if (await isCardUnlocked(card.id, card.version)) {  // Trop d'appels
    // ...
  }
}
```

### 3. Sound Effects Pool
```dart
// ✅ Bon - utiliser le service (pool automatique)
await soundService.playSoundEffect('click.mp3');

// ❌ Mauvais - créer manuellement
final player = AudioPlayer();  // Fuite mémoire potentielle
await player.play(AssetSource('click.mp3'));
```

---

**Dernière mise à jour:** 2026-02-13
**Version:** 1.0
**Statut:** ✅ RÉFÉRENCE COMPLÈTE
