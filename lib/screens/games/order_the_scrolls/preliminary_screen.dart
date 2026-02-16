import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/preliminary_page.dart';

class OrderTheScrollsPreliminaryScreen extends StatelessWidget {
  const OrderTheScrollsPreliminaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PreliminaryPage(
      title: 'games_menu_reorder_history',
      imagePath: 'assets/images/menu/order_the_scrolls.webp',
      helpText: 'order_the_scrolls_preliminary_screen_help_text',
      buttonText: 'order_the_scrolls_preliminary_screen_start_button',
      onPressed: () {
        context.go('/order_the_scrolls');
      },
    );
  }
}
