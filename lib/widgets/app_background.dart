import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final String? imagePath;

  const AppBackground({super.key, required this.child, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            imagePath ?? 'assets/images/backgrounds/main.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
