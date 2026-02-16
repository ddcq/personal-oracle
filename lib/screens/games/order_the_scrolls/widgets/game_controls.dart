import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/game_controller.dart';
import 'package:oracle_d_asgard/widgets/chibi_text_button.dart';
import 'package:oracle_d_asgard/providers/responsive_provider.dart';

class GameControls extends StatelessWidget {
  final GameController controller;
  final VoidCallback onValidate;
  final VoidCallback onReset;

  const GameControls({
    super.key,
    required this.controller,
    required this.onValidate,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final buttonTextStyle = TextStyle(
      // Define a common text style for buttons
      fontSize: responsive.sp(16),
      fontWeight: FontWeight.bold,
      letterSpacing: responsive.sp(1.5),
      color: Colors.white,
    );

    if (!controller.validated) {
      return SizedBox(
        width: double.infinity,
        height: responsive.height(50), // Adjusted height with responsive
        child: ChibiTextButton(
          // Replaced TextButton with ChibiButton
          text: 'Valider l\'ordre',
          color: const Color(0xFFF9A825), // Orange color from main screen
          onPressed: onValidate,
          textStyle: buttonTextStyle,
        ),
      );
    }

    return Column(
      children: [
        if (controller.isOrderCompletelyCorrect())
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(
                150,
              ), // Changed to black with alpha 150
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF22C55E), width: 2),
            ),
            child: const Text(
              '✅ Bravo ! Vous avez reconstitué l\'histoire et gagné toutes les cartes ! ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        SizedBox(height: responsive.height(12)), // Adjusted height with .h
        SizedBox(
          width: double.infinity,
          height: responsive.height(50), // Adjusted height with responsive
          child: ChibiTextButton(
            // Replaced TextButton with ChibiButton
            text: 'Rejouer avec un autre mythe',
            color: const Color(0xFF1E88E5), // Blue color from main screen
            onPressed: onReset,
            textStyle: buttonTextStyle,
          ),
        ),
      ],
    );
  }
}
