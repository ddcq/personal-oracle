import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

class GameMenu extends StatelessWidget {
  final VoidCallback onStartGame;
  const GameMenu({super.key, required this.onStartGame});

  @override
  Widget build(BuildContext context) {
    // Le menu reste inchangé
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withAlpha(25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFF6B35).withAlpha(76)),
            ),
            child: const Column(
              children: [
                Text(
                  '🌲 YGGDRASIL 🌲',
                  style: TextStyle(color: Color(0xFFFF6B35), fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Les Neuf Royaumes',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Jörmungand, le Serpent-Monde, a envahi les royaumes sacrés. Trace des frontières magiques pour reconquérir 75% du territoire et emprisonner la bête !',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  '⌨️ Commandes Clavier ⌨️\nFlèches pour bouger, Espace pour tracer lentement.',
                  style: TextStyle(color: Colors.cyan, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ChibiButton(onPressed: onStartGame, text: '⚔️ Commencer la Conquête', color: const Color(0xFFFF6B35)),
        ],
      ),
    );
  }
}
