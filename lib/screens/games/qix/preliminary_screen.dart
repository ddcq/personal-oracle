import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/qix/main_screen.dart';
import 'package:oracle_d_asgard/widgets/preliminary_page.dart';

class QixPreliminaryScreen extends StatelessWidget {
  const QixPreliminaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PreliminaryPage(
      title: 'games_menu_territory_conquest',
      imagePath: 'assets/images/menu/qix.webp',
      helpText: 'qix_preliminary_screen_help_text',
      buttonText: 'qix_preliminary_screen_start_button',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QixGameScreen()),
        );
      },
    );
  }
}
