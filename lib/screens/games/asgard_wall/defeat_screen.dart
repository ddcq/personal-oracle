import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/asgard_wall/game_screen.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';

import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';


class DefeatScreen extends StatelessWidget {
  const DefeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(titleText: 'Défaite…'),
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.gpp_bad, // Icône d'échec
                  color: Colors.red,
                  size: 100,
                ),
                SizedBox(height: 24),
                Text(
                  'Défaite !',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                    fontFamily: AppTextStyles.amaticSC,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red[800],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[600]!, width: 2),
                  ),
                  child: Text(
                    '💥 Un trou dans la muraille !\nLes Ases ne paieront pas le géant.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ChibiButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GameScreen()));
                  },
                  text: 'Réessayer',
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
