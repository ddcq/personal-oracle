import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:personal_oracle/screens/games/snake/game_logic.dart';
import 'package:personal_oracle/screens/games/snake/snake_flame_game.dart';
import 'package:personal_oracle/services/gamification_service.dart';
import 'package:provider/provider.dart';

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
    // GamificationService is available after initState, so we initialize _game in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gamificationService = Provider.of<GamificationService>(context, listen: false);
    _game = SnakeFlameGame(gamificationService: gamificationService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        title: const Text(
          '🐍 Le Serpent de Midgard (Flame)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF22C55E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final gameSize = constraints.biggest.shortestSide;
                final wallThickness = gameSize / (GameState.gridSize + 2); // 1 cell for wall
                final gameAreaSize = gameSize - (wallThickness * 2); // Inner game area

                return Center(
                  child: Container(
                    width: gameSize,
                    height: gameSize,
                    child: Stack(
                      children: [
                        // Background wall image for the entire gameSize area
                        Positioned.fill(
                          child: Image.asset('assets/images/wall.webp', fit: BoxFit.fill),
                        ),
                        // Centered black square for the game area
                        Center(
                          child: Container(
                            width: gameAreaSize,
                            height: gameAreaSize,
                            color: Colors.black, // Black square
                            child: GameWidget(
                              game: _game,
                              overlayBuilderMap: {
                                'startOverlay': (BuildContext context, SnakeFlameGame game) {
                                  return StartOverlay(game: game);
                                },
                                'gameOverOverlay': (BuildContext context, SnakeFlameGame game) {
                                  return GameOverOverlay(game: game);
                                },
                              },
                              initialActiveOverlays: const ['startOverlay'],
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
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Haut
                GestureDetector(
                  onTap: () => _game.gameLogic.changeDirection(_game.gameState, Direction.up),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Gauche et Droite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => _game.gameLogic.changeDirection(_game.gameState, Direction.left),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _game.gameLogic.changeDirection(_game.gameState, Direction.right),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Bas
                GestureDetector(
                  onTap: () => _game.gameLogic.changeDirection(_game.gameState, Direction.down),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StartOverlay extends StatelessWidget {
  final SnakeFlameGame game;

  const StartOverlay({super.key, required this.game});

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
            border: Border.all(
              color: const Color(0xFF22C55E),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.trending_up,
                size: 60,
                color: Color(0xFF22C55E),
              ),
              const SizedBox(height: 16),
              const Text(
                'Guide Jörmungandr',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Aide le serpent-monde à grandir\nen dévorant les offrandes des mortels',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '⌨️ Contrôles:\n↑↓←→ Flèches | R: Recommencer',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove('startOverlay');
                  game.startGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Réveiller le Serpent',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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
            border: Border.all(
              color: const Color(0xFF22C55E),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⚰️ Ragnarök !',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Jörmungandr a péri...\nScore final: ${game.gameState.score}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove('gameOverOverlay');
                  game.resetGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                ),
                child: const Text(
                  'Renaître',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}