import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/game_help_dialog.dart';

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

  @override
  void initState() {
    super.initState();
    _game = PuzzleGame(rows: _rows, cols: _cols);
    _flameGame = PuzzleFlameGame(puzzleGame: _game, onRewardEarned: _showVictoryDialog);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetGame();
    });
  }

  void _resetGame() {
    final dimensions = _calculatePuzzleDimensions(context);

    // Update the game with the new piece size and board dimensions
    _game.pieceSize = dimensions['pieceSize'];
    _game.rows = _rows;
    _game.cols = _cols;

    setState(() {
      _game.initializeAndScatter(dimensions['puzzleBoardBounds'], MediaQuery.of(context).size);
    });
    _flameGame.reset();
  }

  Map<String, dynamic> _calculatePuzzleDimensions(BuildContext context) {
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

    return {
      'pieceSize': calculatedPieceSize,
      'puzzleBoardBounds': puzzleBoardBounds,
    };
  }

  void _showVictoryDialog(CollectibleCard? rewardCard) {
    _flameGame.overlays.add('victoryOverlay');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SafeArea(
            child: GameWidget<PuzzleFlameGame>(
              game: _flameGame,
              overlayBuilderMap: {
                'victoryOverlay': (BuildContext context, PuzzleFlameGame game) {
                  return VictoryPopup(
                    rewardCard: game.associatedCard,
                    onDismiss: () {
                      game.overlays.remove('victoryOverlay');
                      _resetGame();
                    },
                    onSeeRewards: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
                    },
                  );
                },
              },
            ),
          ),
          SafeArea(
            child: IgnorePointer(
              child: ChibiAppBar(
                titleText: 'Les runes dispersées',
              ),
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Navigator.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.help_outline, color: Colors.white),
                onPressed: () {
                  GameHelpDialog.show(
                    context,
                    [
                      'Réorganisez les tuiles pour former l\'image complète.',
                      'Glissez les tuiles dans les espaces vides.',
                      'Le but est de reconstituer l\'image le plus rapidement possible.',
                    ],
                    onGamePaused: () => _flameGame.pauseEngine(),
                    onGameResumed: () => _flameGame.resumeEngine(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

}
