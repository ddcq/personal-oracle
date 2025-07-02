import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'pyqix_game.dart';

class Qix3 extends StatelessWidget {
  const Qix3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qix Flutter',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: GameWidget(game: PyQixGame()),
    );
  }
}

