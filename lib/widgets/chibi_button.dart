import 'package:flutter/material.dart';

class ChibiButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color shadowColor;
  final VoidCallback onPressed;

  const ChibiButton({super.key, required this.text, required this.color, required this.shadowColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 280,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white.withAlpha((255 * 0.8).round()), width: 2.5),
          boxShadow: [BoxShadow(color: shadowColor, offset: const Offset(0, 6), blurRadius: 0)],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              shadows: [Shadow(blurRadius: 3.0, color: Colors.black54, offset: Offset(2.0, 2.0))],
            ),
          ),
        ),
      ),
    );
  }
}
