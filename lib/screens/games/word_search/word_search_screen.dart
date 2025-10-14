import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/screens/games/word_search/word_search_controller.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/game_help_dialog.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';

class WordSearchScreen extends StatelessWidget {
  const WordSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => WordSearchController(), child: const _WordSearchView());
  }
}

class _WordSearchView extends StatelessWidget {
  const _WordSearchView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WordSearchController>();

    _showVictoryDialog(context, controller); // Call the new method here

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(
        titleText: 'L\'Œil d\'Odin',
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
                'Trouvez tous les mots cachés dans la grille.',
                'Les mots peuvent être horizontaux, verticaux ou diagonaux, et peuvent être lus dans les deux sens.',
                'Sélectionnez les lettres en faisant glisser votre doigt sur la grille.',
                'Une fois tous les mots trouvés, un mot secret vous sera demandé.',
                'Utilisez les lettres restantes pour former le mot secret et valider votre victoire.',
              ], onGamePaused: () {}, onGameResumed: () {});
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          AppBackground(
            child: SafeArea(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
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
        ],
      ),
    );
  }

  void _showVictoryDialog(BuildContext context, WordSearchController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.gamePhase == GamePhase.victory) {
        final bool isGenericVictory = controller.unlockedChapter == null;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return VictoryPopup(
              unlockedStoryChapter: controller.unlockedChapter?.chapter,
              isGenericVictory: isGenericVictory,
              onDismiss: () {
                Navigator.of(context).pop();
                controller.resetGame(); // Assuming you have a resetGame method in your controller
              },
              onSeeRewards: () {
                Navigator.of(context).pop(); // Close the dialog
                context.push('/profile');
              },
            );
          },
        );
      }
    });
  }
}

class _Grid extends StatelessWidget {
  final WordSearchController controller;
  const _Grid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final columnCount = controller.grid[0].length;
        final rowCount = controller.grid.length;

        // Handle potential division by zero if constraints are not properly defined yet
        if (constraints.maxHeight == 0 || columnCount == 0) {
          return const SizedBox.shrink(); // Or a placeholder
        }

        final childAspectRatio = (constraints.maxWidth / columnCount) / (constraints.maxHeight / rowCount);

        return GestureDetector(
          onPanStart: controller.gamePhase == GamePhase.searchingWords
              ? (details) {
                  _handleInteraction(details.localPosition, size);
                }
              : null,
          onPanUpdate: controller.gamePhase == GamePhase.searchingWords
              ? (details) {
                  _handleInteraction(details.localPosition, size, isUpdate: true);
                }
              : null,
          onPanEnd: controller.gamePhase == GamePhase.searchingWords ? (_) => controller.endSelection() : null,
          onTapUp: controller.gamePhase == GamePhase.unscramblingSecret
              ? (details) {
                  _handleInteraction(details.localPosition, size, isTap: true);
                }
              : null,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columnCount, childAspectRatio: childAspectRatio),
            itemCount: rowCount * columnCount,
            itemBuilder: (context, index) {
              final row = index ~/ columnCount;
              final col = index % columnCount;
              final offset = Offset(col.toDouble(), row.toDouble());
              final isSelected = controller.currentSelection.contains(offset);
              final isConfirmed = controller.confirmedSelection.contains(offset);
              return _buildGridCell(isSelected, isConfirmed, controller.grid[row][col]);
            },
          ),
        );
      },
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

  Widget _buildGridCell(bool isSelected, bool isConfirmed, String text) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? ChibiColors.buttonOrange.withAlpha(150)
            : isConfirmed
            ? ChibiColors.buttonBlue.withAlpha(150)
            : Colors.black.withAlpha(102),
        border: Border.all(color: Colors.white.withAlpha(150)),
      ),
      child: Center(child: Text(text, style: ChibiTextStyles.dialogText)),
    );
  }
}

class _WordList extends StatelessWidget {
  final WordSearchController controller;
  const _WordList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(102),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.white.withAlpha(150), width: 2),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: controller.wordsToFind.map((word) {
              final isFound = controller.foundWords.contains(word);
              return _buildWordText(word, isFound);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildWordText(String word, bool isFound) {
    return Text(
      word,
      style: ChibiTextStyles.dialogText.copyWith(
        decoration: isFound ? TextDecoration.lineThrough : TextDecoration.none,
        color: isFound ? Colors.white.withAlpha(128) : Colors.white,
        decorationColor: ChibiColors.buttonRed,
        decorationThickness: 2.0,
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
          Text(
            controller.instructionClue,
            style: ChibiTextStyles.storyTitle.copyWith(
              fontSize: 28.sp,
              shadows: [const Shadow(blurRadius: 20.0, color: Colors.black, offset: Offset(5.0, 5.0))],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4.0, // Horizontal spacing
            runSpacing: 4.0, // Vertical spacing for wrapping
            children: List.generate(controller.secretWord.length, (index) {
              final letter = (index < controller.currentSecretWordGuess.length) ? controller.currentSecretWordGuess[index] : '';
              return _buildLetterContainer(letter, controller.isSecretWordError);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterContainer(String letter, bool isError) {
    return Container(
      width: 35,
      height: 50,
      decoration: BoxDecoration(
        color: isError ? ChibiColors.buttonRed.withAlpha(180) : Colors.black.withAlpha(102),
        border: Border.all(color: Colors.white.withAlpha(150), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(letter, style: ChibiTextStyles.storyTitle.copyWith(fontSize: 30.sp)),
      ),
    );
  }
}
