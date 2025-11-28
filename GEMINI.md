# Oracle d'Asgard

## 📌 Description du projet  
- **Objet** : Application Flutter multi-plateforme d'exploration de la mythologie nordique, intégrant quiz interactifs, mini-jeux (Tetris, Qix, puzzle), histoires mythologiques et système de progression avec trophées.
- **Stack / Versions** : Flutter (SDK ^3.8.1), Dart (null-safety), Provider pour state management, GoRouter pour navigation, Freezed pour modèles immuables, EasyLocalization pour i18n.
- **Plateformes visées** : Android, iOS, Windows, macOS, Linux, Web.
- **Objectifs techniques / non-fonctionnels** : Performance optimale, design responsive avec flutter_screenutil, architecture modulaire avec injection de dépendances (GetIt), animations fluides (flutter_animate, confetti), expérience utilisateur immersive avec audio/vidéo, monétisation par publicités (google_mobile_ads).

## 🏗️ Architecture & Structure du projet  
- `/lib/main.dart` → point d'entrée principal de l'application  
- `/lib/router.dart` → configuration GoRouter pour navigation déclarative  
- `/lib/locator.dart` → injection de dépendances avec GetIt (service locator)  
- `/lib/screens/` → écrans / pages de l'application  
  - `main_screen.dart` → écran d'accueil principal
  - `quiz_screen.dart` → écran de quiz mythologique
  - `result_screen.dart` → écran de résultats du quiz
  - `about_screen.dart` → écran à propos
  - `settings_screen.dart` → écran de paramètres
  - `collectible_card_detail_page.dart` → détail des cartes à collectionner
  - `games/` → mini-jeux (asgard_wall, minesweeper, order_the_scrolls, puzzle, qix, snake, word_search, myth_story_page)
  - `profile/` → profil utilisateur (deity_selection_screen, main_screen, utils/, widgets/)
- `/lib/widgets/` → composants UI réutilisables (21 widgets)
- `/lib/components/` → composants métier plus complexes
- `/lib/services/` → logique métier et services  
  - `database_service.dart` → gestion base de données SQLite
  - `quiz_service.dart` → logique du quiz
  - `deity_service.dart` → gestion des divinités nordiques
  - `gamification_service.dart` → système de progression et récompenses
  - `sound_service.dart` → gestion audio
  - `notification_service.dart` → notifications locales
  - `cache_service.dart` → gestion du cache
  - `image_hosting_service.dart` → gestion des images
  - `data_service.dart` → accès aux données
  - `word_search_generator.dart` → générateur de grilles de mots
- `/lib/models/` → modèles de données avec Freezed & json_serializable (19 modèles)
- `/lib/providers/` → state management avec Provider  
- `/lib/data/` → données statiques  
  - `app_data.dart` → données générales de l'application
  - `collectible_cards_data.dart` → données des cartes à collectionner
  - `norse_riddles.dart` → énigmes nordiques
  - `stories_data.dart` → histoires mythologiques
- `/lib/utils/` → fonctions utilitaires / helpers / thèmes (14 fichiers utilitaires)
- `/lib/constants/` → constantes globales de l'application  
- `/lib/generated/` → code auto-généré (Freezed, json_serializable, EasyLocalization)  
- `/assets/` → ressources de l'application  
  - `audio/` → musiques et effets sonores
  - `fonts/` → polices AmaticSC et Amarante
  - `images/` → images et visuels  
    - `backgrounds/` → fonds d'écran
    - `blocks/` → blocs pour jeux
    - `cards/` → cartes (chibi/, epic/, premium/)
    - `heads/` → avatars de divinités
    - `icons/` → icônes de l'application
    - `preliminary/` → ressources préliminaires
    - `profile/` → images de profil
    - `qix/` → ressources du jeu Qix
    - `snake/` → ressources du jeu Snake
    - `stories/` → illustrations des histoires
  - `resources/langs/` → fichiers de traductions (en-US.json, es-ES.json, fr-FR.json)
- `/test/screens/` → tests des écrans

## ✏️ Conventions & Style de code  
- Utiliser `const` autant que possible pour les widgets immuables / stateless.  
- Nom des classes / widgets : **PascalCase**.  
- Nom des fichiers : **snake_case.dart** (ex : `user_profile.dart`, `main_screen.dart`).  
- Formatage / indentations : respecter le format standard Dart / Flutter (2 espaces).  
- Séparation claire UI / logique : éviter d'avoir de la logique métier dans les widgets — privilégier les services / providers / state management.  
- Utiliser Freezed pour les modèles de données immuables avec sérialisation JSON.  
- Utiliser GetIt pour l'injection de dépendances des services.  
- Navigation déclarative avec GoRouter (routes nommées).  
- Internationalisation avec EasyLocalization (fichiers JSON dans assets/resources/langs/).  
- Documentation : toute classe publique ou complexe doit avoir une doc DartDoc si pertinent (description + paramètres + retours).  
- Tests : tout service + logique métier significative + widget "complexe" doit avoir un test (unité ou widget).  

## 🧰 Workflow & Commandes utiles  
- `flutter pub get` — pour récupérer les dépendances.  
- `flutter pub run build_runner build --delete-conflicting-outputs` — générer le code Freezed/json_serializable.  
- `flutter pub run build_runner watch --delete-conflicting-outputs` — mode watch pour génération automatique.  
- `flutter pub run easy_localization:generate -S assets/resources/langs` — générer les traductions (si nécessaire).  
- `flutter pub run flutter_launcher_icons` — générer les icônes d'application pour toutes les plateformes.  
- `flutter analyze` + `flutter format .` — à lancer **avant chaque commit / PR** pour garantir qualité & cohérence.  
- `flutter test` — lancer l'ensemble des tests avant merge.  
- `flutter build apk` / `flutter build ios` / `flutter build windows|macos|linux|web` — builds production.  
- `./release.sh` — script de release automatique (si existant).  

## 🔄 Bonnes pratiques d'équipe / de review  
- Avant tout merge : revérifier que le code respecte les conventions (nommages, format, const, tests, docs).  
- Commits atomiques et descriptifs : un commit = une idée / une feature / un fix / une refactor cohérente.  
- PR + code-review + tests → code + documentation + tests passent.  
- Pour tout ajout de dépendance externe : noter le **but + justificatif** (raison business / technique), éviter les dépendances "juste parce que c'est pratique" sans validation.  
- Utiliser `dependency_validator` pour vérifier que toutes les dépendances sont utilisées et nécessaires.  
- Vérifier les traductions dans toutes les langues supportées (utiliser `check_translations.zsh` si disponible).  

## 🚫 Ce qu'on évite ou qu'on doit surveiller  
- Pas de logique métier directement dans les widgets UI.  
- Éviter d'ajouter des packages externes sans justification ou sans test de stabilité / compatibilité.  
- Ne pas avoir de code "spaghetti" — maintenir une architecture claire et modulaire.  
- Limiter le nombre profond de dossiers imbriqués — garder la structure simple/plate quand possible.  
- Bien gérer les assets / ressources pour éviter doublons, poids trop importants, mauvaise organisation.  
- Ne pas oublier de générer le code après modification de modèles Freezed/json_serializable.  
- Attention aux performances sur mobile : optimiser les images, limiter les animations simultanées, gérer correctement la mémoire.  
- Bien tester sur toutes les plateformes cibles (iOS, Android, Desktop, Web) car comportements peuvent différer.  

## 🧠 Pour l'IA / Gemini CLI — Consignes spécifiques  
Quand Gemini génère du code ou des fichiers pour ce projet :  
- Respecter strictement les conventions de nommage & structure ci-dessus.  
- Toujours utiliser `const` quand possible, nommage snake_case.dart pour les fichiers, PascalCase pour classes/widgets.  
- Séparer UI / logique : no business-logic dans les widgets — générer les services ou providers si nécessaire.  
- Utiliser GetIt pour enregistrer/récupérer les services (voir `locator.dart`).  
- Utiliser Provider pour le state management des écrans/widgets.  
- Utiliser Freezed pour créer des modèles de données immuables avec `@freezed` et json_serializable.  
- Utiliser GoRouter pour la navigation (définir routes dans `router.dart`).  
- Utiliser EasyLocalization pour les textes traduisibles : `tr('key')` ou `context.tr('key')`.  
- Ajouter des docs DartDoc pour les classes/fonctions publiques ou non triviales.  
- Générer des tests (unitaires ou widget) pour toute fonctionnalité ou widget "non trivial" ou réutilisable.  
- Proposer des commits atomiques, clairs, avec message descriptif.  
- Si une dépendance externe est ajoutée : demander confirmation et documenter la justification.  
- Respecter la structure des assets existante (chemins dans pubspec.yaml).  
- Prendre en compte la compatibilité multi-plateforme (Android, iOS, Desktop, Web).  
- **Important** : Après création/modification de modèles Freezed, rappeler d'exécuter `flutter pub run build_runner build --delete-conflicting-outputs`.  

## 🎮 Spécificités du projet Oracle d'Asgard  
- **Thème mythologie nordique** : tous les contenus, visuels, textes doivent respecter cet univers.  
- **Mini-jeux intégrés** : 
  - Asgard Wall (Tetris nordique)
  - Qix
  - Snake
  - Puzzle
  - Minesweeper
  - Order the Scrolls
  - Word Search (recherche de mots)
  - Myth Story Page (histoires interactives)
- **Quiz de personnalité** : questions mythologiques pour déterminer quelle divinité nordique correspond à l'utilisateur.  
- **Système de progression** : trophées, cartes à collectionner (chibi, epic, premium), histoires à débloquer, énigmes nordiques.  
- **Base de données locale** : SQLite via sqflite pour stocker progression, scores, préférences.  
- **Audio** : audioplayers pour musiques/effets sonores thématiques.  
- **Animations** : confetti pour célébrations, flutter_animate pour transitions fluides.  
- **Monétisation** : google_mobile_ads pour affichage publicités (banner, interstitiel, rewarded).  
- **Notifications locales** : flutter_local_notifications pour rappels quotidiens ou événements.  
- **Partage** : share_plus pour partager résultats/scores sur réseaux sociaux.  
- **Cache** : flutter_cache_manager pour images/ressources réseau.  
- **Vibrations** : vibration pour feedback haptique lors des interactions.  
- **Internationalisation** : Support de 3 langues (anglais US, espagnol ES, français FR).  

## 🗂️ Structure context / documents additionnels  
- `README.md` — description haut niveau du projet, comment lancer, build, tests, architecture, etc.  
- `README_translations.md` — documentation sur le système de traductions.  
- `REFACTORING_*.md` — documents d'analyse et progression des refactorings.  
- `RELEASE_NOTES_*.md` — notes de release par version.  
- `analysis_options.yaml` — configuration des règles de lint Flutter.  
- `firebase.json` — configuration Firebase (si utilisé pour analytics/crashlytics).  
- `.geminiignore` — pour exclure des dossiers/fichiers (assets volumineux, build/, .dart_tool/) du contexte IA.  
