import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/word_search/main_screen.dart';
import 'package:oracle_d_asgard/widgets/preliminary_page.dart';

class WordSearchPreliminaryScreen extends StatelessWidget {
  const WordSearchPreliminaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PreliminaryPage(
      title: 'games_menu_odin_eye',
      imagePath: 'assets/images/menu/word_search.webp',
      helpText: 'word_search_preliminary_screen_help_text',
      buttonText: 'word_search_preliminary_screen_start_button',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WordSearchScreen()),
        );
      },
    );
  }
}
