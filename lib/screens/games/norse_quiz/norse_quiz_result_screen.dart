import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';

class NorseQuizResultScreen extends StatefulWidget {
  final int score;

  const NorseQuizResultScreen({super.key, required this.score});

  @override
  State<NorseQuizResultScreen> createState() => _NorseQuizResultScreenState();
}

class _NorseQuizResultScreenState extends State<NorseQuizResultScreen> {
  int _coinsWon = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _processResult();
  }

  void _processResult() async {
    // Calculate coins
    if (widget.score == 10) {
      _coinsWon = 100;
    } else if (widget.score == 9) {
      _coinsWon = 50;
    } else if (widget.score == 8) {
      _coinsWon = 10;
    } else {
      _coinsWon = 0;
    }

    if (_coinsWon > 0) {
      await getIt<GamificationService>().addCoins(_coinsWon);
    }

    // Handle level up
    if (widget.score == 10) {
      final currentLevel = await getIt<GamificationService>().getNorseQuizLevel();
      if (currentLevel < 10) {
        final newLevel = currentLevel + 1;
        await getIt<GamificationService>().saveNorseQuizLevel(newLevel);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildResultContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'norse_quiz_result_screen_correct_answers'.tr(namedArgs: {'score': '${widget.score}'}),
          style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        if (_coinsWon > 0)
          Text(
            'victory_popup_coins_earned_message'.tr(namedArgs: {'coins': '$_coinsWon'}),
            style: const TextStyle(fontSize: 22, color: Colors.amber, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: AppBackground(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return AppBackground(
      child: VictoryPopup(
        customTitle: 'victory_popup_title'.tr(),
        content: _buildResultContent(),
        onDismiss: () => context.go('/norse_quiz'), // Replay
        onSeeRewards: () => context.go('/games'), // Back to games
        hideReplayButton: false, // Show replay button
      ),
    );
  }
}
