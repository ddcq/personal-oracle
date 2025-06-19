import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class OrderTheScrollsGame extends StatefulWidget {
  const OrderTheScrollsGame({super.key});

  @override
  State<OrderTheScrollsGame> createState() => _OrderTheScrollsGameState();
}

class _OrderTheScrollsGameState extends State<OrderTheScrollsGame> {
  final List<String> correctOrder = [
    "Découverte du feu",
    "Cuisson de la nourriture",
    "Apparition des villages",
    "Création des outils"
  ];

  List<String> currentOrder = [];

  @override
  void initState() {
    super.initState();
    currentOrder = List.from(correctOrder)..shuffle();
  }

  void _validate() {
    bool isCorrect = ListEquality().equals(currentOrder, correctOrder);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? 'Bravo !' : 'Raté'),
        content: Text(isCorrect ? 'Ordre correct.' : 'Essaie encore.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => currentOrder.shuffle());
            },
            child: Text('Rejouer'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("🧠 Règles"),
        content: Text("Glisse les cartes pour les remettre dans le bon ordre logique ou chronologique. Puis appuie sur 'Valider'."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🧠 Order the Scrolls"),
        actions: [
          IconButton(icon: Icon(Icons.help_outline), onPressed: _showHelp),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("🎯 But : Remets les événements dans le bon ordre."),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = currentOrder.removeAt(oldIndex);
                  currentOrder.insert(newIndex, item);
                });
              },
              children: currentOrder
                  .map((text) => ListTile(
                        key: ValueKey(text),
                        title: Text(text),
                      ))
                  .toList(),
            ),
          ),
          ElevatedButton(onPressed: _validate, child: Text("Valider")),
        ],
      ),
    );
  }
}
