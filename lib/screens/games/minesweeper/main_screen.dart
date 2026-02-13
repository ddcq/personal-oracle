import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

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
              content: Text('minesweeper_game_over'.tr()),
              onReplay: () {
                controller.initializeGame();
                Navigator.of(context).pop();
              },
              onMenu: () {
                context.go('/games');
              },
            );
          },
        );
      } else if (controller.isGameWon) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final gamificationService = getIt<GamificationService>();
          const coinsEarned = 50;
          await gamificationService.addCoins(coinsEarned);

          if (!context.mounted) return;

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return VictoryPopup(
                coinsEarned: coinsEarned,
                onDismiss: () {
                  controller.initializeGame();
                  Navigator.of(context).pop();
                },
                onSeeRewards: () {
                  Navigator.of(context).pop();
                  context.push('/shop');
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
        titleText: 'minesweeper_title'.tr(),
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
                  'minesweeper_rule_1'.tr(),
                  'minesweeper_rule_2'.tr(),
                  'minesweeper_rule_3'.tr(),
                  'minesweeper_rule_4'.tr(),
                  'minesweeper_rule_5'.tr(),
                  'minesweeper_rule_6'.tr(),
                ],
                onGamePaused: () {},
                onGameResumed: () {},
              );
            },
          ),
        ],
      ),
      body: AppBackground(child: SafeArea(child: _buildPortraitLayout(controller))),
    );
  }

  Widget _buildPortraitLayout(MinesweeperController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _TreasureCounter(treasuresFound: controller.treasuresFound, totalTreasures: controller.treasureCount),
        ),
        const _RuneLegend(),
        Expanded(
          child: Center(
            child: AspectRatio(aspectRatio: 1.0, child: _MinesweeperGrid(controller: controller)),
          ),
        ),
      ],
    );
  }
}

class _MinesweeperGrid extends StatelessWidget {
  final MinesweeperController controller;

  const _MinesweeperGrid({required this.controller});

  // Constantes pour l'image de fond
  static const double cellSize = 83.0;
  static const double borderSize = 33.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        final gridSize = controller.cols * cellSize + borderSize * 2;
        final scale = size / gridSize;

        return Container(
          width: size,
          height: size, // 1:1 ratio enforced
          color: Colors.transparent,
          child: Stack(
            children: [
              // Image de fond - prend 100% de la largeur et garde ratio 1:1
              Positioned.fill(child: Image.asset('assets/images/minesweeper/background.webp', fit: BoxFit.fill)),
              // Grille de jeu positionnée avec bordure
              Positioned(
                left: borderSize * scale,
                top: borderSize * scale,
                width: controller.cols * cellSize * scale,
                height: controller.rows * cellSize * scale,
                child: Stack(
                  children: [
                    // Couche 1 : Grille de jeu en dessous (contenu révélé)
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: controller.cols, childAspectRatio: 1.0),
                      itemCount: controller.rows * controller.cols,
                      itemBuilder: (context, index) {
                        final row = index ~/ controller.cols;
                        final col = index % controller.cols;
                        final cell = controller.board[row][col];

                        return GestureDetector(
                          onTap: () => controller.revealCell(row, col),
                          onLongPress: () => controller.toggleFlag(row, col),
                          child: Container(
                            key: ValueKey('${row}_${col}_${cell.isRevealed}_${cell.isFlagged}'),
                            color: Colors.transparent,
                            child: Center(child: _buildCellContent(cell, context)),
                          ),
                        );
                      },
                    ),
                    // Couche 2 : Sprites des cases non révélées
                    IgnorePointer(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: controller.cols, childAspectRatio: 1.0),
                        itemCount: controller.rows * controller.cols,
                        itemBuilder: (context, index) {
                          final row = index ~/ controller.cols;
                          final col = index % controller.cols;
                          final cell = controller.board[row][col];

                          // Afficher le sprite uniquement si la case n'est pas révélée
                          if (!cell.isRevealed) {
                            return _SpriteTile(spriteRow: row, spriteCol: col);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    // Couche 3 : Drapeaux par-dessus tout
                    IgnorePointer(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: controller.cols, childAspectRatio: 1.0),
                        itemCount: controller.rows * controller.cols,
                        itemBuilder: (context, index) {
                          final row = index ~/ controller.cols;
                          final col = index % controller.cols;
                          final cell = controller.board[row][col];

                          // Afficher le drapeau uniquement si la case est flagguée
                          if (cell.isFlagged) {
                            return const Center(
                              child: Icon(Icons.flag, color: Colors.red, size: 25.6),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCellContent(Cell cell, BuildContext context) {
    if (cell.isFlagged) {
      return const Icon(Icons.flag, color: Colors.red);
    }
    if (!cell.isRevealed) {
      return const SizedBox.shrink();
    }

    const imageSize = 40.0;

    if (cell.hasMine) {
      return Image.asset('assets/images/explosion.png', key: const ValueKey('explosion'), width: imageSize, height: imageSize);
    }
    if (cell.hasTreasure) {
      return Image.asset('assets/images/sparkle.png', key: const ValueKey('sparkle'), width: imageSize, height: imageSize);
    }
    if (cell.adjacentMines > 0 || cell.adjacentTreasures > 0) {
      List<Widget> counts = [];
      double baseFontSize = MediaQuery.of(context).size.width * 0.06;

      double currentFontSize = baseFontSize;

      if (cell.adjacentMines > 0 && cell.adjacentTreasures > 0) {
        currentFontSize = baseFontSize * 0.75;
      }

      if (cell.adjacentMines > 0) {
        counts.add(
          Text(
            _getRuneForMines(cell.adjacentMines),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: currentFontSize),
          ),
        );
      }
      if (cell.adjacentTreasures > 0) {
        counts.add(
          Text(
            _getRuneForTreasures(cell.adjacentTreasures),
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

class _TreasureCounter extends StatelessWidget {
  final int treasuresFound;
  final int totalTreasures;

  const _TreasureCounter({required this.treasuresFound, required this.totalTreasures});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.5;
    final coinSize = (containerWidth - (totalTreasures - 1) * 8.0) / totalTreasures;

    return Center(
      child: SizedBox(
        width: containerWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalTreasures, (index) {
            final isFound = index < treasuresFound;
            return ColorFiltered(
              colorFilter: isFound
                  ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                  : const ColorFilter.matrix([0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0]),
              child: Image.asset('assets/images/sparkle.png', width: coinSize, height: coinSize),
            );
          }),
        ),
      ),
    );
  }
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
    const double imageSize = 32.0;

    TextStyle legendTextStyle = ChibiTextStyles.dialogText.copyWith(fontSize: uniformFontSize);
    TextStyle mineRuneTextStyle = legendTextStyle.copyWith(color: Colors.red, fontSize: uniformFontSize * 1.5);
    TextStyle treasureRuneTextStyle = legendTextStyle.copyWith(color: Colors.yellow, fontSize: uniformFontSize * 1.5);
    TextStyle valueTextStyle = legendTextStyle.copyWith(fontSize: uniformFontSize * 0.8);

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
          Text('minesweeper_rune_legend'.tr(), style: legendTextStyle),
          const SizedBox(height: 4),
          Wrap(
            spacing: 2.0,
            runSpacing: 4.0,
            children: [
              Image.asset('assets/images/explosion.png', width: imageSize, height: imageSize),
              const SizedBox(width: 4),
              ..._buildRuneTexts(mineRunes, mineRuneTextStyle, valueTextStyle),
              const SizedBox(width: 16),
              Image.asset('assets/images/sparkle.png', width: imageSize, height: imageSize),
              const SizedBox(width: 4),
              ..._buildRuneTexts(treasureRunes, treasureRuneTextStyle, valueTextStyle, suffixBuilder: (count) => count > 1 ? '+' : ''),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher une case du sprite sheet foreground 9x9
class _SpriteTile extends StatelessWidget {
  final int spriteRow;
  final int spriteCol;

  const _SpriteTile({required this.spriteRow, required this.spriteCol});

  // Taille native d'une cellule dans l'image foreground
  static const double nativeCellSize = 83.0;

  @override
  Widget build(BuildContext context) {
    // Découper l'image foreground 9x9 pour afficher la bonne case
    const gridSize = 9;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculer l'alignement pour cette case spécifique
        // -1 = gauche/haut, +1 = droite/bas
        final alignX = -1.0 + (spriteCol * 2.0 / (gridSize - 1));
        final alignY = -1.0 + (spriteRow * 2.0 / (gridSize - 1));

        // Calculer le scale pour adapter la taille native à la taille d'affichage
        // scale = taille native / taille désirée
        final displayCellSize = constraints.maxWidth;
        final scale = nativeCellSize / displayCellSize;

        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/minesweeper/foreground.webp'),
              fit: BoxFit.none,
              repeat: ImageRepeat.noRepeat,
              scale: scale,
              alignment: Alignment(alignX, alignY),
            ),
          ),
        );
      },
    );
  }
}
