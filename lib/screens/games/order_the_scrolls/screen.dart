import 'package:flutter/material.dart';
import 'utils/help_dialog.dart';

import 'package:provider/provider.dart';
import 'game_controller.dart';
import './widgets/thumbnail_list.dart';
import './widgets/detail_panel.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';

import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/game_over_popup.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class OrderTheScrollsGame extends StatefulWidget {
  const OrderTheScrollsGame({super.key});

  @override
  State<OrderTheScrollsGame> createState() => _OrderTheScrollsGameState();
}

class _OrderTheScrollsGameState extends State<OrderTheScrollsGame> with SingleTickerProviderStateMixin {
  late GameController _gameController;

  final Curve _currentCurve = Curves.easeOutCubic; // User's chosen curve

  late AnimationController _animationController; // Animation controller
  late Animation<double> _leftPanelFlexAnimation; // Animation for left panel flex
  late Animation<double> _rightPanelFlexAnimation; // Animation for right panel flex

  void _toggleDetailPanelEnlargement() {
    // New method
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else if (_animationController.isCompleted) {
      _animationController.reverse();
    }
    // No need for setState here, as the animation controller will trigger rebuilds
  }

  @override
  void initState() {
    super.initState();
    _gameController = GameController();
    _gameController.initializeGame();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Animation duration
    );
    _animationController.value = 0.0; // Set initial animation value to 0.0 (begin state)

    _leftPanelFlexAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(CurvedAnimation(parent: _animationController, curve: _currentCurve));

    _rightPanelFlexAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: _currentCurve));
  }

  @override
  void dispose() {
    _gameController.dispose();
    _animationController.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameController,
      child: Consumer<GameController>(
        builder: (context, controller, child) {
          if (controller.showIncorrectOrderPopup) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return GameOverPopup(
                    content: Text(
                      '❌ Désolé, l’ordre est incorrect.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: AppTextStyles.amaticSC, // Added font family
                        shadows: [Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(1.0, 1.0))],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      ChibiButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: 'Réessayer',
                        color: const Color(0xFFF9A825),
                      ),
                    ],
                  );
                },
              ).then((_) => controller.incorrectOrderPopupShown());
            });
          } else if (controller.showVictoryPopup) {
            // Handle victory popup
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return VictoryPopup(
                    rewardCard: controller.rewardCard, // Pass the reward card
                    unlockedStoryChapter: controller.unlockedStoryChapter, // Pass the unlocked story chapter
                    onDismiss: () {
                      Navigator.of(context).pop();
                      controller.victoryPopupShown(); // Reset popup state
                      controller.resetGame(); // Start a new game
                    },
                    onSeeRewards: () {
                      Navigator.of(context).pop();
                      controller.victoryPopupShown(); // Reset popup state
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                    },
                  );
                },
              );
            });
          }
          return Scaffold(
            extendBodyBehindAppBar: true, // Make background visible behind AppBar
            appBar: AppBar(
              title: Text(controller.selectedStory.title, style: ChibiTextStyles.storyTitle),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.help_outline, color: Colors.white),
                  onPressed: () => HelpDialog.show(context, onGamePaused: () => _animationController.stop()),
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
                      child: AnimatedBuilder(
                        // Re-introduce AnimatedBuilder
                        animation: _animationController, // Listen to the animation controller
                        builder: (context, child) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final totalWidth = constraints.maxWidth;
                              // Calculate animated widths based on totalWidth and animation values
                              final leftPanelWidth = totalWidth * _leftPanelFlexAnimation.value;
                              final rightPanelWidth = totalWidth * _rightPanelFlexAnimation.value;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500), // Use the animation controller's duration
                                    curve: _currentCurve, // Use the current curve
                                    width: leftPanelWidth,
                                    child: ThumbnailList(controller: controller),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500), // Use the animation controller's duration
                                    curve: _currentCurve, // Use the current curve
                                    width: rightPanelWidth,
                                    child: DetailPanel(
                                      controller: controller,
                                      isEnlarged: _animationController.isCompleted, // Use animation state for isEnlarged
                                      onToggleEnlargement: _toggleDetailPanelEnlargement,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    // Validation Button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ChibiButton(
                        text: 'Valider l’ordre',
                        color: const Color(0xFFF9A825), // Orange color
                        onPressed: () => controller.validateOrder(),
                      ),
                    ),
                  ],
                ),
              ), // Closing parenthesis for SafeArea
            ),
          );
        },
      ),
    );
  }
}
