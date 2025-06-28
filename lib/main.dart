import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // 👈 Nouveau fichier avec MainScreen
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oracle Nordique',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppConstants.primaryDark,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          bodySmall: TextStyle(
            color: Colors.white60,
            fontSize: 14,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white.withAlpha(25),
          elevation: 4,
        ),
      ),
      home: const MainScreen(), // 👈 Utilise MainScreen au lieu de WelcomeScreen
      debugShowCheckedModeBanner: false,
    );
  }
}