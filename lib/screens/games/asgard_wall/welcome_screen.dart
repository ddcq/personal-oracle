import 'package:flutter/material.dart';


import 'package:oracle_d_asgard/screens/games/asgard_wall/game_screen.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/backgrounds/landscape.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(title: Text('Muraille d’Asgard', style: TextStyle(fontFamily: AppTextStyles.amaticSC, fontSize: 48)), elevation: 0, backgroundColor: Colors.transparent),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF0F3460),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFFFD700), width: 1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Règles du jeu:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Construisez la muraille parfaite comme le géant bâtisseur.\nVotre objectif est de remplir toutes les cases jusqu’à la ligne dorée sans laisser de trous inaccessibles (fermés de tous les côtés).',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Contrôles:\n←→ ou A/D pour bouger\n↑/W/Space/Q/E pour pivoter\n↓/S pour descendre\n(Les contrôles tactiles sont disponibles en jeu)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                
                SizedBox(height: 16),
                ChibiButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GameScreen()),
                    );
                  },
                  text: 'Construire le Mur',
                  color: const Color(0xFFFFD700), // Fond doré
                  textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}