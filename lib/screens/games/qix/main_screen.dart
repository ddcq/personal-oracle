import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:oracle_d_asgard/screens/games/qix/qix_game.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/game_help_dialog.dart';
import 'package:oracle_d_asgard/widgets/game_over_popup.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/joystick_controller.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' show Direction;
import 'package:oracle_d_asgard/widgets/progress_bar.dart';
import 'dart:math' as math;

class QixGameScreen extends StatefulWidget {
  const QixGameScreen({super.key});

  @override
  State<QixGameScreen> createState() => _QixGameScreenState();
}

class _QixGameScreenState extends State<QixGameScreen> {
  QixGame? _game;
  late Future<void> _initializeGameFuture;
  final ValueNotifier<bool> _showVictoryPopupNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _initializeGameFuture = _initializeGame(context);
  }

  void _resetGame() {
    // Reset the victory popup notifier
    _showVictoryPopupNotifier.value = false;

    // Re-initialize the game
    setState(() {
      // Setting the future will trigger the FutureBuilder to show a loading indicator
      // and then rebuild with the new game instance.
      _initializeGameFuture = _initializeGame(context);
    });
  }

  Future<void> _initializeGame(BuildContext context) async {
    final gamificationService = getIt<GamificationService>();
    final int currentDifficulty = await gamificationService.getQixDifficulty();
    final CollectibleCard? potentialRewardCard = await gamificationService.selectRandomUnearnedCollectibleCard();

    _game = QixGame(
      onGameOver: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return GameOverPopup(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'qix_main_screen_defeat_title'.tr(),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: AppTextStyles.amaticSC,
                      shadows: [Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0, 2.0))],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  Text(
                    'qix_main_screen_defeat_message'.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: AppTextStyles.amaticSC,
                      shadows: [Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(1.0, 1.0))],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onReplay: () {
                Navigator.of(dialogContext).pop();
                _resetGame();
              },
              onMenu: () {
                Navigator.of(dialogContext).pop();
                context.go('/games');
              },
            );
          },
        );
      },
      onWin: (CollectibleCard? collectibleCard) async {
        _showVictoryPopupNotifier.value = true;
        await gamificationService.saveQixDifficulty(currentDifficulty + 1); // Increment and save difficulty
      },
      rewardCardImagePath: potentialRewardCard?.imagePath, // Pass the image path here
      rewardCard: potentialRewardCard, // Pass the actual card object
      difficulty: currentDifficulty, // Pass difficulty to QixGame
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(
        titleText: 'qix_main_screen_title'.tr(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/games');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              GameHelpDialog.show(
                context,
                [
                  'qix_main_screen_rule_1'.tr(),
                  'qix_main_screen_rule_2'.tr(),
                  'qix_main_screen_rule_3'.tr(),
                  'qix_main_screen_rule_4'.tr(),
                  'qix_main_screen_rule_5'.tr(),
                ],
                onGamePaused: () => _game?.pauseEngine(),
                onGameResumed: () => _game?.resumeEngine(),
              );
            },
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: FutureBuilder<void>(
            future: _initializeGameFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text('${'qix_main_error_prefix'.tr()}: ${snapshot.error}'));
                } else if (_game == null) {
                  return Center(child: Text('qix_main_game_not_initialized_error'.tr()));
                } else {
                  final Orientation orientation = MediaQuery.of(context).orientation;
                  final Size screenSize = MediaQuery.of(context).size;
                  final double appBarHeight = AppBar().preferredSize.height; // Standard AppBar height
                  final double statusBarHeight = MediaQuery.of(context).padding.top; // Status bar height

                  // Estimate controls height (progress bar + directional pad + padding)
                  // This is an approximation, adjust as needed
                  const double controlsEstimatedHeight = 250.0;

                  double availableWidth = screenSize.width;
                  double availableHeight = screenSize.height - appBarHeight - statusBarHeight;

                  double arenaSize;
                  Widget percentageDisplay = ValueListenableBuilder<double>(
                    valueListenable: _game!.filledPercentageNotifier,
                    builder: (context, percentage, child) {
                      return ProgressBar(progress: percentage);
                    },
                  );

                  Widget gameAndControls;

                  if (orientation == Orientation.portrait) {
                    // In portrait, game takes width, controls take remaining height
                    arenaSize = math.min(availableWidth, availableHeight - controlsEstimatedHeight);
                    gameAndControls = Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: arenaSize,
                          height: arenaSize,
                          child: GestureDetector(
                            onVerticalDragEnd: (details) {
                              if (details.primaryVelocity! > 0) {
                                _game!.handleDirectionChange(Direction.down);
                              } else if (details.primaryVelocity! < 0) {
                                _game!.handleDirectionChange(Direction.up);
                              }
                            },
                            onHorizontalDragEnd: (details) {
                              if (details.primaryVelocity! > 0) {
                                _game!.handleDirectionChange(Direction.right);
                              } else if (details.primaryVelocity! < 0) {
                                _game!.handleDirectionChange(Direction.left);
                              }
                            },
                            child: Container(
                              color: Colors.blue[900],
                              child: GameWidget(game: _game!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // Spacing
                        percentageDisplay,
                        const SizedBox(height: 16), // Spacing
                        Center(
                          child: JoystickController(
                            onDirectionChanged: (Direction direction) {
                              _game!.handleDirectionChange(direction);
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Orientation.landscape
                    // Game takes height, controls take remaining width
                    arenaSize = math.min(availableHeight, availableWidth - controlsEstimatedHeight);
                    gameAndControls = Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: arenaSize,
                          height: arenaSize,
                          child: GestureDetector(
                            onVerticalDragEnd: (details) {
                              if (details.primaryVelocity! > 0) {
                                _game!.handleDirectionChange(Direction.down);
                              } else if (details.primaryVelocity! < 0) {
                                _game!.handleDirectionChange(Direction.up);
                              }
                            },
                            onHorizontalDragEnd: (details) {
                              if (details.primaryVelocity! > 0) {
                                _game!.handleDirectionChange(Direction.right);
                              } else if (details.primaryVelocity! < 0) {
                                _game!.handleDirectionChange(Direction.left);
                              }
                            },
                            child: Container(
                              color: Colors.blue[900],
                              child: GameWidget(game: _game!),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                percentageDisplay,
                                JoystickController(
                                  onDirectionChanged: (Direction direction) {
                                    _game!.handleDirectionChange(direction);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Stack(
                    children: [
                      gameAndControls,
                      ValueListenableBuilder<bool>(
                        valueListenable: _showVictoryPopupNotifier,
                        builder: (context, showPopup, child) {
                          if (showPopup) {
                            return Positioned.fill(
                              child: VictoryPopup(
                                rewardCard: _game!.rewardCard,
                                onDismiss: () {
                                  _resetGame();
                                },
                                onSeeRewards: () {
                                  _showVictoryPopupNotifier.value = false;
                                  Navigator.of(context).pop(); // Go back to the previous screen (game menu)
                                  context.push('/profile');
                                },
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  );
                }
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
