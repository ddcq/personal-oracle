import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/game_controller.dart';

class ThumbnailList extends StatelessWidget {
  final GameController controller;

  const ThumbnailList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final double fontSize = screenWidth * (isLandscape ? 0.03 : 0.06); // 5% of screen width in landscape, 4% in portrait

    return DragAndDropLists(
      children: [
        DragAndDropList(
          children: List.generate(controller.shuffledCards.length, (index) {
            final card = controller.shuffledCards[index];
            final isSelected = controller.selectedMythCard?.id == card.id;

            Color borderColor;
            if (controller.placementResults.isNotEmpty && controller.placementResults[index] != null) {
              borderColor = controller.placementResults[index]! ? Colors.green : Colors.red;
            } else {
              borderColor = isSelected ? Colors.amber : Colors.transparent;
            }

            return DragAndDropItem(
              child: GestureDetector(
                onTap: () => controller.selectMythCard(card),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  color: isSelected ? Colors.blueGrey[700] : Colors.blueGrey[900],
                  elevation: isSelected ? 12 : 8,
                  shadowColor: Colors.black.withAlpha(128),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: borderColor, width: 2),
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
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0), bottomLeft: Radius.circular(12.0)),
                            child: Image.asset('assets/images/stories/${card.imagePath}', width: 60, height: 60, fit: BoxFit.cover),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            card.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontFamily: AppTextStyles.amaticSC,
                              shadows: [Shadow(blurRadius: 2.0, color: Colors.black.withAlpha(128), offset: const Offset(1.0, 1.0))],
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
            );
          }),
        ),
      ],
      onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
        controller.reorderCards(oldItemIndex, newItemIndex);
      },
      onListReorder: (int oldListIndex, int newListIndex) {
        // Not needed
      },
      listPadding: EdgeInsets.zero,
    );
  }
}
