import 'package:flutter/material.dart';
import '../data/app_data.dart';
import 'main_screen.dart';
import '../widgets/deity_card.dart'; // 👈 Import it
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

class ResultScreen extends StatelessWidget {
  final String deity;

  const ResultScreen({super.key, required this.deity});

  @override
  Widget build(BuildContext context) {
    final deityData = AppData.deities[deity]!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/backgrounds/landscape.jpg'), fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  const SizedBox(height: 32),
                  // ✅ Use extracted widget
                  DeityCard(deity: deityData),

                  const SizedBox(height: 32),
                  
                  // Description
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 0, 0, 0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Votre Profil',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          deityData.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Boutons d'action
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ChibiButton(
                          text: 'Retour à l’accueil',
                          color: Colors.amber,
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                            (route) => false,
                          ),
                        ),
                      ),
                    ],
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