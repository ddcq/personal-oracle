import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

import 'package:oracle_d_asgard/utils/text_styles.dart';

import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/utils/image_utils.dart';
import 'package:oracle_d_asgard/widgets/confetti_overlay.dart';
import 'package:confetti/confetti.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';

class VictoryPopup extends StatefulWidget {
  final CollectibleCard rewardCard;
  final VoidCallback onDismiss;
  final VoidCallback onSeeRewards;

  const VictoryPopup({super.key, required this.rewardCard, required this.onDismiss, required this.onSeeRewards});

  @override
  State<VictoryPopup> createState() => _VictoryPopupState();
}

class _VictoryPopupState extends State<VictoryPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

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
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black54, // Semi-transparent background for the overlay
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
                      'Victoire !',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontFamily: AppTextStyles.amaticSC,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 70, // Adjust size as needed
                        letterSpacing: 2.0,
                        shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(addAssetPrefix(widget.rewardCard.imagePath), height: 150, fit: BoxFit.contain),
                    const SizedBox(height: 10),
                    Text(
                      widget.rewardCard.title,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontFamily: AppTextStyles.amaticSC,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 30, // Adjust size as needed
                        letterSpacing: 1.0,
                        shadows: [const Shadow(blurRadius: 8.0, color: Colors.black87, offset: Offset(2.0, 2.0))],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.rewardCard.description,
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        ChibiButton(
                          text: 'Menu principal',
                          color: ChibiColors.buttonOrange,
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> a) => false);
                          },
                        ),
                        const SizedBox(height: 10),
                        ChibiButton(
                          text: 'Voir mes récompenses',
                          color: ChibiColors.buttonBlue,
                          onPressed: widget.onSeeRewards,
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
