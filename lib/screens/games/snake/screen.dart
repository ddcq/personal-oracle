import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:personal_oracle/screens/games/snake/game_logic.dart';
import 'package:personal_oracle/services/gamification_service.dart';
import 'package:provider/provider.dart';

// ==========================================
// SNAKE GAME - Le Serpent de Midgard
// ==========================================
class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> with TickerProviderStateMixin {
  final GameLogic _gameLogic = GameLogic();
  late GameState gameState;

  // Previous state for interpolation
  List<Offset> previousSnake = [];
  Offset previousFood = const Offset(0, 0);

  static const int gameSpeed = 300; // milliseconds
  Timer? gameTimer;
  Timer? _goldenAppleTimer;
  ui.Image? _foodImage;
  ui.Image? _goldenFoodImage;
  ui.Image? _obstacleImage;
  late AnimationController _growthAnimationController;
  late Animation<double> _growthAnimation;
  late AnimationController _movementAnimationController;
  late Animation<double> _movementAnimation;

  @override
  void initState() {
    super.initState();
    gameState = GameState.initial();
    previousSnake = List.from(gameState.snake);
    previousFood = gameState.food;

    _growthAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _growthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _growthAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _movementAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: gameSpeed),
    );
    _movementAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _movementAnimationController,
        curve: Curves.linear,
      ),
    );

    _loadImages();
  }

  void _loadImages() {
    _loadImage('assets/images/apple_regular.png').then((image) {
      setState(() => _foodImage = image);
    });
    _loadImage('assets/images/apple_golden.png').then((image) {
      setState(() => _goldenFoodImage = image);
    });
    _loadImage('assets/images/stone.png').then((image) {
      setState(() => _obstacleImage = image);
    });
  }

  Future<ui.Image> _loadImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          _gameLogic.changeDirection(gameState, Direction.up);
          break;
        case LogicalKeyboardKey.arrowDown:
          _gameLogic.changeDirection(gameState, Direction.down);
          break;
        case LogicalKeyboardKey.arrowLeft:
          _gameLogic.changeDirection(gameState, Direction.left);
          break;
        case LogicalKeyboardKey.arrowRight:
          _gameLogic.changeDirection(gameState, Direction.right);
          break;
        case LogicalKeyboardKey.space:
          if (gameState.isGameRunning || gameState.isGameOver) {
            _pauseGame();
          } else {
            _startGame();
          }
          break;
        case LogicalKeyboardKey.keyR:
          _resetGame();
          break;
      }
    }
  }

  @override
  void dispose() {
    _growthAnimationController.dispose();
    _movementAnimationController.dispose();
    gameTimer?.cancel();
    _goldenAppleTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      gameState = GameState.initial();
      gameState.isGameRunning = true;
      gameState.obstacles = _gameLogic.generateObstacles(gameState);
      previousSnake = List.from(gameState.snake);
      previousFood = gameState.food;
    });

    gameTimer?.cancel();
    gameTimer = Timer.periodic(Duration(milliseconds: _calculateGameSpeed(gameState.score)), (timer) {
      if (mounted) {
        _tick();
      }
    });
  }

  void _pauseGame() {
    if (gameState.isGameOver) return;

    gameTimer?.cancel();
    setState(() {
      gameState.isGameRunning = !gameState.isGameRunning;
    });

    if (gameState.isGameRunning) {
      gameTimer = Timer.periodic(const Duration(milliseconds: gameSpeed), (timer) {
        if (mounted) {
          _tick();
        }
      });
    }
  }

  void _resetGame() {
    gameTimer?.cancel();
    _goldenAppleTimer?.cancel();
    setState(() {
      gameState = GameState.initial();
      previousSnake = List.from(gameState.snake);
      previousFood = gameState.food;
    });
  }

  void _tick() {
    final wasGameOver = gameState.isGameOver;
    final oldSnakeLength = gameState.snake.length;
    final oldFoodType = gameState.foodType;
    final oldScore = gameState.score;

    previousSnake = List.from(gameState.snake);
    previousFood = gameState.food;

    final newState = _gameLogic.updateGame(gameState);

    // Handle golden apple timer
    if (oldFoodType != FoodType.golden && newState.foodType == FoodType.golden) {
      _goldenAppleTimer?.cancel();
      _goldenAppleTimer = Timer(const Duration(seconds: 5), () {
        if (mounted && gameState.foodType == FoodType.golden) {
          setState(() {
            gameState.foodType = FoodType.regular;
          });
        }
      });
    } else if (oldFoodType == FoodType.golden && newState.food != previousFood) {
      // Food was eaten, cancel timer
      _goldenAppleTimer?.cancel();
    }

    // Trigger growth animation
    if (newState.snake.length > oldSnakeLength) {
      _growthAnimationController.forward(from: 0.0);
    }

    // Update movement animation speed
    _movementAnimationController.duration = Duration(milliseconds: _calculateGameSpeed(newState.score));
    _movementAnimationController.reset();
    _movementAnimationController.forward();

    setState(() {
      gameState = newState;
    });

    // REGRESSION FIX: If score changed, update the game loop timer speed
    if (newState.score > oldScore) {
      gameTimer?.cancel();
      gameTimer = Timer.periodic(Duration(milliseconds: _calculateGameSpeed(newState.score)), (timer) {
        if (mounted) {
          _tick();
        }
      });
    }

    // Check for game over
    if (!wasGameOver && gameState.isGameOver) {
      _handleGameOver();
    }
  }

  int _calculateGameSpeed(int currentScore) {
    return max(50, gameSpeed - (currentScore ~/ 20) * 20);
  }

  void _handleGameOver() async {
    gameTimer?.cancel();
    final gamificationService = Provider.of<GamificationService>(context, listen: false);
    await gamificationService.saveGameScore('Snake', gameState.score);

    if (gameState.score > 50) {
      await gamificationService.unlockTrophy('snake_master');
    }
    if (gameState.score > 80) {
      await gamificationService.unlockCollectibleCard('fenrir_card');
    }
    if (gameState.score > 90) {
      await gamificationService.unlockStory('fenrir_story');
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F23),
        appBar: AppBar(
          title: const Text(
            '🐍 Le Serpent de Midgard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF22C55E),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  'Score: ${gameState.score}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E3A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF22C55E).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    RepaintBoundary(
                      child: CustomPaint(
                        key: ValueKey('${gameState.snake.length}-${gameState.food.dx}-${gameState.food.dy}-${gameState.foodType.index}-${gameState.obstacles.length}'),
                        painter: GamePainter(
                          snake: gameState.snake,
                          food: gameState.food,
                          foodType: gameState.foodType,
                          growthAnimation: _growthAnimation,
                          movementAnimation: _movementAnimation,
                          previousSnake: previousSnake,
                          previousFood: previousFood,
                          foodImage: gameState.foodType == FoodType.golden ? _goldenFoodImage : _foodImage,
                          obstacles: gameState.obstacles,
                          obstacleImage: _obstacleImage,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                    if (gameState.isGameOver)
                      Container(
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
                                  'Jörmungandr a péri...\nScore final: ${gameState.score}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _resetGame,
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
                      ),
                    if (!gameState.isGameRunning && !gameState.isGameOver)
                      Container(
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
                                  '⌨️ Contrôles:\n↑↓←→ Flèches | Espace: Pause | R: Reset',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _startGame,
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
                      ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: (gameState.isGameRunning || gameState.isGameOver)
                            ? _pauseGame
                            : null,
                        icon: Icon(
                          gameState.isGameRunning ? Icons.pause : Icons.play_arrow,
                        ),
                        label: Text(
                          gameState.isGameRunning
                              ? 'Pause (Espace)'
                              : 'Reprendre (Espace)',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _resetGame,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset (R)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B7280),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF22C55E).withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      '⌨️ Utilisez les flèches du clavier pour contrôler Jörmungandr\n'
                      'Espace: Pause/Reprendre • R: Recommencer',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => _gameLogic.changeDirection(gameState, Direction.up),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _gameLogic.changeDirection(gameState, Direction.left),
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
                            onTap: () => _gameLogic.changeDirection(gameState, Direction.right),
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
                      GestureDetector(
                        onTap: () => _gameLogic.changeDirection(gameState, Direction.down),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// PAINTER POUR LE JEU
// ==========================================
class GamePainter extends CustomPainter {
  final List<Offset> snake;
  final List<Offset> previousSnake;
  final Offset food;
  final FoodType foodType;
  final Offset previousFood;
  final Animation<double> growthAnimation;
  final Animation<double> movementAnimation;
  final ui.Image? foodImage;
  final List<Offset> obstacles;
  final ui.Image? obstacleImage;

  GamePainter({
    required this.snake,
    required this.previousSnake,
    required this.food,
    required this.foodType,
    required this.previousFood,
    required this.growthAnimation,
    required this.movementAnimation,
    this.foodImage,
    required this.obstacles,
    this.obstacleImage,
  }) : super(repaint: Listenable.merge([growthAnimation, movementAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final double cellWidth = size.width / GameState.gridSize;
    final double cellHeight = size.height / GameState.gridSize;

    // Dessiner la grille (optionnel)
    final gridPaint = Paint()
      ..color = const Color(0xFF22C55E).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i <= GameState.gridSize; i++) {
      // Lignes verticales
      canvas.drawLine(
        Offset(i * cellWidth, 0),
        Offset(i * cellWidth, size.height),
        gridPaint,
      );
      // Lignes horizontales
      canvas.drawLine(
        Offset(0, i * cellHeight),
        Offset(size.width, i * cellHeight),
        gridPaint,
      );
    }

    // Dessiner les obstacles
    if (obstacleImage != null) {
      for (final obstacle in obstacles) {
        final double obstacleScale = 1.2; // 20% larger for rocks
        final double originalObstacleWidth = cellWidth;
        final double originalObstacleHeight = cellHeight;
        final double scaledObstacleWidth = originalObstacleWidth * obstacleScale;
        final double scaledObstacleHeight = originalObstacleHeight * obstacleScale;

        final rect = Rect.fromLTWH(
          obstacle.dx * cellWidth + (cellWidth - scaledObstacleWidth) / 2,
          obstacle.dy * cellHeight + (cellHeight - scaledObstacleHeight) / 2,
          scaledObstacleWidth,
          scaledObstacleHeight,
        );
        paintImage(
          canvas: canvas,
          rect: rect,
          image: obstacleImage!,
          fit: BoxFit.contain,
        );
      }
    } else {
      final obstaclePaint = Paint()..color = Colors.grey;
      for (final obstacle in obstacles) {
        final double obstacleScale = 1.2; // 20% larger for rocks
        final double originalObstacleWidth = cellWidth - 4;
        final double originalObstacleHeight = cellHeight - 4;
        final double scaledObstacleWidth = originalObstacleWidth * obstacleScale;
        final double scaledObstacleHeight = originalObstacleHeight * obstacleScale;

        final rect = Rect.fromLTWH(
          obstacle.dx * cellWidth + (cellWidth - scaledObstacleWidth) / 2,
          obstacle.dy * cellHeight + (cellHeight - scaledObstacleHeight) / 2,
          scaledObstacleWidth,
          scaledObstacleHeight,
        );
        canvas.drawRect(rect, obstaclePaint);
      }
    }

    // Dessiner le serpent
    final snakePaint = Paint()..color = const Color(0xFF22C55E);
    final snakeHeadPaint = Paint()..color = const Color(0xFF16A34A);

    for (int i = 0; i < snake.length; i++) {
      final segment = snake[i];
      final previousSegment = previousSnake.length > i ? previousSnake[i] : snake[i];

      final interpolatedDx = previousSegment.dx + (segment.dx - previousSegment.dx) * movementAnimation.value;
      final interpolatedDy = previousSegment.dy + (segment.dy - previousSegment.dy) * movementAnimation.value;

      final rect = Rect.fromLTWH(
        interpolatedDx * cellWidth + 1,
        interpolatedDy * cellHeight + 1,
        cellWidth - 2,
        cellHeight - 2,
      );

      // Tête du serpent plus foncée
      if (i == 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(8)),
          snakeHeadPaint,
        );

        // Yeux du serpent
        final eyePaint = Paint()..color = Colors.red;
        final eyeSize = cellWidth * 0.15;
        canvas.drawCircle(
          Offset(rect.left + cellWidth * 0.3, rect.top + cellHeight * 0.3),
          eyeSize,
          eyePaint,
        );
        canvas.drawCircle(
          Offset(rect.right - cellWidth * 0.3, rect.top + cellHeight * 0.3),
          eyeSize,
          eyePaint,
        );
      } else {
        // Appliquer l'animation de croissance aux segments du serpent
        final scale = (i == snake.length - 1) ? growthAnimation.value : 1.0;
        final scaledRect = Rect.fromLTWH(
          rect.left + (rect.width * (1 - scale)) / 2,
          rect.top + (rect.height * (1 - scale)) / 2,
          rect.width * scale,
          rect.height * scale,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(scaledRect, const Radius.circular(4)),
          snakePaint,
        );
      }
    }

    // Dessiner la nourriture (offrande)
    final double foodScale = 2.0; // Double size for apples
    final double originalFoodWidth = cellWidth - 4;
    final double originalFoodHeight = cellHeight - 4;
    final double scaledFoodWidth = originalFoodWidth * foodScale;
    final double scaledFoodHeight = originalFoodHeight * foodScale;

    final foodRect = Rect.fromLTWH(
      food.dx * cellWidth + (cellWidth - scaledFoodWidth) / 2,
      food.dy * cellHeight + (cellHeight - scaledFoodHeight) / 2,
      scaledFoodWidth,
      scaledFoodHeight,
    );

    if (foodImage != null) {
      paintImage(
        canvas: canvas,
        rect: foodRect,
        image: foodImage!,
        fit: BoxFit.contain,
      );
    } else {
      final foodPaint = Paint()..color = Colors.orange;
      canvas.drawOval(foodRect, foodPaint);
    }

    // Effet de lueur sur la nourriture
    final glowPaint = Paint()
      ..color = (foodType == FoodType.golden ? Colors.yellow : Colors.orange).withOpacity(0.4) // NEW: Dynamic glow
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, foodType == FoodType.golden ? 8.0 : 4.0); // NEW: Dynamic glow

    canvas.drawOval(
      Rect.fromLTWH(
        food.dx * cellWidth,
        food.dy * cellHeight,
        cellWidth,
        cellHeight,
      ),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) {
    return oldDelegate.snake.length != snake.length ||
        oldDelegate.snake.first != snake.first ||
        oldDelegate.food != food ||
        oldDelegate.foodType != foodType ||
        oldDelegate.obstacles != obstacles ||
        oldDelegate.growthAnimation.value != growthAnimation.value ||
        oldDelegate.movementAnimation.value != movementAnimation.value ||
        oldDelegate.foodImage != foodImage ||
        oldDelegate.obstacleImage != obstacleImage;
  }
}