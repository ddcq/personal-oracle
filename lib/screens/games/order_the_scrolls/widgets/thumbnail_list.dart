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

        return Column(
          children: [
            LongPressDraggable<int>(
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
                            'assets/images/stories/${card.imagePath}',
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
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      color: isSelected ? Colors.blueGrey[700] : Colors.blueGrey[900],
                      elevation: isSelected ? 12 : 8,
                      shadowColor: Colors.black.withAlpha(128),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? Colors.amber : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          children: [
                            ShaderMask(
                              shaderCallback: (rect) {
                                return const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.black, Colors.transparent],
                                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                              },
                              blendMode: BlendMode.dstIn,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0),
                                ),
                                child: Image.asset(
                                  'assets/images/stories/${card.imagePath}',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                card.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: AppTextStyles.amaticSC,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2.0,
                                      color: Colors.black.withAlpha(128),
                                      offset: const Offset(1.0, 1.0),
                                    ),
                                  ],
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
            ),
            if (index < controller.shuffledCards.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: 24,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black.withAlpha(128),
                      offset: const Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}