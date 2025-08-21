import 'package:flutter/material.dart';
import 'utils/help_dialog.dart';

import 'package:provider/provider.dart';
import 'game_controller.dart';
import './widgets/game_grid.dart';
import './widgets/game_controls.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Added import

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

class _OrderTheScrollsGameState extends State<OrderTheScrollsGame> {
  late GameController _gameController;


  @override
  void initState() {
    super.initState();
    _gameController = GameController();
    _gameController.initializeGame();
  }

  @override
  void dispose() {
    _gameController.dispose();
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
                      '❌ Désolé, l\'ordre est incorrect.',
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
          }
          return Stack(
            children: [
              Scaffold(
                body: AppBackground(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 120,
                        floating: false,
                        pinned: true,
                        backgroundColor: Colors.transparent, // Changed to transparent
                        leading: IconButton( // Explicitly define leading back button
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(), // Removed gradient background
                          centerTitle: true, // Center title for better appearance
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.end, // Align to bottom
                            children: [
                              Text(
                                controller.selectedStory.title,
                                style: ChibiTextStyles.storyTitle,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Reconstitue l\'histoire',
                                style: ChibiTextStyles.buttonText.copyWith(
                                  color: Colors.white60,
                                  fontSize: 16.sp,
                                  shadows: [const Shadow(blurRadius: 10.0, color: Colors.black54, offset: Offset(2.0, 2.0))],
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          Container(
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withAlpha(51),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.help_outline, color: Colors.white),
                              onPressed: () => HelpDialog.show(context),
                            ),
                          ),
                        ],
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF6366F1).withAlpha(51),
                                    const Color(0xFF6366F1).withAlpha(12),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF6366F1).withAlpha(76),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withAlpha(25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: GameGrid(
                                  controller: controller,
                                  onCardReorder: (fromIndex, toIndex) {
                                    controller.reorderCards(fromIndex, toIndex);
                                  },
                                  onDragStarted: () {
                                    // Logique supplémentaire si nécessaire
                                  },
                                  onDragEnd: () {
                                    controller.setDraggedIndex(null);
                                  },
                                  onCardPressed: (card) {},
                                onCardReleased: () {},
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GameControls(
                              controller: controller,
                              onValidate: () => controller.validateOrder(),
                              onReset: () => controller.resetGame(),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}