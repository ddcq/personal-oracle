import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Configuration pour un élément de la grille hexagonale
class HexGridItem {
  final Widget child;
  final VoidCallback? onTap;

  const HexGridItem({
    required this.child,
    this.onTap,
  });
}

/// Widget pour afficher des éléments dans une grille hexagonale
/// avec disposition en quinconce (honeycomb pattern)
class HexagonalGrid extends StatelessWidget {
  /// Liste des éléments à afficher
  final List<HexGridItem> items;

  /// Nombre de colonnes de la grille
  final int columns;

  /// Nombre de lignes de la grille
  final int rows;

  /// Taille de l'hexagone (rayon)
  final double hexSize;

  /// Si true, ignore le premier élément (index 0) pour avoir un pattern décalé
  final bool skipFirstTile;

  /// Si true, centre automatiquement la grille horizontalement
  final bool centerHorizontally;

  /// Décalage horizontal relatif (pourcentage de la largeur de l'écran)
  /// Ignoré si centerHorizontally est true
  final double horizontalOffset;

  /// Décalage vertical relatif (pourcentage de la hauteur du conteneur)
  final double verticalOffset;

  /// Hauteur du conteneur de la grille
  final double containerHeight;

  const HexagonalGrid({
    super.key,
    required this.items,
    required this.columns,
    required this.rows,
    this.hexSize = 55.0,
    this.skipFirstTile = true,
    this.centerHorizontally = false,
    this.horizontalOffset = 0.22,
    this.verticalOffset = 0.15,
    required this.containerHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final positions = _calculatePositions(screenWidth);

    return Stack(
      children: _buildGridItems(positions),
    );
  }

  /// Calcule les positions de chaque élément dans la grille hexagonale
  List<Offset> _calculatePositions(double screenWidth) {
    final positions = <Offset>[];
    final scaledHexSize = hexSize.sp;
    final horizontalSpacing = scaledHexSize * 1.73; // √3 approximation for pointy hex
    final verticalSpacing = scaledHexSize * 1.5;

    // Calculer la largeur totale de la grille
    final gridWidth = (columns - 1) * horizontalSpacing + scaledHexSize * 2.4;

    // Calculer startX selon le mode de centrage
    final startX = centerHorizontally 
        ? (screenWidth - gridWidth) / 2 + scaledHexSize * 1.2
        : screenWidth * horizontalOffset;
    
    final startY = containerHeight * verticalOffset;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final index = row * columns + col;

        // Skip first tile si demandé
        if (skipFirstTile && index == 0) continue;
        if (index - (skipFirstTile ? 1 : 0) >= items.length) continue;

        final offsetX = col * horizontalSpacing;
        final offsetY = row * verticalSpacing + (col.isOdd ? verticalSpacing / 2 : 0);

        positions.add(Offset(startX + offsetX, startY + offsetY));
      }
    }

    return positions;
  }

  /// Construit les widgets positionnés de la grille
  List<Widget> _buildGridItems(List<Offset> positions) {
    final widgets = <Widget>[];
    final scaledHexSize = hexSize.sp;

    for (int i = 0; i < positions.length && i < items.length; i++) {
      final position = positions[i];
      final item = items[i];

      widgets.add(
        Positioned(
          left: position.dx - scaledHexSize * 1.2,
          top: position.dy - scaledHexSize * 1.4,
          child: GestureDetector(
            onTap: item.onTap,
            child: SizedBox(
              width: scaledHexSize * 2.4,
              height: scaledHexSize * 2.8,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [item.child],
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}
