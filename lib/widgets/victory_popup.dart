import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/widgets/app_dialog.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart'; // Import ChibiColors

class VictoryPopup extends StatelessWidget {
  final int score;
  final CollectibleCard wonCard;
  final VoidCallback onResetGame;

  const VictoryPopup({
    super.key,
    required this.score,
    required this.wonCard,
    required this.onResetGame,
  });

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: '🎉 Victoire ! 🎉',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Votre score : $score',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 20),
          Text(
            'Vous avez gagné une carte !',
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Image.asset(
            'assets/images/${wonCard.imagePath}',
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Text(
            wonCard.title,
            style: AppTextStyles.cardTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ChibiButton(
            text: 'Rejouer',
            color: ChibiColors.buttonOrange, // Added color
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              onResetGame();
            },
          ),
        ],
      ),
    );
  }
}
