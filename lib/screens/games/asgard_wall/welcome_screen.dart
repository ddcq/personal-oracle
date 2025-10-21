import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/game_help_dialog.dart';

class WelcomeScreenDialog {
  static void show(BuildContext context, {VoidCallback? onGamePaused, VoidCallback? onGameResumed}) {
    final List<String> rules = [
      'asgard_wall_welcome_screen_rule_1'.tr(),
      'asgard_wall_welcome_screen_rule_2'.tr(),
    ];

    GameHelpDialog.show(context, rules, onGamePaused: onGamePaused ?? () {}, onGameResumed: onGameResumed ?? () {});
  }
}
