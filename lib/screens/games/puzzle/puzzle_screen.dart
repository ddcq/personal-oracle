import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:confetti/confetti.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/confetti_overlay.dart';

import 'package:oracle_d_asgard/screens/games/puzzle/puzzle_flame_game.dart';

import './puzzle_game.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  late PuzzleGame _game;
  late PuzzleFlameGame _flameGame;
  final int _rows = 5; // Default rows
  final int _cols = 5; // Default cols
  final String versionNumber = "Version 1.7";
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _game = PuzzleGame(rows: _rows, cols: _cols);
    _flameGame = PuzzleFlameGame(puzzleGame: _game, onRewardEarned: _showVictoryDialog);
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetGame();
    });
  }

  void _resetGame() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;

    // Calculate pieceSize based on the smaller dimension to ensure it fits
    final double calculatedPieceSize = isPortrait
        ? (screenWidth * 0.9) /
              _cols // 90% of screen width for portrait
        : (screenHeight * 0.9) / _rows; // 90% of screen height for landscape

    final double calculatedPuzzleWidth = calculatedPieceSize * _cols;
    final double calculatedPuzzleHeight = calculatedPieceSize * _rows;

    final double boardX = (screenWidth - calculatedPuzzleWidth) / 2;
    final double boardY = (screenHeight - calculatedPuzzleHeight) / 2;

    final Rect puzzleBoardBounds = Rect.fromLTWH(boardX, boardY, calculatedPuzzleWidth, calculatedPuzzleHeight);

    // Update the game with the new piece size and board dimensions
    _game.pieceSize = calculatedPieceSize;
    _game.rows = _rows;
    _game.cols = _cols;

    setState(() {
      _game.initializeAndScatter(puzzleBoardBounds, MediaQuery.of(context).size);
    });
  }

  void _showVictoryDialog(CollectibleCard rewardCard) {
    _flameGame.overlays.add('victoryOverlay');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('Jeu de Puzzle', style: TextStyle(fontFamily: AppTextStyles.amaticSC))),
      body: ConfettiOverlay(
        controller: _confettiController,
        child: GameWidget(
          game: _flameGame,
          overlayBuilderMap: {
            'victoryOverlay': (BuildContext context, PuzzleFlameGame game) {
              return VictoryPopup(
                rewardCard: game.associatedCard!,
                onDismiss: () {
                  game.overlays.remove('victoryOverlay');
                  _resetGame();
                },
              );
            },
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
