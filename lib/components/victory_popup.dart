import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/utils/image_utils.dart';
import 'package:confetti/confetti.dart';

class VictoryPopup extends StatefulWidget {
  final CollectibleCard rewardCard;
  final VoidCallback onDismiss;

  const VictoryPopup({super.key, required this.rewardCard, required this.onDismiss});

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
    _confettiController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800], // Revert to a solid color or make it transparent
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(128), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8, maxHeight: MediaQuery.of(context).size.height * 0.7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Victoire !',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontFamily: 'AmaticSC',
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
                          fontFamily: 'AmaticSC',
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
                      ChibiButton(
                        text: 'Continuer',
                        color: const Color(0xFF1E88E5), // Blue, matching one of the main screen buttons
                        onPressed: widget.onDismiss,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ],
        ),
      ),
    ); // End of Column children
  }
}
