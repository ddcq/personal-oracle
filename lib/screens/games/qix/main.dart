import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:oracle_d_asgard/widgets/progress_bar.dart';
import 'qix_game.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';

import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';

import 'defeat_screen.dart';
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
  Map<String, dynamic>? _unearnedContent;
  late Future<void> _initializeGameFuture;
  final ValueNotifier<bool> _showVictoryPopupNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _initializeGameFuture = _initializeGame();
  }

  Future<void> _initializeGame() async {
    final gamificationService = Provider.of<GamificationService>(context, listen: false);
    CollectibleCard? selectedRewardCard = await gamificationService.selectRandomUnearnedCollectibleCard();
    String? rewardCardImagePath = selectedRewardCard?.imagePath;

    _game = QixGame(
      onGameOver: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DefeatScreen())),
      onWin: (CollectibleCard? collectibleCard) {
        _showVictoryPopupNotifier.value = true;
      },
      rewardCardImagePath: rewardCardImagePath,
      rewardCard: selectedRewardCard,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(titleText: 'Conquête de Territoire'),
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

                  Widget percentageDisplay = ValueListenableBuilder<double>(
                    valueListenable: _game!.filledPercentageNotifier,
                    builder: (context, percentage, child) {
                      return ProgressBar(progress: percentage);
                    },
                  );

                  Widget gameAndControls;

                  if (orientation == Orientation.portrait) {
                    gameAndControls = Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.blue[900],
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: GameWidget(
                                  game: _game!,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(padding: const EdgeInsets.all(8.0), child: percentageDisplay),
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
                        ),
                      ],
                    );
                  } else {
                    // Orientation.landscape
                    gameAndControls = Row(
                      children: [
                        Center(
                          child: Container(
                            color: Colors.blue[900],
                            child: AspectRatio(aspectRatio: 1.0, child: GameWidget(game: _game!)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              // Use a column for percentage and directional pad in landscape
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
