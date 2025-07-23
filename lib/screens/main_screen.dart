import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';
import 'package:oracle_d_asgard/screens/quiz_screen.dart';
import 'package:oracle_d_asgard/screens/games/menu.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/backgrounds/landscape.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Oracle d’Asgard',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontFamily: 'AmaticSC',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 70,
                      letterSpacing: 2.0,
                      shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                    ),
                  ),
                  SizedBox(
                    height: 350, // Hauteur visible (70% de 500)
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          width: MediaQuery.of(context).size.width, // Prend toute la largeur
                          child: ClipRect(
                            child: Align(
                              alignment: Alignment.topCenter,
                              heightFactor: 0.7, // Affiche 70% de l'image
                              child: Image.asset(
                                'assets/images/odin_chibi.png',
                                height: 500, // Hauteur réelle de l'image
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ChibiButton(
                      text: 'Mini games',
                      color: const Color(0xFFF9A825), // Orange

                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPrincipal()));
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ChibiButton(
                      text: 'Quiz',
                      color: const Color(0xFF1E88E5), // Blue

                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ChibiButton(
                      text: 'Profile',
                      color: const Color(0xFFE53935), // Red

                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
