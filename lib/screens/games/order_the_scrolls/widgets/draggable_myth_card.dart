import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'myth_card_content.dart';
import '../game_controller.dart';

class DraggableMythCard extends StatelessWidget {
  final MythCard card;
  final int index;
  final double size;
  final GameController controller;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnd;
  final Function(int, int) onReorder;
  final Function(MythCard) onCardPressed;
  final VoidCallback onCardReleased;

  const DraggableMythCard({
    super.key,
    required this.card,
    required this.index,
    required this.size,
    required this.controller,
    required this.onDragStarted,
    required this.onDragEnd,
    required this.onReorder,
    required this.onCardPressed,
    required this.onCardReleased,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        onReorder(details.data, index);
      },
      onWillAcceptWithDetails: (details) => details.data != index,
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return Draggable<int>(
          data: index,
          onDragStarted: onDragStarted,
          onDragEnd: (_) => onDragEnd(),
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: size * 0.9,
              height: size * 0.9,
              child: MythCardContent(card: card, index: index, size: size * 0.9, controller: controller, isDragging: true),
            ),
          ),
          childWhenDragging: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
              color: Colors.grey[100],
            ),
            child: const Icon(Icons.add, color: Colors.grey, size: 32),
          ),
          child: GestureDetector(
            onLongPressStart: (_) => onCardPressed(card),
            onLongPressEnd: (_) => onCardReleased(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform:
                  Matrix4.translationValues(0.0, isHovering ? -4.0 : 0.0, 0.0) * Matrix4.diagonal3Values(isHovering ? 1.05 : 1.0, isHovering ? 1.05 : 1.0, 1.0),
              child: MythCardContent(card: card, index: index, size: size, controller: controller),
            ),
          ),
        );
      },
    );
  }
}
