import 'package:easy_localization/easy_localization.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For Completer

import 'package:oracle_d_asgard/screens/games/snake/snake_flame_game.dart';
import 'package:oracle_d_asgard/screens/games/snake/snake_game_over_popup.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/widgets/joystick_controller.dart';
import 'package:oracle_d_asgard/widgets/directional_pad.dart' show Direction;
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/screens/games/snake/game_logic.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/game_help_dialog.dart';


import 'package:oracle_d_asgard/components/victory_popup.dart'; // Import the victory popup

import 'package:oracle_d_asgard/models/collectible_card.dart'; // Import CollectibleCard
import 'package:confetti/confetti.dart'; // Import ConfettiController
import 'package:oracle_d_asgard/locator.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
class SnakeGame extends StatefulWidget {
  // Temporary comment
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  SnakeFlameGame? _game; // Make it nullable
  late final ConfettiController _confettiController;
  int _currentLevel = 1; // Initialize with default value
  Future<int>? _initializeGameFuture;
  bool _isGameInitialized = false;
  bool _isLevelInitialized = false; // Track if level was loaded from DB

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _initializeGameFuture = _initializeGame();
  }

  Future<int> _initializeGame() async {
    final gamificationService = getIt<GamificationService>();
    _currentLevel = await gamificationService.getSnakeDifficulty();
    return _currentLevel;
  }

  @override
  void dispose() {
    final game = _game;
    if (game != null) {
      game.pauseEngine();
      game.removeAll(game.children);
      game.onRemove();
    }
    _confettiController.dispose(); // Dispose the confetti controller
    super.dispose();
  }

  // ==========================================
  // CLEAN GAME MANAGEMENT METHODS
  // ==========================================

  /// Creates a new game instance at the current level
  void _initializeNewGame() {
    _game?.pauseEngine();
    _game = SnakeFlameGame(
      gamificationService: getIt<GamificationService>(),
      onGameEnd: _onGameEnd,
      onResetGame: _onResetGame,
      onRottenFoodEaten: () => _game?.shakeScreen(),
      level: _currentLevel,
      onScoreChanged: () => setState(() {}),
      onConfettiTrigger: () {
        if (_safeGameStateValue != null && _safeGameStateValue!.score >= SnakeFlameGame.victoryScoreThreshold) {
          _confettiController.play();
        } else {
          _confettiController.stop();
        }
      },
      onBonusCollected: () => setState(() {}),
      onGameLoaded: () {
        setState(() {
          _isGameInitialized = true;
        });
        _game?.startGame(); // Start the game automatically
      },
    );
  }

  /// Resets the current game at the same level
  void _resetCurrentGame() {
    _game?.resetGame();
    _confettiController.stop();
    setState(() {});
  }

  /// Increases level and creates new game instance
  Future<void> _levelUp() async {
    await getIt<GamificationService>().saveSnakeDifficulty(_currentLevel + 1);
    setState(() {
      _currentLevel++;
    });
    _initializeNewGame();
  }

  /// Starts the current game
  void _startGame() {
    _game?.startGame();
  }

  /// Safe getter for gameState - returns null if not ready
  ValueNotifier<GameState>? get _safeGameState {
    return _isGameInitialized && _game != null ? _game!.gameState : null;
  }

  /// Safe getter for gameState value - returns null if not ready
  GameState? get _safeGameStateValue {
    return _safeGameState?.value;
  }

  // ==========================================
  // GAME EVENT HANDLERS
  // ==========================================

  void _onGameEnd(int score, {required bool isVictory, CollectibleCard? wonCard}) async {
    if (isVictory) {
      final rewardCard = wonCard ?? await getIt<GamificationService>().selectRandomUnearnedCollectibleCard();
      _showVictoryDialog(rewardCard);
    } else {
      _showGameOverDialog(score);
    }
  }

  void _onResetGame() {
    _resetCurrentGame();
    setState(() {});
  }

  // ==========================================
  // DIALOG METHODS
  // ==========================================

  void _showVictoryDialog(CollectibleCard? wonCard) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return VictoryPopup(
          rewardCard: wonCard,
          onDismiss: () async {
            Navigator.of(context).pop();
            await _levelUp();
            // Wait for setState to complete before starting game
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _startGame();
            });
          },
          onSeeRewards: () {
            Navigator.of(context).pop();
            context.push('/profile');
          },
        );
      },
    );
  }

  void _showGameOverDialog(int score) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SnakeGameOverPopup(
          score: score,
          onResetGame: () {
            _resetCurrentGame();
            _startGame();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.go('/games');
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Score with Confetti
              Stack(
                alignment: Alignment.center,
                children: [
                  _safeGameState != null
                      ? ValueListenableBuilder<GameState>(
                          valueListenable: _safeGameState!,
                          builder: (context, gameState, child) {
                            return Text(
                              'snake_screen_score'.tr(namedArgs: {'score': '${gameState.score}'}),
                              style: ChibiTextStyles.dialogText,
                            );
                          },
                        )
                      : Text('snake_screen_score_default'.tr(), style: ChibiTextStyles.dialogText),
                  if (_safeGameStateValue != null && _safeGameStateValue!.score >= SnakeFlameGame.victoryScoreThreshold)
                    ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive, // All directions
                      // shouldLoop: true, // Continuously emit confetti
                      colors: const [
                        Colors.green,
                        Colors.blue,
                        Colors.pink,
                        Colors.orange,
                        Colors.purple
                      ], // Customize colors
                      createParticlePath: (size) {
                        // Custom particle path for a more controlled spread
                        return Path()
                          ..addOval(Rect.fromCircle(center: Offset.zero, radius: 5));
                      },
                    ),
                ],
              ),

              // Center: Apple info
              if (_safeGameStateValue != null)
                ValueListenableBuilder<FoodType>(
                  valueListenable: _safeGameStateValue!.foodType,
                  builder: (context, foodType, child) {
                    String foodImage;
                    switch (foodType) {
                      case FoodType.golden:
                        foodImage = 'assets/images/snake/apple_golden.png';
                        break;
                      case FoodType.rotten:
                        foodImage = 'assets/images/snake/apple_rotten.png';
                        break;
                      default:
                        foodImage = 'assets/images/snake/apple_regular.png';
                    }
                    return ValueListenableBuilder<double>(
                      valueListenable: _game!.remainingFoodTime,
                      builder: (context, remainingTime, child) {
                        return Row(
                          children: [
                            Image.asset(foodImage, height: 30),
                            const SizedBox(width: 8),
                            Text('${remainingTime.ceil()}${'snake_screen_time_seconds_suffix'.tr()}', style: ChibiTextStyles.dialogText),
                          ],
                        );
                      },
                    );
                  },
                )
              else
                Text('snake_screen_loading'.tr(), style: ChibiTextStyles.dialogText),

              // Right: Pause button
              IconButton(
                icon: const Icon(Icons.pause, color: Colors.white),
                onPressed: () {
                  GameHelpDialog.show(
                    context,
                    [
                      'snake_screen_rule_1'.tr(),
                      'snake_screen_rule_2'.tr(),
                      'snake_screen_rule_3'.tr(),
                      'snake_screen_rule_4'.tr(),
                      'snake_screen_rule_5'.tr(),
                      'snake_screen_rule_6'.tr(),
                    ],
                    onGamePaused: () => _game?.pauseEngine(),
                    onGameResumed: () => _game?.resumeEngine(),
                    onGoToHome: () {
                      Navigator.of(context).pop();
                      context.go('/games');
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: FutureBuilder<int>(
            // Specify the type of data
            future: _initializeGameFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text('${'snake_screen_error_prefix'.tr()}: ${snapshot.error}'));
                }
                // Only set _currentLevel from snapshot on first initialization
                if (!_isLevelInitialized) {
                  _currentLevel = snapshot.data!;
                  _isLevelInitialized = true;
                }

                if (_game == null) {
                  _initializeNewGame();
                }

                final orientation = MediaQuery.of(context).orientation;

                if (orientation == Orientation.landscape) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              JoystickController(
                                onDirectionChanged: (direction) {
                                  _game?.requestDirectionChange(direction);
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildBonusList(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: _buildGameArea(context),
                      ),
                    ],
                  );
                } else {
                  // Portrait mode
                  return Column(
                    children: [
                      Expanded(
                        child: _buildGameArea(context),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              JoystickController(
                                onDirectionChanged: (direction) {
                                  _game?.requestDirectionChange(direction);
                                },
                              ),
                              const SizedBox(width: 16),
                              _buildBonusList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              } else {
                // Show a loading indicator while the game is initializing
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }


  Widget _buildBonusList() {
    if (_game == null || _safeGameState == null) return const SizedBox.shrink();

    try {
      return ValueListenableBuilder<GameState>(
        valueListenable: _safeGameState!,
        builder: (context, gameState, child) {
          if (gameState.activeBonusEffects.isEmpty) {
            return const SizedBox.shrink();
          }
          
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(128),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Bonus',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 8,
                  children: gameState.activeBonusEffects.asMap().entries.map((entry) {
                    final index = entry.key;
                    final effect = entry.value;
                    final sprite = _game!.bonusSprites[effect.type];
                    if (sprite == null) {
                      return const SizedBox.shrink();
                    }
                    
                    return _BonusProgressWidget(
                      key: ValueKey('${effect.type}_${effect.activationTime}_$index'),
                      sprite: sprite,
                      effect: effect,
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildGameArea(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final displayGameWidth = constraints.biggest.width;
        final displayGameHeight = constraints.biggest.height;

        final wallThickness = constraints.biggest.shortestSide / 22; // 1 cell for wall
        final gameAreaWidth = displayGameWidth - (wallThickness * 2);
        final gameAreaHeight = displayGameHeight - (wallThickness * 2);

        return Center(
          child: SizedBox(
            width: displayGameWidth,
            height: displayGameHeight,
            child: Stack(
              children: [
                // Background wall image for the entire display area
                Positioned.fill(child: Image.asset('assets/images/backgrounds/wall.webp', fit: BoxFit.fill)),
                // Centered black rectangle for the game area
                Center(
                  child: SimpleGestureDetector(
                    swipeConfig: const SimpleSwipeConfig(
                      verticalThreshold: 20.0,
                      horizontalThreshold: 20.0,
                      swipeDetectionBehavior: SwipeDetectionBehavior.singularOnEnd,
                    ),
                    onVerticalSwipe: (direction) {
                      if (direction == SwipeDirection.down) {
                        _game?.requestDirectionChange(Direction.down);
                      } else if (direction == SwipeDirection.up) {
                        _game?.requestDirectionChange(Direction.up);
                      }
                    },
                    onHorizontalSwipe: (direction) {
                      if (direction == SwipeDirection.right) {
                        _game?.requestDirectionChange(Direction.right);
                      } else if (direction == SwipeDirection.left) {
                        _game?.requestDirectionChange(Direction.left);
                      }
                    },
                    onDoubleTap: () {
                      _game?.pauseEngine();
                    },
                    child: Container(
                      width: gameAreaWidth,
                      height: gameAreaHeight,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/sea.webp'), repeat: ImageRepeat.repeat),
                      ),
                      child: GameWidget(
                        game: _game!, // Use _game!
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BonusProgressWidget extends StatefulWidget {
  final Sprite sprite;
  final ActiveBonusEffect effect;

  const _BonusProgressWidget({
    super.key,
    required this.sprite,
    required this.effect,
  });

  @override
  State<_BonusProgressWidget> createState() => _BonusProgressWidgetState();
}

class _BonusProgressWidgetState extends State<_BonusProgressWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.effect.activationTime;
    final remainingDuration = GameLogic.bonusEffectDuration - _startTime;
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (remainingDuration * 1000).toInt()),
      value: _startTime / GameLogic.bonusEffectDuration,
    );
    
    _controller.animateTo(1.0, curve: Curves.linear).then((_) {
      // Animation finished, the widget should be removed by the parent
      if (mounted) {
        setState(() {}); // Force rebuild to trigger removal
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = 1.0 - _controller.value;
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: RawImage(
                  image: widget.sprite.image,
                  fit: BoxFit.cover,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 30,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.5),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 30 * progress,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

