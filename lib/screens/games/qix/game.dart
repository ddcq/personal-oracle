import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oracle_d_asgard/widgets/app_dialog.dart';
import 'dart:async';
import 'dart:collection'; // Pour utiliser Queue pour le flood fill
import 'dart:math';
import 'constants.dart';

class QixGameScreen extends StatefulWidget {
  final VoidCallback onGameOver;
  const QixGameScreen({super.key, required this.onGameOver});

  @override
  State<QixGameScreen> createState() => _QixGameScreenState();
}

class _QixGameScreenState extends State<QixGameScreen>
    with TickerProviderStateMixin {
  // --- ÉTAT DU JEU ---
  late List<List<int>> _grid;
  late double _scaleX;
  late double _scaleY;

  late AnimationController _jormungandController;
  // SUPPRESSION du Timer pour la boucle de jeu. On utilisera l'AnimationController.
  // Timer? _gameLoopTimer;
  bool _gameRunning = true;
  bool _isDrawing = false;
  bool _slowDraw = false;
  int _score = 0;
  int _lives = 3;
  double _territoryConquered = 0.0;
  bool _isGameReady = false;

  Timer? _countdownTimer;
  int _countdown = 3;
  String _countdownMessage = "";

  final List<SparK> _sparks = [];

  Offset _playerPosition = const Offset(kGridWidth / 2, 0);
  Point<int> _playerGridPos = const Point(kGridWidth ~/ 2, 0);
  Offset _jormungandPosition = const Offset(kGridWidth / 2, kGridHeight / 2);

  final List<Point<int>> _currentLinePoints = [];

  final double _moveSpeed = 0.75;
  String _currentDirection = 'right';
  bool _autoMove = true;
  bool _atCorner = false;

  Offset _jormungandVelocity = const Offset(0.6, 0.45);
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeGrid();

    _jormungandController = AnimationController(
      duration: const Duration(
        milliseconds: 1000,
      ), // La durée n'importe pas en mode repeat
      vsync: this,
    );

    // *** CORRECTION PERFORMANCE MAJEURE ***
    // On attache la logique du jeu au listener de l'AnimationController.
    // Il se déclenche à chaque frame de manière synchronisée avec le rendu.
    _jormungandController.addListener(() {
      if (!_gameRunning || !mounted) return;

      if (_isGameReady) {
        setState(() {
          _updatePlayer();
          _updateJormungand();
          _updateSparks();
          _checkCollisions();
          _checkVictory();
        });
      } else {
        // On appelle quand même setState pour que l'animation de Jörmungand continue
        setState(() {});
      }
    });

    _jormungandController.repeat(); // On lance la boucle de jeu/rendu

    _startCountdown();
    // On supprime l'appel à l'ancienne boucle de jeu
    // _startGameLoop();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  void _initializeGrid() {
    _grid = List.generate(
      kGridWidth,
      (_) => List.filled(kGridHeight, kGridFree),
    );
    // CORRECTION : On remplit les bordures pour que la logique de déplacement
    // sur les zones conquises puisse fonctionner à l'avenir et pour la cohérence.
    for (int x = 0; x < kGridWidth; x++) {
      for (int y = 0; y < kGridHeight; y++) {
        if (x == 0 || x == kGridWidth - 1 || y == 0 || y == kGridHeight - 1) {
          _grid[x][y] = kGridEdge;
        }
      }
    }
    _scaleX = gameWidth / kGridWidth;
    _scaleY = gameHeight / kGridHeight;
    _updateTerritoryPercentage();
  }

  void _startCountdown() {
    setState(() {
      _isGameReady = false;
      _countdown = 3;
      _countdownMessage = "Préparez-vous !";
    });

    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdown > 1) {
          _countdown--;
          _countdownMessage = "$_countdown...";
        } else if (_countdown == 1) {
          _countdown--;
          _countdownMessage = "Partez !";
        } else {
          timer.cancel();
          _isGameReady = true;
          _countdownMessage = "";
        }
      });
    });
  }

  // L'ancienne boucle de jeu n'est plus nécessaire
  // void _startGameLoop() { ... }

  void _loseLife() {
    if (!mounted) return;
    setState(() {
      _lives--;

      for (var point in _currentLinePoints) {
        if (_grid[point.x][point.y] == kGridPath) {
          _grid[point.x][point.y] = kGridFree;
        }
      }
      _currentLinePoints.clear();

      _isDrawing = false;
      _slowDraw = false;
      _playerPosition = const Offset(kGridWidth / 2, 0);
      _playerGridPos = const Point(kGridWidth ~/ 2, 0);
      _currentDirection = 'right';
      _autoMove = true;
      _atCorner = false;

      if (_lives <= 0) {
        _gameRunning = false;
        _showGameOverDialog();
      } else {
        _startCountdown();
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!_isGameReady) return KeyEventResult.ignored;

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _changePlayerDirection('up');
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _changePlayerDirection('down');
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _changePlayerDirection('left');
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _changePlayerDirection('right');
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.space && !_isDrawing) {
        // La spécification originale de Qix veut qu'on appuie sur un bouton pour commencer à tracer
        // Ici, on le lie au slow draw, ce qui est une variante.
        setState(() => _slowDraw = true);
        return KeyEventResult.handled;
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        setState(() => _slowDraw = false);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppDialog(
        icon: Icons.sentiment_very_dissatisfied,
        title: 'Défaite !',
        content: Text(
          'Jörmungand a triomphé !\n\nScore: $_score\nTerritoire conquis: ${(_territoryConquered * 100).toStringAsFixed(1)}%',
          style: const TextStyle(color: Color(0xFFC5CAE9)),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onGameOver();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF81D4FA).withAlpha(51),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Menu Principal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getValidNextDirections() {
    final List<String> validDirections = [];
    final Point<int> currentPos = _playerGridPos;

    final Map<String, Point<int>> potentialMoves = {
      'up': Point(currentPos.x, currentPos.y - 1),
      'down': Point(currentPos.x, currentPos.y + 1),
      'left': Point(currentPos.x - 1, currentPos.y),
      'right': Point(currentPos.x + 1, currentPos.y),
    };

    final Map<String, String> oppositeDirections = {
      'up': 'down',
      'down': 'up',
      'left': 'right',
      'right': 'left',
    };

    final String oppositeDirection = oppositeDirections[_currentDirection]!;

    for (final entry in potentialMoves.entries) {
      final direction = entry.key;
      final nextPos = entry.value;

      // On ne peut pas faire demi-tour
      if (direction == oppositeDirection) {
        continue;
      }
      // On ne teste pas la direction actuelle
      if (direction == _currentDirection) {
        continue;
      }

      // On vérifie si la case est valide (sur une bordure ou une zone conquise)
      if (nextPos.x >= 0 &&
          nextPos.x < kGridWidth &&
          nextPos.y >= 0 &&
          nextPos.y < kGridHeight &&
          (_grid[nextPos.x][nextPos.y] == kGridEdge ||
              _grid[nextPos.x][nextPos.y] == kGridFilled)) {
        validDirections.add(direction);
      }
    }
    return validDirections;
  }

  void _updatePlayer() {
    if (!_autoMove || _atCorner) return;

    // 1. Calcul de la position visuelle suivante
    double currentSpeed =
        (_isDrawing && _slowDraw) ? _moveSpeed * 0.5 : _moveSpeed;
    Offset newPosition = _playerPosition;
    switch (_currentDirection) {
      case 'up':
        newPosition = Offset(
            _playerPosition.dx, _playerPosition.dy - currentSpeed);
        break;
      case 'down':
        newPosition = Offset(
            _playerPosition.dx, _playerPosition.dy + currentSpeed);
        break;
      case 'left':
        newPosition = Offset(
            _playerPosition.dx - currentSpeed, _playerPosition.dy);
        break;
      case 'right':
        newPosition = Offset(
            _playerPosition.dx + currentSpeed, _playerPosition.dy);
        break;
    }

    // 2. Déterminer la case logique suivante
    Point<int> nextGridPos =
        Point(newPosition.dx.round(), newPosition.dy.round());

    // 3. Si on ne change pas de case, on met juste à jour la position visuelle et on arrête
    if (nextGridPos == _playerGridPos) {
      _playerPosition = newPosition;
      return;
    }

    // 4. On a changé de case, on vérifie si le mouvement est valide
    if (_isValidGridPosition(nextGridPos)) {
      // Le mouvement est valide, on met à jour la position visuelle
      _playerPosition = newPosition;

      // Logique de début/fin de dessin
      bool wasOnBorder =
          _grid[_playerGridPos.x][_playerGridPos.y] == kGridEdge ||
              _grid[_playerGridPos.x][_playerGridPos.y] == kGridFilled;
      bool isOnBorder = _grid[nextGridPos.x][nextGridPos.y] == kGridEdge ||
          _grid[nextGridPos.x][nextGridPos.y] == kGridFilled;

      if (wasOnBorder && !isOnBorder && !_isDrawing) {
        _isDrawing = true;
        _currentLinePoints.clear();
        _currentLinePoints.add(_playerGridPos);
        // La nouvelle case est le premier point du chemin
        _grid[nextGridPos.x][nextGridPos.y] = kGridPath;
        _currentLinePoints.add(nextGridPos);
      } else if (_isDrawing) {
        if (!_currentLinePoints.contains(nextGridPos)) {
          _grid[nextGridPos.x][nextGridPos.y] = kGridPath;
          _currentLinePoints.add(nextGridPos);
        }
      }

      if (_isDrawing && isOnBorder) {
        _finishDrawing();
      }

      // On met à jour la position logique du joueur
      _playerGridPos = nextGridPos;
    } else {
      // Le mouvement est invalide (mur, etc.)
      if (_isDrawing) {
        _loseLife();
      } else {
        // On est sur une bordure et on a heurté un coin
        // On replace le joueur au centre de sa case actuelle pour éviter qu'il ne se coince
        _playerPosition =
            Offset(_playerGridPos.x.toDouble(), _playerGridPos.y.toDouble());

        final validDirections = _getValidNextDirections();
        if (validDirections.length == 1) {
          setState(() {
            _currentDirection = validDirections.first;
          });
        } else {
          setState(() {
            _atCorner = true;
            _autoMove = false;
          });
        }
      }
    }
  }

  bool _isValidGridPosition(Point<int> pos) {
    // Vérifie les limites de la grille
    if (pos.x < 0 || pos.x >= kGridWidth || pos.y < 0 || pos.y >= kGridHeight) {
      return false;
    }

    // Empêche de croiser sa propre ligne en dessinant
    if (_isDrawing && _grid[pos.x][pos.y] == kGridPath) {
      // On peut revenir sur le premier point pour fermer une zone, mais pas sur les autres.
      if (_currentLinePoints.length > 2 && pos == _currentLinePoints.first) {
        return true;
      }
      return false;
    }
    
    return true; // Le mouvement est permis par défaut, les cas interdits sont traités au-dessus
  }

  void _finishDrawing() {
    if (!_isDrawing || _currentLinePoints.isEmpty) {
      _resetDrawingState();
      return;
    }

    Point<int> jormungandGridPos = Point(
      (_jormungandPosition.dx).round().clamp(0, kGridWidth - 1),
      (_jormungandPosition.dy).round().clamp(0, kGridHeight - 1),
    );

    List<Point<int>> seeds = _findSeeds(_currentLinePoints);
    if (seeds.length < 2) {
      _resetDrawingState();
      return;
    }

    // *** CORRECTION LISIBILITÉ ***
    // Utilisation des constantes nommées
    List<Point<int>> area1 = _floodFill(seeds[0], kTempFillArea1);
    List<Point<int>> area2 = _floodFill(seeds[1], kTempFillArea2);

    bool jormungandInArea1 =
        _grid[jormungandGridPos.x][jormungandGridPos.y] == kTempFillArea1;

    List<Point<int>> areaToFill;

    // On choisit l'aire la plus petite à remplir. Si l'aire contient Jörmungand, on prend l'autre.
    if (jormungandInArea1) {
      areaToFill = area2.length < area1.length
          ? area2
          : area2; // On remplit la zone sans le monstre
    } else {
      areaToFill = area1.length < area2.length
          ? area1
          : area1; // On remplit la zone sans le monstre
    }

    // Si les deux zones sont de taille égale, on remplit celle sans le monstre.
    if (area1.length == area2.length) {
      areaToFill = jormungandInArea1 ? area2 : area1;
    }

    // On remplit la zone choisie
    for (var point in areaToFill) {
      _grid[point.x][point.y] = kGridFilled;
    }
    // On transforme la ligne en bordure remplie
    for (var point in _currentLinePoints) {
      _grid[point.x][point.y] = kGridFilled;
    }

    // On nettoie les marqueurs temporaires (kTempFill...) en les remettant à kGridFree
    for (int x = 1; x < kGridWidth - 1; x++) {
      for (int y = 1; y < kGridHeight - 1; y++) {
        final cell = _grid[x][y];
        if (cell == kTempFillArea1 || cell == kTempFillArea2) {
          _grid[x][y] = kGridFree;
        }
      }
    }

    _score += areaToFill.length * (_slowDraw ? 2 : 1);
    _updateTerritoryPercentage();
    _resetDrawingState();
  }

  List<Point<int>> _findSeeds(List<Point<int>> line) {
    List<Point<int>> seeds = [];
    List<Point<int>> tempFilled = [];

    for (var point in line) {
      for (var offset in [
        const Point(0, 1),
        const Point(0, -1),
        const Point(1, 0),
        const Point(-1, 0),
      ]) {
        Point<int> neighbor = Point(point.x + offset.x, point.y + offset.y);

        if (neighbor.x > 0 &&
            neighbor.x < kGridWidth - 1 &&
            neighbor.y > 0 &&
            neighbor.y < kGridHeight - 1 &&
            _grid[neighbor.x][neighbor.y] == kGridFree) {
          seeds.add(neighbor);
          // *** CORRECTION LISIBILITÉ ***
          _floodFill(neighbor, kSeedScanArea, tempFilled);
          if (seeds.length >= 2) {
            // Nettoie le marquage temporaire
            for (var p in tempFilled) {
              _grid[p.x][p.y] = kGridFree;
            }
            return seeds;
          }
        }
      }
    }
    // Nettoyage au cas où un seul seed a été trouvé
    for (var p in tempFilled) {
      _grid[p.x][p.y] = kGridFree;
    }
    return seeds;
  }

  List<Point<int>> _floodFill(
    Point<int> startNode,
    int fillId, [
    List<Point<int>>? trackedPoints,
  ]) {
    List<Point<int>> filledPoints = [];
    Queue<Point<int>> queue = Queue();

    if (_grid[startNode.x][startNode.y] != kGridFree) return filledPoints;

    queue.add(startNode);
    _grid[startNode.x][startNode.y] = fillId;
    filledPoints.add(startNode);
    trackedPoints?.add(startNode);

    while (queue.isNotEmpty) {
      Point<int> node = queue.removeFirst();
      for (var offset in [
        const Point(0, 1),
        const Point(0, -1),
        const Point(1, 0),
        const Point(-1, 0),
      ]) {
        Point<int> neighbor = Point(node.x + offset.x, node.y + offset.y);
        if (neighbor.x > 0 &&
            neighbor.x < kGridWidth - 1 &&
            neighbor.y > 0 &&
            neighbor.y < kGridHeight - 1 &&
            _grid[neighbor.x][neighbor.y] == kGridFree) {
          _grid[neighbor.x][neighbor.y] = fillId;
          filledPoints.add(neighbor);
          trackedPoints?.add(neighbor);
          queue.add(neighbor);
        }
      }
    }
    return filledPoints;
  }

  void _updateTerritoryPercentage() {
    int filledCount = 0;
    for (int x = 0; x < kGridWidth; x++) {
      for (int y = 0; y < kGridHeight; y++) {
        if (_grid[x][y] == kGridFilled) {
          filledCount++;
        }
      }
    }
    // Le territoire total est la grille entière. Les bordures comptent.
    int totalPlayable = kGridWidth * kGridHeight;
    setState(() {
      _territoryConquered = filledCount / totalPlayable;
    });
  }

  void _resetDrawingState() {
    // Pas besoin de setState ici car il sera appelé par les fonctions parentes (_finishDrawing, _loseLife)
    for (var point in _currentLinePoints) {
      if (_grid[point.x][point.y] == kGridPath) {
        _grid[point.x][point.y] = kGridFree;
      }
    }
    _currentLinePoints.clear();
    _isDrawing = false;
    _autoMove = true;
    _atCorner = false;
    _slowDraw = false;
  }

  void _updateJormungand() {
    _jormungandPosition = Offset(
      (_jormungandPosition.dx + _jormungandVelocity.dx),
      (_jormungandPosition.dy + _jormungandVelocity.dy),
    );

    // Rebond sur les murs extérieurs
    if (_jormungandPosition.dx <= 0 ||
        _jormungandPosition.dx >= kGridWidth - 1) {
      _jormungandVelocity = Offset(
        -_jormungandVelocity.dx,
        _jormungandVelocity.dy,
      );
    }
    if (_jormungandPosition.dy <= 0 ||
        _jormungandPosition.dy >= kGridHeight - 1) {
      _jormungandVelocity = Offset(
        _jormungandVelocity.dx,
        -_jormungandVelocity.dy,
      );
    }
  }

  void _updateSparks() {
    for (var spark in _sparks) {
      spark.update();
    }
  }

  void _checkCollisions() {
    // *** CORRECTION BUG CRITIQUE ***
    // On vérifie la collision en utilisant la position de Jörmungand sur la grille
    // par rapport aux points de la ligne en cours de traçage.
    if (_isDrawing && _currentLinePoints.isNotEmpty) {
      Point<int> jormungandGridPos = Point(
        _jormungandPosition.dx.round().clamp(0, kGridWidth - 1),
        _jormungandPosition.dy.round().clamp(0, kGridHeight - 1),
      );

      for (var linePoint in _currentLinePoints) {
        if (linePoint == jormungandGridPos) {
          _loseLife();
          return; // Quitte la fonction pour éviter de perdre plusieurs vies en une frame.
        }
      }
    }

    // La collision avec les sparks n'a pas été modifiée, elle est toujours basée sur la distance.
    for (var spark in _sparks) {
      if ((spark.position - _playerPosition).distance < 8) {
        _loseLife();
        return;
      }
    }
  }

  void _checkVictory() {
    // La condition de victoire est d'avoir conquis 75% du territoire TOTAL (y compris les bordures)
    if (_territoryConquered >= 0.75) {
      _gameRunning = false;
      _showVictoryDialog();
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppDialog(
        icon: Icons.celebration,
        title: 'Victoire !',
        content: Text(
          'Jörmungand a été vaincu!\n\nScore final: $_score\nTerritoire conquis: ${(_territoryConquered * 100).toStringAsFixed(1)}%',
          style: const TextStyle(color: Color(0xFFC5CAE9)),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onGameOver();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF81D4FA).withAlpha(51),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Menu Principal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changePlayerDirection(String newDirection) {
    if ((_currentDirection == 'up' && newDirection == 'down') ||
        (_currentDirection == 'down' && newDirection == 'up') ||
        (_currentDirection == 'left' && newDirection == 'right') ||
        (_currentDirection == 'right' && newDirection == 'left')) {
      return;
    }
    setState(() {
      _currentDirection = newDirection;
      _autoMove = true;
      _atCorner = false;
    });
  }

  @override
  void dispose() {
    // On s'assure de bien arrêter tous les timers et contrôleurs
    _countdownTimer?.cancel();
    _jormungandController.stop();
    _jormungandController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Le reste des méthodes...
  @override
  Widget build(BuildContext context) {
    // ...
    // Le widget principal est maintenant le GamePainter qui dessine la grille
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      autofocus: true,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                // Header...
                Expanded(
                  child: Center(
                    child: Container(
                      width: gameWidth,
                      height: gameHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1a1a2e),
                        border: Border.all(
                          color: const Color(0xFFFF6B35),
                          width: 3.0,
                        ),
                      ),
                      child: CustomPaint(
                        painter: GamePainter(
                          grid: _grid,
                          scaleX: _scaleX,
                          scaleY: _scaleY,
                          jormungandPos: _jormungandPosition,
                          playerPos: _playerPosition,
                          isDrawing: _isDrawing,
                          slowDraw: _slowDraw,
                          jormungandAnim: _jormungandController.value,
                        ),
                        size: Size(gameWidth, gameHeight),
                      ),
                    ),
                  ),
                ),
                // Contrôles...
              ],
            ),
            if (!_isGameReady && _gameRunning)
              Container(
                color: Colors.black54,
                alignment: Alignment.center,
                child: Text(
                  _countdownMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SparK {
  Offset position;
  Offset velocity;
  final bool horizontal;

  SparK(this.position, this.velocity, this.horizontal);

  void update() {
    position = position + velocity;

    if (horizontal) {
      if (position.dx <= 0 && velocity.dx < 0) {
        velocity = Offset(-velocity.dx, velocity.dy);
      }
      if (position.dx >= gameWidth && velocity.dx > 0) {
        velocity = Offset(-velocity.dx, velocity.dy);
      }
    } else {
      if (position.dy <= 0 && velocity.dy < 0) {
        velocity = Offset(velocity.dx, -velocity.dy);
      }
      if (position.dy >= gameHeight && velocity.dy > 0) {
        velocity = Offset(velocity.dx, -velocity.dy);
      }
    }
  }
}

// ===================================================================
// PAINTER ENTIÈREMENT REVU POUR DESSINER LA GRILLE
// ===================================================================
class GamePainter extends CustomPainter {
  final List<List<int>> grid;
  final double scaleX, scaleY;
  final Offset jormungandPos;
  final Offset playerPos;
  final bool isDrawing;
  final bool slowDraw;
  final double jormungandAnim;

  GamePainter({
    required this.grid,
    required this.scaleX,
    required this.scaleY,
    required this.jormungandPos,
    required this.playerPos,
    required this.isDrawing,
    required this.slowDraw,
    required this.jormungandAnim,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final emptyPaint = Paint()..color = const Color(0xFF1a1a2e);
    final filledPaint = Paint()
      ..color = const Color(0xFFFF6B35).withAlpha((255 * 0.3).toInt());
    final linePaint = Paint()..color = slowDraw ? Colors.amber : Colors.white;

    // 1. Dessine l'état de la grille
    for (int x = 0; x < grid.length; x++) {
      for (int y = 0; y < grid[x].length; y++) {
        Paint currentPaint;
        switch (grid[x][y]) {
          case kGridFilled:
            currentPaint = filledPaint;
            break;
          case kGridPath:
            currentPaint = linePaint;
            break;
          default:
            currentPaint = emptyPaint;
        }
        canvas.drawRect(
          Rect.fromLTWH(x * scaleX, y * scaleY, scaleX, scaleY),
          currentPaint,
        );
      }
    }

    // 2. Dessine Jörmungand
    final jormungandPaint = Paint()
      ..color = Colors.green.withAlpha(
        (255 * (0.8 + 0.2 * sin(jormungandAnim * 2 * pi))).toInt(),
      );
    canvas.drawCircle(
      Offset(jormungandPos.dx * scaleX, jormungandPos.dy * scaleY),
      8,
      jormungandPaint,
    );

    // 3. Dessine le joueur
    final playerPaint = Paint()
      ..color = isDrawing
          ? Colors.cyan.withAlpha((255 * 0.5).toInt())
          : Colors.cyan;
    canvas.drawCircle(
      Offset(playerPos.dx * scaleX, playerPos.dy * scaleY),
      4,
      playerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
