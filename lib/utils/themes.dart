import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/utils/constants.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class AppThemes {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.amber,
      scaffoldBackgroundColor: AppConstants.primaryDark,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.amaticSC,
          color: AppConstants.accent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppConstants.secondaryDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          side: const BorderSide(color: AppConstants.borderDark),
        ),
      ),

      // Text themes
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppConstants.accent,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppConstants.textDark,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppConstants.accent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: AppConstants.textDark,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: AppConstants.textDark,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: TextStyle(color: AppConstants.textDark, fontSize: 12),
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppConstants.accent,
        linearTrackColor: AppConstants.cardDark,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.amber,
      scaffoldBackgroundColor: AppConstants.primaryLight,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.amaticSC,
          color: AppConstants.accent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppConstants.secondaryLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          side: const BorderSide(color: AppConstants.borderLight),
        ),
      ),

      // Text themes
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppConstants.accent,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppConstants.textLight,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppConstants.accent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: AppConstants.textLight,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: AppConstants.textLight,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: TextStyle(color: AppConstants.textLight, fontSize: 12),
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppConstants.accent,
        linearTrackColor: AppConstants.cardLight,
      ),
    );
  }
}
