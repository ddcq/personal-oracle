import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/game_help_dialog.dart';

class WelcomeScreenDialog {
  static void show(BuildContext context, {VoidCallback? onGamePaused, VoidCallback? onGameResumed}) {
    final List<String> rules = [
      'Construisez la muraille parfaite comme le géant bâtisseur. Votre objectif est de remplir toutes les cases jusqu’à la ligne dorée sans laisser de trous inaccessibles (fermés de tous les côtés).',
      'Contrôles: ←→ ou A/D pour bouger, ↑/W/Space/Q/E pour pivoter, ↓/S pour descendre (Les contrôles tactiles sont disponibles en jeu)',
    ];

    GameHelpDialog.show(context, rules, onGamePaused: onGamePaused, onGameResumed: onGameResumed);
  }
}