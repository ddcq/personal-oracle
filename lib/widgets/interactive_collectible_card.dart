import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/screens/collectible_card_detail_page.dart';

class InteractiveCollectibleCard extends StatefulWidget {
  final CollectibleCard card;

  const InteractiveCollectibleCard({super.key, required this.card});

  @override
  State<InteractiveCollectibleCard> createState() => _InteractiveCollectibleCardState();
}

class _InteractiveCollectibleCardState extends State<InteractiveCollectibleCard> with SingleTickerProviderStateMixin {
  double _rotationX = 0;
  double _rotationY = 0;
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);

    _shineAnimation = Tween<double>(
      begin: -200.0, // Start off-screen left (width of shine effect)
      end: 200.0 + 200.0,   // End off-screen right (card width + shine width)
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
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CollectibleCardDetailPage(card: widget.card)));
      },
      child: MouseRegion(
        onHover: _onPointerHover,
        onExit: _onPointerExit,
        child: AnimatedBuilder(
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
                        left: _shineAnimation.value,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 200, // Width of the shine effect
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white.withAlpha(0), Colors.white.withAlpha((255 * 0.3).toInt()), Colors.white.withAlpha(0)],
                              begin: Alignment(-math.cos(math.pi / 6), -math.sin(math.pi / 6)), // 30 degrees angle
                              end: Alignment(math.cos(math.pi / 6), math.sin(math.pi / 6)), // 30 degrees angle
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
        ),
      ),
    );
  }
}
