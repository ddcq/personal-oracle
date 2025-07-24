import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:oracle_d_asgard/widgets/progress_bar.dart';
import 'qix_game.dart';
import 'directional_pad.dart';
import 'constants.dart';
import 'defeat_screen.dart';
import 'victory_screen.dart';

class QixGameScreen extends StatefulWidget {
  const QixGameScreen({super.key});

  @override
  State<QixGameScreen> createState() => _QixGameScreenState();
}

class _QixGameScreenState extends State<QixGameScreen> {
  late final QixGame _game;

  @override
  void initState() {
    super.initState();
    _game = QixGame(
      onGameOver: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DefeatScreen())),
      onWin: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VictoryScreen())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    Widget percentageDisplay = ValueListenableBuilder<double>(
      valueListenable: _game.filledPercentageNotifier,
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
                child: AspectRatio(aspectRatio: 1.0, child: GameWidget(game: _game)),
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
                      _game.handleDirectionChange(direction);
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
              child: AspectRatio(aspectRatio: 1.0, child: GameWidget(game: _game)),
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
                        _game.handleDirectionChange(direction);
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

    return Scaffold(
      appBar: AppBar(title: const Text('Qix Basic')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/backgrounds/landscape.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: gameAndControls,
        ),
      ),
    );
  }
}
