import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final jeux = <_MiniJeuItem>[
      _MiniJeuItem('Réordonne l\'Histoire', const Color(0xFF6366F1), () => context.go('/order_the_scrolls_preliminary')),
      _MiniJeuItem('La Muraille d\'Asgard', const Color(0xFFEF4444), () => context.go('/asgard_wall_preliminary')),
      _MiniJeuItem('Les Runes Dispersées', const Color(0xFF06B6D4), () => context.go('/puzzle_preliminary')),
      _MiniJeuItem('Le Serpent de Midgard', const Color(0xFF22C55E), () => context.go('/snake_preliminary')),
      _MiniJeuItem('Conquête de Territoire', const Color(0xFFFF6B35), () => context.go('/qix_preliminary')),
      _MiniJeuItem('L\'Œil d\'Odin', const Color(0xFF8B5CF6), () => context.go('/word_search_preliminary')),
      _MiniJeuItem('Le Butin d\'Andvari', Colors.brown, () => context.go('/minesweeper_preliminary')),
    ];
    return Scaffold(
      extendBodyBehindAppBar: true, // Permet au body de s’étendre derrière l’AppBar
      appBar: ChibiAppBar(
        titleText: 'Mini-Jeux',
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            context.go('/');
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
                  // Generate ChibiButtons from the jeux list
                  ...jeux.map(
                    (jeu) => Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: ChibiButton(
                        text: jeu.label,
                        color: jeu.color,
                        onPressed: jeu.onPressed,
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
  final VoidCallback onPressed;

  _MiniJeuItem(this.label, this.color, this.onPressed);
}
