import 'dart:convert';
import 'dart:math';

import 'package:oracle_d_asgard/data/stories_data.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';

/// Represents the next chapter that a user can earn.
class NextChapter {
  final MythStory story;
  final MythCard chapter;

  NextChapter({required this.story, required this.chapter});
}

/// Selects the next story chapter that the user can win.
///
/// This function scans all stories, checks the user's progress for each,
/// and finds all chapters that have not yet been unlocked. It then randomly
/// selects one from all available earnable chapters.
///
/// Returns a [NextChapter] object containing the story and the specific chapter
/// to be won, or `null` if all chapters across all stories have been earned.
Future<NextChapter?> selectNextChapterToWin(GamificationService gamificationService) async {
  final allStories = getMythStories().skip(1).toList();

  final List<NextChapter> earnableChapters = [];

  for (var story in allStories) {
    // Iterate over allStories
    final progress = await gamificationService.getStoryProgress(story.id);
    // Decode the list of unlocked part IDs, or start with an empty list.
    final unlockedParts = progress != null ? jsonDecode(progress['parts_unlocked']) as List<dynamic> : [];

    // Find the first chapter in the story's correct order that is not yet unlocked.
    for (var chapter in story.correctOrder) {
      if (!unlockedParts.contains(chapter.id)) {
        earnableChapters.add(NextChapter(story: story, chapter: chapter));
        // Once we find the first unearned chapter for a story, we move to the next story.
        break;
      }
    }
  }

  if (earnableChapters.isNotEmpty) {
    // Return a randomly selected chapter from all possible earnable chapters.
    final random = Random();
    return earnableChapters[random.nextInt(earnableChapters.length)];
  } else {
    // Return null if there are no more chapters to earn.
    return null;
  }
}

/// Selects a random chapter from all available stories, regardless of unlock status.
/// This is used when all stories have been completed, to allow continuous play.
Future<NextChapter> selectRandomChapterFromAllStories() async {
  final allStories = getMythStories().skip(1).toList();
  final random = Random();

  // Select a random story
  final randomStory = allStories[random.nextInt(allStories.length)];

  // Select a random chapter from the chosen story
  final randomChapter = randomStory.correctOrder[random.nextInt(randomStory.correctOrder.length)];

  return NextChapter(story: randomStory, chapter: randomChapter);
}
