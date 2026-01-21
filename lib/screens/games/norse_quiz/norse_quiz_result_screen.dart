import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

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
    final rewardTitleStyle = Theme.of(context).textTheme.displayMedium!.copyWith(
      fontFamily: AppTextStyles.amaticSC,
      color: Colors.amber,
      fontWeight: FontWeight.bold,
      fontSize: 30,
      letterSpacing: 1.0,
      shadows: [
        Shadow(
          blurRadius: 8.0,
          color: Colors.black87,
          offset: const Offset(2.0, 2.0),
        ),
      ],
      decoration: TextDecoration.none,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black.withAlpha(0),
                Colors.black.withAlpha((255 * 0.7).round()),
                Colors.black.withAlpha(0),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'norse_quiz_result_screen_correct_answers'.tr(namedArgs: {'score': '${widget.score}'}),
            style: rewardTitleStyle.copyWith(
              fontSize: 24,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (_coinsWon > 0) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withAlpha(0),
                  Colors.black.withAlpha((255 * 0.7).round()),
                  Colors.black.withAlpha(0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'victory_popup_coins_earned_message'.tr(namedArgs: {'coins': '$_coinsWon'}),
              style: rewardTitleStyle.copyWith(
                fontSize: 24,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
        onDismiss: () => context.go('/norse_quiz_preliminary'), // Replay
        onSeeRewards: () => context.go('/trophies'), // Go to trophies
        hideReplayButton: false, // Show replay button
      ),
    );
  }
}
