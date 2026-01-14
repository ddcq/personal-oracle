import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_text_button.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';

class VisualNovelPreliminaryScreen extends StatelessWidget {
  const VisualNovelPreliminaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget gameInfoLayout = Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.black.withAlpha(128), borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Loki chibi image - using menu visual novel image
          Image.asset(
            'assets/images/menu/visual_novel.webp',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          const Text(
            'L\'Oracle d\'Asgard - Loki',
            style: TextStyle(color: Color(0xFFd4af37), fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Vivez l\'épopée tragique de Loki Laufeyjarson à travers ses propres yeux. '
            'De fils adoptif d\'Odin au catalyseur de Ragnarök, découvrez comment '
            'l\'amour, la trahison et l\'amertume façonnent le destin d\'un dieu.\n\n'
            '• Histoire basée sur la mythologie nordique authentique\n'
            '• Vos choix influencent l\'état psychologique de Loki\n'
            '• Explorez les relations complexes entre les dieux d\'Asgard',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    final Widget startButton = ChibiTextButton(
      text: 'Commencer l\'Épopée',
      color: ChibiColors.darkEpicPurple,
      onPressed: () {
        context.go('/visual_novel');
      },
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [gameInfoLayout, const SizedBox(height: 20), startButton]),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => context.go('/games'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
