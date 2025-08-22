import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For Completer
import 'package:oracle_d_asgard/screens/games/snake/game_logic.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_flame_game.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_game_over_popup.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/guide_jormungandr_popup.dart';
import 'package:oracle_d_asgard/widgets/victory_popup.dart'; // Import the victory popup
import 'package:oracle_d_asgard/widgets/confetti_overlay.dart'; // Import the confetti overlay
import 'package:oracle_d_asgard/models/collectible_card.dart'; // Import CollectibleCard
import 'package:confetti/confetti.dart'; // Import ConfettiController

class SnakeGame extends StatefulWidget { // Temporary comment
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

  Future<int> _initializeGame() async { // Return int
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
    showDialog(
      context: context,
      barrierDismissible: false, // User must interact with the button
      builder: (BuildContext context) {
        return GuideJormungandrPopup(
          onStartGame: () {
            _game?.startGame();
          },
        );
      },
    );
  }

  void _handleGameEnd(int score, {required bool isVictory, CollectibleCard? wonCard}) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must interact with the button
      builder: (BuildContext context) {
        if (isVictory) {
          return ConfettiOverlay(
            controller: _confettiController,
            child: VictoryPopup(
              score: score,
              wonCard: wonCard!,
              onResetGame: () {
                _game?.resetGame();
              },
            ),
          );
        } else {
          return SnakeGameOverPopup(
            score: score,
            onResetGame: () {
              _game?.resetGame();
              _showStartPopup();
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: ChibiAppBar(titleText: '🐍 Le Serpent de Midgard'),
        body: FutureBuilder<int>( // Specify the type of data
          future: _initializeGameFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              _currentLevel = snapshot.data!; // Get the level from snapshot

              if (_game == null) {
                // Initialize _game here
                final Completer<void> completer = Completer<void>();
                _game = SnakeFlameGame(
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
                  level: _currentLevel,
                  onGameLoaded: () {
                    completer.complete();
                  },
                  onScoreChanged: () {
                    setState(() {});
                  },
                );

                // Call _showStartPopup after the game is loaded
                completer.future.then((_) {
                  _showStartPopup();
                });
              }

              // Game is initialized, show the game content
              return Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
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
                    ),
                  ),
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
            } else {
              // Show a loading indicator while the game is initializing
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}




