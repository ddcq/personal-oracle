import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/game_help_dialog.dart';

class HelpDialog {
  static void show(BuildContext context, {VoidCallback? onGamePaused, VoidCallback? onGameResumed}) {
    final List<String> rules = [
      'order_the_scrolls_help_dialog_rule_1'.tr(),
      'order_the_scrolls_help_dialog_rule_2'.tr(),
      'order_the_scrolls_help_dialog_rule_3'.tr(),
      'order_the_scrolls_help_dialog_rule_4'.tr(),
      'order_the_scrolls_help_dialog_rule_5'.tr(),
      'order_the_scrolls_help_dialog_rule_6'.tr(),
    ];

    GameHelpDialog.show(context, rules, onGamePaused: onGamePaused ?? () {}, onGameResumed: onGameResumed ?? () {});
  }
}
