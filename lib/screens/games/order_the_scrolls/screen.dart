import 'package:flutter/material.dart';
import 'data.dart';
import 'dart:math';
import 'model.dart';

class OrderTheScrollsGame extends StatefulWidget {
  const OrderTheScrollsGame({super.key});

  @override
  State<OrderTheScrollsGame> createState() => _OrderTheScrollsGameState();
}

class _OrderTheScrollsGameState extends State<OrderTheScrollsGame> {
  late MythStory _selectedStory;
  late List<MythCard> _shuffledCards;
  bool _validated = false;
  int? _draggedIndex;

  @override
  void initState() {
    super.initState();
    _loadNewStory();
  }

  void _loadNewStory() {
    final stories = getMythStories();
    _selectedStory = stories[Random().nextInt(stories.length)];
    _shuffledCards = List<MythCard>.from(_selectedStory.correctOrder);
    _shuffledCards.shuffle();
    _validated = false;
  }

  void _onCardReorder(int fromIndex, int toIndex) {
    if (fromIndex != toIndex) {
      setState(() {
        final item = _shuffledCards.removeAt(fromIndex);
        _shuffledCards.insert(toIndex, item);
        _draggedIndex = null;
      });
    }
  }

  void _validateOrder() {
    setState(() {
      _validated = true;
    });
  }

  void _resetGame() {
    setState(() {
      _loadNewStory();
    });
  }

  BoxBorder? _getTileBorder(int index) {
    if (!_validated) return null;
    final correct =
        _shuffledCards[index].id == _selectedStory.correctOrder[index].id;
    return Border.all(color: correct ? Colors.green : Colors.red, width: 4);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 4 : (screenWidth > 600 ? 3 : 2);
    final cardSize = (screenWidth - 48) / crossAxisCount - 8;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 50,
            backgroundColor: const Color(0xFF2E3B4E),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _selectedStory.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () => _showHelpDialog(context),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _shuffledCards.length,
                  itemBuilder: (context, index) {
                    return _buildDraggableCard(
                      _shuffledCards[index],
                      index,
                      cardSize,
                    );
                  },
                ),
                const SizedBox(height: 20),
                if (!_validated)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _validateOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3B4E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Valider l\'ordre',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              _shuffledCards.asMap().entries.every(
                                (e) =>
                                    e.value.id ==
                                    _selectedStory.correctOrder[e.key].id,
                              )
                              ? Colors.green[50]
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                _shuffledCards.asMap().entries.every(
                                  (e) =>
                                      e.value.id ==
                                      _selectedStory.correctOrder[e.key].id,
                                )
                                ? Colors.green
                                : Colors.red,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          _shuffledCards.asMap().entries.every(
                                (e) =>
                                    e.value.id ==
                                    _selectedStory.correctOrder[e.key].id,
                              )
                              ? '✅ Bravo ! Ordre correct !'
                              : '❌ Désolé, l\'ordre est incorrect.',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _resetGame,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF2E3B4E),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Rejouer avec un autre mythe',
                            style: TextStyle(
                              color: Color(0xFF2E3B4E),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableCard(MythCard card, int index, double size) {
    final isCorrect =
        _validated &&
        _shuffledCards[index].id == _selectedStory.correctOrder[index].id;
    final isIncorrect =
        _validated &&
        _shuffledCards[index].id != _selectedStory.correctOrder[index].id;

    return DragTarget<int>(
      onAccept: (fromIndex) {
        _onCardReorder(fromIndex, index);
      },
      onWillAccept: (fromIndex) => fromIndex != index,
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return Draggable<int>(
          data: index,
          onDragStarted: () {
            setState(() {
              _draggedIndex = index;
            });
          },
          onDragEnd: (_) {
            setState(() {
              _draggedIndex = null;
            });
          },
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: size * 0.9,
              height: size * 0.9,
              child: _buildCardContent(
                card,
                index,
                size * 0.9,
                isDragging: true,
              ),
            ),
          ),
          childWhenDragging: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 2,
                style: BorderStyle.solid,
              ),
              color: Colors.grey[100],
            ),
            child: const Icon(Icons.add, color: Colors.grey, size: 32),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()
              ..scale(isHovering ? 1.05 : 1.0)
              ..translate(0.0, isHovering ? -4.0 : 0.0),
            child: _buildCardContent(card, index, size),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(
    MythCard card,
    int index,
    double size, {
    bool isDragging = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isDragging ? 16 : 20),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
        border: _getTileBorder(index),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(card.imagePath, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.title,
                    style: isDragging
                        ? const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black,
                              ),
                            ],
                          )
                        : const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black,
                              ),
                            ],
                          ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.description,
                    style: isDragging
                        ? const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black,
                              ),
                            ],
                          )
                        : const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            if (!_validated)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.open_with,
                  color: Colors.white,
                  size: 20,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            if (_validated)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color:
                        _shuffledCards[index].id ==
                            _selectedStory.correctOrder[index].id
                        ? Colors.green
                        : Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF2E3B4E)),
            SizedBox(width: 8),
            Text('Règles du jeu'),
          ],
        ),
        content: const Text(
          'Remettez les cartes dans l\'ordre chronologique du mythe nordique.\n\n'
          '• Glissez une carte sur une autre pour les échanger\n'
          '• L\'icône ⭲ indique qu\'une carte est déplaçable\n'
          '• Organisez-les de la première à la dernière étape\n'
          '• Cliquez sur "Valider l\'ordre" pour vérifier\n'
          '• Les cartes correctes apparaîtront avec un contour vert ✅',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text(
              'J\'ai compris !',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
