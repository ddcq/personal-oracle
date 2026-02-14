import 'package:flutter/material.dart';

class SquaredIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double size; // Size of the square button
  final double? iconSize; // Size of the icon if the child is an Icon

  const SquaredIconButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = 60.0, // Default size
    this.iconSize, // Default to null, will calculate if not provided
  });

  @override
  Widget build(BuildContext context) {
    // Calculate effective icon size: 50% larger than a typical 24.0 icon (i.e. 36.0)
    // or 60% of the button's size (60 * 0.6 = 36.0)
    final double effectiveIconSize = iconSize ?? size * 0.7;

    Widget effectiveChild = child;
    if (child is Icon) {
      final Icon originalIcon = child as Icon;
      effectiveChild = Icon(
        originalIcon.icon,
        size: effectiveIconSize,
        color: originalIcon.color,
        semanticLabel: originalIcon.semanticLabel,
        textDirection: originalIcon.textDirection,
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/squared_button.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(child: effectiveChild),
      ),
    );
  }
}
