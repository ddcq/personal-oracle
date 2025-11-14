import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';

import 'package:oracle_d_asgard/screens/games/order_the_scrolls/game_controller.dart';

class MythCardContent extends StatelessWidget {
  final MythCard card;
  final int index;
  final double size;
  final GameController controller;
  final bool isDragging;

  const MythCardContent({
    super.key,
    required this.card,
    required this.index,
    required this.size,
    required this.controller,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isDragging ? 16 : 20),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(77),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(38),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/stories/${card.imagePath}',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(51),
                      Colors.black.withAlpha(204),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'story_${controller.selectedStory.id}_card_${card.id}_title'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDragging ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!controller.validated)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.open_with,
                  color: Colors.white,
                  size: 20,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            if (controller.validated)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: controller.isCardCorrect(index)
                        ? Colors.green
                        : Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(77),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
