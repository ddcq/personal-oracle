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
              content: const Text('BOUM ! Vous avez touché une mine.'),
              actions: [
                ChibiButton(
                  onPressed: () {
                    controller.initializeGame();
                    Navigator.of(context).pop();
                  },
                  text: 'Recommencer',
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
                child: Text('Trésors trouvés: ${controller.treasuresFound} / ${controller.treasureCount}', style: ChibiTextStyles.storyTitle),
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
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: Container(
                            key: ValueKey('${row}_${col}_${cell.isRevealed}_${cell.isFlagged}'), // Unique key for animation
                            decoration: BoxDecoration(
                              color: cell.isRevealed ? Colors.grey[800] : Colors.grey[600],
                              border: Border.all(color: Colors.grey[900]!),
                            ),
                            child: Center(child: _buildCellContent(cell, context)),
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

  Widget _buildCellContent(Cell cell, BuildContext context) {
    if (cell.isFlagged) {
      return const Icon(Icons.flag, color: Colors.red);
    }
    if (!cell.isRevealed) {
      return const SizedBox.shrink();
    }
    if (cell.hasMine) {
      return Image.asset('assets/images/explosion.png', key: const ValueKey('explosion'), width: 40, height: 40); // Explosion animation
    }
    if (cell.hasTreasure) {
      return Image.asset('assets/images/sparkle.png', key: const ValueKey('sparkle'), width: 40, height: 40); // Placeholder for treasure
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

  List<Widget> _buildRuneTexts(Map<int, String> runes, TextStyle style, {String Function(int)? suffixBuilder}) {
    return runes.entries.map((entry) {
      final suffix = suffixBuilder != null ? suffixBuilder(entry.key) : '';
      return Text('${entry.value} (${entry.key}$suffix)', style: style);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double uniformFontSize = MediaQuery.of(context).size.width * 0.04; // Responsive font size
    TextStyle legendTextStyle = ChibiTextStyles.buttonText.copyWith(fontSize: uniformFontSize);
    TextStyle mineRuneTextStyle = legendTextStyle.copyWith(color: Colors.red);
    TextStyle treasureRuneTextStyle = legendTextStyle.copyWith(color: Colors.yellow);

    final Map<int, String> mineRunes = {
      1: 'ᛚ', 2: 'ᚨ', 3: 'ᚾ', 4: 'ᛋ', 5: 'ᚱ', 6: 'ᚹ', 7: 'ᛟ', 8: 'ᛞ'
    };
    final Map<int, String> treasureRunes = {
      1: 'ᛇ', 2: 'ᛏ'
    };

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
              Text('Mines :', style: legendTextStyle),
              ..._buildRuneTexts(mineRunes, mineRuneTextStyle),
              const SizedBox(width: 16), // Spacer
              Text('Trésors :', style: legendTextStyle),
              ..._buildRuneTexts(treasureRunes, treasureRuneTextStyle, suffixBuilder: (count) => count == 1 ? '' : '+'),
            ],
          ),
        ],
      ),
    );
  }
}
