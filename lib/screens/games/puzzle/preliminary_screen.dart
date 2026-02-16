import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/puzzle/main_screen.dart';
import 'package:oracle_d_asgard/widgets/preliminary_page.dart';

// =========================================
// PUZZLE GAME - Les Runes Dispersées
// =========================================
class PuzzlePreliminaryScreen extends StatelessWidget {
  const PuzzlePreliminaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PreliminaryPage(
      title: 'puzzle_screen_title',
      imagePath: 'assets/images/menu/puzzle.webp',
      helpText: 'puzzle_preliminary_screen_help_text',
      buttonText: 'puzzle_preliminary_screen_start_button',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PuzzleScreen()),
        );
      },
    );
  }
}
