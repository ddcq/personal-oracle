import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flame/game.dart';

import './puzzle_game.dart';
import './puzzle_model.dart';
import './puzzle_flame_game.dart';



class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({Key? key}) : super(key: key);

  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  late final PuzzleGame _game;
  late final PuzzleFlameGame _flameGame;
  final double puzzleSize = 300.0;
  final double pieceSize = 100.0;
  final String versionNumber = "Version 1.6";

  @override
  void initState() {
    super.initState();
    _game = PuzzleGame();
    _flameGame = PuzzleFlameGame(puzzleGame: _game);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _game.scatterPieces(MediaQuery.of(context).size, Rect.fromLTWH(0, 0, puzzleSize, puzzleSize));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jeu de Puzzle Jigsaw - $versionNumber')),
      body: Stack(
        children: [
          GameWidget(game: _flameGame),
        ],
      ),
    );
  }
}
