import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:oracle_d_asgard/widgets/progress_bar.dart';
import 'qix_game.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeGameFuture = _initializeGame();
  }

  Future<void> _initializeGame() async {
    final gamificationService = Provider.of<GamificationService>(context, listen: false);
    _unearnedContent = await gamificationService.getUnearnedContent();

    CollectibleCard? selectedRewardCard;
    String? rewardCardImagePath;

    if (_unearnedContent != null && _unearnedContent!['unearned_collectible_cards'] != null && _unearnedContent!['unearned_collectible_cards'].isNotEmpty) {
      selectedRewardCard = _unearnedContent!['unearned_collectible_cards'][0];
      rewardCardImagePath = selectedRewardCard?.imagePath;
    }

    _game = QixGame(
      onGameOver: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DefeatScreen())),
      onWin: (CollectibleCard? collectibleCard) {
        _game!.overlays.add('victoryOverlay');
      },
      rewardCardImagePath: rewardCardImagePath,
      rewardCard: selectedRewardCard,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qix Basic')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/backgrounds/landscape.jpg'), fit: BoxFit.cover),
        ),
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
                                  overlayBuilderMap: {
                                    'victoryOverlay': (BuildContext context, QixGame game) {
                                      return VictoryPopup(
                                        rewardCard: game.rewardCard!,
                                        onDismiss: () {
                                          game.overlays.remove('victoryOverlay');
                                          Navigator.of(context).pop(); // Go back to the previous screen (game menu)
                                        },
                                      );
                                    },
                                  },
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
                  return gameAndControls;
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
