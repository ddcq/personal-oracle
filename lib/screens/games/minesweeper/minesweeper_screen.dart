import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './minesweeper_controller.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/game_over_popup.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

class MinesweeperScreen extends StatelessWidget {
  const MinesweeperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => MinesweeperController(), child: const _MinesweeperView());
  }
}

class _MinesweeperView extends StatelessWidget {
  const _MinesweeperView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MinesweeperController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.isGameOver) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GameOverPopup(
              content: const Text('BOOM! You hit a mine.'),
              actions: [
                ChibiButton(
                  onPressed: () {
                    controller.initializeGame();
                    Navigator.of(context).pop();
                  },
                  text: 'Restart',
                  color: ChibiColors.buttonBlue,
                ),
              ],
            );
          },
        );
      } else if (controller.isGameWon) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return VictoryPopup(
              unlockedStoryChapter: null, // You can add rewards here
              onDismiss: () {
                controller.initializeGame();
                Navigator.of(context).pop();
              },
              onSeeRewards: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            );
          },
        );
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(titleText: 'Le Butin d’Andvari'),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Treasures Found: ${controller.treasuresFound} / ${controller.treasureCount}', style: ChibiTextStyles.storyTitle),
              ),
              _RuneLegend(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: controller.cols),
                    itemCount: controller.rows * controller.cols,
                    itemBuilder: (context, index) {
                      final row = index ~/ controller.cols;
                      final col = index % controller.cols;
                      final cell = controller.board[row][col];

                      return GestureDetector(
                        onTap: () => controller.revealCell(row, col),
                        onLongPress: () => controller.toggleFlag(row, col),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cell.isRevealed ? Colors.grey[800] : Colors.grey[600],
                            border: Border.all(color: Colors.grey[900]!),
                          ),
                          child: Center(child: _buildCellContent(cell, context)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCellContent(Cell cell, BuildContext context) {
    if (cell.isFlagged) {
      return const Icon(Icons.flag, color: Colors.red);
    }
    if (!cell.isRevealed) {
      return const SizedBox.shrink();
    }
    if (cell.hasMine) {
      return const Icon(Icons.warning, color: Colors.red); // Placeholder for mine
    }
    if (cell.hasTreasure) {
      return const Icon(Icons.star, color: Colors.yellow); // Placeholder for treasure
    }
    if (cell.adjacentMines > 0 || cell.adjacentTreasures > 0) {
      List<Widget> counts = [];
      double baseFontSize = MediaQuery.of(context).size.width * 0.06;
      double currentFontSize = baseFontSize;

      // Check if both mine and treasure runes will be displayed
      if (cell.adjacentMines > 0 && cell.adjacentTreasures > 0) {
        currentFontSize = baseFontSize * 0.75; // Reduce font size if both are present
      }

      if (cell.adjacentMines > 0) {
        counts.add(
          Text(
            _getRuneForMines(cell.adjacentMines), // Use rune
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: currentFontSize),
          ),
        );
      }
      if (cell.adjacentTreasures > 0) {
        counts.add(
          Text(
            _getRuneForTreasures(cell.adjacentTreasures), // Use rune
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow, fontSize: currentFontSize),
          ),
        );
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: counts.toList(),
      );
    }
    return const SizedBox.shrink();
  }
}

String _getRuneForMines(int count) {
  switch (count) {
    case 1:
      return 'ᛚ'; // Laguz
    case 2:
      return 'ᚨ'; // Ansuz
    case 3:
      return 'ᚾ'; // Nauthiz
    case 4:
      return 'ᛋ'; // Sowilo
    case 5:
      return 'ᚱ'; // Raido
    case 6:
      return 'ᚹ'; // Wunjo
    case 7:
      return 'ᛟ'; // Othala
    case 8:
      return 'ᛞ'; // Dagaz
    default:
      return '';
  }
}

String _getRuneForTreasures(int count) {
  if (count == 1) {
    return 'ᛇ'; // Eihwaz
  } else if (count > 1) {
    return 'ᛏ'; // Tiwaz
  }
  return '';
}

class _RuneLegend extends StatelessWidget {
  const _RuneLegend();

  @override
  Widget build(BuildContext context) {
    final double uniformFontSize = MediaQuery.of(context).size.width * 0.04; // Responsive font size
    TextStyle legendTextStyle = ChibiTextStyles.buttonText.copyWith(fontSize: uniformFontSize);
    TextStyle mineRuneTextStyle = legendTextStyle.copyWith(color: Colors.red);
    TextStyle treasureRuneTextStyle = legendTextStyle.copyWith(color: Colors.yellow);

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(102),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(150), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Légende des Runes:', style: legendTextStyle),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              Text('Mines:', style: legendTextStyle),
              Text('ᛚ (1)', style: mineRuneTextStyle),
              Text('ᚨ (2)', style: mineRuneTextStyle),
              Text('ᚾ (3)', style: mineRuneTextStyle),
              Text('ᛋ (4)', style: mineRuneTextStyle),
              Text('ᚱ (5)', style: mineRuneTextStyle),
              Text('ᚹ (6)', style: mineRuneTextStyle),
              Text('ᛟ (7)', style: mineRuneTextStyle),
              Text('ᛞ (8)', style: mineRuneTextStyle),
              const SizedBox(width: 16), // Spacer
              Text('Trésors:', style: legendTextStyle),
              Text('ᛇ (1)', style: treasureRuneTextStyle),
              Text('ᛏ (2+)', style: treasureRuneTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}
