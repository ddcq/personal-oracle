import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'qix_game.dart';

class ArenaComponent extends PositionComponent with HasGameReference<QixGame> {
  final double gridSize;
  final double cellSize;

  late List<List<bool>> _grid; // true if filled (boundary or claimed area), false if empty
  late List<List<bool>> _boundaryGrid; // true if part of the current boundary
  List<Vector2> _currentDrawingPath = [];
  late Vector2 _virtualQixPosition;

  ArenaComponent({
    required this.gridSize,
    required this.cellSize,
    required QixGame gameRef,
  }) {
    size = Vector2(gridSize * cellSize, gridSize * cellSize);
    position = Vector2.zero();
    _initializeGrid();
    _virtualQixPosition = Vector2(gridSize / 2, gridSize / 2); // Center of the arena
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
    _grid = List.generate(gridSize.toInt(), (_) => List.generate(gridSize.toInt(), (_) => false));
    _boundaryGrid = List.generate(gridSize.toInt(), (_) => List.generate(gridSize.toInt(), (_) => false));

    // Initialize outer boundary
    for (int x = 0; x < gridSize; x++) {
      _setBoundary(x, 0, true);
      _setBoundary(x, gridSize.toInt() - 1, true);
    }
    for (int y = 0; y < gridSize; y++) {
      _setBoundary(0, y, true);
      _setBoundary(gridSize.toInt() - 1, y, true);
    }
  }

  bool isPointOnBoundary(Vector2 point) {
    int x = point.x.toInt();
    int y = point.y.toInt();
    if (x < 0 || x >= gridSize || y < 0 || y >= gridSize) return false;
    return _boundaryGrid[y][x];
  }

  void _setBoundary(int x, int y, bool value) {
    if (x < 0 || x >= gridSize || y < 0 || y >= gridSize) return;
    _boundaryGrid[y][x] = value;
    _grid[y][x] = value; // Boundary pixels are also considered filled
  }

  void _setFilled(int x, int y, bool value) {
    if (x < 0 || x >= gridSize || y < 0 || y >= gridSize) return;
    _grid[y][x] = value;
  }

  bool _isFilled(int x, int y) {
    if (x < 0 || x >= gridSize || y < 0 || y >= gridSize) return true; // Treat out of bounds as filled
    return _grid[y][x];
  }

  void fillArea(List<Vector2> path, Vector2 pathStartGridPosition, Vector2 pathEndGridPosition) {
    // 1. Mark the path itself as boundary and filled
    for (var p in path) {
      _setBoundary(p.x.toInt(), p.y.toInt(), true);
    }

    // Ensure start and end points of the path are also marked as boundary
    _setBoundary(pathStartGridPosition.x.toInt(), pathStartGridPosition.y.toInt(), true);
    _setBoundary(pathEndGridPosition.x.toInt(), pathEndGridPosition.y.toInt(), true);

    // 2. Find all distinct empty regions
    List<List<Vector2>> emptyRegions = [];
    List<List<bool>> visitedForFloodFill = List.generate(gridSize.toInt(), (_) => List.generate(gridSize.toInt(), (_) => false));

    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (!_isFilled(x, y) && !visitedForFloodFill[y][x]) {
          List<Vector2> region = _floodFill(x, y, _grid, visitedForFloodFill);
          if (region.isNotEmpty) {
            emptyRegions.add(region);
          }
        }
      }
    }

    // 3. Determine which region to fill.
    // In Qix, the area without the Qix (enemy) is filled.
    // Since there are no enemies, we fill the smaller of the two regions created by the path.
    // If only one region is found, it means the path didn't enclose an area, or it enclosed the whole remaining area.
    if (emptyRegions.length == 2) {
      List<Vector2> region1 = emptyRegions[0];
      List<Vector2> region2 = emptyRegions[1];

      List<Vector2> areaToFill;

      bool region1ContainsQix = region1.contains(_virtualQixPosition);
      bool region2ContainsQix = region2.contains(_virtualQixPosition);

      if (region1ContainsQix && !region2ContainsQix) {
        areaToFill = region2; // Region1 contains Qix, so fill Region2
      } else if (!region1ContainsQix && region2ContainsQix) {
        areaToFill = region1; // Region2 contains Qix, so fill Region1
      } else {
        // This case should ideally not happen if the Qix is always in one of the two regions.
        // As a fallback, fill the smaller region (assuming Qix is not enclosed).
        areaToFill = (region1.length < region2.length) ? region1 : region2;
      }

      for (var p in areaToFill) {
        _setFilled(p.x.toInt(), p.y.toInt(), true);
      }
    } else if (emptyRegions.length == 1) {
      // If only one region is found, it means the path enclosed the Qix or the outside.
      // We fill only if this single region contains the Qix.
      List<Vector2> region = emptyRegions[0];
      if (region.contains(_virtualQixPosition)) {
        for (var p in region) {
          _setFilled(p.x.toInt(), p.y.toInt(), true);
        }
      }
    }
    // If emptyRegions.length is 0, it means the whole grid is filled or no new empty regions were found.
  }

  List<Vector2> _floodFill(int startX, int startY, List<List<bool>> grid, List<List<bool>> visited) {
    List<Vector2> filledPoints = [];
    Queue<Vector2> queue = Queue();

    if (startX < 0 || startX >= gridSize || startY < 0 || startY >= gridSize || grid[startY][startX] || visited[startY][startX]) {
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
          if (!grid[nextY][nextX] && !visited[nextY][nextX]) {
            visited[nextY][nextX] = true;
            queue.add(Vector2(nextX.toDouble(), nextY.toDouble()));
          }
        }
      }
    }
    return filledPoints;
  }

  @override
  void render(Canvas canvas) {
    // Render filled areas (including boundaries)
    final filledPaint = Paint()..color = Colors.cyan.withOpacity(0.5);
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (_grid[y][x]) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            filledPaint,
          );
        }
      }
    }

    // Render the outer boundary more prominently if desired, or rely on _grid rendering.
    // For now, the _grid rendering of boundary cells is sufficient.

    // Render current drawing path
    if (_currentDrawingPath.isNotEmpty) {
      final pathPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(_currentDrawingPath.first.x * cellSize + cellSize / 2, _currentDrawingPath.first.y * cellSize + cellSize / 2);
      for (int i = 1; i < _currentDrawingPath.length; i++) {
        path.lineTo(_currentDrawingPath[i].x * cellSize + cellSize / 2, _currentDrawingPath[i].y * cellSize + cellSize / 2);
      }
      canvas.drawPath(path, pathPaint);
    }
  }
}