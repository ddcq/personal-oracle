import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:oracle_d_asgard/models/collectible_card.dart';

class CollectibleCardDetailPage extends StatefulWidget {
  final CollectibleCard card;

  const CollectibleCardDetailPage({super.key, required this.card});

  @override
  State<CollectibleCardDetailPage> createState() => _CollectibleCardDetailPageState();
}

class _CollectibleCardDetailPageState extends State<CollectibleCardDetailPage> with SingleTickerProviderStateMixin {
  double _rotationX = 0;
  double _rotationY = 0;
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);

    _shineAnimation = Tween<double>(
      begin: -2.0, // Start off-screen left (relative to card width)
      end: 1.0, // End off-screen right (relative to card width)
    ).animate(_shineController);
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  void _onPointerHover(PointerHoverEvent event) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(event.position);
    final Size size = box.size;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    _rotationY = (localPosition.dx - centerX) / centerX * 0.3; // Max 0.3 radians
    _rotationX = (localPosition.dy - centerY) / centerY * -0.3; // Max 0.3 radians, inverted

    setState(() {});
  }

  void _onPointerExit(PointerExitEvent event) {
    setState(() {
      _rotationX = 0;
      _rotationY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.card.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // For back button
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A148C), // Dark Purple
              Color(0xFF880E4F), // Dark Pink
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MouseRegion(
                  onHover: _onPointerHover,
                  onExit: _onPointerExit,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = constraints.maxWidth;
                      return AnimatedBuilder(
                        animation: _shineAnimation,
                        builder: (context, child) {
                          return Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001) // Perspective
                              ..rotateX(_rotationX)
                              ..rotateY(_rotationY),
                            child: AspectRatio(
                              aspectRatio: 1.0, // Force the card to be square
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Stack(
                                  children: [
                                    Image.asset(widget.card.imagePath, fit: BoxFit.contain),
                                    // Shine overlay
                                    Positioned(
                                      left: _shineAnimation.value * cardWidth, // Scale animation based on card width
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: cardWidth * 3, // Set shine width to card width
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Colors.white.withAlpha(0), Colors.white.withAlpha((255 * 0.3).toInt()), Colors.white.withAlpha(0)],
                                            begin: Alignment(-0.86, -0.5), // 30 degrees angle
                                            end: Alignment(0.86, 0.5), // 30 degrees angle
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.card.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.card.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
