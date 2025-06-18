import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'quiz_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppConstants.primaryDark, AppConstants.secondaryDark],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Icône principale
                Container(
                  width: AppConstants.iconXLarge,
                  height: AppConstants.iconXLarge,
                  decoration: BoxDecoration(
                    color: AppConstants.accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppConstants.accent, width: 2),
                  ),
                  child: const Icon(
                    Icons.shield,
                    size: 60,
                    color: AppConstants.accent,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingXLarge),
                
                // Titre
                Text(
                  'Oracle Nordique',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                
                // Sous-titre
                Text(
                  'Découvrez quelle divinité nordique sommeille en vous',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingXLarge + AppConstants.paddingMedium),
                
                // Description
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      children: [
                        Text(
                          'Comment ça marche ?',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        Text(
                          'Répondez à nos questions pour découvrir votre divinité tutélaire nordique. Recevez ensuite des conseils personnalisés et des défis quotidiens inspirés de la mythologie viking.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                
                // Bouton de démarrage
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _navigateToQuiz(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                    child: const Text(
                      'Commencer le Quiz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToQuiz(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizScreen(),
      ),
    );
  }
}