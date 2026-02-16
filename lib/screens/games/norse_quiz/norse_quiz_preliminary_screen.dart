import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/preliminary_page.dart';

class NorseQuizPreliminaryScreen extends StatelessWidget {
  const NorseQuizPreliminaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PreliminaryPage(
      title: 'games_menu_norse_quiz',
      imagePath: 'assets/images/menu/norse_quiz.webp',
      helpText: 'norse_quiz_preliminary_screen_help_text',
      buttonText: 'norse_quiz_preliminary_screen_start_button',
      onPressed: () {
        context.go('/norse_quiz');
      },
    );
  }
}
