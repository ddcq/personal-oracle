import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:collection';

import 'player.dart';
import 'constants.dart' as game_constants;
import 'qix_game.dart';
import 'qix.dart';
import 'package:oracle_d_asgard/utils/int_vector2.dart';

class FloodFillResult {
  final List<IntVector2> points;
  final bool containsQix;

  FloodFillResult(this.points, this.containsQix);
}

class ArenaComponent extends PositionComponent with HasGameReference<QixGame> {
  late ui.Image _rewardCardImage;
  final int gridSize;
  final double cellSize;
  final String? rewardCardImagePath;

  late List<List<int>> _grid; // 0: free, 1: filled, 2: path, 3: edge
  final List<IntVector2> _currentDrawingPath = [];
  int _nonFreeCells = 0;

  late final Paint _boundaryPaint;
  late final Paint _pathPaint;
  late final Map<int, Sprite> _filledSprites;
  final List<IntVector2> _boundaryPoints = [];
  late final Map<IntVector2, Rect> _cellRects;
  late QixComponent _qixComponent;

  ArenaComponent({required this.gridSize, required this.cellSize, this.rewardCardImagePath}) {
    var arenaDoubleSize = (gridSize * cellSize).toDouble();
    size = Vector2(arenaDoubleSize, arenaDoubleSize);
    position = Vector2.zero();
    _initializeGrid();
    final Random random = Random();
    final IntVector2 initialQixPosition = IntVector2(20 + random.nextInt(gridSize - 40), 20 + random.nextInt(gridSize - 40));

    _boundaryPaint = Paint()
      ..color = Colors.blue[900]!
      ..isAntiAlias = false;
    _pathPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    _filledSprites = {};

    _qixComponent = QixComponent(
      gridPosition: initialQixPosition,
      cellSize: cellSize,
      gridSize: gridSize,
      isGridEdge: isPointOnBoundary,
      isPlayerPath: isPointOnCurrentDrawingPath,
      onGameOver: () => game.gameOver(),
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
      _rewardCardImage = await game.images.load('assets/images/cards/chibi/fenrir.jpg');
    }

    // Pre-calculate sprites for filled areas
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final double sourceX = (x / gridSize) * _rewardCardImage.width;
        final double sourceY = (y / gridSize) * _rewardCardImage.height;
        final double sourceWidth = _rewardCardImage.width / gridSize;
        final double sourceHeight = _rewardCardImage.height / gridSize;

        _filledSprites[y * gridSize + x] = Sprite(_rewardCardImage, srcPosition: Vector2(sourceX, sourceY), srcSize: Vector2(sourceWidth, sourceHeight));
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
      if (value == game_constants.kGridEdge || value == game_constants.kGridFilled) {
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
    _grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => game_constants.kGridFree));

    _boundaryPoints.clear();
    _nonFreeCells = 0; // Initialize to 0 as border cells don’t count
    _cellRects = {};

    // Initialize outer boundary
    for (int x = 0; x < gridSize; x++) {
      _grid[0][x] = game_constants.kGridEdge;
      _grid[gridSize - 1][x] = game_constants.kGridEdge;
      _grid[x][0] = game_constants.kGridEdge;
      _grid[x][gridSize - 1] = game_constants.kGridEdge;
      _boundaryPoints.add(IntVector2(x, 0));
      _boundaryPoints.add(IntVector2(x, gridSize - 1));
      _boundaryPoints.add(IntVector2(0, x));
      _boundaryPoints.add(IntVector2(gridSize - 1, x));
    }

    // Pre-calculate Rects for all grid cells
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        _cellRects[IntVector2(x, y)] = Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize);
      }
    }
  }

  bool isPointOnBoundary(IntVector2 point) {
    int x = point.x;
    int y = point.y;
    if (x < 0 || x >= gridSize || y < 0 || y >= gridSize) return false;
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

  List<IntVector2> fillArea(List<IntVector2> playerPath, IntVector2 pathStartGridPosition, IntVector2 pathEndGridPosition) {
    List<IntVector2> newlyFilledPoints = [];

    // Step 1: Mark the player's path as a permanent edge on the grid.
    // This ensures the drawn line becomes part of the game's boundaries.
    for (var point in playerPath) {
      _setGridValue(point.x, point.y, game_constants.kGridEdge);
      _boundaryPoints.add(point);
    }

    // Step 2: Identify all distinct enclosed regions within the arena.
    // This is done by performing flood-fill operations from all 'free' (unfilled) cells.
    List<FloodFillResult> identifiedRegions = [];
    List<List<bool>> visitedCells = List.generate(gridSize, (_) => List.generate(gridSize, (_) => false));

    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        // If a cell is free and hasn’t been visited yet, it’s part of a new region.
        if (_grid[y][x] == game_constants.kGridFree && !visitedCells[y][x]) {
          FloodFillResult result = _floodFill(x, y, visitedCells);
          if (result.points.isNotEmpty) {
            identifiedRegions.add(result);
          }
        }
      }
    }

    // Step 3: Determine which of the identified regions contains the Qix (enemy).
    // The region containing the Qix should NOT be filled.
    int qixContainingRegionIndex = identifiedRegions.indexWhere((region) => region.containsQix);

    // Step 4: Fill all regions that do NOT contain the Qix.
    // These are the areas successfully claimed by the player.
    for (int i = 0; i < identifiedRegions.length; i++) {
      if (i == qixContainingRegionIndex) continue;
      for (final point in identifiedRegions[i].points) {
        _setGridValue(point.x, point.y, game_constants.kGridFilled);
        newlyFilledPoints.add(point);
      }
    }

    // After filling, re-evaluate edges that might have become fully enclosed
    // and convert them to filled areas.
    _demoteEnclosedEdges(newlyFilledPoints, playerPath);
    calculateFilledPercentage();
    return newlyFilledPoints;
  }

  void _demoteEnclosedEdges(List<IntVector2> newlyFilledPoints, List<IntVector2> playerPath) {
    // Create a set to store unique points to check to avoid redundant processing
    Set<IntVector2> pointsToCheck = {};

    // Add all newly filled points and their immediate neighbors to the set
    for (IntVector2 filledPoint in newlyFilledPoints) {
      pointsToCheck.add(filledPoint);
      for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
          if (dx == 0 && dy == 0) continue;
          IntVector2 neighbor = IntVector2(filledPoint.x + dx, filledPoint.y + dy);
          if (neighbor.x >= 0 && neighbor.x < gridSize && neighbor.y >= 0 && neighbor.y < gridSize) {
            pointsToCheck.add(neighbor);
          }
        }
      }
    }

    // Add all points from the player's path and their immediate neighbors to the set
    for (IntVector2 pathPoint in playerPath) {
      pointsToCheck.add(pathPoint);
      for (final neighbor in pathPoint.allNeighbors) {
        if (neighbor.x >= 0 && neighbor.x < gridSize && neighbor.y >= 0 && neighbor.y < gridSize) {
          pointsToCheck.add(neighbor);
        }
      }
    }

    final Set<IntVector2> demotedPoints = {};
    // Iterate only over the points that might have changed their enclosure status
    for (IntVector2 p in pointsToCheck) {
      int x = p.x;
      int y = p.y;

      if (_grid[y][x] == game_constants.kGridEdge) {
        bool isEnclosed = true;
        // Check 8 neighbors
        for (IntVector2 neighbor in p.allNeighbors) {
          if (neighbor.isInBounds(0, gridSize - 1, 0, gridSize - 1) && _isFree(neighbor)) {
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
    _boundaryPoints.removeWhere((p) => demotedPoints.contains(p));
  }

  FloodFillResult _floodFill(int startX, int startY, List<List<bool>> visited) {
    List<IntVector2> filledPoints = [];
    Queue<IntVector2> queue = Queue();
    bool containsQix = false;

    IntVector2 startPoint = IntVector2(startX, startY);
    if (!startPoint.isInBounds(0, gridSize - 1, 0, gridSize - 1) || _grid[startY][startX] != game_constants.kGridFree || visited[startY][startX]) {
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
    game.updateFilledPercentage((_nonFreeCells / (innerGridSize * innerGridSize)));
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
    if (game.player.state == PlayerState.onEdge && !_isEdge(game.player.gridPosition)) {
      rescuePlayer(game.player.gridPosition);
    }
  }

  @override
  void render(Canvas canvas) {
    // Render filled areas (including boundaries)
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (_grid[y][x] == game_constants.kGridFilled) {
          final sprite = _filledSprites[y * gridSize + x];
          if (sprite != null) {
            sprite.render(
              canvas,
              position: Vector2(x * cellSize, y * cellSize),
              size: Vector2.all(cellSize),
              overridePaint: _boundaryPaint, // Using boundaryPaint for filled areas for now
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
      path.moveTo(_currentDrawingPath.first.x * cellSize + cellSize / 2, _currentDrawingPath.first.y * cellSize + cellSize / 2);
      for (int i = 1; i < _currentDrawingPath.length; i++) {
        path.lineTo(_currentDrawingPath[i].x * cellSize + cellSize / 2, _currentDrawingPath[i].y * cellSize + cellSize / 2);
      }
      canvas.drawPath(path, _pathPaint);
    }
  }
}
