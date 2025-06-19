import 'package:flutter/material.dart';

class WhichDoorGame extends StatelessWidget {
  final int correctDoor = 1;
  final String riddle = "Une seule porte dit la vérité : la bonne est au centre.";

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("🐍 Règles"),
        content: Text("Lis l’indice et choisis la bonne porte en cliquant dessus. Attention : certains indices sont piégeux !"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  void _checkAnswer(BuildContext context, int door) {
    final correct = door == correctDoor;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(correct ? "Bien joué !" : "Faux"),
        content: Text(correct ? "C'était la bonne porte." : "Mauvaise porte, essaie encore."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🐍 Which Door?"),
        actions: [
          IconButton(icon: Icon(Icons.help_outline), onPressed: () => _showHelp(context)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("🎯 But : Trouve la bonne porte à partir de l’indice."),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(riddle, textAlign: TextAlign.center),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (i) {
              return ElevatedButton(
                onPressed: () => _checkAnswer(context, i),
                child: Text("Porte ${i + 1}"),
              );
            }),
          ),
        ],
      ),
    );
  }
}
