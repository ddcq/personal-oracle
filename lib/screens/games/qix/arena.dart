import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:collection';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

import 'package:oracle_d_asgard/screens/games/qix/player.dart';
import 'package:oracle_d_asgard/screens/games/qix/constants.dart'
    as game_constants;
import 'package:oracle_d_asgard/screens/games/qix/qix_game.dart';
import 'package:oracle_d_asgard/screens/games/qix/qix.dart';

class FloodFillResult {
  final List<IntVector2> points;
  final bool containsQix;

  FloodFillResult(this.points, this.containsQix);
}

class ArenaComponent extends PositionComponent with HasGameReference<QixGame> {
  static const MaterialColor _boundaryColor = Colors.blue;
  static const Color _pathColor = Colors.blue;
  static const double _pathStrokeWidth = 2.0;
  static const int _qixInitialPositionPadding = 20;
  static const String _defaultRewardCardImagePath = 'cards/chibi/fenrir.webp';

  late ui.Image _rewardCardImage;
  late ui.Image _undiscoveredAreaImage; // Add this line
  final int gridSize;
  final double cellSize;
  final String? rewardCardImagePath;
  final ui.Image snakeHeadImage;
  final int difficulty;

  late List<List<int>> _grid; // 0: free, 1: filled, 2: path, 3: edge
  final List<IntVector2> _currentDrawingPath = [];
  int _nonFreeCells = 0;

  late final Paint _boundaryPaint;
  late final Paint _pathPaint;
  late final Map<int, Sprite> _filledSprites;
  final List<IntVector2> _boundaryPoints = [];
  late final Map<IntVector2, Rect> _cellRects;
  late QixComponent _qixComponent;

  ArenaComponent({
    required this.gridSize,
    required this.cellSize,
    this.rewardCardImagePath,
    required this.snakeHeadImage,
    required this.difficulty,
  }) : super(
         size: Vector2(gridSize * cellSize, gridSize * cellSize),
         position: Vector2.zero(),
       ) {
    _initializeGrid();
    final Random random = Random();
    final IntVector2 initialQixPosition = IntVector2(
      _qixInitialPositionPadding +
          random.nextInt(gridSize - 2 * _qixInitialPositionPadding),
      _qixInitialPositionPadding +
          random.nextInt(gridSize - 2 * _qixInitialPositionPadding),
    );

    _boundaryPaint = Paint()
      ..color = _boundaryColor
          .shade900 // Use a darker shade for boundary
      ..isAntiAlias = false;
    _pathPaint = Paint()
      ..color = _pathColor
      ..strokeWidth = _pathStrokeWidth
      ..style = PaintingStyle.stroke;
    _filledSprites = {};

    _qixComponent = QixComponent(
      initialGridPosition: initialQixPosition,
      cellSize: cellSize,
      gridSize: gridSize,
      isGridEdge: isPointOnBoundary,
      isPlayerPath: isPointOnCurrentDrawingPath,
      onGameOver: () => game.gameOver(),
      snakeHeadImage: snakeHeadImage,
      difficulty: difficulty,
    );
    add(_qixComponent);
  }

  bool isPointOnCurrentDrawingPath(IntVector2 point) {
    return _currentDrawingPath.contains(point);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (rewardCardImagePath != null) {
      _rewardCardImage = await game.images.load(rewardCardImagePath!);
    } else {
      // Load a default image if no reward card image is provided
      _rewardCardImage = await game.images.load(_defaultRewardCardImagePath);
    }
    _undiscoveredAreaImage = await game.images.load(
      'qix/grass.webp',
    ); // Load the image for undiscovered areas

    // Pre-calculate sprites for filled areas
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final double sourceX = (x / gridSize) * _rewardCardImage.width;
        final double sourceY = (y / gridSize) * _rewardCardImage.height;
        final double sourceWidth = _rewardCardImage.width / gridSize;
        final double sourceHeight = _rewardCardImage.height / gridSize;

        _filledSprites[y * gridSize + x] = Sprite(
          _rewardCardImage,
          srcPosition: Vector2(sourceX, sourceY),
          srcSize: Vector2(sourceWidth, sourceHeight),
        );
      }
    }
    calculateFilledPercentage();
  }

  void _setGridValue(int x, int y, int value) {
    int oldValue = _grid[y][x];
    _grid[y][x] = value;

    // Check if the cell is within the inner playable area (not border)
    bool isInnerCell = x > 0 && x < gridSize - 1 && y > 0 && y < gridSize - 1;

    if (isInnerCell && oldValue == game_constants.kGridFree) {
      if (value == game_constants.kGridEdge ||
          value == game_constants.kGridFilled) {
        _nonFreeCells++;
      }
    }
  }

  bool isFilled(int x, int y) {
    return _grid[y][x] == game_constants.kGridFilled;
  }

  bool isTraversable(int x, int y) {
    if (x < 0 || x >= gridSize || y < 0 || y >= gridSize) {
      return false;
    }
    return _grid[y][x] != game_constants.kGridFilled;
  }

  bool _isFree(IntVector2 position) {
    return _grid[position.y][position.x] == game_constants.kGridFree;
  }

  bool _isEdge(IntVector2 position) {
    return _grid[position.y][position.x] == game_constants.kGridEdge;
  }

  void startPath(IntVector2 startPoint) {
    _currentDrawingPath.clear();
    _currentDrawingPath.add(startPoint);
  }

  void addPathPoint(IntVector2 point) {
    _currentDrawingPath.add(point);
  }

  void endPath() {
    _currentDrawingPath.clear();
  }

  void _initializeGrid() {
    _grid = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => game_constants.kGridFree),
    );

    _boundaryPoints.clear();
    _nonFreeCells = 0; // Initialize to 0 as border cells don’t count
    _cellRects = {};

    // Initialize outer boundary
    for (int i = 0; i < gridSize; i++) {
      _setGridValue(i, 0, game_constants.kGridEdge);
      _setGridValue(i, gridSize - 1, game_constants.kGridEdge);
      _setGridValue(0, i, game_constants.kGridEdge);
      _setGridValue(gridSize - 1, i, game_constants.kGridEdge);

      _boundaryPoints.add(IntVector2(i, 0));
      _boundaryPoints.add(IntVector2(i, gridSize - 1));
      _boundaryPoints.add(IntVector2(0, i));
      _boundaryPoints.add(IntVector2(gridSize - 1, i));
    }

    // Pre-calculate Rects for all grid cells
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        _cellRects[IntVector2(x, y)] = Rect.fromLTWH(
          x * cellSize,
          y * cellSize,
          cellSize,
          cellSize,
        );
      }
    }
  }

  bool isPointOnBoundary(IntVector2 point) {
    int x = point.x;
    int y = point.y;
    if (x < 0 || x >= gridSize || y < 0 || y >= gridSize) return true;
    return _grid[y][x] == game_constants.kGridEdge;
  }

  void rescuePlayer(IntVector2 playerPosition) {
    if (!isPointOnBoundary(playerPosition)) {
      IntVector2 nearestBoundary = findNearestBoundaryPoint(playerPosition);
      game.player.teleportTo(nearestBoundary);
    }
  }

  int getGridValue(int x, int y) {
    return _grid[y][x];
  }

  List<IntVector2> fillArea(
    List<IntVector2> playerPath,
    IntVector2 pathStartGridPosition,
    IntVector2 pathEndGridPosition,
  ) {
    List<IntVector2> newlyFilledPoints = [];

    _markPlayerPathAsEdge(playerPath);

    List<List<bool>> visitedCells = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => false),
    );
    List<FloodFillResult> identifiedRegions = _identifyEnclosedRegions(
      visitedCells,
    );

    int qixContainingRegionIndex = identifiedRegions.indexWhere(
      (region) => region.containsQix,
    );

    _fillRegionsExcludingQix(
      identifiedRegions,
      qixContainingRegionIndex,
      newlyFilledPoints,
    );

    // After filling, re-evaluate edges that might have become fully enclosed
    // and convert them to filled areas.
    _demoteEnclosedEdges(newlyFilledPoints, playerPath);
    calculateFilledPercentage();
    return newlyFilledPoints;
  }

  void _markPlayerPathAsEdge(List<IntVector2> playerPath) {
    for (var point in playerPath) {
      _setGridValue(point.x, point.y, game_constants.kGridEdge);
      _boundaryPoints.add(point);
    }
  }

  List<FloodFillResult> _identifyEnclosedRegions(
    List<List<bool>> visitedCells,
  ) {
    List<FloodFillResult> identifiedRegions = [];
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (_grid[y][x] == game_constants.kGridFree && !visitedCells[y][x]) {
          FloodFillResult result = _floodFill(x, y, visitedCells);
          if (result.points.isNotEmpty) {
            identifiedRegions.add(result);
          }
        }
      }
    }
    return identifiedRegions;
  }

  void _fillRegionsExcludingQix(
    List<FloodFillResult> identifiedRegions,
    int qixContainingRegionIndex,
    List<IntVector2> newlyFilledPoints,
  ) {
    for (int i = 0; i < identifiedRegions.length; i++) {
      if (i == qixContainingRegionIndex) continue;
      for (final point in identifiedRegions[i].points) {
        _setGridValue(point.x, point.y, game_constants.kGridFilled);
        newlyFilledPoints.add(point);
      }
    }
  }

  void _demoteEnclosedEdges(
    List<IntVector2> newlyFilledPoints,
    List<IntVector2> playerPath,
  ) {
    Set<IntVector2> pointsToCheck = _getPointsToCheck(
      newlyFilledPoints,
      playerPath,
    );
    final Set<IntVector2> demotedPoints = {};
    _processPointsForDemotion(pointsToCheck, demotedPoints);
    _boundaryPoints.removeWhere((p) => demotedPoints.contains(p));
  }

  Set<IntVector2> _getPointsToCheck(
    List<IntVector2> newlyFilledPoints,
    List<IntVector2> playerPath,
  ) {
    Set<IntVector2> pointsToCheck = {};

    for (IntVector2 filledPoint in newlyFilledPoints) {
      pointsToCheck.add(filledPoint);
      for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
          if (dx == 0 && dy == 0) continue;
          IntVector2 neighbor = IntVector2(
            filledPoint.x + dx,
            filledPoint.y + dy,
          );
          if (neighbor.x >= 0 &&
              neighbor.x < gridSize &&
              neighbor.y >= 0 &&
              neighbor.y < gridSize) {
            pointsToCheck.add(neighbor);
          }
        }
      }
    }

    for (IntVector2 pathPoint in playerPath) {
      pointsToCheck.add(pathPoint);
      for (final neighbor in pathPoint.allNeighbors) {
        if (neighbor.x >= 0 &&
            neighbor.x < gridSize &&
            neighbor.y >= 0 &&
            neighbor.y < gridSize) {
          pointsToCheck.add(neighbor);
        }
      }
    }
    return pointsToCheck;
  }

  void _processPointsForDemotion(
    Set<IntVector2> pointsToCheck,
    Set<IntVector2> demotedPoints,
  ) {
    for (IntVector2 p in pointsToCheck) {
      int x = p.x;
      int y = p.y;

      if (_grid[y][x] == game_constants.kGridEdge) {
        bool isEnclosed = true;
        for (IntVector2 neighbor in p.allNeighbors) {
          if (neighbor.isInBounds(0, gridSize - 1, 0, gridSize - 1) &&
              _isFree(neighbor)) {
            isEnclosed = false;
            break;
          }
        }

        if (isEnclosed) {
          _setGridValue(x, y, game_constants.kGridFilled);
          demotedPoints.add(p);
        }
      }
    }
  }

  FloodFillResult _floodFill(int startX, int startY, List<List<bool>> visited) {
    List<IntVector2> filledPoints = [];
    Queue<IntVector2> queue = Queue();
    bool containsQix = false;

    IntVector2 startPoint = IntVector2(startX, startY);
    if (!startPoint.isInBounds(0, gridSize - 1, 0, gridSize - 1) ||
        _grid[startY][startX] != game_constants.kGridFree ||
        visited[startY][startX]) {
      return FloodFillResult(filledPoints, containsQix);
    }

    queue.add(IntVector2(startX, startY));
    visited[startY][startX] = true;

    while (queue.isNotEmpty) {
      IntVector2 current = queue.removeFirst();
      filledPoints.add(current);

      if (current == _qixComponent.gridPosition) {
        containsQix = true;
      }

      for (IntVector2 neighbor in current.cardinalNeighbors) {
        if (neighbor.isInBounds(0, gridSize - 1, 0, gridSize - 1)) {
          if (_isFree(neighbor) && !visited[neighbor.y][neighbor.x]) {
            visited[neighbor.y][neighbor.x] = true;
            queue.add(neighbor);
          }
        }
      }
    }
    return FloodFillResult(filledPoints, containsQix);
  }

  void calculateFilledPercentage() {
    final double innerGridSize = gridSize - 2;
    if (innerGridSize <= 0) {
      game.updateFilledPercentage(0.0);
      return;
    }
    game.updateFilledPercentage(
      (_nonFreeCells / (innerGridSize * innerGridSize)),
    );
  }

  // Finds the nearest boundary point to a given point
  IntVector2 findNearestBoundaryPoint(IntVector2 point) {
    IntVector2 nearestPoint = IntVector2(0, 0);
    double minDistanceSquared = double.infinity;

    for (IntVector2 boundaryPoint in _boundaryPoints) {
      int distanceSquared = point.distanceSquaredTo(boundaryPoint);
      if (distanceSquared < minDistanceSquared) {
        minDistanceSquared = distanceSquared.toDouble();
        nearestPoint = boundaryPoint;
      }
    }
    return nearestPoint;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.player.state == PlayerState.onEdge &&
        !_isEdge(game.player.gridPosition)) {
      rescuePlayer(game.player.gridPosition);
    }
  }

  @override
  void render(Canvas canvas) {
    // Render the undiscovered area image as a background
    final Paint backgroundPaint = Paint()
      ..colorFilter = const ColorFilter.mode(Colors.black54, BlendMode.darken);
    canvas.drawImageRect(
      _undiscoveredAreaImage,
      Rect.fromLTWH(
        0,
        0,
        _undiscoveredAreaImage.width.toDouble(),
        _undiscoveredAreaImage.height.toDouble(),
      ),
      Rect.fromLTWH(0, 0, size.x, size.y),
      backgroundPaint,
    );

    // Render filled areas and boundaries
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (_grid[y][x] == game_constants.kGridFilled) {
          final sprite = _filledSprites[y * gridSize + x];
          if (sprite != null) {
            sprite.render(
              canvas,
              position: Vector2(x * cellSize, y * cellSize),
              size: Vector2.all(cellSize),
            );
          }
        } else if (_grid[y][x] == game_constants.kGridEdge) {
          canvas.drawRect(_cellRects[IntVector2(x, y)]!, _boundaryPaint);
        }
      }
    }

    // Render current drawing path
    if (_currentDrawingPath.isNotEmpty) {
      final path = Path();
      path.moveTo(
        _currentDrawingPath.first.x * cellSize + cellSize / 2,
        _currentDrawingPath.first.y * cellSize + cellSize / 2,
      );
      for (int i = 1; i < _currentDrawingPath.length; i++) {
        path.lineTo(
          _currentDrawingPath[i].x * cellSize + cellSize / 2,
          _currentDrawingPath[i].y * cellSize + cellSize / 2,
        );
      }
      canvas.drawPath(path, _pathPaint);
    }
  }
}
