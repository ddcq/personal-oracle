import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';
import 'package:oracle_d_asgard/screens/quiz_screen.dart';
import 'package:oracle_d_asgard/screens/games/menu.dart';

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
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Oracle d’Asgard',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontFamily: 'NotoSansRunic',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(
                          blurRadius: 15.0,
                          color: Colors.black87,
                          offset: Offset(4.0, 4.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      Text(
                        'Welcome',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontFamily: 'NotoSansRunic',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [const Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(5.0, 5.0))],
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

class ChibiButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color shadowColor;
  final VoidCallback onPressed;

  const ChibiButton({super.key, required this.text, required this.color, required this.shadowColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 220,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 2.5),
          boxShadow: [BoxShadow(color: shadowColor, offset: const Offset(0, 6), blurRadius: 0)],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'NotoSansRunic',
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              shadows: [Shadow(blurRadius: 3.0, color: Colors.black54, offset: Offset(2.0, 2.0))],
            ),
          ),
        ),
      ),
    );
  }
}
