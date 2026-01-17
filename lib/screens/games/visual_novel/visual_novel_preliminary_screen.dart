import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_text_button.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';

class VisualNovelPreliminaryScreen extends StatelessWidget {
  const VisualNovelPreliminaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check current language
    final currentLocale = context.locale;
    final isFrench = currentLocale.languageCode == 'fr';
    
    final Widget gameInfoLayout = Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.black.withAlpha(128), borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Loki chibi image - using menu visual novel image
          Image.asset('assets/images/menu/visual_novel.webp', width: 120, height: 120, fit: BoxFit.contain),
          const SizedBox(height: 16),
          // Language warning for non-French users
          if (!isFrench) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(200),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'visual_novel_french_only_warning'.tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Text(
            'visual_novel_preliminary_screen_description'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    final Widget startButton = ChibiTextButton(
      text: 'visual_novel_preliminary_screen_start_button'.tr(),
      color: isFrench ? ChibiColors.darkEpicPurple : Colors.grey,
      onPressed: isFrench ? () {
        context.go('/visual_novel');
      } : null,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('visual_novel_title'.tr(), style: ChibiTextStyles.appBarTitle.copyWith(fontSize: 32), textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    gameInfoLayout,
                    const SizedBox(height: 20),
                    startButton,
                  ],
                ),
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
