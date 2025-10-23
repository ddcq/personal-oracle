import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/game_over_popup.dart';

class SnakeGameOverPopup extends StatelessWidget {
  final int score;
  final VoidCallback onResetGame;

  const SnakeGameOverPopup({super.key, required this.score, required this.onResetGame});

  @override
  Widget build(BuildContext context) {
    return GameOverPopup(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'snake_game_over_popup_title'.tr(),
            style: TextStyle(
              color: Colors.white, // Changed to white
              fontSize: 36,
              fontWeight: FontWeight.bold, // Added bold
              fontFamily: AppTextStyles.amaticSC, // Added font family
              shadows: [Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0, 2.0))],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'snake_game_over_popup_message'.tr(namedArgs: {'score': '$score'}),
            style: TextStyle(
              color: Colors.white, // Changed to white
              fontSize: 24,
              fontWeight: FontWeight.bold, // Added bold
              fontFamily: AppTextStyles.amaticSC, // Added font family
              shadows: [Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(1.0, 1.0))],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      onReplay: () {
        Navigator.of(context).pop();
        onResetGame();
      },
      onMenu: () {
        Navigator.of(context).pop();
        context.go('/');
      },
    );
  }
}
