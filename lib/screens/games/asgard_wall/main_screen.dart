import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/game_components.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/game_data.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/models/wall_game_models.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/welcome_screen.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/services/video_cache_service.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/chibi_icon_button.dart';
import 'package:oracle_d_asgard/widgets/chibi_text_button.dart';
import 'package:oracle_d_asgard/widgets/game_over_popup.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int boardWidth = 11;
  static const int boardHeight = 22;
  static const int victoryHeight = 12;

  List<List<bool>> collisionBoard = List.generate(
    boardHeight,
    (index) => List.generate(boardWidth, (index) => false),
  );
  List<PlacedPiece> placedPieces = [];
  final Set<Segment> _contour = {};

  Timer? effectTimer;
  Timer? gameTimer;
  bool gameActive = false;
  bool _isPaused = false;
  FocusNode focusNode = FocusNode();

  List<List<bool>> currentPiece = [];
  int pieceX = 0;
  int pieceY = 0;
  int currentPieceIndex = 0;
  int currentRotationIndex = 0;
  int currentScore = 0;
  List<int> nextPieces = [];
  final List<String> pieceImageNames = ['o', 'i', 'z', 's', 't', 'j', 'l'];

  CollectibleCard? _rewardCard;

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    startGame();
  }

  Future<void> _preloadNextReward() async {
    _rewardCard = await getIt<GamificationService>()
        .selectRandomUnearnedCollectibleCard();
    if (_rewardCard?.videoUrl != null && _rewardCard!.videoUrl!.isNotEmpty) {
      await getIt<VideoCacheService>().preloadVideo(_rewardCard!.videoUrl!);
    }
  }

  void startGame() {
    gameTimer?.cancel();
    effectTimer?.cancel();

    _preloadNextReward();

    setState(() {
      collisionBoard = List.generate(
        boardHeight,
        (index) => List.generate(boardWidth, (index) => false),
      );
      placedPieces = [];
      _contour.clear();
      for (int i = 0; i < boardWidth; i++) {
        _contour.add(Segment(i, boardHeight, i + 1, boardHeight));
      }
      gameActive = true;
      _isPaused = false;
      currentPiece = [];
      currentScore = 0;
    });

    generateNextPieces();
    spawnNewPiece();

    gameTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (gameActive && !_isPaused) {
        movePieceDown();
      } else if (!gameActive) {
        timer.cancel();
      }
    });

    effectTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isPaused) {
        _updateVisualEffects();
      }
    });
  }

  void generateNextPieces() {
    Random random = Random();
    nextPieces.clear();

    for (int i = 0; i < 5; i++) {
      int pieceIndex = random.nextInt(pieceImageNames.length);
      nextPieces.add(pieceIndex);
    }
  }

  void spawnNewPiece() {
    if (nextPieces.isEmpty) {
      generateNextPieces();
    }

    currentPieceIndex = nextPieces.removeAt(0);
    Random random = Random();
    int newPieceIndex = random.nextInt(pieces.length);
    nextPieces.add(newPieceIndex);

    currentRotationIndex = 0;

    currentPiece = List.generate(
      pieces[currentPieceIndex][currentRotationIndex].length,
      (i) => List.from(pieces[currentPieceIndex][currentRotationIndex][i]),
    );
    pieceX = (boardWidth - currentPiece[0].length) ~/ 2;
    pieceY = 0;

    if (!canPlacePiece(pieceX, pieceY)) {
      endGame(false);
    }

    setState(() {});
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
              (boardY >= 0 && collisionBoard[boardY][boardX])) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void _updateContour() {
    for (int r = 0; r < currentPiece.length; r++) {
      for (int c = 0; c < currentPiece[r].length; c++) {
        if (currentPiece[r][c]) {
          int x = pieceX + c;
          int y = pieceY + r;

          final topEdge = Segment(x, y, x + 1, y);
          if (!_contour.remove(topEdge)) {
            _contour.add(topEdge);
          }

          final bottomEdge = Segment(x, y + 1, x + 1, y + 1);
          if (!_contour.remove(bottomEdge)) {
            _contour.add(bottomEdge);
          }

          final leftEdge = Segment(x, y, x, y + 1);
          if (!_contour.remove(leftEdge)) {
            _contour.add(leftEdge);
          }

          final rightEdge = Segment(x + 1, y, x + 1, y + 1);
          if (!_contour.remove(rightEdge)) {
            _contour.add(rightEdge);
          }
        }
      }
    }
  }

  void placePiece() {
    placedPieces.add(
      PlacedPiece(
        pieceIndex: currentPieceIndex,
        rotationIndex: currentRotationIndex,
        x: pieceX,
        y: pieceY,
      ),
    );

    for (int row = 0; row < currentPiece.length; row++) {
      for (int col = 0; col < currentPiece[row].length; col++) {
        if (currentPiece[row][col]) {
          int boardX = pieceX + col;
          int boardY = pieceY + row;

          if (boardY >= 0 &&
              boardY < boardHeight &&
              boardX >= 0 &&
              boardX < boardWidth) {
            collisionBoard[boardY][boardX] = true;
          }
        }
      }
    }

    _updateContour();
    _simulateBlockPlacement();

    if (_checkInaccessibleHoles()) {
      endGame(false);
      return;
    }

    checkVictoryCondition();
    if (gameActive) {
      spawnNewPiece();
    }
  }

  void _simulateBlockPlacement() {}

  void _updateVisualEffects() {
    bool needsUpdate = false;
    for (final piece in placedPieces) {
      if (piece.isNewlyPlaced) {
        if (Random().nextDouble() < 0.2) {
          piece.isNewlyPlaced = false;
          needsUpdate = true;
        }
      }
    }

    if (needsUpdate) {
      setState(() {});
    }
  }

  void checkVictoryCondition() {
    if (_checkWallComplete()) {
      endGame(true);
    }
  }

  bool _checkInaccessibleHoles() {
    final piece = currentPiece;
    final x = pieceX;
    final y = pieceY;

    final pieceWidth = piece[0].length;
    final pieceHeight = piece.length;

    final startX = x - 1;
    final endX = x + pieceWidth;
    final startY = y - 1;
    final endY = y + pieceHeight;

    for (int cy = startY; cy <= endY; cy++) {
      for (int cx = startX; cx <= endX; cx++) {
        if (cx >= 0 &&
            cx < boardWidth &&
            cy > 0 &&
            cy < boardHeight &&
            !collisionBoard[cy][cx]) {
          final bool blockedTop = collisionBoard[cy - 1][cx];
          final bool blockedLeft = (cx == 0) || collisionBoard[cy][cx - 1];
          final bool blockedRight =
              (cx == boardWidth - 1) || collisionBoard[cy][cx + 1];

          if (blockedTop && blockedLeft && blockedRight) {
            return true;
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

    int nextRotationIndex =
        (currentRotationIndex + 1) % pieces[currentPieceIndex].length;
    List<List<bool>> nextPiece = List.generate(
      pieces[currentPieceIndex][nextRotationIndex].length,
      (i) => List.from(pieces[currentPieceIndex][nextRotationIndex][i]),
    );

    List<List<bool>> tempPiece = currentPiece;
    currentPiece = nextPiece;

    if (canPlacePiece(pieceX, pieceY)) {
      currentRotationIndex = nextRotationIndex;
      setState(() {});
    } else {
      bool rotated = false;
      for (int offset = 1; offset <= 2; offset++) {
        if (canPlacePiece(pieceX + offset, pieceY)) {
          pieceX += offset;
          currentRotationIndex = nextRotationIndex;
          rotated = true;
          break;
        }
        if (canPlacePiece(pieceX - offset, pieceY)) {
          pieceX -= offset;
          currentRotationIndex = nextRotationIndex;
          rotated = true;
          break;
        }
      }

      if (!rotated) {
        currentPiece = tempPiece;
      } else {
        setState(() {});
      }
    }
  }

  bool handleKeyPress(KeyEvent event) {
    if (!gameActive) {
      return false;
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

  void dropPiece() {
    int startY = pieceY;
    while (canPlacePiece(pieceX, pieceY + 1)) {
      pieceY++;
    }
    int floorsDropped = pieceY - startY;
    currentScore += floorsDropped;
    placePiece();
    setState(() {});
  }

  void endGame(bool won) {
    gameTimer?.cancel();
    effectTimer?.cancel();
    setState(() {
      gameActive = false;
    });

    final gamificationService = getIt<GamificationService>();
    gamificationService.saveGameScore('Asgard Wall', currentScore);

    if (won) {
      _showWinDialog();
    } else {
      _showLossDialog();
    }
  }

  void _showWinDialog() {
    if (_rewardCard != null) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return VictoryPopup(
            rewardCard: _rewardCard,
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
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'asgard_wall_game_screen_defeat_message'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
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
    gameTimer?.cancel();
    effectTimer?.cancel();
    focusNode.dispose();
    super.dispose();
  }

  Widget buildBoard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage('assets/images/backgrounds/asgard.jpg'),
          fit: BoxFit.cover,
        ),
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
                  colorFilter: ColorFilter.mode(
                    piece.isNewlyPlaced
                        ? Colors.white.withAlpha(179)
                        : Colors.transparent,
                    BlendMode.srcATop,
                  ),
                  child: Image.asset(
                    'assets/images/blocks/${pieceImageNames[piece.pieceIndex]}.webp',
                    fit: BoxFit.fill,
                  ),
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
                    child: Image.asset(
                      'assets/images/blocks/${pieceImageNames[currentPieceIndex]}.webp',
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : const SizedBox.shrink();

          final boardGrid = GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: boardWidth,
            ),
            itemCount: boardWidth * boardHeight,
            itemBuilder: (context, index) {
              int row = index ~/ boardWidth;
              int col = index % boardWidth;
              return _buildCell(row, col);
            },
          );

          return Stack(
            children: [
              boardGrid,
              ...placedPiecesWidgets,
              fallingPieceWidget,
              CustomPaint(
                size: Size(boardPixelWidth, boardPixelHeight),
                painter: _ContourPainter(
                  contour: _contour,
                  cellWidth: cellWidth,
                  cellHeight: cellHeight,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCell(int row, int col) {
    bool isVictoryLine = row == boardHeight - victoryHeight;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isVictoryLine ? const Color(0xFFFFD700) : Colors.grey[700]!,
          width: isVictoryLine ? 2 : 0.5,
        ),
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
            image: DecorationImage(
              image: AssetImage('assets/images/backgrounds/landscape.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: false,
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
              return handleKeyPress(event)
                  ? KeyEventResult.handled
                  : KeyEventResult.ignored;
            },
            child: SimpleGestureDetector(
              onTap: () => focusNode.requestFocus(),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: boardWidth / boardHeight,
                              child: buildBoard(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: NextPiecesPreview(
                            nextPieces: nextPieces,
                            piecesData: pieces,
                            pieceImageNames: pieceImageNames,
                            currentScore: currentScore,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChibiIconButton(
                        onPressed: gameActive ? movePieceLeft : () {},
                        color: Colors.blueGrey,
                        icon: const Icon(Icons.arrow_left, color: Colors.white),
                      ),
                      ChibiIconButton(
                        onPressed: gameActive ? rotatePiece : () {},
                        color: Colors.blueGrey,
                        icon: const Icon(
                          Icons.rotate_right,
                          color: Colors.white,
                        ),
                      ),
                      ChibiIconButton(
                        onPressed: gameActive ? dropPiece : () {},
                        color: Colors.blueGrey,
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                        ),
                      ),
                      ChibiIconButton(
                        onPressed: gameActive ? movePieceRight : () {},
                        color: Colors.blueGrey,
                        icon: const Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ChibiTextButton(
                    onPressed: startGame,
                    text: 'asgard_wall_game_screen_restart'.tr(),
                    color: const Color(0xFFFFD700),
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

class _ContourPainter extends CustomPainter {
  final Set<Segment> contour;
  final double cellWidth;
  final double cellHeight;

  _ContourPainter({
    required this.contour,
    required this.cellWidth,
    required this.cellHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final segment in contour) {
      final p1 = Offset(segment.p1.x * cellWidth, segment.p1.y * cellHeight);
      final p2 = Offset(segment.p2.x * cellWidth, segment.p2.y * cellHeight);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ContourPainter oldDelegate) {
    return oldDelegate.contour != contour;
  }
}
