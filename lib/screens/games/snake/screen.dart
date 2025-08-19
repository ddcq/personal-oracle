import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/snake/game_logic.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_flame_game.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/guide_jormungandr_popup.dart'; // Import the new popup

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
    _game = SnakeFlameGame(gamificationService: gamificationService);
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
                                overlayBuilderMap: {
                                  'gameOverOverlay': (BuildContext context, SnakeFlameGame game) {
                                    return GameOverOverlay(game: game);
                                  },
                                },
                                initialActiveOverlays: const [], // No initial overlay, handled by popup
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



class GameOverOverlay extends StatelessWidget {
  final SnakeFlameGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F23),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF22C55E)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⚰️ Ragnarök !',
                style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Jörmungandr a péri...\nScore final: ${game.gameState.score}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ChibiButton(
                onPressed: () {
                  game.overlays.remove('gameOverOverlay');
                  game.resetGame();
                },
                text: 'Renaître',
                color: const Color(0xFF22C55E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
