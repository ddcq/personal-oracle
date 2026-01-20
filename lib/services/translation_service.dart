import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service for loading translations asynchronously from JSON files
class TranslationService with ChangeNotifier {
  Map<String, dynamic> _translations = {};
  String _currentLocale = 'en-US';
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  String get currentLocale => _currentLocale;

  Future<void> loadTranslations(Locale locale) async {
    final localeString = '${locale.languageCode}-${locale.countryCode}';
    if (localeString == _currentLocale && _isLoaded) {
      return; // Already loaded
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/resources/langs/$localeString.json',
      );
      _translations = json.decode(jsonString) as Map<String, dynamic>;
      _currentLocale = localeString;
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading translations for $localeString: $e');
      // Fallback to English
      if (localeString != 'en-US') {
        await loadTranslations(const Locale('en', 'US'));
      }
    }
  }

  String translate(String key, {String? fallback}) {
    return _translations[key]?.toString() ?? fallback ?? key;
  }

  String tr(String key) => translate(key);
}
