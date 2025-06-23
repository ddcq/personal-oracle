import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(AsgardWallApp());
}

class AsgardWallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muraille d\'Asgard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF1A1A2E),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int boardWidth = 10;
  static const int boardHeight = 20;
  static const int victoryHeight = 12; // Baissé de 15 à 12 (3 lignes de moins)

  List<List<Color?>> board = List.generate(
    boardHeight,
    (index) => List.generate(boardWidth, (index) => null),
  );

  Timer? gameTimer;
  bool gameActive = false;
  bool gameWon = false;
  bool gameLost = false;
  FocusNode focusNode = FocusNode();

  // Pièce actuelle
  List<List<bool>> currentPiece = [];
  Color currentPieceColor = Colors.blue;
  int pieceX = 0;
  int pieceY = 0;
  int currentPieceIndex = 0;
  int currentRotationIndex = 0;

  // Queue des prochaines pièces
  List<int> nextPieces = [];
  List<Color> nextPieceColors = [];

  // Formes des pièces (similaires à Tetris)
  List<List<List<List<bool>>>> pieces = [
    // I-piece
    [
      [
        [true, true, true, true],
      ],
      [
        [true],
        [true],
        [true],
        [true],
      ],
    ],
    // O-piece
    [
      [
        [true, true],
        [true, true],
      ],
    ],
    // T-piece
    [
      [
        [false, true, false],
        [true, true, true],
      ],
      [
        [true, false],
        [true, true],
        [true, false],
      ],
      [
        [true, true, true],
        [false, true, false],
      ],
      [
        [false, true],
        [true, true],
        [false, true],
      ],
    ],
    // L-piece
    [
      [
        [true, false, false],
        [true, true, true],
      ],
      [
        [true, true],
        [true, false],
        [true, false],
      ],
      [
        [true, true, true],
        [false, false, true],
      ],
      [
        [false, true],
        [false, true],
        [true, true],
      ],
    ],
    // J-piece
    [
      [
        [false, false, true],
        [true, true, true],
      ],
      [
        [true, false],
        [true, false],
        [true, true],
      ],
      [
        [true, true, true],
        [true, false, false],
      ],
      [
        [true, true],
        [false, true],
        [false, true],
      ],
    ],
    // S-piece
    [
      [
        [false, true, true],
        [true, true, false],
      ],
      [
        [true, false],
        [true, true],
        [false, true],
      ],
    ],
    // Z-piece
    [
      [
        [true, true, false],
        [false, true, true],
      ],
      [
        [false, true],
        [true, true],
        [true, false],
      ],
    ],
  ];

  List<Color> pieceColors = [
    Colors.cyan,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    startGame();
  }

  void startGame() {
    gameTimer?.cancel(); // Annuler le timer précédent s'il existe

    setState(() {
      board = List.generate(
        boardHeight,
        (index) => List.generate(boardWidth, (index) => null),
      );
      gameActive = true;
      gameWon = false;
      gameLost = false;
      currentPiece = [];
    });

    generateNextPieces();
    spawnNewPiece();
    gameTimer = Timer.periodic(Duration(milliseconds: 800), (timer) {
      if (gameActive) {
        movePieceDown();
      } else {
        timer.cancel();
      }
    });
  }

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

  void spawnNewPiece() {
    if (nextPieces.isEmpty) {
      generateNextPieces();
    }

    // Prendre la première pièce de la queue
    currentPieceIndex = nextPieces.removeAt(0);
    currentPieceColor = nextPieceColors.removeAt(0);

    // Ajouter une nouvelle pièce à la fin
    Random random = Random();
    int newPieceIndex = random.nextInt(pieces.length);
    nextPieces.add(newPieceIndex);
    nextPieceColors.add(pieceColors[newPieceIndex]);

    currentRotationIndex = 0; // Commencer toujours par la première rotation

    currentPiece = List.generate(
      pieces[currentPieceIndex][currentRotationIndex].length,
      (i) => List.from(pieces[currentPieceIndex][currentRotationIndex][i]),
    );
    pieceX = (boardWidth - currentPiece[0].length) ~/ 2;
    pieceY = 0;

    // Vérifier si le jeu est perdu (nouvelle pièce ne peut pas être placée)
    if (!canPlacePiece(pieceX, pieceY)) {
      endGame(false);
    }

    setState(() {}); // Forcer la mise à jour de l'affichage
  }

  bool canPlacePiece(int x, int y) {
    for (int row = 0; row < currentPiece.length; row++) {
      for (int col = 0; col < currentPiece[row].length; col++) {
        if (currentPiece[row][col]) {
          int boardX = x + col;
          int boardY = y + row;

          if (boardX < 0 ||
              boardX >= boardWidth ||
              boardY >= boardHeight ||
              (boardY >= 0 && board[boardY][boardX] != null)) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void placePiece() {
    for (int row = 0; row < currentPiece.length; row++) {
      for (int col = 0; col < currentPiece[row].length; col++) {
        if (currentPiece[row][col]) {
          int boardX = pieceX + col;
          int boardY = pieceY + row;

          if (boardY >= 0 &&
              boardY < boardHeight &&
              boardX >= 0 &&
              boardX < boardWidth) {
            board[boardY][boardX] = currentPieceColor;
          }
        }
      }
    }

    checkVictoryCondition();
    if (gameActive) {
      spawnNewPiece();
    }
  }

  void checkVictoryCondition() {
    // Vérifier s'il y a des trous inaccessibles dans le mur jusqu'à la hauteur de victoire
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
              continue; // Ce n'est pas un vrai trou, continuer
            } else {
              endGame(false); // Trou inaccessible détecté, le joueur perd
              return;
            }
          }
        }
      }
    }

    // Vérifier si le mur est complètement rempli jusqu'à la hauteur de victoire
    bool wallComplete = true;
    for (int row = boardHeight - 1; row >= boardHeight - victoryHeight; row--) {
      for (int col = 0; col < boardWidth; col++) {
        if (board[row][col] == null) {
          wallComplete = false;
          break;
        }
      }
      if (!wallComplete) break;
    }

    if (wallComplete) {
      endGame(true); // Victoire !
    }
  }

  // Vérifie si un trou est vraiment inaccessible
  bool isTrueHole(int col, int row) {
    // Un trou est considéré comme inaccessible s'il n'y a pas d'accès horizontal
    // sur au moins 2 cases consécutives de chaque côté

    // Vérifier l'accès par la gauche (besoin de 2 cases libres consécutives)
    bool leftAccess = false;
    if (col >= 2) {
      bool canAccessFromLeft = true;
      for (int checkCol = col - 1; checkCol >= col - 2; checkCol--) {
        if (board[row][checkCol] != null) {
          canAccessFromLeft = false;
          break;
        }
      }
      if (canAccessFromLeft) leftAccess = true;
    }

    // Vérifier l'accès par la droite (besoin de 2 cases libres consécutives)
    bool rightAccess = false;
    if (col < boardWidth - 2) {
      bool canAccessFromRight = true;
      for (int checkCol = col + 1; checkCol <= col + 2; checkCol++) {
        if (board[row][checkCol] != null) {
          canAccessFromRight = false;
          break;
        }
      }
      if (canAccessFromRight) rightAccess = true;
    }

    // Si aucun accès n'est possible, c'est un vrai trou
    return !leftAccess && !rightAccess;
  }

  void movePieceDown() {
    if (canPlacePiece(pieceX, pieceY + 1)) {
      setState(() {
        pieceY++;
      });
    } else {
      placePiece();
      setState(() {});
    }
  }

  void movePieceLeft() {
    if (canPlacePiece(pieceX - 1, pieceY)) {
      setState(() {
        pieceX--;
      });
    }
  }

  void movePieceRight() {
    if (canPlacePiece(pieceX + 1, pieceY)) {
      setState(() {
        pieceX++;
      });
    }
  }

  void rotatePiece() {
    if (!gameActive) return;

    // Calculer la prochaine rotation
    int nextRotationIndex =
        (currentRotationIndex + 1) % pieces[currentPieceIndex].length;
    List<List<bool>> nextPiece = List.generate(
      pieces[currentPieceIndex][nextRotationIndex].length,
      (i) => List.from(pieces[currentPieceIndex][nextRotationIndex][i]),
    );

    // Vérifier si la rotation est possible à la position actuelle
    List<List<bool>> tempPiece = currentPiece;
    currentPiece = nextPiece;

    if (canPlacePiece(pieceX, pieceY)) {
      // Rotation réussie
      currentRotationIndex = nextRotationIndex;
      setState(() {});
    } else {
      // Essayer de décaler la pièce pour permettre la rotation
      bool rotated = false;
      for (int offset = 1; offset <= 2; offset++) {
        // Essayer à droite
        if (canPlacePiece(pieceX + offset, pieceY)) {
          pieceX += offset;
          currentRotationIndex = nextRotationIndex;
          rotated = true;
          break;
        }
        // Essayer à gauche
        if (canPlacePiece(pieceX - offset, pieceY)) {
          pieceX -= offset;
          currentRotationIndex = nextRotationIndex;
          rotated = true;
          break;
        }
      }

      if (!rotated) {
        // Restaurer la pièce originale si la rotation échoue
        currentPiece = tempPiece;
      } else {
        setState(() {});
      }
    }
  }

  bool handleKeyPress(KeyEvent event) {
    if (!gameActive) return false;

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

  void dropPiece() {
    while (canPlacePiece(pieceX, pieceY + 1)) {
      pieceY++;
    }
    placePiece();
    setState(() {});
  }

  void endGame(bool won) {
    gameTimer?.cancel();
    setState(() {
      gameActive = false;
      gameWon = won;
      gameLost = !won;
    });
  }

  Widget buildNextPiecesPreview() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF0F3460),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFFFD700), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prochaines pièces',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          ...nextPieces.take(3).toList().asMap().entries.map((entry) {
            int index = entry.key;
            int pieceIndex = entry.value;
            Color pieceColor = nextPieceColors[index];

            // Prendre la première rotation de chaque pièce pour l'aperçu
            List<List<bool>> previewPiece = pieces[pieceIndex][0];

            return Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: previewPiece.map((row) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: row.map((cell) {
                      return Container(
                        width: 12,
                        height: 12,
                        margin: EdgeInsets.all(0.5),
                        decoration: BoxDecoration(
                          color: cell ? pieceColor : Colors.transparent,
                          border: cell
                              ? Border.all(color: Colors.white24, width: 0.5)
                              : null,
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    focusNode.dispose();
    super.dispose();
  }

  Widget buildBoard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: boardWidth,
        ),
        itemCount: boardWidth * boardHeight,
        itemBuilder: (context, index) {
          int row = index ~/ boardWidth;
          int col = index % boardWidth;

          Color? cellColor = board[row][col];

          // Afficher la pièce actuelle
          if (gameActive && currentPiece.isNotEmpty) {
            int relativeRow = row - pieceY;
            int relativeCol = col - pieceX;

            if (relativeRow >= 0 &&
                relativeRow < currentPiece.length &&
                relativeCol >= 0 &&
                relativeCol < currentPiece[relativeRow].length &&
                currentPiece[relativeRow][relativeCol] &&
                cellColor == null) {
              cellColor = currentPieceColor.withOpacity(0.8);
            }
          }

          // Marquer la ligne de victoire
          bool isVictoryLine = row == boardHeight - victoryHeight;

          return Container(
            decoration: BoxDecoration(
              color: cellColor ?? Colors.grey[900],
              border: Border.all(
                color: isVictoryLine ? Color(0xFFFFD700) : Colors.grey[700]!,
                width: isVictoryLine ? 2 : 0.5,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Muraille d\'Asgard'),
        backgroundColor: Color(0xFF16213E),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Focus(
        focusNode: focusNode,
        onKeyEvent: (node, event) {
          return handleKeyPress(event)
              ? KeyEventResult.handled
              : KeyEventResult.ignored;
        },
        child: GestureDetector(
          onTap: () => focusNode.requestFocus(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Légende
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF0F3460),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'La Muraille d\'Asgard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Construisez la muraille parfaite comme le géant bâtisseur.\nAucun trou n\'est toléré ! Remplissez jusqu\'à la ligne dorée.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Contrôles: ←→ ou A/D pour bouger, ↑/W/Space/Q/E pour pivoter, ↓/S pour descendre',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Zone de jeu principale avec plateau et aperçu
                Expanded(
                  child: Row(
                    children: [
                      // Plateau de jeu
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: boardWidth / boardHeight,
                            child: buildBoard(),
                          ),
                        ),
                      ),
                      
                      SizedBox(width: 16),
                      
                      // Aperçu des prochaines pièces
                      Expanded(
                        flex: 1,
                        child: buildNextPiecesPreview(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Messages de fin de jeu
                if (gameWon)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '🏰 Victoire ! La muraille d\'Asgard est parfaite !\nSleipnir peut naître !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                if (gameLost)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '💥 Défaite ! Un trou dans la muraille !\nLes Ases ne paieront pas le géant.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                SizedBox(height: 16),

                // Contrôles (gardés pour mobile/tactile)
                Text(
                  'Contrôles tactiles:',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: gameActive ? movePieceLeft : null,
                      child: Icon(Icons.arrow_left),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0F3460),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: gameActive ? rotatePiece : null,
                      child: Icon(Icons.rotate_right),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0F3460),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: gameActive ? dropPiece : null,
                      child: Icon(Icons.arrow_downward),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0F3460),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: gameActive ? movePieceRight : null,
                      child: Icon(Icons.arrow_right),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0F3460),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: startGame,
                  child: Text('Nouvelle Partie'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}