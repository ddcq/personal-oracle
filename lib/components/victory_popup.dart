import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

import 'package:oracle_d_asgard/utils/text_styles.dart';

import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/myth_card.dart'; // Import MythCard
import 'package:oracle_d_asgard/utils/image_utils.dart';
import 'package:oracle_d_asgard/widgets/confetti_overlay.dart';
import 'package:confetti/confetti.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/custom_video_player.dart';

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
  late AnimationController _controller;
  late Animation<double> _scaleAnimation; // Changed from slide to scale
  late Animation<double> _fadeAnimation;
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // Changed duration to 2 seconds
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    // Using TweenSequence for custom bounce effect (0.1 -> 1.5 -> 0.5 -> 1.2 -> 1.0)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.1, end: 1.5).chain(CurveTween(curve: Curves.easeOut)), weight: 70.0),
      TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 0.5).chain(CurveTween(curve: Curves.easeIn)), weight: 30.0),
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.2).chain(CurveTween(curve: Curves.easeOut)), weight: 20.0),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10.0),
    ]).animate(_controller);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _confettiController = ConfettiController(duration: const Duration(seconds: 2));

    _controller.forward();
    _confettiController.play();
  }

  @override
  void dispose() {
    _controller.dispose();
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
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
                      'Victoire !',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontFamily: AppTextStyles.amaticSC,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 70, // Adjust size as needed
                        letterSpacing: 2.0,
                        shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
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
                          shadows: [const Shadow(blurRadius: 8.0, color: Colors.black87, offset: Offset(2.0, 2.0))],
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
                            ? CustomVideoPlayer(
                                videoUrl: widget.rewardCard!.videoUrl!,
                                placeholderAsset: addAssetPrefix(widget.rewardCard!.imagePath),
                              )
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
                          shadows: [const Shadow(blurRadius: 8.0, color: Colors.black87, offset: Offset(2.0, 2.0))],
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
                          shadows: [const Shadow(blurRadius: 8.0, color: Colors.black87, offset: Offset(2.0, 2.0))],
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.unlockedStoryChapter!.description,
                        style: const TextStyle(fontSize: 16, color: Colors.white70, decoration: TextDecoration.none),
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
                            Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> a) => false);
                          },
                          child: const Icon(Icons.home, color: Colors.white, size: 32),
                        ),
                        if (!widget.hideReplayButton)
                          ChibiButton(
                            color: ChibiColors.buttonGreen,
                            onPressed: widget.onDismiss, // Assuming onDismiss is for replaying
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
              ),
            ),
          ),
        ),
      ),
    ); // End of Column children
  }
}
