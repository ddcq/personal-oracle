# Analyse de Refactoring - Fichiers Dart > 700 lignes

## Résumé

3 fichiers identifiés dépassant 700 lignes :
1. **game_logic.dart** (948 lignes) - Logique du jeu Snake
2. **main_screen.dart** (845 lignes) - Écran principal du jeu Asgard Wall
3. **snake_flame_game.dart** (702 lignes) - Moteur Flame du jeu Snake

---

## 1. lib/screens/games/snake/game_logic.dart (948 lignes)

### Responsabilités actuelles
- Définition des enums (FoodType, BonusType)
- Classes de données (Bonus, ActiveBonusEffect, GameState)
- Logique complète du jeu Snake

### Composants à extraire

#### A. Modèles/Enums (Nouveau fichier: `snake_models.dart`)
```dart
// Lignes 13-14: Enums
enum FoodType { regular, golden, rotten }
enum BonusType { speed, shield, freeze, ghost, coin }

// Lignes 20-30: Classe Bonus
class Bonus { ... }

// Lignes 32-41: Classe ActiveBonusEffect
class ActiveBonusEffect { ... }
```
**Impact**: ~40 lignes → fichier séparé

#### B. GameState (Nouveau fichier: `snake_game_state.dart`)
```dart
// Lignes 47-303: Classe GameState complète
class GameState { ... }
```
**Impact**: ~256 lignes → fichier séparé
**Bénéfices**:
- État du jeu isolé
- Réutilisable pour tests unitaires
- Factory methods séparés du business logic

#### C. Utilitaires de Collision (Nouveau fichier: `collision_utils.dart`)
```dart
// Lignes 476-516: _isCollision
// Lignes 227-275: _calculateStraightDistanceWithObstacles
```
**Impact**: ~60 lignes → fichier utilitaire
**Bénéfices**: Réutilisable, testable indépendamment

#### D. Gestionnaire de Génération (Nouveau fichier: `spawn_manager.dart`)
```dart
// Lignes 617-648: generateNewFood
// Lignes 650-685: spawnBonus
// Lignes 787-848: generateObstacles
// Lignes 876-947: _generateValidPositionFor2x2
```
**Impact**: ~150 lignes → fichier séparé
**Bénéfices**: Logique de spawn centralisée

### Après refactoring
- **game_logic.dart**: ~440 lignes (GameLogic pure)
- **snake_models.dart**: ~40 lignes
- **snake_game_state.dart**: ~260 lignes
- **collision_utils.dart**: ~60 lignes
- **spawn_manager.dart**: ~150 lignes

### Redondances identifiées
1. **Vérification de 2x2 blocks**: Répété dans plusieurs méthodes
   - Lignes 159-170 (GameState.initial)
   - Lignes 502-507 (_isCollision)
   - Lignes 911-920 (_generateValidPositionFor2x2)
   → Créer une méthode utilitaire `isBlock2x2Free(position, occupiedCells)`

2. **Conversion direction → offset**
   - Lignes 199-214 (_getPreviousPosition)
   - Lignes 237-251 (_calculateStraightDistanceWithObstacles)
   - Lignes 457-471 (_getNewHeadPosition)
   → Créer `static Map<Direction, IntVector2> directionOffsets`

---

## 2. lib/screens/games/asgard_wall/main_screen.dart (845 lignes)

### Responsabilités actuelles
- État du jeu (GameScreen widget)
- Logique métier (placement, collision, victoire)
- Rendu UI (board, controls, dialogs)
- Gestion des événements (clavier, gestes)

### Composants à extraire

#### A. Modèles (Nouveau fichier: `wall_game_models.dart`)
```dart
// Lignes 29-37: PlacedPiece
class PlacedPiece { ... }

// Lignes 39-52: _Segment
class _Segment { ... }
```
**Impact**: ~25 lignes → fichier séparé

#### B. Logique métier (Nouveau fichier: `wall_game_logic.dart`)
```dart
// Extraire méthodes de logique pure:
- canPlacePiece (lignes 178-197)
- placePiece (lignes 235-265)
- checkVictoryCondition (lignes 295-343)
- _checkInaccessibleHoles (lignes 301-333)
- _checkWallComplete (lignes 335-343)
- _updateContour (lignes 199-232)
```
**Impact**: ~150 lignes → classe WallGameLogic
**Bénéfices**: Logique testable sans UI

#### C. Gestionnaire de pièces (Nouveau fichier: `piece_manager.dart`)
```dart
// Extraire:
- generateNextPieces (lignes 137-146)
- spawnNewPiece (lignes 149-175)
- rotatePiece (lignes 377-422)
```
**Impact**: ~90 lignes → classe PieceManager

#### D. Widget Board séparé (Nouveau fichier: `game_board_widget.dart`)
```dart
// Lignes 615-700: buildBoard et _buildCell
class GameBoardWidget extends StatelessWidget { ... }

// Lignes 819-845: _ContourPainter
class ContourPainter extends CustomPainter { ... }
```
**Impact**: ~110 lignes → widget réutilisable

#### E. Gestionnaire d'événements (Nouveau fichier: `input_handler.dart`)
```dart
// Lignes 425-458: handleKeyPress
// Lignes 359-374: movePieceLeft/Right
// Lignes 347-356: movePieceDown
// Lignes 461-470: dropPiece
```
**Impact**: ~70 lignes → classe InputHandler

### Après refactoring
- **main_screen.dart**: ~400 lignes (UI principale + orchestration)
- **wall_game_models.dart**: ~25 lignes
- **wall_game_logic.dart**: ~150 lignes
- **piece_manager.dart**: ~90 lignes
- **game_board_widget.dart**: ~110 lignes
- **input_handler.dart**: ~70 lignes

### Redondances identifiées
1. **Vérifications de collision répétées**
   - Dans canPlacePiece (lignes 186-192)
   - Dans _checkInaccessibleHoles (lignes 319-327)
   → Centraliser dans une méthode `isCellOccupied(x, y)`

2. **Gestion des timers dupliquée**
   - gameTimer (lignes 120-126)
   - effectTimer (lignes 128-133)
   → Créer classe `GameTimerManager`

3. **Logique de dialogue Win/Loss similaire**
   - _showWinDialog (lignes 491-558)
   - _showLossDialog (lignes 560-604)
   → Créer widget générique `GameEndDialog`

---

## 3. lib/screens/games/snake/snake_flame_game.dart (702 lignes)

### Responsabilités actuelles
- Initialisation du moteur Flame
- Gestion des sprites et animations
- Boucle de jeu (update/tick)
- Gestion des événements clavier
- Effets visuels (explosion, shake)

### Composants à extraire

#### A. Configuration (Nouveau fichier: `snake_game_config.dart`)
```dart
// Lignes 47-58: Constantes de configuration
class SnakeGameConfig {
  static const double shakeIntensity = 10.0;
  static const int shakeDurationMs = 200;
  static const int gameSpeedInitial = 200;
  static const double growthAnimationPeriod = 0.15;
  static const double foodRottingTimeBase = 12.0;
  // ... etc
}
```
**Impact**: ~30 lignes → fichier config

#### B. Gestionnaire de Sprites (Nouveau fichier: `sprite_manager.dart`)
```dart
// Extraire logique de chargement:
- loadSprite calls (lignes 179-189)
- _getFoodSprite (lignes 655-663)
```
**Impact**: ~40 lignes → classe SpriteManager
**Bénéfices**: Chargement centralisé, cache possible

#### C. Calculateur de vitesse (Nouveau fichier: `speed_calculator.dart`)
```dart
// Lignes 365-385: _calculateGameSpeed
class SpeedCalculator {
  static double calculate(int score) { ... }
}
```
**Impact**: ~20 lignes → utilitaire réutilisable

#### D. Gestionnaire d'effets (Nouveau fichier: `effects_manager.dart`)
```dart
// Lignes 552-625: _triggerRockExplosion
// Lignes 80-99: shakeScreen
class EffectsManager {
  void triggerExplosion(...) { ... }
  void shakeCamera(...) { ... }
}
```
**Impact**: ~90 lignes → classe dédiée

#### E. Processeur d'état (Nouveau fichier: `game_state_processor.dart`)
```dart
// Lignes 387-465: _processGameUpdate
// Lignes 467-482: _processGameOver
class GameStateProcessor {
  void processUpdate(...) { ... }
  void processGameOver(...) { ... }
}
```
**Impact**: ~95 lignes → logique métier séparée

### Après refactoring
- **snake_flame_game.dart**: ~430 lignes (orchestration Flame)
- **snake_game_config.dart**: ~30 lignes
- **sprite_manager.dart**: ~40 lignes
- **speed_calculator.dart**: ~20 lignes
- **effects_manager.dart**: ~90 lignes
- **game_state_processor.dart**: ~95 lignes

### Redondances identifiées
1. **Vérifications répétées de l'état du jeu**
   ```dart
   if (!gameState.value.isGameRunning || gameState.value.isGameOver)
   ```
   Apparaît lignes 271, 506, 632
   → Créer propriété computed `get isGameActive`

2. **Conversions position répétées**
   ```dart
   .toVector2() * cellSize
   ```
   Apparaît 10+ fois
   → Créer méthode extension `IntVector2.toGamePosition(cellSize)`

3. **Gestion de vibration dupliquée**
   - Lignes 419-433 (regular/golden food)
   - Lignes 435-440 (rotten food)
   - Lignes 471-473 (game over)
   → Créer classe `VibrationManager` avec patterns prédéfinis

---

## Optimisations globales recommandées

### 1. Extraction de constantes magiques
- **Snake**: Scores (10, 50, etc.) → SnakeScoring class
- **Wall**: Dimensions (11, 22, 12) → WallDimensions class

### 2. Pattern Strategy pour les bonus
```dart
abstract class BonusEffect {
  void apply(GameState state);
  void remove(GameState state);
}

class SpeedBonus implements BonusEffect { ... }
class ShieldBonus implements BonusEffect { ... }
```
**Bénéfice**: Facilite l'ajout de nouveaux bonus

### 3. Utilisation d'EventBus
Pour les événements (onRottenFoodEaten, onConfettiTrigger, etc.)
- Découplage UI ↔ logique
- Plus facile à tester

### 4. Injection de dépendances
Les services (SoundService, GamificationService) sont accédés via `getIt`
→ Passer en paramètres de constructeur pour meilleure testabilité

### 5. Tests unitaires facilitées
Après refactoring:
- Logique pure testable sans UI
- Mocks/stubs simplifiés
- Coverage amélioré

---

## Plan d'implémentation suggéré

### Phase 1 - Extraction des modèles (1-2h)
- Créer les fichiers `*_models.dart`
- Migrer les classes de données
- Mettre à jour les imports

### Phase 2 - Extraction de la logique métier (3-4h)
- Créer les classes `*Logic` et `*Manager`
- Migrer les méthodes pures
- Ajouter tests unitaires basiques

### Phase 3 - Extraction des widgets (2-3h)
- Séparer les widgets UI réutilisables
- Optimiser le rebuild (const, keys)

### Phase 4 - Optimisations (2-3h)
- Éliminer les redondances
- Implémenter les patterns suggérés
- Refactoring final

### Phase 5 - Tests et validation (2h)
- Tests unitaires complets
- Tests d'intégration
- Validation performances

**Total estimé**: 10-14 heures de développement

---

## Métriques avant/après

| Fichier | Lignes avant | Lignes après | Fichiers créés | Gain |
|---------|--------------|--------------|----------------|------|
| game_logic.dart | 948 | 440 | 4 | -54% |
| main_screen.dart | 845 | 400 | 5 | -53% |
| snake_flame_game.dart | 702 | 430 | 5 | -39% |
| **Total** | **2495** | **1270** | **14** | **-49%** |

## Bénéfices attendus

✅ **Maintenabilité**: Fichiers < 500 lignes, responsabilité unique  
✅ **Testabilité**: Logique métier isolée, injection de dépendances  
✅ **Réutilisabilité**: Composants génériques extraits  
✅ **Lisibilité**: Structure claire, navigation facilitée  
✅ **Performance**: Moins de rebuilds inutiles, optimisations ciblées  
✅ **Évolutivité**: Ajout de features simplifié (nouveaux bonus, niveaux, etc.)
