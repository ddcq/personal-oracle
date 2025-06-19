import 'package:flutter/material.dart';

class LetHimWinGame extends StatelessWidget {
  const LetHimWinGame({super.key});

  void _showResult(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Résultat"),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Rejouer"),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("🛡️ Règles"),
        content: Text("Ton adversaire est plus faible. Tu dois décider si tu veux gagner, l’épargner ou te rendre. Ton choix déterminera ton honneur."),
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
        title: Text("🛡️ Let Him Win?"),
        actions: [
          IconButton(icon: Icon(Icons.help_outline), onPressed: () => _showHelp(context)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🎯 But : Choisis ton comportement dans ce duel déséquilibré."),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _showResult(context, "Tu gagnes... mais perds le respect du public."),
              child: Text("🗡️ Attaquer"),
            ),
            ElevatedButton(
              onPressed: () => _showResult(context, "Il gagne... avec dignité. Tu as fait preuve d’honneur."),
              child: Text("✋ Se retenir"),
            ),
            ElevatedButton(
              onPressed: () => _showResult(context, "Tu te rends. Le public t'acclame pour ton humilité."),
              child: Text("⚪ Te rendre"),
            ),
          ],
        ),
      ),
    );
  }
}
