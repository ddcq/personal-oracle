import 'package:flutter/material.dart';

class BalanceOfJusticeGame extends StatefulWidget {
  const BalanceOfJusticeGame({super.key});

  @override
  State<BalanceOfJusticeGame> createState() => _BalanceOfJusticeGameState();
}

class _BalanceOfJusticeGameState extends State<BalanceOfJusticeGame> {
  final List<int> weights = [1, 2, 3, 4];
  List<int> leftSide = [];
  List<int> rightSide = [];

  void _dropWeight(int value, bool left) {
    setState(() {
      if (left)
        leftSide.add(value);
      else
        rightSide.add(value);
    });
  }

  void _checkBalance() {
    final totalLeft = leftSide.fold(0, (a, b) => a + b);
    final totalRight = rightSide.fold(0, (a, b) => a + b);
    final result = totalLeft == totalRight
        ? "⚖️ Équilibre parfait ! Justice rendue."
        : "⚠️ Déséquilibre. Essaie encore.";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Résultat"),
        content: Text("$result\nGauche: $totalLeft | Droite: $totalRight"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  leftSide.clear();
                  rightSide.clear();
                });
              },
              child: Text("Rejouer"))
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("⚖️ Règles"),
        content: Text("Glisse les poids sur la gauche ou la droite pour équilibrer la balance."),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
      ),
    );
  }

  Widget _buildWeight(int value) {
    return Draggable<int>(
      data: value,
      feedback: _weightBox(value, Colors.grey.withOpacity(0.7)),
      childWhenDragging: _weightBox(value, Colors.grey.shade200),
      child: _weightBox(value, Colors.grey),
    );
  }

  Widget _weightBox(int value, Color color) {
    return Container(
      margin: EdgeInsets.all(6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text("$value kg", style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildDropZone(String sideName, bool isLeft) {
    final side = isLeft ? leftSide : rightSide;
    return DragTarget<int>(
      onAccept: (data) => _dropWeight(data, isLeft),
      builder: (_, __, ___) => Container(
        width: 150,
        height: 200,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(sideName, style: TextStyle(fontWeight: FontWeight.bold)),
            ...side.map((w) => Text("$w kg")).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("⚖️ Balance of Justice"),
        actions: [IconButton(icon: Icon(Icons.help_outline), onPressed: _showHelp)],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("🎯 But : Glisse les bons poids de chaque côté pour équilibrer."),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDropZone("Gauche", true),
              _buildDropZone("Droite", false),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: weights.map((w) => _buildWeight(w)).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _checkBalance, child: Text("Vérifier")),
        ],
      ),
    );
  }
}
