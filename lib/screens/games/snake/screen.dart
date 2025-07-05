import 'package:flame/game.dart';
import 'package:flutter/material.dart';
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
      body: GameWidget(
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