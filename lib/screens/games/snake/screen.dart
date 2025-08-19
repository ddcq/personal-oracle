import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/snake/game_logic.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_flame_game.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/guide_jormungandr_popup.dart'; // Import the new popup
import 'package:oracle_d_asgard/widgets/game_over_popup.dart'; // Import the new game over popup

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  late final SnakeFlameGame _game;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartPopup();
    });
  }

  @override
  void dispose() {
    _game.pauseEngine(); // Pause the game engine when the widget is disposed
    _game.removeAll(_game.children); // Remove all components from the game
    _game.onRemove(); // Clean up resources
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gamificationService = Provider.of<GamificationService>(context, listen: false);
    _game = SnakeFlameGame(
      gamificationService: gamificationService,
      onGameOver: (score) {
        _showGameOverPopup(score);
      },
      onResetGame: () {
        _game.resetGame();
      },
    );
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

  void _showGameOverPopup(int score) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must interact with the button
      builder: (BuildContext context) {
        return GameOverPopup(
          score: score,
          onResetGame: () {
            _game.resetGame();
          },
        );
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




