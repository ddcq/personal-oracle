// game_data.dart (Simulé : Données et constantes du jeu)
// Ces constantes seraient normalement dans un fichier séparé comme lib/game_data.dart
// pour une meilleure organisation et réutilisabilité.

const List<String> pieceShapes = [
  '11|11', // O
  '1|1|1|1/1111', // I
  '110|011/01|11|10', // Z
  '011|110/10|11|01', // S
  '010|111/10|11|10/111|010/01|11|01', // T
  '100|111/11|10|10/111|001/01|01|11', // J-tetromino (4)
  '001|111/10|10|11/111|100/11|01|01', // L-tetromino (4)
];

// Convertit les chaînes de formes en listes de booléens.
// Cette partie serait dans game_data.dart si "pieces" était une fonction.
final List<List<List<List<bool>>>> pieces = pieceShapes
    .map((s) => s.split('/').map((r) => r.split('|').map((l) => l.split('').map((c) => c == '1').toList()).toList()).toList())
    .toList();
