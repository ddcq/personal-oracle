import 'dart:async';

import 'package:flutter/material.dart';

class BreakTheRockGame extends StatefulWidget {
  const BreakTheRockGame({super.key});

  @override
  State<BreakTheRockGame> createState() => _BreakTheRockGameState();
}

class _BreakTheRockGameState extends State<BreakTheRockGame> {
  int _taps = 0;
  bool _started = false;

  void _startGame() {
    setState(() {
      _taps = 0;
      _started = true;
    });

    Timer(Duration(seconds: 10), () {
      setState(() => _started = false);
      _showResult(_taps >= 50 ? "Tu as brisé le rocher ! 💥" : "Pas assez fort... Essaie encore.");
    });
  }

  void _showResult(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Résultat"),
        content: Text("$message\nTaps : $_taps"),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("💪 Règles"),
        content: Text("Tape sur le bouton le plus vite possible pendant 10 secondes pour casser le rocher."),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("💪 Break the Rock"),
        actions: [IconButton(icon: Icon(Icons.help_outline), onPressed: _showHelp)],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("🎯 But : Casse le rocher avec ta force !"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _started ? () => setState(() => _taps++) : _startGame,
            child: Text(_started ? "💥 TAP!" : "Démarrer"),
          ),
          if (_started) Text("Taps : $_taps", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
