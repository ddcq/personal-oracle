import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/widgets/epic_icon_button.dart';

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
  final int? coinsEarned;
  final VoidCallback onDismiss;
  final VoidCallback onSeeRewards;
  final bool isGenericVictory;
  final bool hideReplayButton;

  const VictoryPopup({
    super.key,
    this.rewardCard,
    this.unlockedStoryChapter,
    this.coinsEarned,
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
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
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

  TextStyle get _rewardTitleStyle =>
      Theme.of(context).textTheme.displayMedium!.copyWith(
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

  TextStyle get _rewardDescriptionStyle =>
      Theme.of(context).textTheme.displayMedium!.copyWith(
        fontSize: 12,
        color: Colors.white70,
        decoration: TextDecoration.none,
      );

  Widget _buildGenericContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/odin-happy.webp',
          height: 150,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        Text(
          'victory_popup_congratulations'.tr(),
          style: _rewardTitleStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          'victory_popup_generic_message'.tr(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
            decoration: TextDecoration.none,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCoinsContent(int coins) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.monetization_on,
          size: 120,
          color: Colors.amber,
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: const Duration(seconds: 2))
            .shake(duration: const Duration(milliseconds: 500)),
        const SizedBox(height: 20),
        Text(
          'victory_popup_coins_earned'.tr(),
          style: _rewardTitleStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          '+$coins',
          style: _rewardTitleStyle.copyWith(
            fontSize: 48,
            color: Colors.amber,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCardContent(CollectibleCard card) {
    final imageWidget = SizedBox(
      height: 150,
      child: card.videoUrl != null && card.videoUrl!.isNotEmpty
          ? CustomVideoPlayer(
              videoUrl: card.videoUrl!,
              placeholderAsset: addAssetPrefix(card.imagePath),
            )
          : Image.asset(addAssetPrefix(card.imagePath), fit: BoxFit.contain),
    );

    final titleWidget = Text(
      'collectible_card_${card.id}_title'.tr(),
      style: _rewardTitleStyle,
      textAlign: TextAlign.center,
    );

    final descriptionWidget = Text(
      card.description.tr(),
      style: _rewardDescriptionStyle,
      textAlign: TextAlign.center,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        imageWidget,
        const SizedBox(height: 10),
        titleWidget,
        const SizedBox(height: 5),
        descriptionWidget,
      ],
    );
  }

  Widget _buildStoryContent(MythCard storyChapter) {
    final imageWidget = Image.asset(
      addAssetPrefix('stories/${storyChapter.imagePath}'),
      height: 150,
      fit: BoxFit.contain,
    );

    final titleWidget = Text(
      storyChapter.title.tr(),
      style: _rewardTitleStyle,
      textAlign: TextAlign.center,
    );

    final descriptionWidget = Text(
      storyChapter.description.tr(),
      style: _rewardDescriptionStyle,
      textAlign: TextAlign.center,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        imageWidget,
        const SizedBox(height: 10),
        titleWidget,
        const SizedBox(height: 5),
        descriptionWidget,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.coinsEarned != null) {
      content = _buildCoinsContent(widget.coinsEarned!);
    } else if (widget.isGenericVictory ||
        (widget.rewardCard == null && widget.unlockedStoryChapter == null)) {
      content = _buildGenericContent();
    } else if (widget.rewardCard != null) {
      content = _buildCardContent(widget.rewardCard!);
    } else {
      content = _buildStoryContent(widget.unlockedStoryChapter!);
    }

    final buttonsRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        EpicIconButton(
          color: ChibiColors.buttonOrange,
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.home, color: Colors.white, size: 32),
        ),
        if (!widget.hideReplayButton)
          EpicIconButton(
            color: ChibiColors.buttonGreen,
            onPressed: widget.onDismiss,
            icon: const Icon(Icons.replay, color: Colors.white, size: 32),
          ),
        EpicIconButton(
          color: ChibiColors.buttonBlue,
          onPressed: widget.onSeeRewards,
          icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 32),
        ),
      ],
    );

    return ConfettiOverlay(
      controller: _confettiController,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black54,
        child: Center(
          child:
              Container(
                    constraints: BoxConstraints(
                      maxWidth: 400,
                      maxHeight: MediaQuery.of(context).size.height * 0.9,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[800],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(128),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'victory_popup_title'.tr(),
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                fontFamily: AppTextStyles.amaticSC,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 70,
                                letterSpacing: 2.0,
                                shadows: [
                                  const Shadow(
                                    blurRadius: 15.0,
                                    color: Colors.black87,
                                    offset: Offset(4.0, 4.0),
                                  ),
                                ],
                                decoration: TextDecoration.none,
                              ),
                        ),
                        const SizedBox(height: 20),
                        content,
                        const SizedBox(height: 20),
                        buttonsRow,
                      ],
                    ),
                  )
                  .animate()
                  .scale(
                    begin: const Offset(0.1, 0.1),
                    end: const Offset(1.0, 1.0),
                    duration: 2.seconds,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(duration: 2.seconds, curve: Curves.easeIn),
        ),
      ),
    );
  }
}
