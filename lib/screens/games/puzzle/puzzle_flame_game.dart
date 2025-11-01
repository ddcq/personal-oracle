import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:oracle_d_asgard/screens/games/puzzle/puzzle_game.dart';
import 'package:oracle_d_asgard/screens/games/puzzle/puzzle_model.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:oracle_d_asgard/utils/image_picker_utils.dart';

class DashedRectangleComponent extends RectangleComponent {
  static const double _dashLength = 5.0;
  static const double _spaceLength = 5.0;

  DashedRectangleComponent({required Rect rect}) : super(position: Vector2(rect.left, rect.top), size: Vector2(rect.width, rect.height)) {
    paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
  }

  @override
  void render(Canvas canvas) {
    final Path path = Path();
    _drawDashedLine(path, Offset.zero, Offset(size.x, 0), _dashLength, _spaceLength);
    _drawDashedLine(path, Offset(size.x, 0), Offset(size.x, size.y), _dashLength, _spaceLength);
    _drawDashedLine(path, Offset(size.x, size.y), Offset(0, size.y), _dashLength, _spaceLength);
    _drawDashedLine(path, Offset(0, size.y), Offset.zero, _dashLength, _spaceLength);
    canvas.drawPath(path, paint);
  }

  void _drawDashedLine(Path path, Offset p1, Offset p2, double dash, double space) {
    double distance = (p2 - p1).distance;
    double current = 0.0;
    while (current < distance) {
      path.moveTo(p1.dx + (p2.dx - p1.dx) * (current / distance), p1.dy + (p2.dy - p1.dy) * (current / distance));
      current += dash;
      if (current > distance) current = distance;
      path.lineTo(p1.dx + (p2.dx - p1.dx) * (current / distance), p1.dy + (p2.dy - p1.dy) * (current / distance));
      current += space;
    }
  }
}

class PuzzleFlameGame extends FlameGame {
  final PuzzleGame puzzleGame;
  late ui.Image puzzleImage;
  final GamificationService _gamificationService = GamificationService();
  final Function(CollectibleCard? rewardCard) onRewardEarned;
  CollectibleCard? associatedCard;
  MythStory? associatedStory;
  int currentLevel;

  PuzzleFlameGame({required this.puzzleGame, required this.onRewardEarned, required this.currentLevel}) {
    puzzleGame.onGameCompleted = onGameCompletedFromPuzzleGame;
  }

  @override
  Color backgroundColor() => Colors.transparent;

  Future<bool> _assetExists(String path) async {
    try {
      await rootBundle.load('assets/images/$path');
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadImageForPuzzle();

    // Dessiner le plateau de jeu en pointillés
    final double pieceSize = puzzleGame.pieceSize;
    final double boardWidth = pieceSize * puzzleGame.cols;
    final double boardHeight = pieceSize * puzzleGame.rows;

    final double offsetX = (size.x - boardWidth) / 2;
    final double offsetY = (size.y - boardHeight) / 2;

    for (int i = 0; i < puzzleGame.rows; i++) {
      for (int j = 0; j < puzzleGame.cols; j++) {
        final Rect rect = Rect.fromLTWH(offsetX + j * pieceSize, offsetY + i * pieceSize, pieceSize, pieceSize);
        add(DashedRectangleComponent(rect: rect));
      }
    }

    // Ajouter les pièces de puzzle
    for (var pieceData in puzzleGame.pieces) {
      add(
        PuzzlePieceComponent(
          pieceData: pieceData,
          gameRef: this,
          offsetX: offsetX,
          offsetY: offsetY,
          puzzleImage: puzzleImage,
          puzzleSize: puzzleGame.cols,
          pieceSize: pieceSize,
        ),
      );
    }
  }

  Future<void> _loadImageForPuzzle() async {
    final unearnedContent = await _gamificationService.getUnearnedContent();
    final List<CollectibleCard> unearnedCollectibleCards = unearnedContent['unearned_collectible_cards'].cast<CollectibleCard>();
    final List<MythStory> unearnedMythStories = unearnedContent['unearned_myth_stories'].cast<MythStory>();

    // Calculate story selection probability based on level
    // 7% per level, capped at 70% for level 10+
    final int storyPercentage = (currentLevel * 7).clamp(0, 70);
    final random = Random();
    final bool selectStory = random.nextInt(100) < storyPercentage;

    String imageToLoad;
    
    if (selectStory && unearnedMythStories.isNotEmpty) {
      // Select a random unearned story
      final selected = unearnedMythStories[random.nextInt(unearnedMythStories.length)];
      // Use the first card image from the story
      if (selected.correctOrder.isNotEmpty) {
        imageToLoad = selected.correctOrder[0].imagePath;
        associatedStory = selected;
        associatedCard = null;
      } else {
        // Fallback to card if story has no cards
        imageToLoad = await _selectCardImage(unearnedCollectibleCards);
      }
    } else {
      // Select a collectible card
      imageToLoad = await _selectCardImage(unearnedCollectibleCards);
    }
    
    puzzleImage = await Flame.images.load(imageToLoad);
  }

  Future<String> _selectCardImage(List<CollectibleCard> unearnedCollectibleCards) async {
    final List<CollectibleCard> availableCards = [];
    for (var card in unearnedCollectibleCards) {
      if (await _assetExists(card.imagePath)) {
        availableCards.add(card);
      }
    }

    if (availableCards.isNotEmpty) {
      final random = Random();
      final selected = availableCards[random.nextInt(availableCards.length)];
      associatedCard = selected;
      associatedStory = null;
      return selected.imagePath;
    } else {
      // Fallback image if no unearned cards
      associatedCard = null;
      associatedStory = null;
      return getRandomCardImagePath();
    }
  }

  void onGameCompletedFromPuzzleGame() async {
    if (associatedCard != null) {
      await _gamificationService.unlockCollectibleCard(associatedCard!);
    } else if (associatedStory != null) {
      // Unlock the first chapter of the story
      await _gamificationService.unlockStoryPart(associatedStory!.id, associatedStory!.correctOrder[0].id);
    }
    onRewardEarned(associatedCard);
  }

  void reset() async {
    // Remove all existing puzzle pieces and dashed rectangles
    removeAll(children.whereType<PuzzlePieceComponent>());
    removeAll(children.whereType<DashedRectangleComponent>());

    // Reload a new image for the puzzle
    await _loadImageForPuzzle();

    // Re-add dashed rectangles
    final double pieceSize = puzzleGame.pieceSize;
    final double boardWidth = pieceSize * puzzleGame.cols;
    final double boardHeight = pieceSize * puzzleGame.rows;

    final double offsetX = (size.x - boardWidth) / 2;
    final double offsetY = (size.y - boardHeight) / 2;

    for (int i = 0; i < puzzleGame.rows; i++) {
      for (int j = 0; j < puzzleGame.cols; j++) {
        final Rect rect = Rect.fromLTWH(offsetX + j * pieceSize, offsetY + i * pieceSize, pieceSize, pieceSize);
        add(DashedRectangleComponent(rect: rect));
      }
    }

    // Re-add puzzle pieces
    for (var pieceData in puzzleGame.pieces) {
      add(
        PuzzlePieceComponent(
          pieceData: pieceData,
          gameRef: this,
          offsetX: offsetX,
          offsetY: offsetY,
          puzzleImage: puzzleImage,
          puzzleSize: puzzleGame.cols,
          pieceSize: pieceSize,
        ),
      );
    }
  }
}

class PuzzlePieceComponent extends PositionComponent with DragCallbacks {
  static const double _cornerRadius = 8.0;
  static const double _borderStrokeWidth = 1.5;
  static const double _shadowBlurRadiusDefault = 5.0;
  static const double _shadowBlurRadiusDragging = 10.0;
  static const int _shadowAlphaDefault = 102;
  static const int _shadowAlphaDragging = 178;
  static const int _bevelAlphaLight = 89;
  static const int _bevelAlphaMedium = 25;
  static const int _bevelAlphaDark = 115;
  static const int _borderAlpha = 51;

  final PuzzlePieceData pieceData;
  final PuzzleFlameGame gameRef;
  final double offsetX;
  final double offsetY;
  final ui.Image puzzleImage;
  final int puzzleSize;
  final double pieceSize;

  late final Rect _sourceRect;
  final Paint _paint = Paint()..filterQuality = FilterQuality.high;
  final Paint _shadowPaint = Paint(); // Pre-allocate shadow paint
  final Offset _defaultShadowOffset = const Offset(2.0, 2.0); // Pre-allocate default shadow offset
  final Offset _draggingShadowOffset = const Offset(5.0, 5.0); // Pre-allocate dragging shadow offset
  bool _isDragging = false; // Indicateur de glissement

  // Priorités de rendu
  static const int _lockedPriority = 0;
  static const int _defaultPriority = 1;
  static const int _draggingPriority = 100;

  PuzzlePieceComponent({
    required this.pieceData,
    required this.gameRef,
    required this.offsetX,
    required this.offsetY,
    required this.puzzleImage,
    required this.puzzleSize,
    required this.pieceSize,
  }) : super(
         position: Vector2(pieceData.currentPosition.dx + offsetX, pieceData.currentPosition.dy + offsetY),
         size: Vector2(pieceData.size.width, pieceData.size.height),
         priority: pieceData.isLocked ? _lockedPriority : _defaultPriority, // Initialiser la priorité
       ) {
    _calculateSourceRect();
  }

  void _calculateSourceRect() {
    final double imageSliceWidth = puzzleImage.width / puzzleSize;
    final double imageSliceHeight = puzzleImage.height / puzzleSize;

    final int col = pieceData.id % puzzleSize;
    final int row = pieceData.id ~/ puzzleSize;

    _sourceRect = Rect.fromLTWH(col * imageSliceWidth, row * imageSliceHeight, imageSliceWidth, imageSliceHeight);
    size = Vector2(pieceSize, pieceSize);
  }

  @override
  void render(Canvas canvas) {
    final Rect destRect = size.toRect();
    final RRect pieceRRect = RRect.fromRectAndRadius(destRect, const Radius.circular(_cornerRadius));

    // 1. Dessiner l’ombre portée pour l’effet de flottement
    if (!pieceData.isLocked) {
      _shadowPaint
        ..color = Colors.black
            .withAlpha((_isDragging ? _shadowAlphaDragging : _shadowAlphaDefault)) // Ombre plus prononcée
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _isDragging ? _shadowBlurRadiusDragging : _shadowBlurRadiusDefault); // Flou plus important

      final Offset currentShadowOffset = _isDragging ? _draggingShadowOffset : _defaultShadowOffset;
      canvas.drawRRect(pieceRRect.shift(currentShadowOffset), _shadowPaint);
    }

    // Sauvegarder l’état du canvas avant de clipper
    canvas.save();
    // Appliquer le clipping pour les coins arrondis
    canvas.clipRRect(pieceRRect);

    // 2. Dessiner l’image
    canvas.drawImageRect(puzzleImage, _sourceRect, destRect, _paint);

    // 3. Ajouter un biseau pour l’effet 3D
    // Biseau interne (superposition sur l’image)
    final Paint bevelPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.4, 0.6, 1.0],
        colors: [
          Colors.white.withAlpha(_bevelAlphaLight), // Lumière en haut à gauche
          Colors.white.withAlpha(_bevelAlphaMedium),
          Colors.black.withAlpha(_bevelAlphaMedium),
          Colors.black.withAlpha(_bevelAlphaDark), // Ombre en bas à droite
        ],
      ).createShader(destRect);

    // Dessiner un rectangle par-dessus l’image avec le shader de gradient
    canvas.drawRect(destRect, bevelPaint);

    // 4. Ajouter une bordure pour mieux définir la pièce
    final Paint borderPaint = Paint()
      ..color = Colors.black.withAlpha(_borderAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _borderStrokeWidth;
    canvas.drawRRect(pieceRRect, borderPaint);

    // Restaurer l’état du canvas
    canvas.restore();
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (!pieceData.isLocked) {
      priority = _draggingPriority; // Mettre la pièce au-dessus de toutes les autres
      _isDragging = true; // La pièce est en cours de glissement
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Mettre à jour la position du composant Flame en fonction des données du modèle
    position.x = pieceData.currentPosition.dx + offsetX;
    position.y = pieceData.currentPosition.dy + offsetY;

    // Ajuster la priorité si l’état de verrouillage a changé
    if (pieceData.isLocked && priority != _lockedPriority) {
      priority = _lockedPriority;
    } else if (!pieceData.isLocked && priority == _lockedPriority) {
      // Si elle était verrouillée mais ne l’est plus (cas peu probable mais pour robustesse)
      priority = _defaultPriority;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!pieceData.isLocked) {
      position.add(event.localDelta);
      pieceData.currentPosition = Offset(position.x - offsetX, position.y - offsetY);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!pieceData.isLocked) {
      gameRef.puzzleGame.handlePieceDrop(pieceData.id, Offset(position.x - offsetX, position.y - offsetY));
    }
    // Si la pièce n’est pas verrouillée après le drop, elle reste à la priorité par défaut
    // Si elle est verrouillée, update() la mettra à _lockedPriority
    if (!pieceData.isLocked) {
      priority = _defaultPriority;
    }
    _isDragging = false; // Le glissement est terminé
  }
}
