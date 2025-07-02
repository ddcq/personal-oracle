import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_painter.dart';
import 'model.dart';
import 'constants.dart';


// --- Classes pour représenter l'état du jeu

// Représente un point entier (similaire à la struct 'point')


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qix Flutter',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // --- État du jeu
  late Timer _gameLoopTimer;
  late Coordinate _playerPos;
  late List<bool> _pixels; // Grille de pixels (true = rempli)
  late List<Bar> _bars;
  late List<Coordinate> _currentPath;

  // Pour la gestion des entrées clavier
  final Set<LogicalKeyboardKey> _pressedKeys = {};
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _startGame();
    
    // Le timer qui agit comme la `loop()` du C++
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _updateGame();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _startGame() {
    _playerPos = Coordinate(screenWidth ~/ 2, 0);
    _currentPath = [];

    // Initialisation de la grille de pixels
    _pixels = List.generate(screenWidth * screenHeight, (index) => false);
    // Dessiner les bordures initiales
    for (int x = 0; x < screenWidth; x++) {
      _setPixel(x, 0, true);
      _setPixel(x, screenHeight - 1, true);
    }
    for (int y = 0; y < screenHeight; y++) {
      _setPixel(0, y, true);
      _setPixel(screenWidth - 1, y, true);
    }

    // Initialisation des barres
    _bars = [
      Bar(
        MovingPoint(Coordinate(12, 12), -0.5, -0.7),
        MovingPoint(Coordinate(40, 40), 0.7, 0.5),
      ),
    ];
    // Ajoute des barres "fantômes" pour l'effet de traînée
    for (int i = 0; i < barCount - 1; i++) {
      _bars.add(Bar(
        MovingPoint(Coordinate(_bars[0].p1.pos.x, _bars[0].p1.pos.y), 0, 0),
        MovingPoint(Coordinate(_bars[0].p2.pos.x, _bars[0].p2.pos.y), 0, 0),
      ));
    }
  }

  bool _getPixel(int x, int y) {
    if (x < 0 || x >= screenWidth || y < 0 || y >= screenHeight) return true;
    return _pixels[y * screenWidth + x];
  }

  void _setPixel(int x, int y, bool value) {
    if (x < 0 || x >= screenWidth || y < 0 || y >= screenHeight) return;
    _pixels[y * screenWidth + x] = value;
  }

  void _updateGame() {
    Coordinate prevPlayerPos = Coordinate(_playerPos.x, _playerPos.y);
    bool isDrawing = _currentPath.isNotEmpty;
    bool moved = false;

    if (_pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
      _playerPos.x -= 1;
      moved = true;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
      _playerPos.x += 1;
      moved = true;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.arrowUp)) {
      _playerPos.y -= 1;
      moved = true;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.arrowDown)) {
      _playerPos.y += 1;
      moved = true;
    }
    
    _playerPos.x = _playerPos.x.clamp(0, screenWidth - 1);
    _playerPos.y = _playerPos.y.clamp(0, screenHeight - 1);

    bool isCurrentlyOnFilledPixel = _getPixel(_playerPos.x, _playerPos.y);
    bool wasOnFilledPixel = _getPixel(prevPlayerPos.x, prevPlayerPos.y);

    if (wasOnFilledPixel && !isCurrentlyOnFilledPixel) {
      _currentPath = [prevPlayerPos, _playerPos];
    } 
    else if (!isCurrentlyOnFilledPixel && moved) {
      _currentPath.add(Coordinate(_playerPos.x, _playerPos.y));
    } 
    else if (isCurrentlyOnFilledPixel && isDrawing) {
      _fillNewArea();
      _currentPath = [];
    }
    
    for (int i = _bars.length - 1; i > 0; i--) {
        _bars[i].p1.pos = Coordinate(_bars[i-1].p1.pos.x, _bars[i-1].p1.pos.y);
        _bars[i].p2.pos = Coordinate(_bars[i-1].p2.pos.x, _bars[i-1].p2.pos.y);
    }

    Bar mainBar = _bars[0];
    mainBar.p1.pos.x = (mainBar.p1.pos.x + mainBar.p1.dirX).round();
    mainBar.p1.pos.y = (mainBar.p1.pos.y + mainBar.p1.dirY).round();
    mainBar.p2.pos.x = (mainBar.p2.pos.x + mainBar.p2.dirX).round();
    mainBar.p2.pos.y = (mainBar.p2.pos.y + mainBar.p2.dirY).round();

    _handleBarCollisions(mainBar.p1);
    _handleBarCollisions(mainBar.p2);

    setState(() {});
  }
  
  void _handleBarCollisions(MovingPoint p) {
    if (!_getPixel(p.pos.x, p.pos.y)) return;

    bool hitVertical = _getPixel(p.pos.x - 1, p.pos.y) || _getPixel(p.pos.x + 1, p.pos.y);
    bool hitHorizontal = _getPixel(p.pos.x, p.pos.y - 1) || _getPixel(p.pos.x, p.pos.y + 1);

    if (hitVertical) {
      p.dirX = -p.dirX;
    }
    if (hitHorizontal) {
      p.dirY = -p.dirY;
    }
    
    p.pos.x = (p.pos.x + p.dirX).round().clamp(0, screenWidth - 1);
    p.pos.y = (p.pos.y + p.dirY).round().clamp(0, screenHeight - 1);
  }

  void _fillNewArea() {
    for (int i = 0; i < _currentPath.length - 1; i++) {
        _drawLineOnPixels(_currentPath[i], _currentPath[i+1]);
    }
    
    Coordinate? seed1;
    Coordinate? seed2;

    Coordinate p1 = _currentPath[_currentPath.length - 2];
    Coordinate p2 = _currentPath.last;
    int midX = ((p1.x + p2.x) / 2).round();
    int midY = ((p1.y + p2.y) / 2).round();

    if(p1.x == p2.x) { 
      if(!_getPixel(midX - 1, midY)) seed1 = Coordinate(midX - 1, midY);
      if(!_getPixel(midX + 1, midY)) seed2 = Coordinate(midX + 1, midY);
    } else { 
      if(!_getPixel(midX, midY - 1)) seed1 = Coordinate(midX, midY - 1);
      if(!_getPixel(midX, midY + 1)) seed2 = Coordinate(midX, midY + 1);
    }

    List<Coordinate> fillArea1 = (seed1 != null) ? _floodFill(seed1) : [];
    List<Coordinate> fillArea2 = (seed2 != null) ? _floodFill(seed2) : [];
    
    bool area1ContainsQix = fillArea1.any((p) => p == _bars.first.p1.pos || p == _bars.first.p2.pos);
    bool area2ContainsQix = fillArea2.any((p) => p == _bars.first.p1.pos || p == _bars.first.p2.pos);

    List<Coordinate> areaToFill;
    if (area1ContainsQix) {
        areaToFill = fillArea2;
    } else if (area2ContainsQix) {
        areaToFill = fillArea1;
    } else {
        areaToFill = (fillArea1.length < fillArea2.length) ? fillArea1 : fillArea2;
    }

    for (var p in areaToFill) {
      _setPixel(p.x, p.y, true);
    }
  }
  
  List<Coordinate> _floodFill(Coordinate startNode) {
    List<Coordinate> filledPoints = [];
    Queue<Coordinate> queue = Queue();

    if (_getPixel(startNode.x, startNode.y)) return filledPoints;
    
    queue.add(startNode);
    Set<Coordinate> visited = {startNode};

    while (queue.isNotEmpty) {
      Coordinate current = queue.removeFirst();
      filledPoints.add(current);

      const dx = [0, 0, 1, -1];
      const dy = [1, -1, 0, 0];

      for (int i = 0; i < 4; i++) {
        Coordinate next = Coordinate(current.x + dx[i], current.y + dy[i]);
        if (next.x >= 0 && next.x < screenWidth && next.y >= 0 && next.y < screenHeight) {
          if (!_getPixel(next.x, next.y) && !visited.contains(next)) {
            visited.add(next);
            queue.add(next);
          }
        }
      }
    }
    return filledPoints;
  }
  
  void _drawLineOnPixels(Coordinate p0, Coordinate p1) {
    int x0 = p0.x, y0 = p0.y;
    int x1 = p1.x, y1 = p1.y;
    int dx = (x1 - x0).abs();
    int dy = (y1 - y0).abs();
    int sx = (x0 < x1) ? 1 : -1;
    int sy = (y0 < y1) ? 1 : -1;
    int err = dx - dy;

    while (true) {
      _setPixel(x0, y0, true);
      if ((x0 == x1) && (y0 == y1)) break;
      int e2 = 2 * err;
      if (e2 > -dy) {
        err -= dy;
        x0 += sx;
      }
      if (e2 < dx) {
        err += dx;
        y0 += sy;
      }
    }
  }

  @override
  void dispose() {
    _gameLoopTimer.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qix Game in Flutter')),
      body: Center(
        child: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: (event) {
            if (event is KeyDownEvent) {
              _pressedKeys.add(event.logicalKey);
            } else if (event is KeyUpEvent) {
              _pressedKeys.remove(event.logicalKey);
            }
          },
          child: AspectRatio(
            aspectRatio: screenWidth / screenHeight,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              color: Colors.black,
              child: CustomPaint(
                painter: GamePainter(
                  pixels: _pixels,
                  playerPos: _playerPos,
                  bars: _bars,
                  currentPath: _currentPath,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text("Utilisez les flèches du clavier pour vous déplacer.", textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
