import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/screens/games/word_search_controller.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';

class WordSearchScreen extends StatelessWidget {
  const WordSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WordSearchController(),
      child: const _WordSearchView(),
    );
  }
}

class _WordSearchView extends StatelessWidget {
  const _WordSearchView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WordSearchController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(titleText: 'L’Œil d’Odin'),
      body: Stack(
        children: [
          AppBackground(
            child: SafeArea(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            controller.instructionClue,
                            style: ChibiTextStyles.storyTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _Grid(controller: controller),
                          ),
                        ),
                        if (controller.gamePhase == GamePhase.searchingWords)
                          Expanded(flex: 2, child: _WordList(controller: controller))
                        else
                          Expanded(flex: 2, child: _SecretWordInput(controller: controller)),
                      ],
                    ),
            ),
          ),
          if (controller.gamePhase == GamePhase.victory && controller.unlockedChapter != null)
            VictoryPopup(
              unlockedStoryChapter: controller.unlockedChapter!.chapter,
              onDismiss: () => Navigator.of(context).pop(),
              onSeeRewards: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  final WordSearchController controller;
  const _Grid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 8 / 10,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            return GestureDetector(
              onPanStart: controller.gamePhase == GamePhase.searchingWords ? (details) {
                _handleInteraction(details.localPosition, size);
              } : null,
              onPanUpdate: controller.gamePhase == GamePhase.searchingWords ? (details) {
                _handleInteraction(details.localPosition, size, isUpdate: true);
              } : null,
              onPanEnd: controller.gamePhase == GamePhase.searchingWords ? (_) => controller.endSelection() : null,
              onTapUp: controller.gamePhase == GamePhase.unscramblingSecret ? (details) {
                _handleInteraction(details.localPosition, size, isTap: true);
              } : null,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: controller.grid[0].length),
                itemCount: controller.grid.length * controller.grid[0].length,
                itemBuilder: (context, index) {
                  final row = index ~/ controller.grid[0].length;
                  final col = index % controller.grid[0].length;
                  final offset = Offset(col.toDouble(), row.toDouble());
                  final isSelected = controller.currentSelection.contains(offset);
                  final isConfirmed = controller.confirmedSelection.contains(offset);
                  return Container(
                    decoration: BoxDecoration(
                      color: isConfirmed ? ChibiColors.buttonBlue.withAlpha(150) : isSelected ? ChibiColors.buttonOrange.withAlpha(150) : Colors.black.withAlpha(102),
                      border: Border.all(color: Colors.white.withAlpha(150)),
                    ),
                    child: Center(
                      child: Text(controller.grid[row][col], style: ChibiTextStyles.buttonText.copyWith(fontFamily: 'NotoSansRunic', fontSize: 18.sp)),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleInteraction(Offset localPosition, Size size, {bool isUpdate = false, bool isTap = false}) {
    final offset = _getGridOffset(localPosition, size);
    if (offset != null) {
      if (isTap) {
        controller.handleGridTap(offset.dy.toInt(), offset.dx.toInt());
      } else if (isUpdate) {
        controller.updateSelection(offset);
      } else {
        controller.startSelection(offset);
      }
    }
  }

  Offset? _getGridOffset(Offset localPosition, Size size) {
    final double cellWidth = size.width / controller.grid[0].length;
    final double cellHeight = size.height / controller.grid.length;
    final col = (localPosition.dx / cellWidth).floor();
    final row = (localPosition.dy / cellHeight).floor();
    if (col >= 0 && col < controller.grid[0].length && row >= 0 && row < controller.grid.length) {
      return Offset(col.toDouble(), row.toDouble());
    }
    return null;
  }
}

class _WordList extends StatelessWidget {
  final WordSearchController controller;
  const _WordList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(color: Colors.black.withAlpha(102), borderRadius: BorderRadius.circular(15.0), border: Border.all(color: Colors.white.withAlpha(150), width: 2)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 16.0, runSpacing: 8.0, alignment: WrapAlignment.center,
            children: controller.wordsToFind.map((word) {
              final isFound = controller.foundWords.contains(word);
              return Text(word, style: ChibiTextStyles.buttonText.copyWith(decoration: isFound ? TextDecoration.lineThrough : TextDecoration.none, color: isFound ? Colors.white.withAlpha(128) : Colors.white, decorationColor: ChibiColors.buttonRed, decorationThickness: 2.0));
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _SecretWordInput extends StatelessWidget {
  final WordSearchController controller;
  const _SecretWordInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Épelez le mot secret...", style: ChibiTextStyles.storyTitle),
          const SizedBox(height: 15),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4.0, // Horizontal spacing
            runSpacing: 4.0, // Vertical spacing for wrapping
            children: List.generate(controller.secretWord.length, (index) {
              final letter = (index < controller.currentSecretWordGuess.length) ? controller.currentSecretWordGuess[index] : '';
              return Container(
                width: 35, height: 50,
                decoration: BoxDecoration(
                  color: controller.isSecretWordError ? ChibiColors.buttonRed.withAlpha(180) : Colors.black.withAlpha(102),
                  border: Border.all(color: Colors.white.withAlpha(150), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text(letter, style: ChibiTextStyles.storyTitle.copyWith(fontSize: 30.sp))),
              );
            }),
          ),
        ],
      ),
    );
  }
}