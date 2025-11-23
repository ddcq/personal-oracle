import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/game_controller.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class ThumbnailList extends StatelessWidget {
  final GameController controller;

  const ThumbnailList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth * 0.06;

    return ListView.builder(
      itemCount: controller.shuffledCards.length,
      itemBuilder: (context, index) {
        final card = controller.shuffledCards[index];
        final isSelected = controller.selectedMythCard?.id == card.id;
        final isFirst = index == 0;
        final isLast = index == controller.shuffledCards.length - 1;

        Color borderColor;
        if (controller.placementResults.isNotEmpty &&
            controller.placementResults[index] != null) {
          borderColor = controller.placementResults[index]!
              ? Colors.green
              : Colors.red;
        } else {
          borderColor = isSelected ? Colors.amber : Colors.transparent;
        }

        return SimpleGestureDetector(
          onTap: () => controller.selectMythCard(card),
          child: Card(
            margin: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ),
            color: isSelected
                ? Colors.blueGrey[700]
                : Colors.blueGrey[900],
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
                      ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height),
                      );
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
                      'story_${controller.selectedStory.id}_card_${card.id}_title'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
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
                  // UP/DOWN buttons - only show on selected card
                  if (isSelected)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isFirst)
                          IconButton(
                            icon: const Icon(Icons.arrow_upward, color: Colors.white, size: 32),
                            onPressed: () => controller.moveCardUp(index),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                          ),
                        if (!isLast)
                          IconButton(
                            icon: const Icon(Icons.arrow_downward, color: Colors.white, size: 32),
                            onPressed: () => controller.moveCardDown(index),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
