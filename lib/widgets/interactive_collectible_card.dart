import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/screens/collectible_card_detail_page.dart';
import 'package:oracle_d_asgard/utils/image_utils.dart';
import 'package:oracle_d_asgard/widgets/custom_video_player.dart';

class InteractiveCollectibleCard extends StatefulWidget {
  final CollectibleCard card;
  final bool enableNavigation;
  final bool playVideo;

  const InteractiveCollectibleCard({super.key, required this.card, this.enableNavigation = true, this.playVideo = true});

  @override
  State<InteractiveCollectibleCard> createState() => _InteractiveCollectibleCardState();
}

class _InteractiveCollectibleCardState extends State<InteractiveCollectibleCard> with SingleTickerProviderStateMixin {
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;
  bool _showVideo = true;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);

    _shineAnimation = Tween<double>(
      begin: -2.0, // Start off-screen left (relative to card width)
      end: 1.0, // End off-screen right (relative to card width)
    ).animate(_shineController);

    _showVideo = widget.card.videoUrl != null && widget.playVideo;
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InteractiveCollectibleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card != oldWidget.card || widget.playVideo != oldWidget.playVideo) {
      setState(() {
        _showVideo = widget.card.videoUrl != null && widget.playVideo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasVideo = widget.card.videoUrl != null;

    return GestureDetector(
      onTap: () {
        if (widget.enableNavigation) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CollectibleCardDetailPage(card: widget.card)));
        } else if (hasVideo) {
          setState(() {
            _showVideo = !_showVideo;
          });
        }
      },
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
                      if (hasVideo && _showVideo)
                        CustomVideoPlayer(videoUrl: widget.card.videoUrl!, placeholderAsset: addAssetPrefix(widget.card.imagePath))
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
              );
            },
          );
        },
      ),
    );
  }
}
