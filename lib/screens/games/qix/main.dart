import 'dart:math' as math;
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';
import 'package:oracle_d_asgard/widgets/progress_bar.dart';
import 'qix_game.dart';
import 'package:oracle_d_asgard/widgets/game_help_dialog.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';

import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/game_over_popup.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';

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
    _initializeGameFuture = _initializeGame();
  }

  Future<void> _initializeGame() async {
    final gamificationService = Provider.of<GamificationService>(context, listen: false);
    final int currentDifficulty = await gamificationService.getQixDifficulty();
    CollectibleCard? selectedRewardCard = await gamificationService.selectRandomUnearnedCollectibleCard();
    String? rewardCardImagePath = selectedRewardCard?.imagePath;

    _game = QixGame(
      onGameOver: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return GameOverPopup(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'DÉFAITE !',
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
                    'Vous avez été vaincu. Réessayez !',
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
              actions: [
                ChibiButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => QixGameScreen()));
                  },
                  text: 'Réessayer',
                  color: Colors.red,
                ),
              ],
            );
          },
        );
      },
      onWin: (CollectibleCard? collectibleCard) async {
        // Made async to await saveQixDifficulty
        _showVictoryPopupNotifier.value = true;
        await gamificationService.saveQixDifficulty(currentDifficulty + 1); // Increment and save difficulty
      },
      rewardCardImagePath: rewardCardImagePath,
      rewardCard: selectedRewardCard,
      difficulty: currentDifficulty, // Pass difficulty to QixGame
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(
        titleText: 'Conquête de Territoire',
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              GameHelpDialog.show(
                context,
                [
                  'Tracez des lignes pour capturer des territoires. Évitez les ennemis et leurs lignes !',
                  'Capturez plus de 75% du territoire pour gagner.',
                  'Si un ennemi touche votre ligne en construction, vous perdez une vie.',
                  'Si un ennemi touche votre corps, vous perdez une vie.',
                  'Collectez les bonus pour des avantages temporaires.',
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
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (_game == null) {
                  return const Center(child: Text('Error: Game not initialized.'));
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
                          child: Container(
                            color: Colors.blue[900],
                            child: GameWidget(game: _game!),
                          ),
                        ),
                        const SizedBox(height: 16), // Spacing
                        percentageDisplay,
                        const SizedBox(height: 16), // Spacing
                        Center(
                          child: FittedBox(
                            child: DirectionalPad(
                              onDirectionChanged: (Direction direction) {
                                _game!.handleDirectionChange(direction);
                              },
                            ),
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
                          child: Container(
                            color: Colors.blue[900],
                            child: GameWidget(game: _game!),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                percentageDisplay,
                                FittedBox(
                                  child: DirectionalPad(
                                    onDirectionChanged: (Direction direction) {
                                      _game!.handleDirectionChange(direction);
                                    },
                                  ),
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
                                rewardCard: _game!.rewardCard!,
                                onDismiss: () {
                                  _showVictoryPopupNotifier.value = false;
                                  Navigator.of(context).pop(); // Go back to the previous screen (game menu)
                                },
                                onSeeRewards: () {
                                  _showVictoryPopupNotifier.value = false;
                                  Navigator.of(context).pop(); // Go back to the previous screen (game menu)
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
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
