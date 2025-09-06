import 'package:flutter/material.dart';

class AppConstants {
  // Couleurs principales
  static const Color primaryDark = Color(0xFF0F172A);
  static const Color secondaryDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF334155);
  static const Color borderDark = Color(0xFF475569);
  static const Color accent = Colors.amber;

  static const Color primaryLight = Color(0xFFFFFFFF);
  static const Color secondaryLight = Color(0xFFF0F0F0);
  static const Color cardLight = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFD0D0D0);
  static const Color textLight = Color(0xFF333333);
  static const Color textDark = Color(0xFFFFFFFF);
  
  // Traits de personnalité
  static const List<String> personalityTraits = [
    'courage',
    'wisdom',
    'cunning',
    'justice',
    'passion',
    'strength',
    'nature',
    'honor',
  ];
  
  // Espacement
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Rayons de bordure
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  
  // Tailles d'icônes
  static const double iconSmall = 24.0;
  static const double iconMedium = 48.0;
  static const double iconLarge = 80.0;
  static const double iconXLarge = 120.0;
}