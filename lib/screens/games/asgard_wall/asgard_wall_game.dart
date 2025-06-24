import 'package:flutter/material.dart';
import 'package:personal_oracle/screens/games/asgard_wall/defeat_screen.dart';
import 'package:personal_oracle/screens/games/asgard_wall/game_screen.dart';
import 'package:personal_oracle/screens/games/asgard_wall/victory_screen.dart';
import 'package:personal_oracle/screens/games/asgard_wall/welcome_screen.dart';


void main() {
  runApp(AsgardWallApp());
}

class AsgardWallApp extends StatelessWidget {
  const AsgardWallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muraille d\'Asgard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Couleur de fond générale pour l'application
        scaffoldBackgroundColor: Color(0xFF1A1A2E),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF16213E), // Barre d'app sombre
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0F3460), // Fond bleu foncé pour les boutons
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      // Définition des routes pour la navigation entre les écrans
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/game': (context) => GameScreen(),
        '/victory': (context) => VictoryScreen(),
        '/defeat': (context) => DefeatScreen(),
      },
    );
  }
}
