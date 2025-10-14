import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/screens/games/minesweeper/minesweeper_controller.dart';
import 'package:oracle_d_asgard/locator.dart';

import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/game_help_dialog.dart';
import 'package:oracle_d_asgard/widgets/game_over_popup.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';

import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';

class MinesweeperScreen extends StatelessWidget {
  const MinesweeperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => MinesweeperController(), child: const _MinesweeperView());
  }
}

const List<String> mineRunes = [
  '', // 0: No rune
  'ᛚ', // 1: Laguz
  'ᚨ', // 2: Ansuz
  'ᚾ', // 3: Nauthiz
  'ᛋ', // 4: Sowilo
  'ᚱ', // 5: Raido
  'ᚹ', // 6: Wunjo
  'ᛟ', // 7: Othala
  'ᛞ', // 8: Dagaz
];

const List<String> treasureRunes = [
  '', // 0: No rune
  'ᛇ', // 1: Eiwaz
  'ᛏ', // 2: Tiwaz
];

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
              onReplay: () {
                controller.initializeGame();
                Navigator.of(context).pop();
              },
              onMenu: () {
                context.go('/');
              },
            );
          },
        );
      } else if (controller.isGameWon) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final gamificationService = getIt<GamificationService>();
          CollectibleCard? wonCard = await gamificationService.selectRandomUnearnedCollectibleCard();

          if (wonCard != null) {
            await gamificationService.unlockCollectibleCard(wonCard);
          }

          if (!context.mounted) return;

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return VictoryPopup(
                rewardCard: wonCard,
                unlockedStoryChapter: null,
                onDismiss: () {
                  controller.initializeGame();
                  Navigator.of(context).pop();
                },
                onSeeRewards: () {
                  Navigator.of(context).pop(); // Close the dialog
                  context.push('/profile');
                },
              );
            },
          );
        });
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(
        titleText: 'Le Butin d\'Andvari',
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            context.go('/');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              GameHelpDialog.show(context, [
                'Le but est de trouver tous les trésors sans déclencher de mines.',
                'Appuyez sur une case pour la révéler. Si c\'est une mine, la partie est perdue.',
                'Si la case révélée contient une rune, cela indique le nombre de mines ou de trésors adjacents.',
                'Les runes rouges indiquent les mines adjacentes, les runes jaunes indiquent les trésors adjacents.',
                'Appuyez longuement sur une case pour y placer ou retirer un drapeau, marquant ainsi une mine suspectée.',
                'Trouvez tous les trésors pour gagner la partie !',
              ], onGamePaused: () {}, onGameResumed: () {});
            },
          ),
        ],
      ),
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
                        child: Container(
                          key: ValueKey('${row}_${col}_${cell.isRevealed}_${cell.isFlagged}'), // Unique key for animation
                          decoration: BoxDecoration(
                            color: cell.isRevealed ? Colors.grey[800] : Colors.grey[600],
                            border: Border.all(color: Colors.grey[900]!),
                          ),
                          child: Center(child: _buildCellContent(cell, context)),
                        ).animate(key: ValueKey('${row}_${col}_${cell.isRevealed}_${cell.isFlagged}')).scale(duration: const Duration(milliseconds: 300)),
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
      return Row(mainAxisSize: MainAxisSize.min, children: counts.toList());
    }
    return const SizedBox.shrink();
  }
}

String _getRuneForMines(int count) {
  return (count >= 1 && count <= 8) ? mineRunes[count] : '';
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

  List<Widget> _buildRuneTexts(List<String> runes, TextStyle runeStyle, TextStyle valueStyle, {String Function(int)? suffixBuilder}) {
    return [
      for (int i = 1; i < runes.length; i++)
        if (runes[i].isNotEmpty)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(runes[i], style: runeStyle),
              Text('$i${suffixBuilder?.call(i) ?? ''}', style: valueStyle),
            ],
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double uniformFontSize = MediaQuery.of(context).size.width * 0.035;
    TextStyle legendTextStyle = ChibiTextStyles.dialogText.copyWith(fontSize: uniformFontSize);
    TextStyle mineRuneTextStyle = legendTextStyle.copyWith(color: Colors.red, fontSize: uniformFontSize * 1.5); // Larger for rune
    TextStyle treasureRuneTextStyle = legendTextStyle.copyWith(color: Colors.yellow, fontSize: uniformFontSize * 1.5); // Larger for rune
    TextStyle valueTextStyle = legendTextStyle.copyWith(fontSize: uniformFontSize * 0.8); // Smaller for value

    return Container(
      padding: const EdgeInsets.all(6.0),
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
            spacing: 2.0,
            runSpacing: 4.0, // Increased runSpacing to accommodate vertical layout
            children: [
              Image.asset('assets/images/explosion.png', width: 32, height: 32), // Mine image
              const SizedBox(width: 4), // Small space between image and runes
              ..._buildRuneTexts(mineRunes, mineRuneTextStyle, valueTextStyle),
              const SizedBox(width: 16),
              Image.asset('assets/images/sparkle.png', width: 32, height: 32), // Treasure image
              const SizedBox(width: 4), // Small space between image and runes
              ..._buildRuneTexts(treasureRunes, treasureRuneTextStyle, valueTextStyle, suffixBuilder: (count) => count > 1 ? '+' : ''),
            ],
          ),
        ],
      ),
    );
  }
}
