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

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

// game_logic.dart (Simulé : La logique et l’état du jeu)
// Les méthodes et l’état de jeu sont gérés par _GameScreenState.
class _GameScreenState extends State<GameScreen> {
  static const int boardWidth = 10;
  static const int boardHeight = 20;
  static const int victoryHeight = 12;

  // Le plateau de jeu stocke la couleur de chaque cellule, qui sera maintenant la couleur du mur pour les blocs posés.
  List<List<Color?>> board = List.generate(boardHeight, (index) => List.generate(boardWidth, (index) => null));

  // La couleur fixe pour les blocs du mur une fois qu'ils sont posés
  Color wallBlockColor = Color(0xFF6B5B95); // Une couleur de pierre (violet/gris)

  // Animation pour l’effet de construction du mur, indiquant les blocs nouvellement posés.
  List<List<bool>> justPlaced = List.generate(boardHeight, (index) => List.generate(boardWidth, (index) => false));

  // Timer pour les effets visuels
  Timer? effectTimer;

  Timer? gameTimer;
  bool gameActive = false;
  bool _isPaused = false; // New flag for pausing game logic
  // gameWon et gameLost sont maintenant gérés par la navigation vers les écrans dédiés.
  FocusNode focusNode = FocusNode();

  // Pièce actuelle
  List<List<bool>> currentPiece = [];
  Color currentPieceColor = Colors.blue; // Couleur de la pièce en mouvement
  int pieceX = 0;
  int pieceY = 0;
  int currentPieceIndex = 0;
  int currentRotationIndex = 0;

  // Queue des prochaines pièces
  List<int> nextPieces = [];
  List<Color> nextPieceColors = [];

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    startGame();
  }

  // Initialise ou réinitialise le jeu.
  void startGame() {
    gameTimer?.cancel(); // Annule le timer précédent s’il existe
    effectTimer?.cancel(); // Annule le timer d'effets visuels précédent

    setState(() {
      // Réinitialise le plateau et les effets
      board = List.generate(boardHeight, (index) => List.generate(boardWidth, (index) => null));
      justPlaced = List.generate(boardHeight, (index) => List.generate(boardWidth, (index) => false));
      gameActive = true;
      _isPaused = false; // Ensure game is not paused on start
      currentPiece = []; // Vide la pièce actuelle
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

    for (int i = 0; i < 5; i++) {
      int pieceIndex = random.nextInt(pieces.length);
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
              (boardY >= 0 && board[boardY][boardX] != null)) {
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
    for (int row = 0; row < currentPiece.length; row++) {
      for (int col = 0; col < currentPiece[row].length; col++) {
        if (currentPiece[row][col]) {
          int boardX = pieceX + col;
          int boardY = pieceY + row;

          if (boardY >= 0 && boardY < boardHeight && boardX >= 0 && boardX < boardWidth) {
            // IMPORTANT: Les blocs posés prennent la couleur du mur
            board[boardY][boardX] = wallBlockColor;
            justPlaced[boardY][boardX] = true; // Marque comme nouvellement placé pour l’effet visuel
          }
        }
      }
    }

    // Simule un effet de placement (peut être remplacé par vibration/son)
    _simulateBlockPlacement();

    checkVictoryCondition(); // Vérifie si la condition de victoire est atteinte
    if (gameActive) {
      spawnNewPiece(); // Fait apparaître une nouvelle pièce si le jeu est toujours actif
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

    // Réduit progressivement l’effet "nouvellement placé"
    for (int row = 0; row < boardHeight; row++) {
      for (int col = 0; col < boardWidth; col++) {
        if (justPlaced[row][col]) {
          // Après quelques frames, enlève l’effet aléatoirement
          if (Random().nextDouble() < 0.1) {
            // 10% de chance de désactiver l’effet par frame
            justPlaced[row][col] = false;
            needsUpdate = true;
          }
        }
      }
    }

    if (needsUpdate) {
      setState(() {}); // Force la mise à jour pour que les effets disparaissent
    }
  }

  // Vérifie si le joueur a gagné ou perdu.
  void checkVictoryCondition() {
    if (_checkInaccessibleHoles()) {
      endGame(false); // Trou inaccessible détecté, le joueur perd
      return;
    }

    if (_checkWallComplete()) {
      endGame(true); // Victoire !
    }
  }

  bool _checkInaccessibleHoles() {
    for (int row = boardHeight - 1; row >= boardHeight - victoryHeight; row--) {
      for (int col = 0; col < boardWidth; col++) {
        if (board[row][col] == null) {
          // Il y a un trou, vérifier s'il y a des blocs au-dessus
          bool hasBlockAbove = false;
          for (int checkRow = row - 1; checkRow >= 0; checkRow--) {
            if (board[checkRow][col] != null) {
              hasBlockAbove = true;
              break;
            }
          }

          if (hasBlockAbove) {
            // Il y a un bloc au-dessus, vérifier si le trou est accessible
            if (!isTrueHole(col, row)) {
              continue; // Ce n’est pas un vrai trou, continuer
            } else {
              return true; // Trou inaccessible détecté
            }
          }
        }
      }
    }
    return false;
  }

  bool _checkWallComplete() {
    for (int row = boardHeight - 1; row >= boardHeight - victoryHeight; row--) {
      for (int col = 0; col < boardWidth; col++) {
        if (board[row][col] == null) {
          return false;
        }
      }
    }
    return true;
  }

  // Vérifie si un trou est vraiment inaccessible (selon la logique du jeu).
  bool isTrueHole(int col, int row) {
    // Un trou est considéré comme inaccessible s’il n’y a pas d'accès horizontal
    // sur au moins 2 cases consécutives de chaque côté

    bool canAccessFromDirection(int startCol, int endCol) {
      for (int checkCol = startCol; checkCol <= endCol; checkCol++) {
        if (checkCol < 0 || checkCol >= boardWidth || board[row][checkCol] != null) {
          return false;
        }
      }
      return true;
    }

    // Vérifier l’accès par la gauche (besoin de 2 cases libres consécutives)
    bool leftAccess = false;
    if (col >= 2) {
      leftAccess = canAccessFromDirection(col - 2, col - 1);
    }

    // Vérifier l’accès par la droite (besoin de 2 cases libres consécutives)
    bool rightAccess = false;
    if (col < boardWidth - 2) {
      rightAccess = canAccessFromDirection(col + 1, col + 2);
    }

    // Si aucun accès n’est possible, c’est un vrai trou
    return !leftAccess && !rightAccess;
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
    gamificationService.selectRandomUnearnedCollectibleCard().then((card) {
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
    }).catchError((error) {
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
        border: Border.all(color: Colors.white, width: 2), // Bordure blanche autour du plateau
        borderRadius: BorderRadius.circular(8),
        // AJOUT : Image de fond pour le plateau
        image: DecorationImage(
          image: AssetImage('assets/images/backgrounds/asgard.jpg'),
          fit: BoxFit.cover, // L’image couvrira le conteneur
          // Optionnel : un filtre pour assombrir l’image et améliorer la lisibilité des blocs
          // colorFilter: ColorFilter.mode(Colors.black.withAlpha(128), BlendMode.dstATop),
        ),
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(), // Empêche le défilement du GridView
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: boardWidth, // Nombre de colonnes
        ),
        itemCount: boardWidth * boardHeight, // Nombre total de cellules
        itemBuilder: (context, index) {
          int row = index ~/ boardWidth;
          int col = index % boardWidth;

          Color? cellColor = board[row][col]; // Couleur du bloc fixe sur le plateau

          // Affiche la pièce actuelle qui tombe
          if (gameActive && currentPiece.isNotEmpty) {
            int relativeRow = row - pieceY;
            int relativeCol = col - pieceX;

            if (relativeRow >= 0 &&
                relativeRow < currentPiece.length &&
                relativeCol >= 0 &&
                relativeCol < currentPiece[relativeRow].length &&
                currentPiece[relativeRow][relativeCol] &&
                cellColor == null) {
              // Si c’est une partie de la pièce qui tombe et la cellule est vide
              cellColor = currentPieceColor;
            }
          }

          return _buildCell(row, col, cellColor);
        },
      ),
    );
  }

  Widget _buildCell(int row, int col, Color? cellColor) {
    // Marque la ligne de victoire avec une bordure dorée
    bool isVictoryLine = row == boardHeight - victoryHeight;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isVictoryLine ? Color(0xFFFFD700) : Colors.grey[700]!, // Bordure dorée pour la ligne de victoire
          width: isVictoryLine ? 2 : 0.5,
        ),
      ),
      child:
          cellColor !=
              null // Si la cellule contient un bloc (fixe ou tombant)
          ? AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                // Couleur de base pour les blocs (couleur de la pièce en mouvement ou couleur du mur)
                color: cellColor,
                // Effet de brillance pour les blocs nouvellement placés
                boxShadow: justPlaced[row][col] ? [BoxShadow(color: Colors.white.withAlpha(128), blurRadius: 4, spreadRadius: 1)] : null,
              ),
              // Ajoute des bordures et des dégradés pour simuler des joints et la profondeur des pierres
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: justPlaced[row][col] ? Colors.white38 : Colors.black45, // Bordure plus claire pour les blocs nouvellement placés
                    width: justPlaced[row][col] ? 1.0 : 0.5,
                  ),
                  // Effet de profondeur pour les pierres
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white.withAlpha(25), Colors.transparent, Colors.black.withAlpha(25)],
                  ),
                ),
                // Icône de pierre ou autre effet pour les blocs nouvellement placés
                child: justPlaced[row][col]
                    ? Center(
                        child: Icon(
                          Icons.hexagon, // Symbole de pierre
                          color: Colors.white.withAlpha(76),
                          size: 12,
                        ),
                      )
                    : null,
              ),
            )
          : Container(
              // Rendre les cases vides transparentes pour laisser l’image de fond apparaître
              color: Colors.transparent, // Transparent pour les cases vides
            ),
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
            child: GestureDetector(
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
                          child: NextPiecesPreview(nextPieces: nextPieces, nextPieceColors: nextPieceColors, piecesData: pieces),
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
