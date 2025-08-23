import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/screens/games/qix/main.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/game_screen.dart';
import 'package:oracle_d_asgard/screens/games/snake/screen.dart';
import 'package:oracle_d_asgard/screens/games/puzzle/screen.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/screen.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/card_version.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';

class MenuPrincipal extends StatelessWidget {
  MenuPrincipal({super.key});

  final jeux = <_MiniJeuItem>[
    _MiniJeuItem("Réordonne l’Histoire", const Color(0xFF6366F1), () => OrderTheScrollsGame()),
    _MiniJeuItem("La Muraille d’Asgard", const Color(0xFFEF4444), () => const GameScreen()),
    _MiniJeuItem(
      "Les Runes Dispersées",
      const Color(0xFF06B6D4),
      () => PuzzleGameScreen(), // À créer
    ),
    _MiniJeuItem("Le Serpent de Midgard", const Color(0xFF22C55E), () => const SnakeGame()),
    _MiniJeuItem("Conquête de Territoire", const Color(0xFFFF6B35), () => QixGameScreen()),
    _MiniJeuItem(
      "Debug: Victory Popup",
      Colors.purple,
      () => Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => VictoryPopup(
                  rewardCard: CollectibleCard(
                    id: 'debug_card',
                    title: 'Carte de Débogage',
                    description: 'Ceci est une carte de débogage.',
                    imagePath: 'assets/images/odin_chibi.png', // Use an existing image
                    version: CardVersion.chibi,
                    tags: [],
                  ),
                  onDismiss: () {
                    Navigator.of(context).pop();
                  },
                  onSeeRewards: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  },
                ),
              );
            },
            child: const Text("Show Debug Victory Popup"),
          );
        },
      ),
    ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Permet au body de s’étendre derrière l’AppBar
      appBar: ChibiAppBar(titleText: 'Mini-Jeux'),
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
