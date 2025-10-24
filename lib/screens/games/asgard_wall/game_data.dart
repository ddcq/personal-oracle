// game_data.dart (Simulé : Données et constantes du jeu)
// Ces constantes seraient normalement dans un fichier séparé comme lib/game_data.dart
// pour une meilleure organisation et réutilisabilité.
import 'package:flutter/material.dart';

const List<String> pieceShapes = [
  '11/1|1', // I-bimino (2)
  '111/1|1|1', // I-tromino (3)
  '10|11/11|10/11|01/01|11', // L-tromino (3)
  // Removed pieces: toot hard to fit
  //  '01|10|11/110|101/11|01|10/101|011', // ?-tetromino (4)
  //  '011|110|010/010|111|001/010|011|110/100|111|010', // F-pentomino (5)
  //  '110|011|010/010|111|100/010|110|011/001|111|010', // 7-pentomino (5)
  '11|11|10/111|011/01|11|11/110|111', // P-pentomino (5)
  '11|11|01/011|111/10|11|11/111|110', // Q-pentomino (5)
  '111|010|010/001|111|001/010|010|111/100|111|100', // T-pentomino (5)
  '101|111/11|10|11/111|101/11|01|11', // U-pentomino (5)
  '010|111|010', // X-pentomino (5)
];

// Convertit les chaînes de formes en listes de booléens.
// Cette partie serait dans game_data.dart si "pieces" était une fonction.
final List<List<List<List<bool>>>> pieces = pieceShapes
    .map((s) => s.split('/').map((r) => r.split('|').map((l) => l.split('').map((c) => c == '1').toList()).toList()).toList())
    .toList();

List<Color> pieceColors = [
  Colors.cyan,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.teal,
  Colors.pink,
  Colors.lime,
  Colors.indigo,
  Colors.amber,
];
