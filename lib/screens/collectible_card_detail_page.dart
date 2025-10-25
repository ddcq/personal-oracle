import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/widgets/interactive_collectible_card.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';

class CollectibleCardDetailPage extends StatefulWidget {
  final CollectibleCard card;

  const CollectibleCardDetailPage({super.key, required this.card});

  @override
  State<CollectibleCardDetailPage> createState() => _CollectibleCardDetailPageState();
}

class _CollectibleCardDetailPageState extends State<CollectibleCardDetailPage> {
  late SoundService _soundService;

  @override
  void initState() {
    super.initState();
    _soundService = getIt<SoundService>();
    _soundService.playCardMusic(widget.card.id);
  }

  @override
  void dispose() {
    // Logic moved to WillPopScope to handle async operation correctly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _soundService.resumePreviousMusic().then((_) {
          if (mounted) {
            // ignore: use_build_context_synchronously
            context.go('/profile');
          }
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.card.title,
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
            InteractiveCollectibleCard(card: widget.card, enableNavigation: false, playVideo: true),
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
              child: InteractiveCollectibleCard(card: widget.card, enableNavigation: false, playVideo: true),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.card.title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.card.description,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
