import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/screens/games/qix/main.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/welcome_screen.dart';
import 'package:oracle_d_asgard/screens/games/snake/screen.dart';
import 'package:oracle_d_asgard/screens/games/puzzle/screen.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/screen.dart';

class MenuPrincipal extends StatelessWidget {
  MenuPrincipal({super.key});

  final jeux = <_MiniJeuItem>[
    _MiniJeuItem(
      "Réordonne l'Histoire", 
      const Color(0xFF6366F1),
      const Color(0xFF4A4CBB),
      () => OrderTheScrollsGame()
    ),
    _MiniJeuItem(
      "La Muraille d'Asgard", 
      const Color(0xFFEF4444),
      const Color(0xFFB71C1C),
      () => WelcomeScreen()
    ),
    _MiniJeuItem(
      "Les Runes Dispersées", 
      const Color(0xFF06B6D4),
      const Color(0xFF048D9F),
      () => PuzzleGameScreen() // À créer
    ),
    _MiniJeuItem(
      "Le Serpent de Midgard", 
      const Color(0xFF22C55E),
      const Color(0xFF1A9B49),
      () => const SnakeGame()
    ),
    _MiniJeuItem(
      "Conquête de Territoire", 
      const Color(0xFFFF6B35),
      const Color(0xFFCC552A),
      () => QixGameScreen()
    ),
    _MiniJeuItem(
      "Accueil du Guerrier", 
      const Color(0xFF10B981),
      const Color(0xFF0C8C64),
      () => WelcomeScreen()
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Permet au body de s'étendre derrière l'AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Rend l'AppBar transparente
        elevation: 0, // Supprime l'ombre de l'AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // Icône de retour
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/backgrounds/landscape.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Mini-Jeux',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontFamily: 'AmaticSC',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 70,
                      letterSpacing: 2.0,
                      shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Generate ChibiButtons from the jeux list
                  ...jeux.map((jeu) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ChibiButton(
                      text: jeu.label,
                      color: jeu.color,
                      shadowColor: jeu.shadowColor,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => jeu.builder()));
                      },
                    ),
                  )),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniJeuItem {
  final String label;
  final Color color;
  final Color shadowColor;
  final Widget Function() builder;

  _MiniJeuItem(this.label, this.color, this.shadowColor, this.builder);
}