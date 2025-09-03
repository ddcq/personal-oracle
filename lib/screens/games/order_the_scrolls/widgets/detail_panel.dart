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
    final double normalFontSize = 16.0;
    final double enlargedFontSize = 20.0;

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
          padding: EdgeInsets.fromLTRB(
            0, // No left padding for the image
            0, // No top padding for the image
            0, // No right padding for the image
            isEnlarged ? enlargedPadding : normalPadding, // Only bottom padding
          ),
          child: Column(
            // Main column for image and description
            children: [
              // Image, Gradient, and Title Stack
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)), // Match container's top radius
                child: SizedBox(
                  // Replaced AspectRatio with SizedBox
                  height: 200.0, // Fixed height for the image container
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white, // Fully opaque at the top
                                Colors.transparent, // Fully transparent at the bottom
                              ],
                              stops: const [0.5, 1.0], // Gradient starts at 50%
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn, // Apply the gradient as a transparency mask
                          child: Image.asset(
                            'assets/images/stories/${selectedCard.imagePath}',
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter, // Align image to top
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: AnimatedDefaultTextStyle(
                          // Animated font size for title
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontFamily: AppTextStyles.amaticSC,
                            fontSize: isEnlarged ? enlargedFontSize + 16 : normalFontSize + 20, // Adjust title font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(2.0, 2.0))],
                          ),
                          textAlign: TextAlign.center,
                          child: Text(selectedCard.title),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Description
              Expanded(
                // Make description scrollable and take remaining space
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    isEnlarged ? enlargedPadding : normalPadding, // Apply horizontal padding here
                    isEnlarged ? enlargedPadding : normalPadding, // Apply top padding here
                    isEnlarged ? enlargedPadding : normalPadding, // Apply horizontal padding here
                    isEnlarged ? enlargedPadding : normalPadding, // Apply bottom padding here
                  ),
                  child: AnimatedDefaultTextStyle(
                    // Animated font size for description
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: isEnlarged ? enlargedFontSize : normalFontSize, // Animated font size
                      color: Colors.white70,
                    ),
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
