import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/utils/help_dialog.dart';

import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/game_controller.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/widgets/thumbnail_list.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/widgets/detail_panel.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';

import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/game_over_popup.dart';
import 'package:oracle_d_asgard/widgets/chibi_text_button.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class OrderTheScrollsGame extends StatefulWidget {
  const OrderTheScrollsGame({super.key});

  @override
  State<OrderTheScrollsGame> createState() => _OrderTheScrollsGameState();
}

class _OrderTheScrollsGameState extends State<OrderTheScrollsGame> {
  late GameController _gameController;
  final ValueNotifier<bool> _isDetailPanelEnlarged = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _gameController = GameController();
    _gameController.loadNewStory();
  }

  @override
  void dispose() {
    _gameController.dispose();
    _isDetailPanelEnlarged.dispose();
    super.dispose();
  }

  Widget validationButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ChibiTextButton(
        text: 'order_the_scrolls_screen_validate_order'.tr(),
        color: const Color(0xFFF9A825), // Orange color
        onPressed: () => _gameController.validateOrder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameController,
      child: Consumer<GameController>(
        builder: (context, controller, child) {
          if (controller.showIncorrectOrderPopup) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showIncorrectOrderDialog(controller);
            });
          } else if (controller.showVictoryPopup) {
            // Handle victory popup
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showVictoryDialog(controller);
            });
          }
          return Scaffold(
            extendBodyBehindAppBar:
                true, // Make background visible behind AppBar
            appBar: AppBar(
              title: Text(
                controller.selectedStory.title.tr(),
                style: ChibiTextStyles.storyTitle,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  context.go('/games');
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.help_outline, color: Colors.white),
                  onPressed: () => HelpDialog.show(context),
                ),
              ],
            ),
            body: AppBackground(
              child: SafeArea(
                // Add SafeArea here
                child: Column(
                  // Wrap Row in a Column
                  children: [
                    Expanded(
                      // Make the Row take available space
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _isDetailPanelEnlarged,
                        builder: (context, isEnlarged, child) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final totalHeight = constraints.maxHeight;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (!isEnlarged)
                                    SizedBox(
                                      height: totalHeight * 0.6,
                                      child: ThumbnailList(
                                        controller: controller,
                                      ),
                                    ).animate().fadeIn(duration: 300.ms),
                                  Expanded(
                                    child: DetailPanel(
                                      controller: controller,
                                      isEnlarged: isEnlarged,
                                      onToggleEnlargement: () =>
                                          _isDetailPanelEnlarged.value =
                                              !isEnlarged,
                                    ),
                                  ).animate().fadeIn(duration: 300.ms),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    // Validation Button (always show at bottom)
                    validationButton(),
                  ],
                ),
              ), // Closing parenthesis for SafeArea
            ),
          );
        },
      ),
    );
  }

  void _showIncorrectOrderDialog(GameController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GameOverPopup(
          content: Text(
            'order_the_scrolls_screen_incorrect_order'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: AppTextStyles.amaticSC, // Added font family
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          onReplay: () {
            Navigator.of(context).pop();
          },
          onMenu: () {
            context.go('/games');
          },
        );
      },
    ).then((_) => controller.incorrectOrderPopupShown());
  }

  void _showVictoryDialog(GameController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return VictoryPopup(
          rewardCard: controller.rewardCard, // Pass the reward card
          unlockedStoryChapter: controller
              .unlockedStoryChapter, // Pass the unlocked story chapter
          onDismiss: () {
            Navigator.of(context).pop();
            controller.victoryPopupShown(); // Reset popup state
            controller.resetGame(); // Start a new game
          },
          onSeeRewards: () {
            Navigator.of(context).pop();
            controller.victoryPopupShown(); // Reset popup state
            context.go('/profile');
          },
        );
      },
    );
  }
}
