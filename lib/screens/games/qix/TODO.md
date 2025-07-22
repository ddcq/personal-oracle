# Todo List for Qix Game Improvements

This document outlines potential areas for further improvement in the Qix game, building upon previous refactorings.

## 1. Performance & Optimization

-   **Arena Rendering Optimization (Long-term)**:
    -   The `ArenaComponent.render` method currently iterates through the entire grid (`gridSize * gridSize`) every frame. For very large grids, consider optimizing rendering by:
        -   Only re-rendering changed grid cells.
        -   Using a `PictureRecorder` to pre-render static parts of the arena and only update dynamic elements.
        -   Investigating Flame's `SpriteBatch` or custom shaders for more efficient drawing of many small rectangles/sprites.
-   **`findNearestBoundaryPoint` Performance (Medium-term)**:
    -   If `findNearestBoundaryPoint` becomes a performance bottleneck (e.g., with extremely complex boundaries), consider using a spatial data structure (like a k-d tree or a quadtree) to store `_boundaryPoints` for faster nearest neighbor lookups. This is likely overkill for typical Qix grid sizes but worth noting for scalability.
-   **`_demoteEnclosedEdges` Optimization (Medium-term)**:
    -   While `pointsToCheck` helps, the nested loops for checking neighbors could still be a target for optimization if profiling reveals it as a bottleneck.

## 2. Code Clarity & Maintainability

-   **Constants Naming in `constants.dart`**:
    -   Review the naming of `kTempFillArea1`, `kTempFillArea2`, `kSeedScanArea`. While their purpose is understood within the flood-fill algorithm, more descriptive names could improve clarity if the algorithm's details are ever abstracted or modified.
-   **Player Input State Management (Minor)**:
    -   The `setDirection` method in `player.dart` uses a boolean `_isManualInput` and a temporary variable `originalIsManualInput`. While functional, a more explicit state machine for input handling (e.g., `PlayerInputState { Manual, Automatic }`) could potentially make the logic even clearer, though this is a very minor point.
-   **Game Difficulty/Speed Configuration**:
    -   The `_arenaTraversalTime` in `player.dart` is currently a fixed constant. Consider exposing this (or a derived speed setting) as a configurable parameter, possibly tied to game difficulty levels.

## 3. Feature Enhancements (Future Considerations)

-   **Qix (Enemy) AI**:
    -   Currently, the Qix's movement is not implemented. Developing a basic AI for the Qix to move around the arena and interact with the player's path would be a significant feature.
-   **Game Over Conditions**:
    -   Implement clear game over conditions (e.g., player touching the Qix, Qix touching the drawing path).
-   **Visual Feedback for Path Drawing**:
    -   Enhance the visual feedback when the player is drawing a path (e.g., different color, animation).
-   **Sound Effects and Music**:
    -   Add sound effects for movement, drawing, filling, and game events.
    -   Implement background music.
-   **Multiple Levels/Stages**:
    -   Introduce different arena layouts or increasing difficulty levels.
-   **Score Tracking**:
    -   Implement a scoring system based on filled area, time, or other factors.

## 4. Completed Tasks

-   **Victory Condition**:
    -   The victory condition (covering more than 80% of the arena) has been implemented.