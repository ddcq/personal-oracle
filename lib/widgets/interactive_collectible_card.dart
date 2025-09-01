import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import 'dart:async'; // For StreamSubscription
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/screens/collectible_card_detail_page.dart';
import 'package:oracle_d_asgard/utils/image_utils.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/foundation.dart'; // For defaultTargetPlatform

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
  StreamSubscription? _accelerometerSubscription;
  bool _isMobile = false;
  double _initialAccelerometerX = 0;
  double _initialAccelerometerY = 0;
  bool _initialAccelerometerCaptured = false;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);

    _shineAnimation = Tween<double>(
      begin: -2.0, // Start off-screen left (relative to card width)
      end: 1.0, // End off-screen right (relative to card width)
    ).animate(_shineController);

    _isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

    if (_isMobile) {
      _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
        // Capture initial accelerometer values on the first event
        if (!_initialAccelerometerCaptured) {
          _initialAccelerometerX = event.x;
          _initialAccelerometerY = event.y;
          _initialAccelerometerCaptured = true;
        }

        setState(() {
          // Calculate rotation relative to initial inclination
          _rotationX = (event.y - _initialAccelerometerY) * 0.1; // Adjust multiplier for sensitivity
          _rotationY = (event.x - _initialAccelerometerX) * 0.1; // Adjust multiplier for sensitivity
        });
      });
    }
  }

  @override
  void dispose() {
    _shineController.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _onPointerHover(PointerHoverEvent event) {
    if (_isMobile) return; // Only apply hover effect on non-mobile

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
    if (_isMobile) return; // Only apply hover effect on non-mobile

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
      child: _isMobile
          ? AnimatedBuilder(
              animation: _shineAnimation,
              builder: (context, child) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = constraints.maxWidth;
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
                              Image.asset(addAssetPrefix(widget.card.imagePath), fit: BoxFit.contain),
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
                                      colors: [Colors.white.withAlpha(0), Colors.white.withAlpha(76), Colors.white.withAlpha(0)],
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
                );
              },
            )
          : MouseRegion(
              onHover: _onPointerHover,
              onExit: _onPointerExit,
              child: AnimatedBuilder(
                animation: _shineAnimation,
                builder: (context, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = constraints.maxWidth;
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
                                Image.asset(addAssetPrefix(widget.card.imagePath), fit: BoxFit.contain),
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
                                        colors: [Colors.white.withAlpha(0), Colors.white.withAlpha(76), Colors.white.withAlpha(0)],
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
                  );
                },
              ),
            ),
    );
  }
}
