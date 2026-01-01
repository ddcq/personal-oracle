import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

class OrderTheScrollsPreliminaryScreen extends StatelessWidget {
  const OrderTheScrollsPreliminaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget gameInfoLayout = Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(128),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/menu/order_the_scrolls.webp',
            width: 120,
          ),
          const SizedBox(height: 16),
          Text(
            'order_the_scrolls_preliminary_screen_help_text'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    final Widget startButton = ChibiButton(
      text: 'order_the_scrolls_preliminary_screen_start_button'.tr(),
      color: const Color(0xFF6366F1), // Color from menu
      onPressed: () {
        context.go('/order_the_scrolls');
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                  onPressed: () => context.go('/games'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
