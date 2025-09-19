import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import '../game_controller.dart';

class DetailPanel extends StatelessWidget {
  // Changed to StatelessWidget
  final GameController controller;
  final bool isEnlarged; // New parameter
  final VoidCallback onToggleEnlargement; // New parameter

  const DetailPanel({
    super.key,
    required this.controller,
    required this.isEnlarged, // Required
    required this.onToggleEnlargement, // Required
  });

  @override
  Widget build(BuildContext context) {
    final selectedCard = controller.selectedMythCard; // Use controller directly
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (selectedCard == null) {
      return const Center(
        child: Text(
          'Sélectionnez une carte pour voir les détails.',
          style: TextStyle(color: Colors.white70, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    double normalFontSize;
    if (screenWidth > 1200) {
      normalFontSize = 20;
    } else if (screenWidth > 800) {
      normalFontSize = 18;
    } else {
      normalFontSize = 16;
    }
    final enlargedFontSize = normalFontSize + 4;
    final double titleFontSize = isLandscape ? (screenWidth > 800 ? 22 : 18) : (screenWidth > 800 ? 40 : 36);

    // Define normal and enlarged states
    final double normalPadding = 16.0;
    final double enlargedPadding = 32.0;
    final double normalOpacity = 0.6;
    final double enlargedOpacity = 0.8;

    return GestureDetector(
      onTap: onToggleEnlargement, // Use the callback
      child: AnimatedContainer(
        // Animated container for the frame
        duration: const Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut, // Animation curve
        height: double.infinity, // Make the container take all available height
        // Removed margin: const EdgeInsets.only(top: 8.0), // Add top margin
        // Removed padding: EdgeInsets.all(_isEnlarged ? enlargedPadding : normalPadding), // Animated padding
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(((isEnlarged ? enlargedOpacity : normalOpacity) * 255).round()), // Animated opacity
          borderRadius: BorderRadius.circular(12), // Rounded corners
          border: Border.all(color: Colors.amber, width: 2), // Amber border
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(77), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Padding(
          // Add padding here
          padding: EdgeInsets.only(bottom: isEnlarged ? enlargedPadding : normalPadding),
          child: Column(
            // Main column for image and description
            children: [
              // Image, Gradient, and Title Stack
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: SizedBox(
                  height: 200.0,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Colors.transparent],
                            stops: [0.5, 1.0],
                          ).createShader(bounds),
                          blendMode: BlendMode.dstIn,
                          child: Image.asset('assets/images/stories/${selectedCard.imagePath}', fit: BoxFit.cover, alignment: Alignment.topCenter),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontFamily: isLandscape ? null : AppTextStyles.amaticSC,
                            fontSize: titleFontSize,
                            fontWeight: isLandscape ? FontWeight.normal : FontWeight.bold,
                            color: Colors.white,
                            shadows: const [Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(2.0, 2.0))],
                          ),
                          textAlign: TextAlign.center,
                          child: Text(isLandscape ? selectedCard.description : selectedCard.title),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLandscape)
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isEnlarged ? enlargedPadding : normalPadding),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(fontSize: isEnlarged ? enlargedFontSize : normalFontSize, color: Colors.white70),
                      child: Text(selectedCard.description),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
