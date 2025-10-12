import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/screens/games/qix/preliminary_screen.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/preliminary_screen.dart';
import 'package:oracle_d_asgard/screens/games/snake/preliminary_screen.dart';
import 'package:oracle_d_asgard/screens/games/puzzle/screen.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/preliminary_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/screens/games/word_search/preliminary_screen.dart';
import 'package:oracle_d_asgard/screens/games/minesweeper/preliminary_screen.dart';

import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';

class MenuPrincipal extends StatelessWidget {
  MenuPrincipal({super.key});

  final jeux = <_MiniJeuItem>[
    _MiniJeuItem('Réordonne l’Histoire', const Color(0xFF6366F1), () => const OrderTheScrollsPreliminaryScreen()),
    _MiniJeuItem('La Muraille d’Asgard', const Color(0xFFEF4444), () => const AsgardWallGameScreen()),
    _MiniJeuItem(
      'Les Runes Dispersées',
      const Color(0xFF06B6D4),
      () => const PuzzlePreliminaryScreen(),
    ),
    _MiniJeuItem('Le Serpent de Midgard', const Color(0xFF22C55E), () => const SnakePreliminaryScreen()),
    _MiniJeuItem('Conquête de Territoire', const Color(0xFFFF6B35), () => const QixPreliminaryScreen()),
    _MiniJeuItem('L’Œil d’Odin', const Color(0xFF8B5CF6), () => const WordSearchPreliminaryScreen()),
    _MiniJeuItem('Le Butin d’Andvari', Colors.brown, () => const MinesweeperPreliminaryScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Permet au body de s’étendre derrière l’AppBar
      appBar: ChibiAppBar(
        titleText: 'Mini-Jeux',
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
  final Widget Function() builder;

  _MiniJeuItem(this.label, this.color, this.builder);
}
