// game_data.dart (Simulé : Données et constantes du jeu)
// Ces constantes seraient normalement dans un fichier séparé comme lib/game_data.dart
// pour une meilleure organisation et réutilisabilité.
import 'package:flutter/material.dart';

const List<String> pieceShapes = [
  '1111/1|1|1|1', // I
  '11|11', // O
  '010|111/10|11|10/111|010/01|11|01', // T
  '100|111/11|10|10/111|001/01|01|11', // L (corrigé pour la rotation 4)
  '001|111/10|10|11/111|100/11|01|01', // J (corrigé pour la rotation 4)
  '011|110/10|11|01', // S
  '110|011/01|11|10', // Z
];

// Convertit les chaînes de formes en listes de booléens.
// Cette partie serait dans game_data.dart si "pieces" était une fonction.
final List<List<List<List<bool>>>> pieces = pieceShapes
    .map(
      (s) => s
          .split('/')
          .map(
            (r) => r
                .split('|')
                .map((l) => l.split('').map((c) => c == '1').toList())
                .toList(),
          )
          .toList(),
    )
    .toList();

List<Color> pieceColors = [
  Colors.cyan,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.blue,
  Colors.green,
  Colors.red,
];
