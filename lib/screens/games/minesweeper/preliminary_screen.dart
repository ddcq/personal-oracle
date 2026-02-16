import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/minesweeper/main_screen.dart';
import 'package:oracle_d_asgard/widgets/preliminary_page.dart';

class MinesweeperPreliminaryScreen extends StatelessWidget {
  const MinesweeperPreliminaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PreliminaryPage(
      title: 'games_menu_andvari_loot',
      imagePath: 'assets/images/menu/minesweeper.webp',
      helpText: 'minesweeper_preliminary_screen_help_text',
      buttonText: 'minesweeper_preliminary_screen_start_button',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MinesweeperScreen(),
          ),
        );
      },
    );
  }
}
