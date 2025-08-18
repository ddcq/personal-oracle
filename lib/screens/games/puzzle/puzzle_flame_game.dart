import 'dart:ui' as ui;
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import './puzzle_game.dart';
import './puzzle_model.dart';

import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'dart:math';

class DashedRectangleComponent extends RectangleComponent {
  DashedRectangleComponent({required Rect rect}) : super(position: Vector2(rect.left, rect.top), size: Vector2(rect.width, rect.height)) {
    paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
  }

  @override
  void render(Canvas canvas) {
    final Path path = Path();
    _drawDashedLine(path, Offset.zero, Offset(size.x, 0), 5.0, 5.0);
    _drawDashedLine(path, Offset(size.x, 0), Offset(size.x, size.y), 5.0, 5.0);
    _drawDashedLine(path, Offset(size.x, size.y), Offset(0, size.y), 5.0, 5.0);
    _drawDashedLine(path, Offset(0, size.y), Offset.zero, 5.0, 5.0);
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

class PuzzleFlameGame extends FlameGame with HasCollisionDetection {
  final PuzzleGame puzzleGame;
  late final ui.Image puzzleImage;
  final GamificationService _gamificationService = GamificationService();
  final Function(CollectibleCard rewardCard) onRewardEarned; // New callback
  CollectibleCard? associatedCard;

  PuzzleFlameGame({required this.puzzleGame, required this.onRewardEarned}) {
    puzzleGame.onGameCompleted = onGameCompletedFromPuzzleGame;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final unearnedContent = await _gamificationService.getUnearnedContent();
    final List<CollectibleCard> unearnedCollectibleCards = unearnedContent['unearned_collectible_cards'].cast<CollectibleCard>();
    final List<MythCard> nextMythCardsToEarn = (unearnedContent['next_myth_cards_to_earn'] as List<Map<String, dynamic>>).map((e) => e['next_myth_card'] as MythCard).toList();

    String imageToLoad;
    if (unearnedCollectibleCards.isNotEmpty) {
      final random = Random();
      final selected = unearnedCollectibleCards[random.nextInt(unearnedCollectibleCards.length)];
      imageToLoad = selected.imagePath;
      associatedCard = selected;
    } else if (nextMythCardsToEarn.isNotEmpty) {
      final random = Random();
      final selectedMythCard = nextMythCardsToEarn[random.nextInt(nextMythCardsToEarn.length)];
      imageToLoad = selectedMythCard.imagePath;
      associatedCard = selectedMythCard;
    } else {
      // Fallback image if no unearned cards
      imageToLoad = 'home_illu.png';
      associatedCard = null; // No specific card to unlock
    }
    puzzleImage = await Flame.images.load(imageToLoad);

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
      add(PuzzlePieceComponent(pieceData: pieceData, gameRef: this, offsetX: offsetX, offsetY: offsetY, puzzleImage: puzzleImage, puzzleSize: puzzleGame.cols, pieceSize: pieceSize));
    }
  }

  void onGameCompletedFromPuzzleGame() async {
    if (associatedCard != null) {
      await _gamificationService.unlockCollectibleCard(associatedCard!.id);
      onRewardEarned(associatedCard!); 
    }
  }
}

class PuzzlePieceComponent extends PositionComponent with DragCallbacks {
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
    const double cornerRadius = 8.0;
    final RRect pieceRRect = RRect.fromRectAndRadius(destRect, const Radius.circular(cornerRadius));

    // 1. Dessiner l’ombre portée pour l’effet de flottement
    if (!pieceData.isLocked) {
      _shadowPaint
        ..color = Colors.black
            .withAlpha((_isDragging ? 178 : 102)) // Ombre plus prononcée
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _isDragging ? 10.0 : 5.0); // Flou plus important

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
          Colors.white.withAlpha(89), // Lumière en haut à gauche
          Colors.white.withAlpha(25),
          Colors.black.withAlpha(25),
          Colors.black.withAlpha(115), // Ombre en bas à droite
        ],
      ).createShader(destRect);

    // Dessiner un rectangle par-dessus l’image avec le shader de gradient
    canvas.drawRect(destRect, bevelPaint);

    // 4. Ajouter une bordure pour mieux définir la pièce
    final Paint borderPaint = Paint()
      ..color = Colors.black.withAlpha(51)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
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
