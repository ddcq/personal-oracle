import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/epic_button.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart'; // Import ChibiColors
import 'package:flutter_animate/flutter_animate.dart';

class GameOverPopup extends StatefulWidget {
  final Widget content;
  final VoidCallback onReplay;
  final VoidCallback onMenu;

  const GameOverPopup({super.key, required this.content, required this.onReplay, required this.onMenu});

  @override
  State<GameOverPopup> createState() => _GameOverPopupState();
}

class _GameOverPopupState extends State<GameOverPopup> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey[800]!.withAlpha(128), // Semi-transparent background color
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ChibiColors.buttonOrange), // Changed border color
          image: const DecorationImage(image: AssetImage('assets/images/backgrounds/defeated.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.content,
            const SizedBox(height: 16),
            Image.asset('assets/images/odin_sad.webp', height: 200),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EpicButton(iconData: Icons.replay, onPressed: widget.onReplay),
                EpicButton(iconData: Icons.home, onPressed: widget.onMenu),
              ],
            ),
          ],
        ),
      ).animate().slideY(begin: 1, end: 0, duration: 700.ms, curve: Curves.easeOutBack).fadeIn(duration: 700.ms, curve: Curves.easeIn),
    );
  }
}
