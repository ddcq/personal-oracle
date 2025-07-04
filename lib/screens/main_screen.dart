import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'quiz_screen.dart';
import 'games/menu.dart';
import 'profile_screen.dart';

// Écran principal avec navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Liste des pages
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const WelcomeContent(), // Page d'accueil
      const QuizScreen(),     // Page Quiz
      MenuPrincipal(),        // Page Mini-jeux
      const ProfileScreen(),  // Page Profil
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppConstants.primaryDark,
        selectedItemColor: AppConstants.accent,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: 'Mini-jeux',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// Contenu de votre page d'accueil (WelcomeScreen transformé)
class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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

              // Message d'information
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppConstants.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppConstants.accent.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppConstants.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Utilisez le menu en bas pour naviguer entre les différentes sections',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppConstants.accent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
            ],
          ),
        ),
      ),
    );
  }
}

// Page de profil simple
