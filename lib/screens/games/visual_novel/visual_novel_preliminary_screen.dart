import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/preliminary_page.dart';

class VisualNovelPreliminaryScreen extends StatelessWidget {
  const VisualNovelPreliminaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PreliminaryPage(
      title: 'visual_novel_title',
      imagePath: 'assets/images/menu/visual_novel.webp',
      helpText: 'visual_novel_preliminary_screen_description',
      buttonText: 'visual_novel_preliminary_screen_start_button',
      onPressed: () {
        context.go('/visual_novel');
      },
    );
  }
}
