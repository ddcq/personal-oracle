import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:collection';

import 'constants.dart' as game_constants;
import 'qix_game.dart';

class ArenaComponent extends PositionComponent with HasGameReference<QixGame> {
  late ui.Image _rewardCardImage;
  final double gridSize;
  final double cellSize;

  late List<List<int>> _grid; // 0: free, 1: filled, 2: path, 3: edge
  final List<Vector2> _currentDrawingPath = [];
  late Vector2 _virtualQixPosition;

  late final Paint _boundaryPaint;
  late final Paint _pathPaint;
  late final Map<int, Sprite> _filledSprites;

  ArenaComponent({required this.gridSize, required this.cellSize}) {
    size = Vector2(
      (gridSize * cellSize).toDouble(),
      (gridSize * cellSize).toDouble(),
    );
    position = Vector2.zero();
    _initializeGrid();
    _virtualQixPosition = Vector2(
      gridSize / 2,
      gridSize / 2,
    ); // Center of the arena

    _boundaryPaint = Paint()
      ..color = Colors.blue[900]!
      ..isAntiAlias = false;
    _pathPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    _filledSprites = {};
  }

  @override
  Future<void> onLoad() async {
    _rewardCardImage = await game.images.load('fenrir_card.jpg');

    // Pre-calculate sprites for filled areas
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final double sourceX = (x / gridSize) * _rewardCardImage.width;
        final double sourceY = (y / gridSize) * _rewardCardImage.height;
        final double sourceWidth = (1 / gridSize) * _rewardCardImage.width;
        final double sourceHeight = (1 / gridSize) * _rewardCardImage.height;

        _filledSprites[y * gridSize.toInt() + x] = Sprite(
          _rewardCardImage,
          srcPosition: Vector2(sourceX, sourceY),
          srcSize: Vector2(sourceWidth, sourceHeight),
        );
      }
    }
  }

  void _setGridValue(int x, int y, int value) {
    _grid[y][x] = value;
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

  void startPath(Vector2 startPoint) {
    _currentDrawingPath.clear();
    _currentDrawingPath.add(startPoint);
  }

  void addPathPoint(Vector2 point) {
    _currentDrawingPath.add(point);
  }

  void endPath() {
    _currentDrawingPath.clear();
  }

  void _initializeGrid() {
    _grid = List.generate(
      gridSize.toInt(),
      (_) => List.generate(gridSize.toInt(), (_) => game_constants.kGridFree),
    );

    // Initialize outer boundary
    for (int x = 0; x < gridSize; x++) {
      _setGridValue(x, 0, game_constants.kGridEdge);
      _setGridValue(x, gridSize.toInt() - 1, game_constants.kGridEdge);
    }
    for (int y = 0; y < gridSize; y++) {
      _setGridValue(0, y, game_constants.kGridEdge);
      _setGridValue(gridSize.toInt() - 1, y, game_constants.kGridEdge);
    }
  }

  bool isPointOnBoundary(Vector2 point) {
    int x = point.x.toInt();
    int y = point.y.toInt();
    if (x < 0 || x >= gridSize || y < 0 || y >= gridSize) return false;
    return _grid[y][x] == game_constants.kGridEdge;
  }

  int getGridValue(int x, int y) {
    return _grid[y][x];
  }

  // Helper to check if a list of Vector2 contains a specific point by value
  bool _regionContainsPoint(List<Vector2> region, Vector2 point) {
    for (var p in region) {
      if (p.x.toInt() == point.x.toInt() && p.y.toInt() == point.y.toInt()) {
        return true;
      }
    }
    return false;
  }

  void fillArea(
    List<Vector2> playerPath,
    Vector2 pathStartGridPosition,
    Vector2 pathEndGridPosition,
  ) {
    // Step 1: Mark the player's path as a permanent edge on the grid.
    // This ensures the drawn line becomes part of the game's boundaries.
    for (var point in playerPath) {
      _setGridValue(point.x.toInt(), point.y.toInt(), game_constants.kGridEdge);
    }

    // Step 2: Identify all distinct enclosed regions within the arena.
    // This is done by performing flood-fill operations from all 'free' (unfilled) cells.
    List<List<Vector2>> identifiedRegions = [];
    List<List<bool>> visitedCells = List.generate(
      gridSize.toInt(),
      (_) => List.generate(gridSize.toInt(), (_) => false),
    );

    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        // If a cell is free and hasn't been visited yet, it's part of a new region.
        if (_grid[y][x] == game_constants.kGridFree && !visitedCells[y][x]) {
          List<Vector2> currentRegion = _floodFill(x, y, visitedCells);
          if (currentRegion.isNotEmpty) {
            identifiedRegions.add(currentRegion);
          }
        }
      }
    }

    // Step 3: Determine which of the identified regions contains the Qix (enemy).
    // The region containing the Qix should NOT be filled.
    int qixContainingRegionIndex = -1;
    for (int i = 0; i < identifiedRegions.length; i++) {
      if (_regionContainsPoint(identifiedRegions[i], _virtualQixPosition)) {
        qixContainingRegionIndex = i;
        break;
      }
    }

    // Step 4: Fill all regions that do NOT contain the Qix.
    // These are the areas successfully claimed by the player.
    for (int i = 0; i < identifiedRegions.length; i++) {
      if (i != qixContainingRegionIndex) {
        for (var pointInRegion in identifiedRegions[i]) {
          _setGridValue(pointInRegion.x.toInt(), pointInRegion.y.toInt(), game_constants.kGridFilled);
        }
      }
    }

    // After filling, re-evaluate edges that might have become fully enclosed
    // and convert them to filled areas.
    _demoteEnclosedEdges();
  }

  void _demoteEnclosedEdges() {
    for (int y = 1; y < gridSize - 1; y++) {
      for (int x = 1; x < gridSize - 1; x++) {
        if (_grid[y][x] == game_constants.kGridEdge) {
          bool isEnclosed = true;
          final neighbors = [
            _grid[y - 1][x], // N
            _grid[y + 1][x], // S
            _grid[y][x - 1], // W
            _grid[y][x + 1], // E
            _grid[y - 1][x - 1], // NW
            _grid[y - 1][x + 1], // NE
            _grid[y + 1][x - 1], // SW
            _grid[y + 1][x + 1], // SE
          ];
          for (var neighbor in neighbors) {
            if (neighbor == game_constants.kGridFree) {
              isEnclosed = false;
              break;
            }
          }
          if (isEnclosed) {
            _setGridValue(x, y, game_constants.kGridFilled);
          }
        }
      }
    }
  }

  List<Vector2> _floodFill(int startX, int startY, List<List<bool>> visited) {
    List<Vector2> filledPoints = [];
    Queue<Vector2> queue = Queue();

    if (startX < 0 ||
        startX >= gridSize ||
        startY < 0 ||
        startY >= gridSize ||
        _grid[startY][startX] != game_constants.kGridFree ||
        visited[startY][startX]) {
      return filledPoints;
    }

    queue.add(Vector2(startX.toDouble(), startY.toDouble()));
    visited[startY][startX] = true;

    final dx = [0, 0, 1, -1];
    final dy = [1, -1, 0, 0];

    while (queue.isNotEmpty) {
      Vector2 current = queue.removeFirst();
      filledPoints.add(current);

      for (int i = 0; i < 4; i++) {
        int nextX = current.x.toInt() + dx[i];
        int nextY = current.y.toInt() + dy[i];

        if (nextX >= 0 && nextX < gridSize && nextY >= 0 && nextY < gridSize) {
          if (_grid[nextY][nextX] == game_constants.kGridFree &&
              !visited[nextY][nextX]) {
            visited[nextY][nextX] = true;
            queue.add(Vector2(nextX.toDouble(), nextY.toDouble()));
          }
        }
      }
    }
    return filledPoints;
  }

  // Finds the nearest boundary point to a given point
  Vector2 findNearestBoundaryPoint(Vector2 point) {
    Vector2 nearestPoint = Vector2.zero();
    double minDistance = double.infinity;

    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (_grid[y][x] == game_constants.kGridEdge) {
          Vector2 boundaryPoint = Vector2(x.toDouble(), y.toDouble());
          double distance = point.distanceTo(boundaryPoint);
          if (distance < minDistance) {
            minDistance = distance;
            nearestPoint = boundaryPoint;
          }
        }
      }
    }
    return nearestPoint;
  }

  @override
  void render(Canvas canvas) {
    // Render filled areas (including boundaries)
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (_grid[y][x] == game_constants.kGridFilled) {
          final sprite = _filledSprites[y * gridSize.toInt() + x];
          if (sprite != null) {
            sprite.render(
              canvas,
              position: Vector2(x * cellSize, y * cellSize),
              size: Vector2.all(cellSize),
              overridePaint: _boundaryPaint, // Using boundaryPaint for filled areas for now
            );
          }
        } else if (_grid[y][x] == game_constants.kGridEdge) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            _boundaryPaint,
          );
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
