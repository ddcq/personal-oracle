import 'package:easy_localization/easy_localization.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/data/stories_data.dart';
import 'package:oracle_d_asgard/screens/games/visual_novel/data/story_data.dart';

/// Extracts a set of unique words with 4 or more characters from a MythCard.
///
/// This function processes the title, description, and detailed story
/// associated with the given [card]. It splits the text into words, converts
/// them to lowercase, and collects all unique words that have 4 or more
/// characters.
Set<String> extractWordsFromMythCard(MythCard card) {
  final words = <String>{};
  final textSources = [
    card.title.tr(),
    card.description.tr(),
    card.detailedStory.tr(),
  ];

  final combinedText = textSources.join(' ');

  // Regex to find sequences of letters (including common accented characters).
  final wordRegex = RegExp(r'[a-zA-Zà-üÀ-Ü]+');

  wordRegex.allMatches(combinedText.toLowerCase()).forEach((match) {
    final word = match.group(0)!;
    if (word.length >= 4) {
      words.add(word);
    }
  });

  return words;
}

/// Extracts all words from all myth stories and visual novel content
/// Returns a set of unique words with 4 or more characters
Set<String> extractAllWordsFromStories() {
  final allWords = <String>{};
  
  // Extract words from all myth stories
  final allStories = getMythStories().skip(1).toList(); // Skip loading story
  for (final story in allStories) {
    for (final chapter in story.correctOrder) {
      allWords.addAll(extractWordsFromMythCard(chapter));
    }
  }
  
  // Extract words from visual novel (without translation as these are direct texts)
  final visualNovelStory = StoryData.lokiStory;
  final wordRegex = RegExp(r'[a-zA-Zà-üÀ-Ü]+');
  
  for (final scene in visualNovelStory.scenes.values) {
    // Extract from title (direct text, no translation)
    if (scene.title.isNotEmpty) {
      wordRegex.allMatches(scene.title.toLowerCase()).forEach((match) {
        final word = match.group(0)!;
        if (word.length >= 4) {
          allWords.add(word);
        }
      });
    }
    
    // Extract from content (direct text, no translation)
    if (scene.content != null && scene.content!.isNotEmpty) {
      wordRegex.allMatches(scene.content!.toLowerCase()).forEach((match) {
        final word = match.group(0)!;
        if (word.length >= 4) {
          allWords.add(word);
        }
      });
    }
    
    // Extract from paragraphs (direct text, no translation)
    if (scene.paragraphs != null) {
      for (final paragraph in scene.paragraphs!) {
        wordRegex.allMatches(paragraph.toLowerCase()).forEach((match) {
          final word = match.group(0)!;
          if (word.length >= 4) {
            allWords.add(word);
          }
        });
      }
    }
    
    // Extract from dialogues (direct text, no translation)
    if (scene.dialogues != null) {
      for (final dialogue in scene.dialogues!) {
        wordRegex.allMatches(dialogue.text.toLowerCase()).forEach((match) {
          final word = match.group(0)!;
          if (word.length >= 4) {
            allWords.add(word);
          }
        });
      }
    }
    
    // Extract from choices (direct text, no translation)
    if (scene.choices != null) {
      for (final choice in scene.choices!) {
        wordRegex.allMatches(choice.text.toLowerCase()).forEach((match) {
          final word = match.group(0)!;
          if (word.length >= 4) {
            allWords.add(word);
          }
        });
        
        wordRegex.allMatches(choice.description.toLowerCase()).forEach((match) {
          final word = match.group(0)!;
          if (word.length >= 4) {
            allWords.add(word);
          }
        });
      }
    }
  }
  
  return allWords;
}

/// A map of characters with diacritics to their base characters.
const _diacritics = {
  'À': 'A',
  'Á': 'A',
  'Â': 'A',
  'Ã': 'A',
  'Ä': 'A',
  'Å': 'A',
  'à': 'a',
  'á': 'a',
  'â': 'a',
  'ã': 'a',
  'ä': 'a',
  'å': 'a',
  'Ò': 'O',
  'Ó': 'O',
  'Ô': 'O',
  'Õ': 'O',
  'Ö': 'O',
  'Ø': 'O',
  'ò': 'o',
  'ó': 'o',
  'ô': 'o',
  'õ': 'o',
  'ö': 'o',
  'ø': 'o',
  'È': 'E',
  'É': 'E',
  'Ê': 'E',
  'Ë': 'E',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'Ç': 'C',
  'ç': 'c',
  'Ð': 'D',
  'ð': 'd',
  'Ì': 'I',
  'Í': 'I',
  'Î': 'I',
  'Ï': 'I',
  'ì': 'i',
  'í': 'i',
  'î': 'i',
  'ï': 'i',
  'Ù': 'U',
  'Ú': 'U',
  'Û': 'U',
  'Ü': 'U',
  'ù': 'u',
  'ú': 'u',
  'û': 'u',
  'ü': 'u',
  'Ñ': 'N',
  'ñ': 'n',
  'Š': 'S',
  'š': 's',
  'Ÿ': 'Y',
  'ÿ': 'y',
  'ý': 'y',
  'Ž': 'Z',
  'ž': 'z',
};

/// Removes diacritics (accents) from a string.
String _removeDiacritics(String str) {
  for (var entry in _diacritics.entries) {
    str = str.replaceAll(entry.key, entry.value);
  }
  return str;
}

/// Normalizes a string by making it uppercase and removing diacritics.
String normalizeForWordSearch(String input) {
  return _removeDiacritics(input).toUpperCase();
}
