import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/main_screen.dart';
import 'package:oracle_d_asgard/widgets/preliminary_page.dart';

class AsgardWallGameScreen extends StatelessWidget {
  const AsgardWallGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PreliminaryPage(
      title: 'games_menu_asgard_wall',
      imagePath: 'assets/images/menu/asgard_wall.webp',
      helpText: 'asgard_wall_preliminary_screen_help_text',
      buttonText: 'asgard_wall_preliminary_screen_start_button',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GameScreen()),
        );
      },
    );
  }
}
