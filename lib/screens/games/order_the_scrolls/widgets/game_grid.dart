import 'package:flutter/material.dart';
import '../game_controller.dart';
import 'draggable_myth_card.dart';

class GameGrid extends StatelessWidget {
  final GameController controller;
  final Function(int, int) onCardReorder;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnd;

  const GameGrid({
    super.key,
    required this.controller,
    required this.onCardReorder,
    required this.onDragStarted,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 4 : (screenWidth > 600 ? 3 : 2);
    final cardSize = (screenWidth - 48) / crossAxisCount - 8;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: controller.shuffledCards.length,
      itemBuilder: (context, index) {
        return DraggableMythCard(
          card: controller.shuffledCards[index],
          index: index,
          size: cardSize,
          controller: controller,
          onDragStarted: onDragStarted,
          onDragEnd: onDragEnd,
          onReorder: onCardReorder,
        );
      },
    );
  }
}