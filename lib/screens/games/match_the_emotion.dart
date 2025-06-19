import 'package:flutter/material.dart';

class MatchEmotionGame extends StatelessWidget {
  final String situation = "Tu retrouves un vieil ami";
  final String correctEmotion = "Joie";

  const MatchEmotionGame({super.key});

  void _checkEmotion(BuildContext context, String choice) {
    final result = choice == correctEmotion ? "Bonne réponse ❤️" : "Ce n’était pas ça.";
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Résultat"),
        content: Text(result),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("❤️ Règles"),
        content: Text("Lis la situation et choisis l’émotion la plus appropriée."),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emotions = ["Colère", "Joie", "Tristesse", "Peur"];
    return Scaffold(
      appBar: AppBar(
        title: Text("❤️ Match the Emotion"),
        actions: [IconButton(icon: Icon(Icons.help_outline), onPressed: () => _showHelp(context))],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("🎯 But : Associe la bonne émotion à la situation."),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Situation : $situation", style: TextStyle(fontSize: 18)),
          ),
          ...emotions.map((e) => ElevatedButton(
              onPressed: () => _checkEmotion(context, e), child: Text(e))),
        ],
      ),
    );
  }
}
