
# Todo List pour l'Amélioration du Jeu Qix

Ce document détaille les pistes d'amélioration pour le projet de jeu Qix, basées sur une analyse du code existant. Les suggestions sont regroupées par catégories : Architecture & Design, Factorisation & Lisibilité, et Optimisations de Performance.

## 1. Architecture & Design Logiciel

L'enjeu principal est de clarifier l'architecture en choisissant une seule implémentation et en améliorant la communication entre les composants.

-   [ ] **Supprimer l'implémentation redondante** : Le projet contient deux versions du jeu :
    1.  Une version moderne basée sur Flame (`qix_game.dart`, `player.dart`, `arena.dart`).
    2.  Une version plus ancienne et monolithique utilisant un `CustomPainter` (`game.dart`).
    Le fichier `main.dart` utilise la version Flame. Il est crucial de **supprimer `game.dart` et `game.dart.bak`** pour éviter la confusion, réduire la dette technique et se concentrer sur une seule architecture.

-   [ ] **Améliorer la gestion d'état du joueur** : La classe `Player` gère son état avec plusieurs booléens (`onEdge`, `_isManualInput`). Cela peut devenir complexe et source de bugs.
    -   **Action** : Remplacer les booléens par une machine à états (State Machine) plus robuste en utilisant un `enum`. Par exemple : `enum PlayerState { OnEdge, Drawing, Dead }`. Le comportement du joueur dans la méthode `update` découlerait directement de l'état courant, rendant la logique plus claire.

-   [ ] **Découpler les composants (Single Responsibility Principle)** : La méthode `Player.move` est surchargée. Elle gère le déplacement, le changement d'état (passer de `onEdge` à `drawing`), et déclenche directement le remplissage de la zone dans `arena.fillArea(...)`.
    -   **Action** : Le joueur ne devrait que notifier un changement d'état ou la complétion d'un chemin. Le composant principal (`QixGame`) devrait écouter ces événements et ordonner à l'`Arena` de se mettre à jour. Cela respecte mieux le principe de responsabilité unique.

-   [ ] **Centraliser et unifier les constantes** : Des constantes de grille sont définies dans `constants.dart` (`kGridWidth`) mais une autre taille (`gridSize`) est définie localement dans `qix_game.dart`.
    -   **Action** : Créer une seule source de vérité pour la configuration de la grille (taille, dimensions des cellules, etc.) dans `constants.dart` et l'utiliser partout.

## 2. Factorisation & Lisibilité du Code

L'objectif est de rendre le code plus simple à comprendre et à maintenir en extrayant des logiques complexes dans des fonctions dédiées.

-   [ ] **Simplifier la méthode `Player.update`** : La logique de décision pour le mouvement automatique dans les coins est imbriquée et difficile à suivre.
    -   **Action** : Extraire la logique de "recherche de la prochaine direction valide" dans une méthode dédiée comme `_findNextAutoDirection()` pour alléger la méthode `update`.

-   [ ] **Clarifier l'algorithme de remplissage (`ArenaComponent.fillArea`)** : Cette méthode est correcte mais complexe.
    -   **Action** : Ajouter des commentaires stratégiques pour expliquer les 4 étapes clés de l'algorithme (marquage du chemin, flood-fill pour trouver les régions, identification de la région du Qix, remplissage des autres régions). Renommer certaines variables pour mieux refléter leur intention.

-   [ ] **Utiliser des `enum` pour les directions** : Le code utilise déjà un `enum Direction`, ce qui est une excellente pratique. Il faut s'assurer que son usage est cohérent partout et éviter les `String` comme `'right'` (présent dans l'ancienne version `game.dart`).

## 3. Optimisations de Performance

Les performances sont cruciales pour un jeu fluide. Les optimisations se concentrent sur le rendu et les algorithmes coûteux.

-   [ ] **Optimiser le rendu de l'`ArenaComponent`** : La méthode `render` est très inefficace.
    -   **Action 1 (Critique)** : **Mettre en cache les objets `Paint`**. Ne pas créer de `new Paint()` à chaque frame. Déclarez-les comme des membres finaux de la classe.
    -   **Action 2 (Critique)** : **Arrêter de créer des `Sprite` à chaque frame**. La ligne `final subSprite = Sprite(...)` dans la boucle de rendu est une source majeure de "jank" (saccades). Pré-calculez et stockez les sprites des tuiles de l'image dans une liste ou une map lors du `onLoad`.

-   [ ] **Optimiser les algorithmes de balayage de la grille** : Plusieurs méthodes parcourent toute la grille, ce qui est coûteux.
    -   **Action pour `_demoteEnclosedEdges`** : Au lieu de scanner toute la grille (`O(N*M)`), cette méthode pourrait être optimisée pour ne vérifier que les voisins des nouvelles bordures qui viennent d'être créées après un `fillArea`.
    -   **Action pour `findNearestBoundaryPoint`** : Si cette fonction est utilisée fréquemment, un parcours complet de la grille est trop lent. Envisagez de pré-calculer une liste de tous les points de bordure pour accélérer la recherche.

-   [ ] **Remplacer la boucle de jeu `Timer` par `AnimationController` (Déjà fait dans `game.dart`)** : L'ancienne version `game.dart` a été correctement refactorisée pour utiliser un `AnimationController` au lieu d'un `Timer`. C'est une bonne pratique car il se synchronise avec le cycle de rafraîchissement de l'écran. Il faut s'assurer que la version Flame (`QixGame`) s'appuie bien sur la boucle de jeu interne de Flame (`update(dt)`) et non sur des `Timer` externes. L'implémentation actuelle est correcte à ce niveau.

