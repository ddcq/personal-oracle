import 'package:flutter/material.dart';
import 'constants.dart';

class AppThemes {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.amber,
      scaffoldBackgroundColor: AppConstants.primaryDark,
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.primaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
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
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppConstants.accent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppConstants.accent,
        linearTrackColor: AppConstants.cardDark,
      ),
    );
  }
}