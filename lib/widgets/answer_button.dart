// Widget pour les boutons de réponse
import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String letter;

  const AnswerButton({
    super.key, 
    required this.text,
    required this.onPressed,
    required this.letter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 280,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF1E88E5), // Blue
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white.withAlpha((255 * 0.8).round()), width: 2.5),
          boxShadow: [BoxShadow(color: const Color(0xFF155FA0), offset: const Offset(0, 6), blurRadius: 0)],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: Colors.black, // Use black color for the letter on white background
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [Shadow(blurRadius: 3.0, color: Colors.black54, offset: Offset(2.0, 2.0))],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}