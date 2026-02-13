# Guide de Migration - API UnearnedContent

## Vue d'Ensemble

Ce guide documente les changements d'API introduits par les optimisations Phase 1 et explique comment migrer le code existant.

---

## 📋 Changement Principal

### ❌ AVANT - Map avec String Keys (Non Type-Safe)

```dart
Future<Map<String, dynamic>> getUnearnedContent() async {
  // ...
  return {
    'unearned_collectible_cards': unearnedCollectibleCards,
    'unearned_myth_stories': unearnedMythStories,
  };
}

// Usage
final unearnedContent = await gamificationService.getUnearnedContent();
final cards = unearnedContent['unearned_collectible_cards'] as List<CollectibleCard>; // ❌ Risqué
final stories = unearnedContent['unearned_myth_stories'] as List<MythStory>; // ❌ Risqué
```

**Problèmes:**
- ❌ Pas de vérification à la compilation
- ❌ Risque de typo dans les clés
- ❌ Cast obligatoire à chaque usage
- ❌ Pas d'autocomplétion IDE

---

### ✅ APRÈS - Classe Typée (Type-Safe)

```dart
class UnearnedContent {
  final List<CollectibleCard> collectibleCards;
  final List<MythStory> mythStories;

  const UnearnedContent({
    required this.collectibleCards,
    required this.mythStories,
  });

  bool get isEmpty => collectibleCards.isEmpty && mythStories.isEmpty;
  bool get isNotEmpty => !isEmpty;
}

Future<UnearnedContent> getUnearnedContent() async {
  // ...
  return UnearnedContent(
    collectibleCards: unearnedCollectibleCards,
    mythStories: unearnedMythStories,
  );
}

// Usage
final unearnedContent = await gamificationService.getUnearnedContent();
final cards = unearnedContent.collectibleCards;   // ✅ Type-safe
final stories = unearnedContent.mythStories;      // ✅ Type-safe
```

**Avantages:**
- ✅ Type-safety complète
- ✅ Erreurs détectées à la compilation
- ✅ Autocomplétion IDE
- ✅ Propriétés utilitaires (`isEmpty`, `isNotEmpty`)

---

## 🔄 Migration des Fichiers

### Fichier 1: `shop_screen.dart` ✅ MIGRÉ

**Avant:**
```dart
final unearnedContent = await gamificationService.getUnearnedContent();
final availableCards =
    unearnedContent['unearned_collectible_cards'] as List<CollectibleCard>;
availableCards.sort((a, b) => a.price.compareTo(b.price));
final availableStories =
    unearnedContent['unearned_myth_stories'] as List<MythStory>;
```

**Après:**
```dart
final unearnedContent = await gamificationService.getUnearnedContent();
final availableCards = unearnedContent.collectibleCards;
availableCards.sort((a, b) => a.price.compareTo(b.price));
final availableStories = unearnedContent.mythStories;
```

**Changements:**
- `unearnedContent['unearned_collectible_cards']` → `unearnedContent.collectibleCards`
- `unearnedContent['unearned_myth_stories']` → `unearnedContent.mythStories`
- Suppression des casts `as List<...>`

---

### Fichier 2: `game_controller.dart` ✅ MIGRÉ

**Avant:**
```dart
if (_allChaptersEarned) {
  final unearnedContent = await _gamificationService.getUnearnedContent();
  final cards = (unearnedContent['unearned_collectible_cards'] as List)
      .cast<CollectibleCard>();
  if (cards.isNotEmpty) {
    _rewardCard = cards[Random().nextInt(cards.length)];
    // ...
  }
}
```

**Après:**
```dart
if (_allChaptersEarned) {
  final unearnedContent = await _gamificationService.getUnearnedContent();
  final cards = unearnedContent.collectibleCards;
  if (cards.isNotEmpty) {
    _rewardCard = cards[Random().nextInt(cards.length)];
    // ...
  }
}
```

**Changements:**
- `unearnedContent['unearned_collectible_cards']` → `unearnedContent.collectibleCards`
- Suppression de `.cast<CollectibleCard>()` (déjà typé)

---

## 🔍 Comment Trouver le Code à Migrer

### Commande de Recherche

```bash
# Chercher l'ancienne API dans tout le projet
grep -r "unearnedContent\[" lib/ --include="*.dart"
```

### Patterns à Chercher

1. **Access avec brackets:**
   ```dart
   unearnedContent['unearned_collectible_cards']  // ❌
   unearnedContent['unearned_myth_stories']       // ❌
   ```

2. **Casts explicites:**
   ```dart
   as List<CollectibleCard>  // ❌ Plus nécessaire
   as List<MythStory>        // ❌ Plus nécessaire
   .cast<CollectibleCard>()  // ❌ Plus nécessaire
   ```

---

## ✅ Checklist de Migration

Pour chaque fichier utilisant `getUnearnedContent()`:

- [ ] Remplacer `['unearned_collectible_cards']` par `.collectibleCards`
- [ ] Remplacer `['unearned_myth_stories']` par `.mythStories`
- [ ] Supprimer les casts `as List<...>`
- [ ] Supprimer les `.cast<...>()`
- [ ] Tester que le code compile
- [ ] Vérifier que la logique fonctionne toujours

---

## 🎯 Nouvelles Propriétés Utilitaires

La classe `UnearnedContent` fournit des propriétés helper :

```dart
final content = await gamificationService.getUnearnedContent();

// Vérifier s'il reste du contenu à débloquer
if (content.isEmpty) {
  print('Tout débloqué ! 🎉');
}

if (content.isNotEmpty) {
  print('Il reste ${content.collectibleCards.length} cartes');
  print('Il reste ${content.mythStories.length} histoires');
}
```

---

## 📊 Impact sur la Performance

### Aucun Impact Négatif
- Même logique sous-jacente
- Juste une couche de type-safety
- Compilation optimisée (pas de runtime overhead)

### Impact Positif
- Erreurs détectées plus tôt (compile-time vs runtime)
- Moins de bugs potentiels
- Code plus lisible

---

## 🧪 Tests

### Avant Migration
```dart
test('getUnearnedContent returns map with correct keys', () async {
  final content = await service.getUnearnedContent();
  expect(content, isA<Map<String, dynamic>>());
  expect(content.containsKey('unearned_collectible_cards'), true);
  expect(content.containsKey('unearned_myth_stories'), true);
});
```

### Après Migration
```dart
test('getUnearnedContent returns UnearnedContent', () async {
  final content = await service.getUnearnedContent();
  expect(content, isA<UnearnedContent>());
  expect(content.collectibleCards, isA<List<CollectibleCard>>());
  expect(content.mythStories, isA<List<MythStory>>());
});

test('isEmpty returns true when no content', () {
  final content = UnearnedContent(
    collectibleCards: [],
    mythStories: [],
  );
  expect(content.isEmpty, true);
  expect(content.isNotEmpty, false);
});
```

---

## 🔄 Migration Automatique (Script)

Si vous avez beaucoup de fichiers à migrer, voici un script bash :

```bash
#!/bin/bash

# Remplace l'ancienne API dans tous les fichiers .dart
find lib -name "*.dart" -type f -exec sed -i '' \
  -e "s/unearnedContent\['unearned_collectible_cards'\]/unearnedContent.collectibleCards/g" \
  -e "s/unearnedContent\[\"unearned_collectible_cards\"\]/unearnedContent.collectibleCards/g" \
  -e "s/unearnedContent\['unearned_myth_stories'\]/unearnedContent.mythStories/g" \
  -e "s/unearnedContent\[\"unearned_myth_stories\"\]/unearnedContent.mythStories/g" \
  {} +

echo "Migration automatique terminée !"
echo "Vérifiez les changements avec: git diff"
```

**⚠️ Attention:** Toujours vérifier les changements après migration automatique !

---

## 📝 Fichiers du Projet Migrés

### ✅ Complètement Migrés
1. `lib/services/gamification_service.dart` - Source du changement
2. `lib/screens/shop/shop_screen.dart` - Migré
3. `lib/screens/games/order_the_scrolls/game_controller.dart` - Migré

### ✅ Pas de Migration Nécessaire
- Tous les autres fichiers n'utilisaient pas cette API

---

## 🐛 Problèmes Courants et Solutions

### Erreur: "The operator '[]' isn't defined for the type 'UnearnedContent'"

**Cause:** Utilisation de l'ancienne API avec brackets

**Solution:**
```dart
// ❌ Ancien code
final cards = unearnedContent['unearned_collectible_cards'];

// ✅ Nouveau code
final cards = unearnedContent.collectibleCards;
```

---

### Erreur: "Type cast failed"

**Cause:** Cast inutile après migration

**Solution:**
```dart
// ❌ Cast inutile
final cards = unearnedContent.collectibleCards as List<CollectibleCard>;

// ✅ Pas besoin de cast
final cards = unearnedContent.collectibleCards;
```

---

### Warning: "Unnecessary cast"

**Cause:** `.cast<>()` inutile

**Solution:**
```dart
// ❌ Cast inutile
final cards = unearnedContent.collectibleCards.cast<CollectibleCard>();

// ✅ Déjà typé correctement
final cards = unearnedContent.collectibleCards;
```

---

## 📚 Ressources

### Fichiers Créés
- `lib/models/unearned_content.dart` - Définition de la classe
- `.claude/PERFORMANCE_OPTIMIZATIONS.md` - Documentation complète

### Documentation Dart
- [Value Objects in Dart](https://dart.dev/guides/language/language-tour#classes)
- [Type Safety](https://dart.dev/guides/language/type-system)

---

## ✅ Vérification Post-Migration

### 1. Compilation
```bash
flutter analyze
```
**Attendu:** Aucune erreur liée à `UnearnedContent`

### 2. Tests
```bash
flutter test
```
**Attendu:** Tous les tests passent

### 3. Runtime
- Lancer l'app
- Tester la boutique (shop_screen)
- Tester le jeu "Order the Scrolls"
- Vérifier qu'aucune erreur runtime

---

## 🎊 Conclusion

La migration vers `UnearnedContent` typé améliore:

1. ✅ **Type Safety** - Erreurs détectées à la compilation
2. ✅ **Developer Experience** - Autocomplétion, documentation inline
3. ✅ **Maintenabilité** - Code plus clair et self-documenting
4. ✅ **Refactoring** - Changements détectés automatiquement par IDE
5. ✅ **Performance** - Aucun impact négatif, bénéfices à la compilation

**La migration est simple, rapide, et apporte beaucoup de valeur !** 🚀

---

**Date:** 2026-02-13
**Version:** 1.0
**Statut:** ✅ MIGRATION COMPLETE
