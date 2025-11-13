import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final IconData icon;
  final TextStyle? titleStyle; // New parameter

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.icon = Icons.help_outline,
    this.titleStyle, // Initialize new parameter
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
          backgroundColor: const Color(0xFF2E3B4E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(icon, color: const Color(0xFF81D4FA)),
              const SizedBox(width: 12),
              Text(
                title,
                style:
                    titleStyle ??
                    theme.textTheme.headlineSmall?.copyWith(
                      // Use titleStyle if provided
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          content: SingleChildScrollView(child: content),
          actions: actions,
        )
        .animate()
        .scale(
          begin: const Offset(0.8, 0.8),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 200.ms);
  }
}
