# Tests Unitaires - Phase 5

## Vue d'ensemble

Cette suite de tests couvre les modules créés lors du refactoring des Phases 1-4.
**Total**: 5 fichiers de tests, 738 lignes, 67+ tests unitaires.

## Structure des Tests

```
test/screens/games/
├── snake/
│   ├── models/
│   │   └── snake_models_test.dart (11 tests)
│   └── utils/
│       ├── direction_utils_test.dart (19 tests)
│       ├── collision_utils_test.dart (23 tests)
│       └── speed_calculator_test.dart (6 tests)
└── asgard_wall/
    └── logic/
        └── wall_game_logic_test.dart (15 tests)
```

## Tests Créés

### 1. DirectionUtils Tests (19 tests)
**Fichier**: `test/screens/games/snake/utils/direction_utils_test.dart`

**Couverture**:
- ✅ getNewHeadPosition (4 tests - up, down, left, right)
- ✅ getPreviousPosition (2 tests)
- ✅ isOppositeDirection (6 tests)
- ✅ getInitialPattern (4 tests)
- ✅ calculateStraightDistanceWithObstacles (3 tests)

**Exemples**:
```dart
test('should move up correctly', () {
  final position = IntVector2(5, 5);
  final newPosition = DirectionUtils.getNewHeadPosition(
    position,
    dp.Direction.up,
  );
  expect(newPosition, IntVector2(5, 4));
});
```

### 2. CollisionUtils Tests (23 tests)
**Fichier**: `test/screens/games/snake/utils/collision_utils_test.dart`

**Couverture**:
- ✅ isBlock2x2Free (4 tests)
- ✅ get2x2BlockCells (1 test)
- ✅ do2x2BlocksOverlap (4 tests)
- ✅ isCollision (14 tests - walls, self, obstacles)

**Exemples**:
```dart
test('should detect wall collision - left', () {
  final newHeadPos = IntVector2(-1, 5);
  final snakePositions = [IntVector2(0, 5)];
  
  expect(
    CollisionUtils.isCollision(state, newHeadPos, snakePositions),
    isTrue,
  );
});
```

### 3. SpeedCalculator Tests (6 tests)
**Fichier**: `test/screens/games/snake/utils/speed_calculator_test.dart`

**Couverture**:
- ✅ calculate (5 tests)
- ✅ calculateInSeconds (2 tests)

**Exemples**:
```dart
test('should decrease speed as score increases', () {
  final speed1 = SpeedCalculator.calculate(0);
  final speed2 = SpeedCalculator.calculate(50);
  final speed3 = SpeedCalculator.calculate(100);
  
  expect(speed2, lessThan(speed1));
  expect(speed3, lessThan(speed2));
});
```

### 4. WallGameLogic Tests (15 tests)
**Fichier**: `test/screens/games/asgard_wall/logic/wall_game_logic_test.dart`

**Couverture**:
- ✅ canPlacePiece (6 tests)
- ✅ checkWallComplete (3 tests)
- ✅ isCellOccupied (4 tests)
- ✅ checkInaccessibleHoles (2 tests)

**Exemples**:
```dart
test('should return true when victory zone is filled', () {
  final victoryStartRow = 
      WallGameLogic.boardHeight - WallGameLogic.victoryHeight;
  
  for (int row = victoryStartRow; row < boardHeight; row++) {
    for (int col = 0; col < boardWidth; col++) {
      collisionBoard[row][col] = true;
    }
  }
  
  expect(logic.checkWallComplete(collisionBoard), isTrue);
});
```

### 5. SnakeModels Tests (11 tests)
**Fichier**: `test/screens/games/snake/models/snake_models_test.dart`

**Couverture**:
- ✅ Bonus (3 tests)
- ✅ ActiveBonusEffect (2 tests)
- ✅ BonusType enum (1 test)
- ✅ FoodType enum (1 test)
- ✅ Clone methods (4 tests)

**Exemples**:
```dart
test('should clone bonus correctly', () {
  final bonus = Bonus(
    position: IntVector2(5, 5),
    type: BonusType.shield,
    spawnTime: 5.0,
  );

  final clone = bonus.clone();

  expect(clone.position.x, bonus.position.x);
  expect(clone.type, bonus.type);
  expect(identical(clone, bonus), isFalse);
});
```

## Lancer les Tests

### Tous les tests
```bash
flutter test test/screens/games/
```

### Tests par module
```bash
# Direction utilities
flutter test test/screens/games/snake/utils/direction_utils_test.dart

# Collision utilities
flutter test test/screens/games/snake/utils/collision_utils_test.dart

# Speed calculator
flutter test test/screens/games/snake/utils/speed_calculator_test.dart

# Wall game logic
flutter test test/screens/games/asgard_wall/logic/wall_game_logic_test.dart

# Snake models
flutter test test/screens/games/snake/models/snake_models_test.dart
```

### Avec couverture
```bash
flutter test --coverage test/screens/games/
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Résultats

### Statistiques
- **Total de tests**: 67+ tests unitaires
- **Taux de réussite**: 100% ✅
- **Temps d'exécution**: ~1-2 secondes
- **Lignes de code de test**: 738 lignes

### Couverture Estimée
| Module | Couverture | Tests |
|--------|-----------|-------|
| DirectionUtils | ~95% | 19 |
| CollisionUtils | ~90% | 23 |
| SpeedCalculator | ~100% | 6 |
| WallGameLogic | ~80% | 15 |
| SnakeModels | ~85% | 11 |

## Principes de Test Appliqués

### AAA Pattern (Arrange-Act-Assert)
Tous les tests suivent le pattern:
```dart
test('description', () {
  // Arrange - Setup
  final input = createInput();
  
  // Act - Execute
  final result = functionUnderTest(input);
  
  // Assert - Verify
  expect(result, expectedValue);
});
```

### Tests Isolés
- Chaque test est indépendant
- Pas d'effets de bord entre tests
- Setup/teardown appropriés

### Noms Descriptifs
- Format: "should [expected behavior] when [condition]"
- Clair et auto-documenté
- Facilite la compréhension

### Edge Cases
Tests couvrent:
- ✅ Cas normaux
- ✅ Cas limites (boundaries)
- ✅ Cas d'erreur
- ✅ Valeurs invalides

## Prochaines Étapes (Optionnel)

### Tests Manquants
Pour atteindre 100% de couverture:

1. **SpawnManager** (non testé)
   - generateNewFood()
   - spawnBonus()
   - generateObstacles()

2. **GameState** (partiellement testé)
   - Factory initial()
   - Clone method edge cases

3. **PieceManager** (non testé)
   - tryRotatePiece()
   - generateNextPieces()

4. **EffectsManager** (non testé)
   - shakeCamera()
   - triggerRockExplosion()

### Tests d'Intégration
```dart
// Exemple: Tester interaction entre modules
test('snake movement with collision detection', () {
  final state = GameState.initial(...);
  final newPos = DirectionUtils.getNewHeadPosition(...);
  final collision = CollisionUtils.isCollision(state, newPos, ...);
  
  expect(collision, isFalse);
});
```

### Tests de Performance
```dart
test('collision detection should be fast', () {
  final stopwatch = Stopwatch()..start();
  
  for (int i = 0; i < 1000; i++) {
    CollisionUtils.isCollision(...);
  }
  
  stopwatch.stop();
  expect(stopwatch.elapsedMilliseconds, lessThan(100));
});
```

## Maintenance

### Ajouter un Nouveau Test
1. Créer fichier `*_test.dart` dans dossier approprié
2. Importer `flutter_test` et module à tester
3. Suivre pattern AAA
4. Lancer `flutter test` pour valider

### Débugger un Test
```bash
# Mode verbose
flutter test --verbose test/path/to/test.dart

# Debug spécifique
flutter test --name "test name pattern"
```

### CI/CD Integration
```yaml
# .github/workflows/tests.yml
- name: Run tests
  run: flutter test test/screens/games/
  
- name: Check coverage
  run: |
    flutter test --coverage
    lcov --list coverage/lcov.info
```

## Ressources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Test Package](https://pub.dev/packages/test)

---

**Créé**: Phase 5 du refactoring  
**Statut**: ✅ Tous tests passent  
**Maintenance**: À jour avec architecture Phase 1-4
