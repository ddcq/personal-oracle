import 'dart:async';
import 'dart:math';


import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/game_over_popup.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/game_components.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/game_data.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/welcome_screen.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

// game_logic.dart (Simulé : La logique et l’état du jeu)
// Les méthodes et l’état de jeu sont gérés par _GameScreenState.
class PlacedPiece {
  final int pieceIndex;
  final int rotationIndex;
  final int x;
  final int y;
  bool isNewlyPlaced = true;

  PlacedPiece({required this.pieceIndex, required this.rotationIndex, required this.x, required this.y});
}

class _GameScreenState extends State<GameScreen> {
  static const int boardWidth = 11;
  static const int boardHeight = 22;
  static const int victoryHeight = 12;

  // The board is now for collision detection only.
  List<List<bool>> collisionBoard = List.generate(boardHeight, (index) => List.generate(boardWidth, (index) => false));
  List<PlacedPiece> placedPieces = [];

  // Timer for visual effects
  Timer? effectTimer;

  Timer? gameTimer;
  bool gameActive = false;
  bool _isPaused = false; // New flag for pausing game logic
  // gameWon and gameLost are now handled by navigation to dedicated screens.
  FocusNode focusNode = FocusNode();

  // Current piece
  List<List<bool>> currentPiece = [];
  Color currentPieceColor = Colors.blue; // Fallback color, not used if images work
  int pieceX = 0;
  int pieceY = 0;
  int currentPieceIndex = 0;
  int currentRotationIndex = 0;

  // Queue of next pieces
  List<int> nextPieces = [];
  List<Color> nextPieceColors = [];

  // Assuming image files are named like 'p.webp', 'q.webp' etc. in assets/images/blocks/
  final List<String> pieceImageNames = ['i2', 'i3', 'l', 'p', 'q', 't', 'u', 'x'];

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    startGame();
  }

  // Initializes or resets the game.
  void startGame() {
    gameTimer?.cancel(); // Cancel previous timer if it exists
    effectTimer?.cancel(); // Cancel previous visual effects timer

    setState(() {
      // Reset board and effects
      collisionBoard = List.generate(boardHeight, (index) => List.generate(boardWidth, (index) => false));
      placedPieces = [];
      gameActive = true;
      _isPaused = false; // Ensure game is not paused on start
      currentPiece = []; // Empty the current piece
    });

    generateNextPieces(); // Génère les prochaines pièces
    spawnNewPiece(); // Fait apparaître une nouvelle pièce

    // Lance le timer du jeu pour la descente automatique des pièces
    gameTimer = Timer.periodic(Duration(milliseconds: 800), (timer) {
      if (gameActive && !_isPaused) {
        movePieceDown();
      } else if (!gameActive) {
        timer.cancel();
      }
    });

    // Timer pour les effets visuels temporaires (ex: brillance des blocs nouvellement placés)
    effectTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!_isPaused) {
        _updateVisualEffects();
      }
    });
  }

  // Génère la queue des 5 prochaines pièces aléatoires.
  void generateNextPieces() {
    Random random = Random();
    nextPieces.clear();
    nextPieceColors.clear();

    // Coefficients de chance pour chaque pièce : [5,5,5,2,2,1,1,1]
    final totalWeight = 22;
    final cumulativeWeights = [5, 10, 15, 17, 19, 20, 21, 22];

    for (int i = 0; i < 5; i++) {
      final randomValue = random.nextInt(totalWeight);
      int pieceIndex = 0;
      for (int j = 0; j < cumulativeWeights.length; j++) {
        if (randomValue < cumulativeWeights[j]) {
          pieceIndex = j;
          break;
        }
      }
      nextPieces.add(pieceIndex);
      nextPieceColors.add(pieceColors[pieceIndex]);
    }
  }

  // Fait apparaître une nouvelle pièce en haut du plateau.
  void spawnNewPiece() {
    if (nextPieces.isEmpty) {
      generateNextPieces(); // S’il n’y a plus de pièces, en génère de nouvelles.
    }

    // Prend la première pièce de la queue
    currentPieceIndex = nextPieces.removeAt(0);
    currentPieceColor = nextPieceColors.removeAt(0);

    // Ajoute une nouvelle pièce aléatoire à la fin de la queue
    Random random = Random();
    int newPieceIndex = random.nextInt(pieces.length);
    nextPieces.add(newPieceIndex);
    nextPieceColors.add(pieceColors[newPieceIndex]);

    currentRotationIndex = 0; // Commence toujours par la première rotation

    // Définit la forme de la pièce actuelle basée sur l’index et la rotation
    currentPiece = List.generate(pieces[currentPieceIndex][currentRotationIndex].length, (i) => List.from(pieces[currentPieceIndex][currentRotationIndex][i]));
    pieceX = (boardWidth - currentPiece[0].length) ~/ 2; // Centre la pièce horizontalement
    pieceY = 0; // Place la pièce en haut du plateau

    // Vérifie si le jeu est perdu (nouvelle pièce ne peut pas être placée au départ)
    if (!canPlacePiece(pieceX, pieceY)) {
      endGame(false); // Fin du jeu : défaite
    }

    setState(() {}); // Force la mise à jour de l'affichage
  }

  // Vérifie si la pièce actuelle peut être placée à une position donnée (x, y).
  bool canPlacePiece(int x, int y) {
    for (int row = 0; row < currentPiece.length; row++) {
      for (int col = 0; col < currentPiece[row].length; col++) {
        if (currentPiece[row][col]) {
          int boardX = x + col;
          int boardY = y + row;

          // Vérifie les collisions avec les bords du plateau ou les blocs existants
          if (boardX < 0 || // Hors limite à gauche
              boardX >= boardWidth || // Hors limite à droite
              boardY >= boardHeight || // Hors limite en bas
              (boardY >= 0 && collisionBoard[boardY][boardX])) {
            // Collision avec un bloc existant
            return false;
          }
        }
      }
    }
    return true;
  }

  // Place la pièce actuelle sur le plateau (elle devient fixe).
  void placePiece() {
    // Add to placed pieces list for rendering
    placedPieces.add(PlacedPiece(
      pieceIndex: currentPieceIndex,
      rotationIndex: currentRotationIndex,
      x: pieceX,
      y: pieceY,
    ));

    // Update collision board
    for (int row = 0; row < currentPiece.length; row++) {
      for (int col = 0; col < currentPiece[row].length; col++) {
        if (currentPiece[row][col]) {
          int boardX = pieceX + col;
          int boardY = pieceY + row;

          if (boardY >= 0 && boardY < boardHeight && boardX >= 0 && boardX < boardWidth) {
            collisionBoard[boardY][boardX] = true;
          }
        }
      }
    }

    _simulateBlockPlacement();

    // Check for inaccessible holes created by this piece
    if (_checkInaccessibleHoles()) {
      endGame(false);
      return;
    }

    checkVictoryCondition();
    if (gameActive) {
      spawnNewPiece();
    }
  }

  // Placeholder pour simuler un effet sonore ou haptique.
  void _simulateBlockPlacement() {
    // Ici, on pourrait ajouter HapticFeedback.lightImpact() pour mobile (nécessite d'importer 'package:flutter/services.dart')
    // ou jouer un son de pierre qui tombe.
  }

  // Met à jour les effets visuels (ex: fait disparaître la brillance des blocs après un certain temps).
  void _updateVisualEffects() {
    bool needsUpdate = false;
    for (final piece in placedPieces) {
      if (piece.isNewlyPlaced) {
        // After a short delay, remove the "newly placed" effect.
        // A simple random chance per frame to turn it off.
        if (Random().nextDouble() < 0.2) {
          // 20% chance to turn off the effect per frame
          piece.isNewlyPlaced = false;
          needsUpdate = true;
        }
      }
    }

    if (needsUpdate) {
      setState(() {}); // Force update to make effects disappear
    }
  }

  // Vérifie si le joueur a gagné ou perdu.
  void checkVictoryCondition() {
    if (_checkWallComplete()) {
      endGame(true); // Victoire !
    }
  }

  bool _checkInaccessibleHoles() {
    final piece = currentPiece;
    final x = pieceX;
    final y = pieceY;

    final pieceWidth = piece[0].length;
    final pieceHeight = piece.length;

    // Check all cells in the bounding box of the piece, with a 1-cell margin.
    final startX = x - 1;
    final endX = x + pieceWidth;
    final startY = y - 1;
    final endY = y + pieceHeight;

    for (int cy = startY; cy <= endY; cy++) {
      for (int cx = startX; cx <= endX; cx++) {
        // We are looking for an empty cell (a potential hole).
        // It must be within the board and not on the top row (since it must have a block above).
        if (cx >= 0 && cx < boardWidth && cy > 0 && cy < boardHeight && !collisionBoard[cy][cx]) {
          // Check if it's blocked on top, left, and right.
          final bool blockedTop = collisionBoard[cy - 1][cx];
          final bool blockedLeft = (cx == 0) || collisionBoard[cy][cx - 1];
          final bool blockedRight = (cx == boardWidth - 1) || collisionBoard[cy][cx + 1];

          if (blockedTop && blockedLeft && blockedRight) {
            return true; // Found a hole.
          }
        }
      }
    }

    return false;
  }

  bool _checkWallComplete() {
    for (int row = boardHeight - 1; row >= boardHeight - victoryHeight; row--) {
      for (int col = 0; col < boardWidth; col++) {
        if (!collisionBoard[row][col]) {
          return false;
        }
      }
    }
    return true;
  }

  // Déplace la pièce vers le bas.
  void movePieceDown() {
    if (canPlacePiece(pieceX, pieceY + 1)) {
      setState(() {
        pieceY++;
      });
    } else {
      placePiece(); // Si la pièce ne peut plus descendre, elle est posée.
      setState(() {});
    }
  }

  // Déplace la pièce vers la gauche.
  void movePieceLeft() {
    if (canPlacePiece(pieceX - 1, pieceY)) {
      setState(() {
        pieceX--;
      });
    }
  }

  // Déplace la pièce vers la droite.
  void movePieceRight() {
    if (canPlacePiece(pieceX + 1, pieceY)) {
      setState(() {
        pieceX++;
      });
    }
  }

  // Fait pivoter la pièce.
  void rotatePiece() {
    if (!gameActive) return;

    // Calculer la prochaine rotation
    int nextRotationIndex = (currentRotationIndex + 1) % pieces[currentPieceIndex].length;
    List<List<bool>> nextPiece = List.generate(
      pieces[currentPieceIndex][nextRotationIndex].length,
      (i) => List.from(pieces[currentPieceIndex][nextRotationIndex][i]),
    );

    // Sauvegarde la pièce actuelle temporairement pour la restaurer si la rotation échoue
    List<List<bool>> tempPiece = currentPiece;
    currentPiece = nextPiece; // Tente d'appliquer la nouvelle rotation

    if (canPlacePiece(pieceX, pieceY)) {
      // Rotation réussie sans décalage
      currentRotationIndex = nextRotationIndex;
      setState(() {});
    } else {
      // Essaye de décaler la pièce pour permettre la rotation (kick)
      bool rotated = false;
      for (int offset = 1; offset <= 2; offset++) {
        // Essaye à droite
        if (canPlacePiece(pieceX + offset, pieceY)) {
          pieceX += offset;
          currentRotationIndex = nextRotationIndex;
          rotated = true;
          break;
        }
        // Essaye à gauche
        if (canPlacePiece(pieceX - offset, pieceY)) {
          pieceX -= offset;
          currentRotationIndex = nextRotationIndex;
          rotated = true;
          break;
        }
      }

      if (!rotated) {
        // Restaure la pièce originale si la rotation échoue après les décalages
        currentPiece = tempPiece;
      } else {
        setState(() {});
      }
    }
  }

  // Gère les événements de touche du clavier.
  bool handleKeyPress(KeyEvent event) {
    if (!gameActive) {
      return false; // Ignore les touches si le jeu n’est pas actif
    }

    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
        case LogicalKeyboardKey.keyA:
          movePieceLeft();
          return true;
        case LogicalKeyboardKey.arrowRight:
        case LogicalKeyboardKey.keyD:
          movePieceRight();
          return true;
        case LogicalKeyboardKey.arrowDown:
        case LogicalKeyboardKey.keyS:
          movePieceDown();
          return true;
        case LogicalKeyboardKey.arrowUp:
        case LogicalKeyboardKey.keyW:
        case LogicalKeyboardKey.space:
          rotatePiece();
          return true;
        case LogicalKeyboardKey.keyQ:
        case LogicalKeyboardKey.keyE:
          rotatePiece();
          return true;
        default:
          return false;
      }
    }
    return false;
  }

  // Fait tomber la pièce instantanément au fond.
  void dropPiece() {
    while (canPlacePiece(pieceX, pieceY + 1)) {
      pieceY++;
    }
    placePiece(); // Une fois au fond, la pièce est posée.
    setState(() {});
  }

  // Termine le jeu, affiche le message de victoire ou de défaite.
  void endGame(bool won) {
    gameTimer?.cancel();
    effectTimer?.cancel();
    setState(() {
      gameActive = false;
    });
    if (won) {
      _showWinDialog();
    } else {
      _showLossDialog();
    }
  }

  void _showWinDialog() {
    final gamificationService = getIt<GamificationService>();
    gamificationService
        .selectRandomUnearnedCollectibleCard()
        .then((card) {
          if (card != null) {
            if (!mounted) return;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return VictoryPopup(
                  rewardCard: card,
                  onDismiss: () {
                    Navigator.of(context).pop();
                    startGame();
                  },
                  onSeeRewards: () {
                    Navigator.of(context).pop();
                    context.go('/profile');
                  },
                );
              },
            );
          } else {
            // No card won, just show a simple victory message and restart
            if (!mounted) return;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return VictoryPopup(
                  isGenericVictory: true,
                  onDismiss: () {
                    Navigator.of(context).pop();
                    startGame();
                  },
                  onSeeRewards: () {
                    Navigator.of(context).pop();
                    context.go('/profile');
                  },
                );
              },
            );
          }
        })
        .catchError((error) {
          // Show generic victory popup in case of error
          if (!mounted) return;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return VictoryPopup(
                isGenericVictory: true,
                onDismiss: () {
                  Navigator.of(context).pop();
                  startGame();
                },
                onSeeRewards: () {
                  Navigator.of(context).pop();
                  context.go('/profile');
                },
              );
            },
          );
        });
  }

  void _showLossDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameOverPopup(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'asgard_wall_game_screen_defeat'.tr(),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Changed to white
                  fontFamily: AppTextStyles.amaticSC,
                  shadows: [Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0, 2.0))],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'asgard_wall_game_screen_defeat_message'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: AppTextStyles.amaticSC, // Added font family
                  shadows: [Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(1.0, 1.0))],
                ),
              ),
            ],
          ),
          onReplay: () {
            Navigator.of(context).pop();
            startGame();
          },
          onMenu: () {
            context.go('/');
          },
        );
      },
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel(); // Annule le timer du jeu à la suppression du widget
    effectTimer?.cancel(); // Annule le timer des effets visuels
    focusNode.dispose(); // Libère le FocusNode
    super.dispose();
  }

  // Construit le plateau de jeu visuel.
  Widget buildBoard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(image: AssetImage('assets/images/backgrounds/asgard.jpg'), fit: BoxFit.cover),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boardPixelWidth = constraints.maxWidth;
          final boardPixelHeight = constraints.maxHeight;
          final cellWidth = boardPixelWidth / boardWidth;
          final cellHeight = boardPixelHeight / boardHeight;

          final placedPiecesWidgets = placedPieces.map((piece) {
            final pieceData = pieces[piece.pieceIndex][piece.rotationIndex];
            final pieceWidth = pieceData[0].length;
            final pieceHeight = pieceData.length;

            return Positioned(
              left: piece.x * cellWidth,
              top: piece.y * cellHeight,
              width: pieceWidth * cellWidth,
              height: pieceHeight * cellHeight,
              child: RotatedBox(
                quarterTurns: piece.rotationIndex,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(piece.isNewlyPlaced ? Colors.white.withAlpha(179) : Colors.transparent, BlendMode.srcATop),
                  child: Image.asset('assets/images/blocks/${pieceImageNames[piece.pieceIndex]}.webp', fit: BoxFit.fill),
                ),
              ),
            );
          }).toList();

          final fallingPieceWidget = gameActive && currentPiece.isNotEmpty
              ? Positioned(
                  left: pieceX * cellWidth,
                  top: pieceY * cellHeight,
                  width: currentPiece[0].length * cellWidth,
                  height: currentPiece.length * cellHeight,
                  child: RotatedBox(
                    quarterTurns: currentRotationIndex,
                    child: Image.asset('assets/images/blocks/${pieceImageNames[currentPieceIndex]}.webp', fit: BoxFit.fill),
                  ),
                )
              : const SizedBox.shrink();

          final boardGrid = GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: boardWidth),
            itemCount: boardWidth * boardHeight,
            itemBuilder: (context, index) {
              int row = index ~/ boardWidth;
              int col = index % boardWidth;
              return _buildCell(row, col);
            },
          );

          return Stack(children: [boardGrid, ...placedPiecesWidgets, fallingPieceWidget]);
        },
      ),
    );
  }

  Widget _buildCell(int row, int col) {
    bool isVictoryLine = row == boardHeight - victoryHeight;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isVictoryLine ? const Color(0xFFFFD700) : Colors.grey[700]!, width: isVictoryLine ? 2 : 0.5),
      ),
      child: Container(color: Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/backgrounds/landscape.jpg'), fit: BoxFit.cover),
          ),
        ), // The background is now at the bottom of the stack
        Scaffold(
          backgroundColor: Colors.transparent, // Make the scaffold transparent
          extendBodyBehindAppBar: false, // The body does not extend behind the app bar
          appBar: ChibiAppBar(
            titleText: 'asgard_wall_game_screen_title'.tr(),
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
                  WelcomeScreenDialog.show(
                    context,
                    onGamePaused: () {
                      _isPaused = true;
                    },
                    onGameResumed: () {
                      _isPaused = false;
                    },
                  );
                },
              ),
            ],
          ),
          body: Focus(
            focusNode: focusNode,
            onKeyEvent: (node, event) {
              // Gère les événements clavier
              return handleKeyPress(event) ? KeyEventResult.handled : KeyEventResult.ignored;
            },
            child: SimpleGestureDetector(
              // Permet de refocaliser le jeu en tapant n’importe où
              onTap: () => focusNode.requestFocus(),
              child: Column(
                children: [
                  // Zone de jeu principale avec plateau et aperçu des pièces
                  Expanded(
                    child: Row(
                      children: [
                        // Plateau de jeu (prend 3 parts de l’espace)
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: AspectRatio(aspectRatio: boardWidth / boardHeight, child: buildBoard()),
                          ),
                        ),

                        SizedBox(width: 16),

                        // Aperçu des prochaines pièces
                        Expanded(
                          flex: 1,
                          child: NextPiecesPreview(
                            nextPieces: nextPieces,
                            nextPieceColors: nextPieceColors,
                            piecesData: pieces,
                            pieceImageNames: pieceImageNames,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChibiButton(
                        onPressed: gameActive ? movePieceLeft : () {},
                        color: Colors.blueGrey, // Consistent color for game controls
                        child: Icon(Icons.arrow_left, color: Colors.white),
                      ),
                      ChibiButton(
                        onPressed: gameActive ? rotatePiece : () {},
                        color: Colors.blueGrey,
                        child: Icon(Icons.rotate_right, color: Colors.white),
                      ),
                      ChibiButton(
                        onPressed: gameActive ? dropPiece : () {},
                        color: Colors.blueGrey,
                        child: Icon(Icons.arrow_downward, color: Colors.white),
                      ),
                      ChibiButton(
                        onPressed: gameActive ? movePieceRight : () {},
                        color: Colors.blueGrey,
                        child: Icon(Icons.arrow_right, color: Colors.white),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Bouton Nouvelle Partie (peut être utile pour redémarrer depuis le jeu)
                  ChibiButton(
                    onPressed: startGame,
                    text: 'asgard_wall_game_screen_restart'.tr(),
                    color: const Color(0xFFFFD700), // Fond doré
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
