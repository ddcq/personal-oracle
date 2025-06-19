import 'package:flutter/material.dart';
import 'package:personal_oracle/screens/games/balance_of_justice.dart';
import 'package:personal_oracle/screens/games/break_the_rock.dart';
import 'package:personal_oracle/screens/games/face_the_fear.dart';
import 'package:personal_oracle/screens/games/find_the_path.dart';
import 'package:personal_oracle/screens/games/let_him_win.dart';
import 'package:personal_oracle/screens/games/match_the_emotion.dart';
import 'package:personal_oracle/screens/games/order_the_scrolls/screen.dart';
import 'package:personal_oracle/screens/games/which_door.dart';

class MiniJeuxApp extends StatelessWidget {
  const MiniJeuxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini-Jeux des Valeurs',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: MenuPrincipal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  MenuPrincipal({super.key});

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("📚 À propos"),
        content: Text(
            "Bienvenue dans les Mini-Jeux des Valeurs !\n\nChaque jeu représente une qualité : sagesse, ruse, honneur, courage, force, passion, nature ou justice. Choisis un jeu et montre ta maîtrise !"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  final List<_MiniJeuItem> jeux = [
    _MiniJeuItem("🧠 Wisdom - Riddle Game", () => OrderTheScrollsGame()),
    _MiniJeuItem("🦊 Cunning - Maze Game", () => WhichDoorGame()),
    _MiniJeuItem("⚔️ Honor - Reflection Game", () => LetHimWinGame()),
    _MiniJeuItem("🦁 Courage - Hold Button", () => FaceTheFearGame()),
    _MiniJeuItem("💪 Strength - Tapper", () => BreakTheRockGame()),
    _MiniJeuItem("❤️ Passion - Emotion Match", () => MatchEmotionGame()),
    _MiniJeuItem("🌿 Nature - Find the Path", () => FindThePathGame()),
    _MiniJeuItem("⚖️ Justice - Balance", () => BalanceOfJusticeGame()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎮 Mini-Jeux des Valeurs'),
        actions: [
          IconButton(icon: Icon(Icons.help_outline), onPressed: () => _showHelp(context)),
        ],
      ),
      body: ListView.builder(
        itemCount: jeux.length,
        itemBuilder: (context, index) {
          final jeu = jeux[index];
          return ListTile(
            title: Text(jeu.label),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => jeu.builder()),
            ),
          );
        },
      ),
    );
  }
}

class _MiniJeuItem {
  final String label;
  final Widget Function() builder;

  _MiniJeuItem(this.label, this.builder);
}
