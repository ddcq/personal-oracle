import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/models/myth_card.dart'; // Import MythCard
import 'package:oracle_d_asgard/utils/image_utils.dart';
import 'package:oracle_d_asgard/widgets/confetti_overlay.dart';
import 'package:confetti/confetti.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/custom_video_player.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:easy_localization/easy_localization.dart';

class VictoryPopup extends StatefulWidget {
  final CollectibleCard? rewardCard;
  final MythCard? unlockedStoryChapter;
  final VoidCallback onDismiss;
  final VoidCallback onSeeRewards;
  final bool isGenericVictory;
  final bool hideReplayButton;

  const VictoryPopup({
    super.key,
    this.rewardCard,
    this.unlockedStoryChapter,
    required this.onDismiss,
    required this.onSeeRewards,
    this.isGenericVictory = false,
    this.hideReplayButton = false,
  });

  @override
  State<VictoryPopup> createState() => _VictoryPopupState();
}

class _VictoryPopupState extends State<VictoryPopup> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();

    // Play card music if a collectible card was won
    if (widget.rewardCard?.id != null) {
      getIt<SoundService>().playCardMusic(widget.rewardCard!.id);
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  TextStyle get _rewardTitleStyle => Theme.of(context).textTheme.displayMedium!.copyWith(
        fontFamily: AppTextStyles.amaticSC,
        color: Colors.amber,
        fontWeight: FontWeight.bold,
        fontSize: 30,
        letterSpacing: 1.0,
        shadows: [Shadow(blurRadius: 8.0, color: Colors.black87, offset: const Offset(2.0, 2.0))],
        decoration: TextDecoration.none,
      );

  TextStyle get _rewardDescriptionStyle =>
      Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 12, color: Colors.white70, decoration: TextDecoration.none);

  Widget _buildGenericContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/odin-happy.webp', height: 150, fit: BoxFit.contain),
        const SizedBox(height: 10),
        Text('victory_popup_congratulations'.tr(), style: _rewardTitleStyle, textAlign: TextAlign.center),
        const SizedBox(height: 5),
        Text(
          'victory_popup_generic_message'.tr(),
          style: const TextStyle(fontSize: 16, color: Colors.white70, decoration: TextDecoration.none),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCardContent(CollectibleCard card) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 150,
          child: card.videoUrl != null && card.videoUrl!.isNotEmpty
              ? CustomVideoPlayer(videoUrl: card.videoUrl!, placeholderAsset: addAssetPrefix(card.imagePath))
              : Image.asset(addAssetPrefix(card.imagePath), fit: BoxFit.contain),
        ),
        const SizedBox(height: 10),
        Text(card.title, style: _rewardTitleStyle, textAlign: TextAlign.center),
        const SizedBox(height: 5),
        Text(card.description, style: _rewardDescriptionStyle, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildStoryContent(MythCard storyChapter) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(addAssetPrefix('stories/${storyChapter.imagePath}'), height: 150, fit: BoxFit.contain),
        const SizedBox(height: 10),
        Text(storyChapter.title, style: _rewardTitleStyle, textAlign: TextAlign.center),
        const SizedBox(height: 5),
        Text(storyChapter.description, style: _rewardDescriptionStyle, textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.isGenericVictory || (widget.rewardCard == null && widget.unlockedStoryChapter == null)) {
      content = _buildGenericContent();
    } else if (widget.rewardCard != null) {
      content = _buildCardContent(widget.rewardCard!);
    } else {
      content = _buildStoryContent(widget.unlockedStoryChapter!);
    }

    return ConfettiOverlay(
      controller: _confettiController,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black54,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey[800],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(128), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'victory_popup_title'.tr(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontFamily: AppTextStyles.amaticSC,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 70,
                        letterSpacing: 2.0,
                        shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                        decoration: TextDecoration.none,
                      ),
                ),
                const SizedBox(height: 20),
                content,
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChibiButton(
                      color: ChibiColors.buttonOrange,
                      onPressed: () => context.go('/'),
                      child: const Icon(Icons.home, color: Colors.white, size: 32),
                    ),
                    if (!widget.hideReplayButton)
                      ChibiButton(
                        color: ChibiColors.buttonGreen,
                        onPressed: widget.onDismiss,
                        child: const Icon(Icons.replay, color: Colors.white, size: 32),
                      ),
                    ChibiButton(
                      color: ChibiColors.buttonBlue,
                      onPressed: widget.onSeeRewards,
                      child: const Icon(Icons.emoji_events, color: Colors.white, size: 32),
                    ),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .scale(begin: const Offset(0.1, 0.1), end: const Offset(1.0, 1.0), duration: 2.seconds, curve: Curves.easeOutBack)
              .fadeIn(duration: 2.seconds, curve: Curves.easeIn),
        ),
      ),
    );
  }
}
