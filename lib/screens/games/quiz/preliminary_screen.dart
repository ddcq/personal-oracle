import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/preliminary_page.dart';

class QuizPreliminaryScreen extends StatelessWidget {
  const QuizPreliminaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PreliminaryPage(
      title: 'games_menu_quiz',
      imagePath: 'assets/images/menu/quiz.webp',
      helpText: 'quiz_preliminary_screen_help_text',
      buttonText: 'quiz_preliminary_screen_start_button',
      onPressed: () {
        context.go('/quiz');
      },
    );
  }
}
