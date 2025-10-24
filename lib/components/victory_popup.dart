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

class VictoryPopup extends StatefulWidget {
  final CollectibleCard? rewardCard; // Made nullable
  final MythCard? unlockedStoryChapter; // New: unlocked story chapter
  final VoidCallback onDismiss;
  final VoidCallback onSeeRewards;
  final bool isGenericVictory; // New: to force generic victory message
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

class _VictoryPopupState extends State<VictoryPopup> with SingleTickerProviderStateMixin {
  late final ConfettiController _confettiController;
  late final SoundService _soundService;
  bool _hasPlayedCardMusic = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _soundService = getIt<SoundService>();

    _confettiController.play();

    // Play card music if a collectible card was won
    if (widget.rewardCard != null && !_hasPlayedCardMusic) {
      _playCardMusic();
    }
  }

  void _playCardMusic() async {
    if (widget.rewardCard?.id != null) {
      await _soundService.playCardMusic(widget.rewardCard!.id);
      _hasPlayedCardMusic = true;
    }
  }

  // Note: Music will automatically resume previous track when card music ends
  // Thanks to the onPlayerComplete listener in SoundService

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      controller: _confettiController,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black54, // Semi-transparent background for the overlay
        child: Center(
          child:
              Container(
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
                          'Victoire !',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontFamily: AppTextStyles.amaticSC,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 70, // Adjust size as needed
                            letterSpacing: 2.0,
                            shadows: [Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (widget.isGenericVictory || (widget.rewardCard == null && widget.unlockedStoryChapter == null)) ...[
                          Image.asset('assets/images/odin-happy.webp', height: 150, fit: BoxFit.contain),
                          const SizedBox(height: 10),
                          Text(
                            'Félicitations !',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontFamily: AppTextStyles.amaticSC,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 30, // Adjust size as needed
                              letterSpacing: 1.0,
                              shadows: [Shadow(blurRadius: 8.0, color: Colors.black87, offset: Offset(2.0, 2.0))],
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Vous avez accompli un exploit digne des dieux !',
                            style: const TextStyle(fontSize: 16, color: Colors.white70, decoration: TextDecoration.none),
                            textAlign: TextAlign.center,
                          ),
                        ] else if (widget.rewardCard != null) ...[
                          SizedBox(
                            height: 150,
                            child: widget.rewardCard!.videoUrl != null && widget.rewardCard!.videoUrl!.isNotEmpty
                                ? CustomVideoPlayer(videoUrl: widget.rewardCard!.videoUrl!, placeholderAsset: addAssetPrefix(widget.rewardCard!.imagePath))
                                : Image.asset(addAssetPrefix(widget.rewardCard!.imagePath), fit: BoxFit.contain),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.rewardCard!.title,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontFamily: AppTextStyles.amaticSC,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 30, // Adjust size as needed
                              letterSpacing: 1.0,
                              shadows: [Shadow(blurRadius: 8.0, color: Colors.black87, offset: Offset(2.0, 2.0))],
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.rewardCard!.description,
                            style: const TextStyle(fontSize: 16, color: Colors.white70, decoration: TextDecoration.none),
                            textAlign: TextAlign.center,
                          ),
                        ] else if (widget.unlockedStoryChapter != null) ...[
                          Image.asset('assets/images/stories/${widget.unlockedStoryChapter!.imagePath}', height: 150, fit: BoxFit.contain),
                          const SizedBox(height: 10),
                          Text(
                            widget.unlockedStoryChapter!.title,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontFamily: AppTextStyles.amaticSC,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 30, // Adjust size as needed
                              letterSpacing: 1.0,
                              shadows: [Shadow(blurRadius: 8.0, color: Colors.black87, offset: const Offset(2.0, 2.0))],
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.unlockedStoryChapter!.description,
                            style: Theme.of(context).textTheme.displayMedium,
                            //?.copyWith(fontSize: 14, color: Colors.white70, decoration: TextDecoration.none),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ChibiButton(
                              color: ChibiColors.buttonOrange,
                              onPressed: () {
                                context.go('/');
                              },
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
    ); // End of Column children
  }
}
