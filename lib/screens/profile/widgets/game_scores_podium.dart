import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/profile/utils/profile_helpers.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class GameScoresPodium extends StatelessWidget {
  final List<Map<String, dynamic>> scores;
  final String gameName;

  const GameScoresPodium({
    super.key,
    required this.scores,
    required this.gameName,
  });

  @override
  Widget build(BuildContext context) {
    if (scores.isEmpty) {
      final translationKey = gameName == 'Snake' 
          ? 'profile_screen_no_snake_scores' 
          : 'profile_screen_no_asgard_wall_scores';
      return Text(
        translationKey.tr(),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70, fontFamily: AppTextStyles.amaticSC, fontSize: 20),
        textAlign: TextAlign.center,
      );
    }

    final mutableScores = List<Map<String, dynamic>>.from(scores);
    mutableScores.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    final topScores = mutableScores.take(3).toList();

    Widget? firstPlace;
    Widget? secondPlace;
    Widget? thirdPlace;

    if (topScores.isNotEmpty) {
      firstPlace = _buildPodiumPlace(context, topScores[0], 1);
    }
    if (topScores.length > 1) {
      secondPlace = _buildPodiumPlace(context, topScores[1], 2);
    }
    if (topScores.length > 2) {
      thirdPlace = _buildPodiumPlace(context, topScores[2], 3);
    }

    return Column(
      children: [
        Text(
          gameName == 'Snake' ? 'profile_screen_snake_podium'.tr() : '$gameName - Podium',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: AppTextStyles.amaticSC,
                fontSize: 28,
                shadows: [const Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(3.0, 3.0))],
              ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (secondPlace != null) Flexible(child: secondPlace),
            if (firstPlace != null) Flexible(child: firstPlace),
            if (thirdPlace != null) Flexible(child: thirdPlace),
          ],
        ),
      ],
    );
  }

  Widget _buildPodiumPlace(BuildContext context, Map<String, dynamic> score, int rank) {
    final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(score['timestamp']);

    final podiumConfig = {
      1: {
        'color': Colors.amber,
        'height': 201.0,
        'iconSize': 50.0,
        'gradient': const LinearGradient(colors: [Color(0xFFFFFDE7), Colors.amber], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      },
      2: {
        'color': const Color(0xFFC0C0C0),
        'height': 181.0,
        'iconSize': 40.0,
        'gradient': const LinearGradient(colors: [Color(0xFFF5F5F5), Color(0xFFBDBDBD)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      },
      3: {
        'color': const Color(0xFFCD7F32),
        'height': 161.0,
        'iconSize': 40.0,
        'gradient': const LinearGradient(colors: [Color(0xFFFFEADD), Color(0xFFD8A166)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      },
    };

    final config = podiumConfig[rank]!;
    final double height = config['height'] as double;
    final Gradient gradient = config['gradient'] as Gradient;

    return Container(
      width: 100,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        border: Border.all(color: Colors.black.withAlpha(51)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(77), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(getPodiumImagePath(rank), height: 64, width: 64),
            const Spacer(),
            Text(
              '${score['score']}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black.withAlpha(204),
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.amaticSC,
                    fontSize: 26,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              formatRelativeTime(timestamp),
              style: const TextStyle(color: Colors.black, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
