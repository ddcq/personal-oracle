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
    return ChangeNotifierProvider(
      create: (_) => MinesweeperController(),
      child: const _MinesweeperView(),
    );
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
                child: Text(
                  'Treasures Found: ${controller.treasuresFound} / ${controller.treasureCount}',
                  style: ChibiTextStyles.storyTitle,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: controller.cols,
                    ),
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
                          child: Center(
                            child: _buildCellContent(cell),
                          ),
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

  Widget _buildCellContent(Cell cell) {
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
    if (cell.adjacentMines > 0) {
      return Text(
        cell.adjacentMines.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, color: _getMineCountColor(cell.adjacentMines)),
      );
    }
    return const SizedBox.shrink();
  }

  Color _getMineCountColor(int count) {
    switch (count) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.orange;
      default:
        return Colors.pink;
    }
  }
}