import 'dart:async';

import 'package:flutter/material.dart';

class FaceTheFearGame extends StatefulWidget {
  const FaceTheFearGame({super.key});

  @override
  State<FaceTheFearGame> createState() => _FaceTheFearGameState();
}

class _FaceTheFearGameState extends State<FaceTheFearGame> {
  bool _isHolding = false;
  Timer? _timer;
  int _secondsHeld = 0;

  void _startHold() {
    setState(() {
      _isHolding = true;
      _secondsHeld = 0;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsHeld++;
        if (_secondsHeld >= 10) {
          timer.cancel();
          _showResult("Tu as tenu bon ! Courage validé.");
        }
      });
    });
  }

  void _stopHold() {
    if (_secondsHeld < 10) {
      _timer?.cancel();
      _showResult("Tu as lâché trop tôt. Essaie encore.");
    }
    setState(() => _isHolding = false);
  }

  void _showResult(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Résultat"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("🦁 Règles"),
        content: Text("Appuie longuement pendant 10 secondes sans relâcher, malgré les distractions. Le courage, c’est résister."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🦁 Face the Fear"),
        actions: [
          IconButton(icon: Icon(Icons.help_outline), onPressed: _showHelp),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🎯 But : Ne relâche pas, même sous la pression !"),
            SizedBox(height: 30),
            GestureDetector(
              onLongPressStart: (_) => _startHold(),
              onLongPressEnd: (_) => _stopHold(),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("Maintiens ici", style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            Text("⏱️ Temps : $_secondsHeld s"),
          ],
        ),
      ),
    );
  }
}
