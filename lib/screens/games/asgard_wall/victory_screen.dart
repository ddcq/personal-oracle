import 'package:flutter/material.dart';

import 'package:oracle_d_asgard/screens/games/asgard_wall/main_screen.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';

import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: ChibiAppBar(titleText: 'Victoire !'),
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events, // Icône de trophée
                  color: Color(0xFFFFD700),
                  size: 100,
                ),
                SizedBox(height: 24),
                Text(
                  'Victoire !',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFFFFD700), fontFamily: AppTextStyles.amaticSC),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[800],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[600]!, width: 2),
                  ),
                  child: Text(
                    '🏰 La muraille d’Asgard est parfaite !\nSleipnir peut naître !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(height: 32),
                SizedBox(height: 32),
                ChibiButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GameScreen()));
                  },
                  text: 'Rejouer',
                  color: const Color(0xFFFFD700),
                ),
                SizedBox(height: 16),
                ChibiButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Retour à l’accueil',
                  color: Colors.blueGrey, // Using a consistent color for secondary action
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
