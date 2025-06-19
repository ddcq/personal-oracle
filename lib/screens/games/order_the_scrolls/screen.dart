import 'package:flutter/material.dart';
import 'data.dart';
import 'dart:math';
import 'model.dart';

void main() => runApp(const MaterialApp(home: OrderTheScrollsGame()));

class OrderTheScrollsGame extends StatefulWidget {
  const OrderTheScrollsGame({super.key});

  @override
  State<OrderTheScrollsGame> createState() => _OrderTheScrollsGameState();
}

class _OrderTheScrollsGameState extends State<OrderTheScrollsGame> {
  late MythStory _selectedStory;
  late List<MythCard> _shuffledCards;
  bool _validated = false;

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

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _shuffledCards.removeAt(oldIndex);
      _shuffledCards.insert(newIndex, item);
    });
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

  Color? _getTileColor(int index) {
    if (!_validated) return null;
    final correct = _shuffledCards[index].id == _selectedStory.correctOrder[index].id;
    return correct ? Colors.green[100] : Colors.red[100];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📜 Order the Scrolls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _selectedStory.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ReorderableListView(
                onReorder: _onReorder,
                children: [
                  for (int i = 0; i < _shuffledCards.length; i++)
                    Card(
                      key: ValueKey(_shuffledCards[i].id),
                      color: _getTileColor(i),
                      child: ListTile(
                        leading: const Icon(Icons.menu),
                        title: Text(_shuffledCards[i].title),
                        subtitle: Text(_shuffledCards[i].description),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!_validated)
              ElevatedButton(
                onPressed: _validateOrder,
                child: const Text('Valider l\'ordre'),
              )
            else
              Column(
                children: [
                  Text(
                    _shuffledCards.asMap().entries.every((e) =>
                            e.value.id == _selectedStory.correctOrder[e.key].id)
                        ? '✅ Bravo ! Ordre correct !'
                        : '❌ Désolé, l\'ordre est incorrect.',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _resetGame,
                    child: const Text('Rejouer avec un autre mythe'),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🛈 Règles'),
        content: const Text(
            'Remettez les cartes dans l\'ordre chronologique du mythe nordique. Glissez chaque carte à sa position correcte. Puis validez !'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
