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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/games/banner.png', // Assurez-vous que ce chemin est correct
                        width: 300, // Ajustez la largeur selon vos besoins
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        top: 20.0, // Ajustez cette valeur pour déplacer le texte vers le haut
                        child: Text(
                          'Welcome',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [const Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(5.0, 5.0))],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ChibiButton(
                    text: 'Mini games',
                    color: const Color(0xFFF9A825), // Orange
                    shadowColor: const Color(0xFFC78500),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPrincipal()));
                    },
                  ),
                  const SizedBox(height: 15),
                  ChibiButton(
                    text: 'Quiz',
                    color: const Color(0xFF1E88E5), // Blue
                    shadowColor: const Color(0xFF155FA0),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
                    },
                  ),
                  const SizedBox(height: 15),
                  ChibiButton(
                    text: 'Profile',
                    color: const Color(0xFFE53935), // Red
                    shadowColor: const Color(0xFFB71C1C),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                    },
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
