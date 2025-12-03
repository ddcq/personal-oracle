import 'package:easy_localization/easy_localization.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';

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
