import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For Completer
import 'package:oracle_d_asgard/screens/games/snake/game_logic.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_flame_game.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_game_over_popup.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/game_help_dialog.dart';

import 'package:oracle_d_asgard/components/victory_popup.dart'; // Import the victory popup

import 'package:oracle_d_asgard/models/collectible_card.dart'; // Import CollectibleCard
import 'package:confetti/confetti.dart'; // Import ConfettiController

class SnakeGame extends StatefulWidget {
  // Temporary comment
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  SnakeFlameGame? _game; // Make it nullable
  late final ConfettiController _confettiController;
  late int _currentLevel;
  Future<int>? _initializeGameFuture;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _initializeGameFuture = _initializeGame();
  }

  Future<int> _initializeGame() async {
    // Return int
    final gamificationService = Provider.of<GamificationService>(context, listen: false);
    _currentLevel = await gamificationService.getSnakeDifficulty();
    return _currentLevel;
  }

  @override
  void dispose() {
    final game = _game;
    if (game != null) {
      game.pauseEngine();
      game.removeAll(game.children);
      game.onRemove();
    }
    _confettiController.dispose(); // Dispose the confetti controller
    super.dispose();
  }

  void _showStartPopup() {
    GameHelpDialog.show(context, [
      'Mangez les pommes pour grandir et marquez des points.',
      'Évitez de toucher les murs ou votre propre corps.',
      'Les pommes dorées donnent plus de points et des bonus.',
      'Les pommes pourries vous font rétrécir ou perdre des points.',
      'Le jeu devient plus rapide à chaque niveau.',
    ]);
  }

  void _handleGameEnd(int score, {required bool isVictory, CollectibleCard? wonCard}) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must interact with the button
      builder: (BuildContext context) {
        if (isVictory) {
          return _buildVictoryDialog(wonCard); // Pass wonCard directly
        } else {
          return _buildGameOverDialog(score);
        }
      },
    );
  }

  Widget _buildVictoryDialog(CollectibleCard? wonCard) {
    return VictoryPopup(
      rewardCard: wonCard,
      onDismiss: () {
        Navigator.of(context).pop();
        _game?.resetGame();
      },
      onSeeRewards: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
      },
    );
  }

  Widget _buildGameOverDialog(int score) {
    return SnakeGameOverPopup(
      score: score,
      onResetGame: () {
        _game?.resetGame();
        _showStartPopup();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: ChibiAppBar(
          titleText: '🐍 Le Serpent de Midgard',
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.white),
              onPressed: () {
                GameHelpDialog.show(
                  context,
                  [
                    'Mangez les pommes pour grandir et marquez des points.',
                    'Évitez de toucher les murs ou votre propre corps.',
                    'Les pommes dorées donnent plus de points et des bonus.',
                    'Les pommes pourries vous font rétrécir ou perdre des points.',
                    'Le jeu devient plus rapide à chaque niveau.',
                  ],
                  onGamePaused: () => _game?.pauseEngine(),
                  onGameResumed: () => _game?.resumeEngine(),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: FutureBuilder<int>(
            // Specify the type of data
            future: _initializeGameFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                _currentLevel = snapshot.data!; // Get the level from snapshot

                _game ??= _createSnakeFlameGame(_currentLevel);

                // Game is initialized, show the game content
                return Column(
                  children: [
                    Expanded(
                      child: _buildGameArea(context),
                    ),
                    _buildGameInfoAndControls(),
                  ],
                );
              } else {
                // Show a loading indicator while the game is initializing
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  SnakeFlameGame _createSnakeFlameGame(int level) {
    final Completer<void> completer = Completer<void>();
    final game = SnakeFlameGame(
      gamificationService: Provider.of<GamificationService>(context, listen: false),
      onGameEnd: (score, {required isVictory, CollectibleCard? wonCard}) async {
        if (isVictory) {
          await Provider.of<GamificationService>(context, listen: false).saveSnakeDifficulty(_currentLevel + 1);
        }
        _handleGameEnd(score, isVictory: isVictory, wonCard: wonCard);
      },
      onResetGame: () {
        _game!.resetGame(); // Use _game! because it's nullable
      },
      onRottenFoodEaten: () {
        _game!.shakeScreen(); // Use _game!
      },
      level: level,
      onGameLoaded: () {
        completer.complete();
        _game?.startGame(); // Start the game automatically
      },
      onScoreChanged: () {
        setState(() {});
      },
    );
    completer.future.then((_) {
      // Removed _showStartPopup() as per user request.
    });
    return game;
  }

  Widget _buildGameArea(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gameSize = constraints.biggest.shortestSide;
        final wallThickness = gameSize / (GameState.gridSize + 2); // 1 cell for wall
        final gameAreaSize = gameSize - (wallThickness * 2); // Inner game area

        return Center(
          child: SizedBox(
            width: gameSize,
            height: gameSize,
            child: Stack(
              children: [
                // Background wall image for the entire gameSize area
                Positioned.fill(child: Image.asset('assets/images/backgrounds/wall.webp', fit: BoxFit.fill)),
                // Centered black square for the game area
                Center(
                  child: Container(
                    width: gameAreaSize,
                    height: gameAreaSize,
                    color: Colors.black, // Black square
                    child: GameWidget(
                      game: _game!, // Use _game!
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameInfoAndControls() {
    return Column(
      children: [
        // Add the new Text widget here
        Text(
          'Niveau: $_currentLevel | Score: ${_game!.gameState.score}', // Use _game!
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        // Contrôles directionnels pour mobile
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DirectionalPad(
            onDirectionChanged: (Direction direction) {
              _game!.gameLogic.changeDirection(_game!.gameState, direction); // Use _game!
            },
          ),
        ),
      ],
    );
  }
}
