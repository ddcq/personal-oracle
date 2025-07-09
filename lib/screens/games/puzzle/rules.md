Voici un ensemble **structuré et complet de règles de gestion** pour un jeu de puzzle type "jigsaw" en Flutter, rédigé pour être facilement interprétable par une IA génératrice de code comme Gemini. Les règles utilisent un **vocabulaire constant**, sont **numérotées**, **claires**, et peuvent servir de **base fonctionnelle**.

---

## 🧩 **Règles de gestion du jeu de puzzle Flutter**

### 🎮 Interactions de base

1. **Déplacement libre** :
   Si une pièce est déplacée depuis une position A vers une position B, et que la position B **n’est pas sa position finale correcte**, alors la pièce reste à B et peut être déplacée de nouveau.

2. **Snap à la position correcte** :
   Si une pièce est déplacée à proximité de sa position finale correcte (tolérance définie par un rayon de `snapThreshold` pixels), alors elle **s’aligne automatiquement** (snap) à cette position et devient **verrouillée**.

3. **Verrouillage** :
   Une pièce verrouillée **ne peut plus être déplacée**.

4. **Déplacement unique à la fois** :
   Une seule pièce peut être déplacée à la fois. Un nouveau déplacement n’est possible que lorsque le précédent est terminé.

---

### 🧷 Détection et gestion des positions

5. **Coordonnées de référence** :
   Chaque pièce possède une **position finale de référence** (`targetPosition`), définie au démarrage du jeu.

6. **Position actuelle** :
   Chaque pièce possède une **position actuelle** (`currentPosition`) mise à jour à chaque déplacement.

7. **Tolérance de snapping** :
   Si la distance entre `currentPosition` et `targetPosition` est **inférieure à `snapThreshold`**, la pièce s’aligne automatiquement à `targetPosition`.

---

### 👆 Interactions utilisateur

8. **Drag & drop** :
   Chaque pièce peut être **cliquée et glissée** avec le doigt ou la souris si elle n’est pas verrouillée.

9. **Retour visuel lors du drag** :
   Lorsqu’une pièce est en cours de déplacement, elle peut afficher une **élévation visuelle** ou être rendue légèrement transparente.

10. **Z-index dynamique** :
    Une pièce déplacée passe temporairement au **premier plan (top z-index)** pour ne pas être masquée par d'autres pièces.

---

### ✅ Validation et fin de jeu

11. **Validation individuelle** :
    Lorsqu’une pièce est positionnée correctement (snap), une **validation visuelle et/ou sonore** peut être déclenchée.

12. **Détection de complétion** :
    Le jeu est considéré comme terminé lorsque **toutes les pièces sont verrouillées**.

13. **Déclenchement de fin de partie** :
    À la fin du jeu, un **événement de fin de partie** est déclenché (animation, son, message de victoire, etc.).

---

### 🧠 Logique avancée (optionnelle)

14. **Groupement de pièces** :
    Si plusieurs pièces sont correctement connectées entre elles (emboîtées), elles peuvent être **déplacées ensemble** tant qu’elles ne sont pas verrouillées.

15. **Snapping entre pièces** :
    Une pièce peut s’aligner avec une **autre pièce adjacente** si leurs bords sont compatibles et si les deux sont proches.

16. **Snapping prioritaire à la position finale** :
    Si une pièce est proche à la fois d’une autre pièce et de sa position finale, **la priorité est donnée au snapping vers la position finale**.

17. **Undo / Reset (optionnel)** :
    Le joueur peut annuler le dernier déplacement ou réinitialiser le puzzle (toutes les pièces reviennent à leur position initiale non verrouillée).

---

### 📦 Initialisation du jeu

18. **Disposition initiale aléatoire** :
    Au démarrage, toutes les pièces sont **placées aléatoirement** dans une zone définie, mais en dehors de leur position finale.

19. **Aucune pièce n’est verrouillée au début** :
    Toutes les pièces commencent en mode **déplaçable** (`isLocked = false`).

---

### 📋 Format des données recommandées

Pour faciliter la génération automatique du code, chaque pièce de puzzle peut être représentée par une structure de données contenant au minimum :

```dart
class PuzzlePiece {
  final int id;
  Offset currentPosition;
  final Offset targetPosition;
  bool isLocked;
  Image image; // ou Path shape pour forme personnalisée
}
```

---

Souhaites-tu aussi une **représentation JSON des règles**, ou un **modèle d’état global** pour le puzzle ?
