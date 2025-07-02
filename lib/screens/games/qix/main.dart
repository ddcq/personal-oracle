import 'package:flutter/material.dart';
import 'game.dart';
import 'game_menu.dart';

// ==========================================
// JÖRMUNGAND CONQUEST - Clone de Qix inspiré de la mythologie nordique
// ==========================================

class QixGame extends StatefulWidget {
  const QixGame({super.key});
  @override
  State<QixGame> createState() => _QixGameState();
}

class _QixGameState extends State<QixGame> {
  bool _gameStarted = false;
  void _startGame() => setState(() => _gameStarted = true);
  void _returnToMenu() => setState(() => _gameStarted = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        title: const Text(
          '🐉 Conquête de Jörmungand',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF6B35),
        leading: _gameStarted
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _returnToMenu,
              )
            : null,
      ),
      body: _gameStarted
          ? QixGameScreen(onGameOver: _returnToMenu)
          : GameMenu(onStartGame: _startGame),
    );
  }
}
