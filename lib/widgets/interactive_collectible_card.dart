import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import 'dart:async'; // For StreamSubscription
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/screens/collectible_card_detail_page.dart';
import 'package:oracle_d_asgard/utils/image_utils.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/foundation.dart'; // For defaultTargetPlatform
import 'package:oracle_d_asgard/widgets/video_player_with_cache_and_ping_pong.dart';

class InteractiveCollectibleCard extends StatefulWidget {
  final CollectibleCard card;

  const InteractiveCollectibleCard({super.key, required this.card});

  @override
  State<InteractiveCollectibleCard> createState() => _InteractiveCollectibleCardState();
}

class _InteractiveCollectibleCardState extends State<InteractiveCollectibleCard> with SingleTickerProviderStateMixin {
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;
  bool _isMobile = false;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);

    _shineAnimation = Tween<double>(
      begin: -2.0, // Start off-screen left (relative to card width)
      end: 1.0, // End off-screen right (relative to card width)
    ).animate(_shineController);

    _isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  void build(BuildContext context) {
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
                    return AspectRatio(
                        aspectRatio: 1.0, // Force the card to be square
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            children: [
                              if (widget.card.videoUrl != null)
                                VideoPlayerWithCacheAndPingPong(
                                  videoUrl: widget.card.videoUrl!,
                                  placeholderAsset: addAssetPrefix(widget.card.imagePath),
                                )
                              else
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
                      return AspectRatio(
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
