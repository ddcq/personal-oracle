import 'package:flame/game.dart';
import 'package:flutter/material.dart';
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
  late final SnakeFlameGame _game;
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    final gamificationService = Provider.of<GamificationService>(context, listen: false);
    _game = SnakeFlameGame(
      gamificationService: gamificationService,
      onGameEnd: (score, {required isVictory, CollectibleCard? wonCard}) {
        _handleGameEnd(score, isVictory: isVictory, wonCard: wonCard);
      },
      onResetGame: () {
        _game.resetGame();
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartPopup();
    });
  }

  @override
  void dispose() {
    _game.pauseEngine(); // Pause the game engine when the widget is disposed
    _game.removeAll(_game.children); // Remove all components from the game
    _game.onRemove(); // Clean up resources
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
            _game.startGame();
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
                _game.resetGame();
              },
            ),
          );
        } else {
          return SnakeGameOverPopup(
            score: score,
            onResetGame: () {
              _game.resetGame();
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
        body: Column(
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
                                game: _game,
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
            // Contrôles directionnels pour mobile
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DirectionalPad(
                onDirectionChanged: (Direction direction) {
                  _game.gameLogic.changeDirection(_game.gameState, direction);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




