import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:oracle_d_asgard/widgets/gauge_widget.dart';
import 'qix_game.dart';
import 'directional_pad.dart';
import 'constants.dart';

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
    _game = QixGame();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    Widget percentageDisplay = ValueListenableBuilder<double>(
      valueListenable: _game.filledPercentageNotifier,
      builder: (context, percentage, child) {
        return GaugeWidget(percentage: percentage);
      },
    );

    Widget gameAndControls;

    if (orientation == Orientation.portrait) {
      gameAndControls = Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue[900],
              child: Center(
                child: GameWidget(game: _game),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: percentageDisplay,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DirectionalPad(
              onDirectionChanged: (Direction direction) {
                _game.handleDirectionChange(direction);
              },
            ),
          ),
        ],
      );
    } else { // Orientation.landscape
      gameAndControls = Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue[900],
              child: Center(
                child: GameWidget(game: _game),
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column( // Use a column for percentage and directional pad in landscape
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  percentageDisplay,
                  DirectionalPad(
                    onDirectionChanged: (Direction direction) {
                      _game.handleDirectionChange(direction);
                    },
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
      body: gameAndControls,
    );
  }
}