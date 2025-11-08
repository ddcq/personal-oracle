import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:oracle_d_asgard/data/stories_data.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/screens/games/myth_story_page.dart';
import 'package:oracle_d_asgard/screens/profile/widgets/ad_reward_button.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class UnlockedStoriesGrid extends StatelessWidget {
  final List<Map<String, dynamic>> storyProgress;
  final MythStory? nextAdRewardStory;
  final bool isAdLoading;
  final VoidCallback showRewardedStoryAd;

  const UnlockedStoriesGrid({
    super.key,
    required this.storyProgress,
    this.nextAdRewardStory,
    required this.isAdLoading,
    required this.showRewardedStoryAd,
  });

  @override
  Widget build(BuildContext context) {
    if (storyProgress.isEmpty) {
      final adRewardStoryButton = nextAdRewardStory != null
          ? AdRewardButton(
              imagePath: 'assets/images/stories/${nextAdRewardStory!.correctOrder.first.imagePath}',
              title: nextAdRewardStory!.title,
              icon: Icons.menu_book,
              isAdLoading: isAdLoading,
              onTap: showRewardedStoryAd,
            )
          : null;
      if (adRewardStoryButton != null) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.0),
          itemCount: 1,
          itemBuilder: (context, index) {
            return adRewardStoryButton;
          },
        );
      } else {
        return Text(
          'profile_screen_no_unlocked_stories'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70, fontFamily: AppTextStyles.amaticSC, fontSize: 20),
        );
      }
    }
    final allMythStories = getMythStories();

    final adRewardStoryButton = nextAdRewardStory != null
        ? AdRewardButton(
            imagePath: 'assets/images/stories/${nextAdRewardStory!.correctOrder.first.imagePath}',
            title: nextAdRewardStory!.title,
            icon: Icons.menu_book,
            isAdLoading: isAdLoading,
            onTap: showRewardedStoryAd,
          )
        : null;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.0),
      itemCount: storyProgress.length + (adRewardStoryButton != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < storyProgress.length) {
          final progress = storyProgress[index];
          final storyId = progress['story_id'];
          final mythStories = allMythStories.where((story) => story.id == storyId);
          if (mythStories.isEmpty) {
            return const SizedBox.shrink();
          }
          final mythStory = mythStories.first;
          final unlockedParts = jsonDecode(progress['parts_unlocked']) as List;
          String? lastChapterImagePath;
          if (unlockedParts.isNotEmpty) {
            final lastUnlockedChapterId = unlockedParts.last;
            final lastChapterMythCard = mythStory.correctOrder.firstWhere(
              (card) => card.id == lastUnlockedChapterId,
              orElse: () => mythStory.correctOrder.first, // Fallback to first if last not found
            );
            lastChapterImagePath = lastChapterMythCard.imagePath;
          }

          return SimpleGestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MythStoryPage(mythStory: mythStory)));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF8B4513), width: 2),
              ),
              child: Stack(
                children: [
                  if (lastChapterImagePath != null)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(
                          'assets/images/stories/$lastChapterImagePath',
                          fit: BoxFit.cover,
                          color: Colors.black.withAlpha(102),
                          colorBlendMode: BlendMode.darken,
                        ),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          mythStory.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppTextStyles.amaticSC,
                                fontSize: 28,
                                shadows: [Shadow(blurRadius: 5.0, color: Colors.black.withAlpha(178), offset: const Offset(2.0, 2.0))],
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: mythStory.correctOrder.map((chapter) {
                            final isUnlocked = unlockedParts.contains(chapter.id);
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Container(
                                width: 14,
                                height: 18,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: isUnlocked ? Colors.transparent : Colors.white.withAlpha(100)),
                                child: isUnlocked ? const Icon(Icons.emoji_emotions, color: Colors.yellow, size: 16) : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate(delay: (index * 80).ms).slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOutCubic).fadeIn(duration: 300.ms);
        } else {
          return adRewardStoryButton!.animate(delay: (index * 80).ms).slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOutCubic).fadeIn(duration: 300.ms);
        }
      },
    );
  }
}
