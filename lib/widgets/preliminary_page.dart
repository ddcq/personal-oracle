import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/providers/responsive_provider.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_text_button.dart';

class PreliminaryPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final String helpText;
  final String buttonText;
  final VoidCallback onPressed;
  final String backRoute;
  final Widget? customContent;

  const PreliminaryPage({
    super.key,
    required this.title,
    required this.imagePath,
    required this.helpText,
    required this.buttonText,
    required this.onPressed,
    this.backRoute = '/games',
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    final gameInfoLayout = Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.black.withAlpha(128), borderRadius: BorderRadius.circular(20)),
      child:
          customContent ??
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath, width: 120),
              const SizedBox(height: 16),
              Text(
                helpText.tr(),
                style: TextStyle(color: Colors.white, fontSize: responsive.sp(18)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
    );

    final startButton = ChibiTextButton(text: buttonText.tr(), color: ChibiColors.darkEpicPurple, onPressed: onPressed);

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
                  children: <Widget>[
                    Text(
                      title.tr(),
                      style: ChibiTextStyles.appBarTitleResponsive(context).copyWith(fontSize: responsive.sp(32)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    gameInfoLayout,
                    const SizedBox(height: 32),
                    startButton,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.go(backRoute),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
