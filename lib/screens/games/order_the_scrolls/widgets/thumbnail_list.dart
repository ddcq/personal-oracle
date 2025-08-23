import 'package:flutter/material.dart';

import 'package:oracle_d_asgard/utils/image_utils.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import '../game_controller.dart';

class ThumbnailList extends StatelessWidget {
  final GameController controller;

  const ThumbnailList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.shuffledCards.length,
      itemBuilder: (context, index) {
        final card = controller.shuffledCards[index];
        final isSelected = controller.selectedMythCard?.id == card.id;

        return LongPressDraggable<int>(
          data: index, // The index of the card being dragged
          feedback: Material( // Visual representation during drag
            color: Colors.transparent, // Make background transparent
            elevation: 8,
            child: SizedBox(
              width: 165, // Adjust size as needed for feedback
              height: 77,
              child: Card(
                color: Colors.blueGrey[700],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        addAssetPrefix(card.imagePath),
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          card.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: AppTextStyles.amaticSC,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          childWhenDragging: Container( // What to show in place of the original when dragging
            height: 70, // Match the height of the card
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blueGrey[900]?.withAlpha(128),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.drag_handle, color: Colors.white),
            ),
          ),
          child: DragTarget<int>(
            onAcceptWithDetails: (details) {
              controller.reorderCards(details.data, index);
            },
            builder: (context, candidateData, rejectedData) {
              return GestureDetector(
                onTap: () => controller.selectMythCard(card),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: isSelected ? Colors.blueGrey[700] : Colors.blueGrey[900],
                  elevation: isSelected ? 8 : 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? Colors.amber : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          addAssetPrefix(card.imagePath),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            card.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: AppTextStyles.amaticSC,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}