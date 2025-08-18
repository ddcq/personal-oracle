import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/screens/games/qix/main.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/welcome_screen.dart';
import 'package:oracle_d_asgard/screens/games/snake/screen.dart';
import 'package:oracle_d_asgard/screens/games/puzzle/screen.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';

class MenuPrincipal extends StatelessWidget {
  MenuPrincipal({super.key});

  final jeux = <_MiniJeuItem>[
    _MiniJeuItem("Réordonne l’Histoire", const Color(0xFF6366F1), const Color(0xFF4A4CBB), () => OrderTheScrollsGame()),
    _MiniJeuItem("La Muraille d’Asgard", const Color(0xFFEF4444), const Color(0xFFB71C1C), () => WelcomeScreen()),
    _MiniJeuItem(
      "Les Runes Dispersées",
      const Color(0xFF06B6D4),
      const Color(0xFF048D9F),
      () => PuzzleGameScreen(), // À créer
    ),
    _MiniJeuItem("Le Serpent de Midgard", const Color(0xFF22C55E), const Color(0xFF1A9B49), () => const SnakeGame()),
    _MiniJeuItem("Conquête de Territoire", const Color(0xFFFF6B35), const Color(0xFFCC552A), () => QixGameScreen()),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Permet au body de s’étendre derrière l’AppBar
      appBar: AppBar(
        title: Text('Games', style: TextStyle(fontFamily: AppTextStyles.amaticSC)),
        backgroundColor: Colors.white30, // Rend l'AppBar transparente
        elevation: 0, // Supprime l'ombre de l'AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // Icône de retour
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: AppBackground(
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
                      fontFamily: AppTextStyles.amaticSC,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 70.sp,
                      letterSpacing: 2.0.sp,
                      shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  // Generate ChibiButtons from the jeux list
                  ...jeux.map(
                    (jeu) => Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: ChibiButton(
                        text: jeu.label,
                        color: jeu.color,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => jeu.builder()));
                        },
                      ),
                    ),
                  ),
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
