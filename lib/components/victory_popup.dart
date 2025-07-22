import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';

class VictoryPopup extends StatefulWidget {
  final CollectibleCard rewardCard;
  final VoidCallback onDismiss;

  const VictoryPopup({
    super.key,
    required this.rewardCard,
    required this.onDismiss,
  });

  @override
  State<VictoryPopup> createState() => _VictoryPopupState();
}

class _VictoryPopupState extends State<VictoryPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
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
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Victoire !',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    widget.rewardCard.imagePath,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.rewardCard.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.rewardCard.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: widget.onDismiss,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Continuer',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
