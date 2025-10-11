import 'package:flutter/material.dart';

import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/widgets/custom_video_player.dart';
import 'package:oracle_d_asgard/widgets/interactive_collectible_card.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class CollectibleCardDetailPage extends StatelessWidget {
  final CollectibleCard card;

  const CollectibleCardDetailPage({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          card.title,
          style: TextStyle(color: Colors.white, fontFamily: AppTextStyles.amaticSC),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // For back button
      ),
      body: SafeArea(
        child: Container(
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
          child: OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return _buildPortraitLayout(context);
              } else {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return _buildLandscapeLayout(context, constraints);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InteractiveCollectibleCard(card: card, enableNavigation: false),
            const SizedBox(height: 20),
            Text(
              card.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              card.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            _buildVideoPlayer(),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, BoxConstraints constraints) {
    final cardSize = constraints.maxHeight * 0.8;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: cardSize,
              height: cardSize,
              child: InteractiveCollectibleCard(card: card, enableNavigation: false),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    card.description,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  _buildVideoPlayer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (card.videoUrl != null && card.videoUrl!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: CustomVideoPlayer(videoUrl: card.videoUrl!, placeholderAsset: 'assets/images/${card.imagePath}'),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
