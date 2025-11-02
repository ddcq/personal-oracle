# Changelog depuis v1.0.0+10 jusqu'à v1.0.0+17

**Date:** 2024-11-01  
**Commits:** 30 commits  
**Fichiers modifiés:** 150 fichiers  
**Insertions:** +3999 lignes  
**Suppressions:** -1758 lignes

---

## 🆕 Nouvelles Fonctionnalités

### Jeu Puzzle - Système de Niveaux (v1.0.0+17)
- **Difficulté progressive** : 
  - Niveau 1 : 3×3
  - Niveau 2 : 4×4  
  - Niveaux 3-6 : 5×5
  - Niveaux 7-9 : 6×6
  - Niveau 10+ : 7×7
- **Sélection de chapitres d'histoires** comme récompense (7% par niveau, plafonné à 70%)
- **Marges de sécurité** : Zone d'apparition des pièces limitée (10% haut/bas + hauteur pièce)
- **Affichage du niveau** dans la barre de titre

### Internationalisation (i18n)
- **Support bilingue** : Français et Anglais
- **Package easy_localization** intégré
- **Fichiers de traduction** : fr-FR.json, en-US.json
- **Nouvelles histoires traduites** : 6+ histoires de mythologie nordique
- **Sélecteur de langue** dans l'écran de profil

### Notifications d'Inactivité
- **Système de rappels** après 1, 3 et 7 jours d'inactivité
- **Package flutter_local_notifications**
- **Gestion du timezone** pour les notifications planifiées

### Écran À Propos
- **Informations sur l'application**
- **Crédits et mentions légales**
- **Navigation améliorée** avec go_router

### Outils de Développement (DevTools)
- **Widget DevTools** accessible via tap répété sur l'icône profil
- **Déverrouillage rapide** de toutes les cartes/histoires
- **Réinitialisation** des niveaux de difficulté
- **Mode debug** pour tests

### Profil Utilisateur Amélioré
- **Sélection de divinité** avec vidéos et images
- **Affichage des cartes** à collectionner avec animations
- **Lecture des histoires** débloquées
- **Boutons de récompense publicitaire** pour débloquer contenu

---

## 🐛 Corrections de Bugs Majeurs

### Cohérence story.id vs story.title
**Problème** : Les chapitres d'histoires utilisaient `story.title` comme clé dans certains fichiers et `story.id` dans d'autres, causant des incohérences de sauvegarde.

**Fichiers corrigés** :
- `game_utils.dart` : selectNextChapterToWin
- `myth_story_page.dart` : getStoryProgress et unlockStoryPart
- `word_search_controller.dart` : unlockStoryPart  
- `order_the_scrolls/game_controller.dart` : getStoryProgress et unlockStoryPart (2 occurrences)

**Impact** : Les chapitres débloqués apparaissent maintenant correctement comme débloqués.

### Quiz - Clés Dupliquées
**Problème** : `ValueKey(currentQuestion)` utilisée pour plusieurs widgets, causant l'erreur "Duplicate keys found".

**Solution** : Clés uniques pour chaque widget animé :
- `progress_$currentQuestion` pour ProgressBar
- `question_$currentQuestion` pour Container question (paysage)
- `question_portrait_$currentQuestion` pour Container question (portrait)

### Puzzle - Chemin Images Histoires
**Problème** : Images de chapitres introuvables (`Unable to load asset: creation_1.webp`).

**Solution** : Ajout du préfixe `stories/` aux chemins d'images de chapitres.

### Initialisation Application
- **Meilleure gestion des erreurs** au démarrage
- **Chargement asynchrone** optimisé
- **Écrans de fallback** en cas d'erreur

---

## 🎮 Améliorations des Jeux

### Jeu Snake
- **Remplacement de GestureDetector** par SimpleGestureDetector
- **Sensibilité swipe améliorée** : seuils à 20px (au lieu de 50px)
- **Mode de détection** : singularOnEnd pour plus de précision

### Jeu Asgard Wall (Démineur)
- **Vérification des cases inaccessibles** : évite blocages impossibles
- **Taille plateau dynamique** selon difficulté
- **Interface utilisateur** améliorée avec icônes et indicateurs

### Jeu Qix (Neuf Royaumes)
- **Amélioration des contrôles** tactiles
- **Guide Jörmungandr** avec animations

---

## 🎨 Améliorations UI/UX

### SimpleGestureDetector
**Fichiers migrés** (8 fichiers) :
- `answer_button.dart`
- `interactive_collectible_card.dart`
- `profile_screen.dart`
- `deity_selection_screen.dart`
- `asgard_wall/main_screen.dart`
- `minesweeper/main_screen.dart`
- `order_the_scrolls/widgets/detail_panel.dart`
- `order_the_scrolls/widgets/thumbnail_list.dart`

**Avantages** : Gestion tactile simplifiée, moins de code, plus fiable.

### VictoryPopup Amélioré
- **Support des chapitres d'histoires** (paramètre `unlockedStoryChapter`)
- **Affichage correct** des récompenses (cartes ou chapitres)
- **Animations et confettis** optimisés

### Cartes à Collectionner
- **Vidéos de présentation** pour les déités
- **Système de versions** : Chibi → Premium → Epic
- **Filtrage** des cartes déjà débloquées

---

## 🔧 Refactorings et Optimisations

### Code Cleanup
- **Standardisation** des noms d'écrans de jeu
- **Refactoring i18n** : arguments nommés partout
- **Suppression code mort** et commentaires obsolètes

### Architecture
- **Package game_utils.dart** : fonction `selectNextChapterToWin` réutilisée
- **Meilleure séparation** logique métier / UI
- **Services centralisés** : GamificationService, QuizService, SoundService

### Assets
- **Icônes application** mises à jour (copyright)
- **Image Thor** remplacée (style Marvel → mythologique)
- **Compression images** : -100ko sur icônes principales
- **Nouvelles images** : 6+ histoires mythologiques

---

## 📦 Dépendances

### Ajouts
- `easy_localization: ^3.0.7` - Internationalisation
- `flutter_local_notifications: ^19.5.0` - Notifications
- `timezone: ^0.10.1` - Gestion fuseaux horaires
- `simple_gesture_detector: ^0.2.1` - Détection gestes simplifiée

### Mises à jour
- `go_router: ^16.2.4` - Navigation
- `google_fonts: ^6.3.1` - Polices
- Autres packages vers versions stables

---

## 📊 Statistiques

### Tests & Qualité
- **Analyse statique** : 0 erreurs, 2 warnings (deprecated API)
- **Compilation** : Succès sur Android, iOS, Web
- **Performance** : Amélioration temps chargement initial

### Contenu
- **6+ nouvelles histoires** nordiques traduites
- **Toutes les cartes** avec traductions FR/EN
- **Questions quiz** internationalisées

---

## 🚀 Prochaines Versions

### En cours (non commitées)
- Corrections assets temporaires (.webp~)
- Tests additionnels sur iOS

### Planifié
- Mode hors-ligne complet
- Plus d'animations et effets visuels
- Système de succès/achievements

---

**Développé par** : Denis Declercq  
**Version actuelle** : v1.0.0+17
