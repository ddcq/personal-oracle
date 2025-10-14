import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/game_controller.dart';

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

    if (selectedCard == null) {
      return const Center(
        child: Text(
          'Sélectionnez une carte pour voir les détails.',
          style: TextStyle(color: Colors.white70, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    }

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
          color: Color.fromARGB((255 * (isEnlarged ? enlargedOpacity : normalOpacity)).round(), 0, 0, 0), // Animated opacity
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
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final boxWidth = constraints.maxWidth;
                    final boxHeight = constraints.maxHeight;

                    // Heuristic to determine font size based on container area.
                    // The divisor (e.g., 8000) can be adjusted to fine-tune the text size.
                    final area = boxWidth * boxHeight;
                    final baseFontSize = (area / 2000).clamp(14.0, 24.0);

                    final normalFontSize = baseFontSize;
                    final enlargedFontSize = normalFontSize + 4;

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white, Colors.transparent],
                                stops: [0.5, 1.0],
                              ).createShader(bounds),
                              blendMode: BlendMode.dstIn,
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(const Color.fromARGB(128, 0, 0, 0), BlendMode.darken),
                                child: Image.asset('assets/images/stories/${selectedCard.imagePath}', fit: BoxFit.cover, alignment: Alignment.topCenter),
                              ),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          padding: EdgeInsets.all(isEnlarged ? enlargedPadding : normalPadding),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(fontSize: isEnlarged ? enlargedFontSize : normalFontSize, color: Colors.white),
                            child: Text(selectedCard.description),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
