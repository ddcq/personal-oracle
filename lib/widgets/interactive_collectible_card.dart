import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/utils/image_utils.dart';
import 'package:oracle_d_asgard/widgets/custom_video_player.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InteractiveCollectibleCard extends StatefulWidget {
  final CollectibleCard card;
  final bool enableNavigation;
  final bool playVideo;

  const InteractiveCollectibleCard({super.key, required this.card, this.enableNavigation = true, this.playVideo = true});

  @override
  State<InteractiveCollectibleCard> createState() => _InteractiveCollectibleCardState();
}

class _InteractiveCollectibleCardState extends State<InteractiveCollectibleCard> {
  bool _showVideo = true;

  @override
  void initState() {
    super.initState();
    _showVideo = widget.card.videoUrl != null && widget.playVideo;
  }

  @override
  void dispose() {
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
          context.go('/card_detail', extra: widget.card);
        } else if (hasVideo) {
          setState(() {
            _showVideo = !_showVideo;
          });
        }
      },
      child: LayoutBuilder(
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
                        left: -cardWidth * 2, // Initial position off-screen left
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
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true)).slideX(begin: 0, end: cardWidth * 3, duration: 3.seconds),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),    );
  }
}
