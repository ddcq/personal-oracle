import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:confetti/confetti.dart';
import 'package:oracle_d_asgard/widgets/app_dialog.dart';
import 'package:oracle_d_asgard/screens/games/puzzle/puzzle_flame_game.dart';

import './puzzle_game.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  late final PuzzleGame _game;
  late final PuzzleFlameGame _flameGame;
  final double puzzleSize = 300.0;
  final double pieceSize = 100.0;
  final String versionNumber = "Version 1.7";
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _game = PuzzleGame(onGameCompleted: _showVictoryDialog);
    _flameGame = PuzzleFlameGame(puzzleGame: _game);
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetGame();
    });
  }

  void _resetGame() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double boardX = (screenWidth - puzzleSize) / 2;
    final double boardY = (screenHeight - puzzleSize) / 2;
    final Rect puzzleBoardBounds = Rect.fromLTWH(
      boardX,
      boardY,
      puzzleSize,
      puzzleSize,
    );

    setState(() {
      _game.initializeAndScatter(
        puzzleBoardBounds,
        MediaQuery.of(context).size,
      );
    });
  }

  void _showVictoryDialog() {
    _confettiController.play();
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        icon: Icons.celebration,
        title: 'Victoire !',
        content: const Text(
          'Bravo, vous avez terminé le puzzle.',
          style: TextStyle(color: Color(0xFFC5CAE9)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF81D4FA).withAlpha(51),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Rejouer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Retour à la liste des jeux
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF81D4FA).withAlpha(51),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Retour',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jeu de Puzzle')),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          GameWidget(game: _flameGame),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
}
