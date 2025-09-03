import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/game_help_dialog.dart';

class HelpDialog {
  static void show(BuildContext context, {VoidCallback? onGamePaused, VoidCallback? onGameResumed}) {
    final List<String> rules = [
      'Remettez les cartes dans l\'ordre chronologique du mythe nordique.',
      'Glissez une carte sur une autre pour les échanger.',
      'L\'icône ⭲ indique qu\'une carte est déplaçable.',
      'Organisez-les de la première à la dernière étape.',
      'Cliquez sur "Valider l\'ordre" pour vérifier.',
      'Les cartes correctes apparaîtront avec un contour vert ✅.',
    ];

    GameHelpDialog.show(context, rules, onGamePaused: onGamePaused, onGameResumed: onGameResumed);
  }
}
