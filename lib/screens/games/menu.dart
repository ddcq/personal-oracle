import 'package:flutter/material.dart';
import 'package:personal_oracle/screens/games/asgard_wall/defeat_screen.dart';
import 'package:personal_oracle/screens/games/asgard_wall/victory_screen.dart';
import 'package:personal_oracle/screens/games/asgard_wall/welcome_screen.dart';

import 'asgard_wall/asgard_wall_game.dart';
import 'order_the_scrolls/screen.dart';

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
    _MiniJeuItem("Réordonne l'histoire", () => OrderTheScrollsGame()),
    _MiniJeuItem("La muraille d'Asgard", () => AsgardWallApp()),
    _MiniJeuItem("Wall defeat", () => DefeatScreen()),
    _MiniJeuItem("Wall Victory", () => VictoryScreen()),
    _MiniJeuItem("Wall welcome", () => WelcomeScreen()),
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
