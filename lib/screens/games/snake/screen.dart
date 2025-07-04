import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

// ==========================================
// SNAKE GAME - Le Serpent de Midgard
// ==========================================
class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> with TickerProviderStateMixin {
  static const int gridSize = 20;
  static const int gameSpeed = 300; // milliseconds

  List<Offset> snake = [const Offset(10, 10)];
  List<Offset> previousSnake = [const Offset(10, 10)];
  Offset food = const Offset(15, 15);
  Offset previousFood = const Offset(15, 15);
  Direction direction = Direction.right;
  Direction nextDirection = Direction.right;
  bool isGameRunning = false;
  bool isGameOver = false;
  int score = 0;
  Timer? gameTimer;
  ui.Image? _foodImage; // Declare _foodImage
  late AnimationController _growthAnimationController;
  late Animation<double> _growthAnimation;
  late AnimationController _movementAnimationController;
  late Animation<double> _movementAnimation;

  @override
  void initState() {
    super.initState();
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
    _generateNewFood();
    _loadImage('assets/images/apple_regular.png').then((image) {
      setState(() {
        _foodImage = image;
      });
    });
  }

  Future<ui.Image> _loadImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  // Gérer les événements clavier
  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          _changeDirection(Direction.up);
          break;
        case LogicalKeyboardKey.arrowDown:
          _changeDirection(Direction.down);
          break;
        case LogicalKeyboardKey.arrowLeft:
          _changeDirection(Direction.left);
          break;
        case LogicalKeyboardKey.arrowRight:
          _changeDirection(Direction.right);
          break;
        case LogicalKeyboardKey.space:
          if (isGameRunning || isGameOver) {
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
    super.dispose();
  }

  void _startGame() {
    setState(() {
      snake = [const Offset(10, 10)];
      previousSnake = [const Offset(10, 10)];
      direction = Direction.right;
      nextDirection = Direction.right;
      score = 0;
      isGameRunning = true;
      isGameOver = false;
    });
    _generateNewFood();

    gameTimer?.cancel();
    gameTimer = Timer.periodic(Duration(milliseconds: _calculateGameSpeed(score)), (
      timer,
    ) {
      if (mounted) {
        _movementAnimationController.duration = Duration(milliseconds: _calculateGameSpeed(score));
        _movementAnimationController.reset();
        _movementAnimationController.forward();
        _updateGame();
      }
    });
  }

  void _pauseGame() {
    if (isGameOver) return;

    gameTimer?.cancel();
    setState(() {
      isGameRunning = !isGameRunning;
    });

    if (isGameRunning) {
      gameTimer = Timer.periodic(const Duration(milliseconds: gameSpeed), (
        timer,
      ) {
        _updateGame();
      });
    }
  }

  void _resetGame() {
    gameTimer?.cancel();
    setState(() {
      snake = [const Offset(10, 10)];
      direction = Direction.right;
      nextDirection = Direction.right;
      score = 0;
      isGameRunning = false;
      isGameOver = false;
    });
    _generateNewFood();
  }

  void _updateGame() {
    if (!isGameRunning || isGameOver || !mounted) return;

    previousSnake = List.from(snake); // Store current snake for interpolation
    previousFood = food; // Store current food for interpolation

    // Calculer nouvelle position de la tête
    direction = nextDirection;
    Offset head = snake.first;
    Offset newHead;

    switch (direction) {
      case Direction.up:
        newHead = Offset(head.dx, head.dy - 1);
        break;
      case Direction.down:
        newHead = Offset(head.dx, head.dy + 1);
        break;
      case Direction.left:
        newHead = Offset(head.dx - 1, head.dy);
        break;
      case Direction.right:
        newHead = Offset(head.dx + 1, head.dy);
        break;
    }

    // Gérer les bordures (téléportation)
    if (newHead.dx < 0) newHead = Offset(gridSize - 1, newHead.dy);
    if (newHead.dx >= gridSize) newHead = Offset(0, newHead.dy);
    if (newHead.dy < 0) newHead = Offset(newHead.dx, gridSize - 1);
    if (newHead.dy >= gridSize) newHead = Offset(newHead.dx, 0);

    // Vérifier collision avec soi-même
    if (snake.contains(newHead)) {
      _gameOver();
      return;
    }

    // Mettre à jour le serpent
    List<Offset> newSnake = List.from(snake);
    newSnake.insert(0, newHead);

    // Vérifier si on mange la nourriture
    bool foodEaten = false;
    if (newHead == food) {
      foodEaten = true;
      _generateNewFood();
    } else {
      // Retirer la queue seulement si on n'a pas mangé
      newSnake.removeLast();
    }

    // Mettre à jour l'état - CRITIQUE pour le repaint
    setState(() {
      snake = newSnake;
      if (foodEaten) {
        score += 10;
        _growthAnimationController.forward(from: 0.0); // Déclencher l'animation de croissance
        // Update game speed dynamically
        gameTimer?.cancel();
        gameTimer = Timer.periodic(Duration(milliseconds: _calculateGameSpeed(score)), (timer) {
          if (mounted) {
            _movementAnimationController.duration = Duration(milliseconds: _calculateGameSpeed(score));
            _movementAnimationController.reset();
            _movementAnimationController.forward();
            _updateGame();
          }
        });
      }
    });
  }

  void _generateNewFood() {
    Random random = Random();
    Offset newFood;

    do {
      newFood = Offset(
        random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble(),
      );
    } while (snake.contains(newFood));

    food = newFood; // Pas besoin de setState ici car appelé depuis _updateGame
  }

  int _calculateGameSpeed(int currentScore) {
    // Initial speed is 300ms. Decrease speed by 20ms for every 20 points.
    // Ensure speed doesn't go below a certain minimum (e.g., 50ms).
    int newSpeed = max(50, gameSpeed - (currentScore ~/ 20) * 20);
    return newSpeed;
  }

  void _gameOver() {
    gameTimer?.cancel();
    setState(() {
      isGameRunning = false;
      isGameOver = true;
    });
  }

  void _changeDirection(Direction newDirection) {
    if (!isGameRunning || isGameOver) return;

    // Empêcher le serpent de faire demi-tour
    if ((direction == Direction.up && newDirection == Direction.down) ||
        (direction == Direction.down && newDirection == Direction.up) ||
        (direction == Direction.left && newDirection == Direction.right) ||
        (direction == Direction.right && newDirection == Direction.left)) {
      return;
    }

    nextDirection = newDirection;
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
                  'Score: $score',
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
            // Zone de jeu
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
                    // Grille de jeu avec clé pour forcer le rebuild
                    RepaintBoundary(
                      child: CustomPaint(
                        key: ValueKey('${snake.length}-${food.dx}-${food.dy}'),
                        painter: GamePainter(snake: snake, food: food, growthAnimation: _growthAnimation, movementAnimation: _movementAnimation, previousSnake: previousSnake, previousFood: previousFood, foodImage: _foodImage),
                        size: Size.infinite,
                      ),
                    ),

                    // Overlay de game over
                    if (isGameOver)
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
                                  'Jörmungandr a péri...\nScore final: $score',
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

                    // Overlay de démarrage
                    if (!isGameRunning && !isGameOver)
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

            // Contrôles
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Contrôles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: (isGameRunning || isGameOver)
                            ? _pauseGame
                            : null,
                        icon: Icon(
                          isGameRunning ? Icons.pause : Icons.play_arrow,
                        ),
                        label: Text(
                          isGameRunning
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

                  // Instructions clavier
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

                  // Contrôles directionnels
                  Column(
                    children: [
                      // Haut
                      GestureDetector(
                        onTap: () => _changeDirection(Direction.up),
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
                            onTap: () => _changeDirection(Direction.left),
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
                            onTap: () => _changeDirection(Direction.right),
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
                        onTap: () => _changeDirection(Direction.down),
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
  final Offset previousFood;
  final Animation<double> growthAnimation;
  final Animation<double> movementAnimation;
  final ui.Image? foodImage;

  GamePainter({
    required this.snake,
    required this.previousSnake,
    required this.food,
    required this.previousFood,
    required this.growthAnimation,
    required this.movementAnimation,
    this.foodImage,
  }) : super(repaint: Listenable.merge([growthAnimation, movementAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final double cellWidth = size.width / _SnakeGameState.gridSize;
    final double cellHeight = size.height / _SnakeGameState.gridSize;

    // Dessiner la grille (optionnel)
    final gridPaint = Paint()
      ..color = const Color(0xFF22C55E).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i <= _SnakeGameState.gridSize; i++) {
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
    final foodRect = Rect.fromLTWH(
      food.dx * cellWidth + 2,
      food.dy * cellHeight + 2,
      cellWidth - 4,
      cellHeight - 4,
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
      ..color = Colors.orange.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

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
        oldDelegate.growthAnimation.value != growthAnimation.value ||
        oldDelegate.movementAnimation.value != movementAnimation.value ||
        oldDelegate.foodImage != foodImage;
  }
}

// ==========================================
// ENUM POUR LES DIRECTIONS
// ==========================================
enum Direction { up, down, left, right }
