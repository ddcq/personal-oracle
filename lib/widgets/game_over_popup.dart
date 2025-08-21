import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart'; // Import ChibiColors

class GameOverPopup extends StatefulWidget {
  final Widget content;
  final List<Widget> actions;

  const GameOverPopup({
    super.key,
    required this.content,
    this.actions = const [],
  });

  @override
  State<GameOverPopup> createState() => _GameOverPopupState();
}

class _GameOverPopupState extends State<GameOverPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey[800]!.withOpacity(0.5), // Semi-transparent background color
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ChibiColors.buttonOrange), // Changed border color
              image: DecorationImage(
                image: AssetImage('assets/images/backgrounds/defeated.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/odin_sad.png',
                  height: 100,
                ),
                const SizedBox(height: 16),
                widget.content, // Use widget.content
                const SizedBox(height: 16),
                ...widget.actions, // Use widget.actions
                const SizedBox(height: 8),
                ChibiButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> a) => false);
                  },
                  text: 'Menu principal',
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}