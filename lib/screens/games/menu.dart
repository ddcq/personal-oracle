import 'package:flutter/material.dart';
import 'qix/main.dart';

import 'asgard_wall/welcome_screen.dart';
import 'snake/screen.dart';
import 'puzzle/screen.dart';

import 'order_the_scrolls/screen.dart';

class MenuPrincipal extends StatelessWidget {
  MenuPrincipal({super.key});

  final jeux = <_MiniJeuItem>[
    _MiniJeuItem(
      "Réordonne l'Histoire", 
      "Remets les événements dans l'ordre chronologique",
      Icons.auto_stories,
      const Color(0xFF6366F1),
      () => OrderTheScrollsGame()
    ),
    _MiniJeuItem(
      "La Muraille d'Asgard", 
      "Défends le royaume des dieux nordiques",
      Icons.fort,
      const Color(0xFFEF4444),
      () => WelcomeScreen()
    ),
    _MiniJeuItem(
      "Les Runes Dispersées", 
      "Reconstitue les symboles sacrés vikings",
      Icons.extension,
      const Color(0xFF06B6D4),
      () => PuzzleGameScreen() // À créer
    ),
    _MiniJeuItem(
      "Le Serpent de Midgard", 
      "Guide Jörmungandr dans sa quête éternelle",
      Icons.trending_up,
      const Color(0xFF22C55E),
      () => const SnakeGame()
    ),
    _MiniJeuItem(
      "Conquête de Territoire", 
      "Étends ton domaine en traçant des frontières",
      Icons.crop_square,
      const Color(0xFFFF6B35),
      () => QixGameScreen()
    ),
    _MiniJeuItem(
      "Accueil du Guerrier", 
      "Prépare-toi au combat qui t'attend",
      Icons.favorite,
      const Color(0xFF10B981),
      () => WelcomeScreen()
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: CustomScrollView(
        slivers: [
          // App Bar personnalisée
          SliverAppBar(
            expandedHeight: screenHeight * 0.15, // Responsive height
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1E1E2E),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1E1E2E),
                      const Color(0xFF0F0F23),
                    ],
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.02), // Responsive spacing
                        Text(
                          '⚔️ Mini-Jeux',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05, // Responsive font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01), // Responsive spacing
                        Text(
                          'Forge ton destin nordique',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: screenWidth * 0.03, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Grille des jeux
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 20.0), // Responsive horizontal padding, fixed vertical padding
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3.5, // Adjusted aspect ratio for less height
                mainAxisSpacing: 16.0, // Fixed vertical spacing
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final jeu = jeux[index];
                  return _buildGameCard(context, jeu, index);
                },
                childCount: jeux.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, _MiniJeuItem jeu, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    double iconSize = isLargeScreen ? 40 : 30;
    double fontSizeTitle = isLargeScreen ? 20 : 18;
    double fontSizeDescription = isLargeScreen ? 16 : 14;
    double padding = isLargeScreen ? 24 : 20;
    double spacing = isLargeScreen ? 20 : 16;
    double borderRadius = isLargeScreen ? 24 : 20;
    double iconContainerSize = isLargeScreen ? 70 : 60;
    double arrowContainerSize = isLargeScreen ? 45 : 40;
    double arrowIconSize = isLargeScreen ? 20 : 16;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => jeu.builder()),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              jeu.color.withAlpha(51),
              jeu.color.withAlpha(12),
            ],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: jeu.color.withAlpha(76),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: jeu.color.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Motif de fond
            Positioned(
              right: -padding,
              top: -padding,
              child: Container(
                width: iconContainerSize * 1.5,
                height: iconContainerSize * 1.5,
                decoration: BoxDecoration(
                  color: jeu.color.withAlpha(25),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            // Contenu principal
            Padding(
              padding: EdgeInsets.all(padding),
              child: Row(
                children: [
                  // Icône du jeu
                  Container(
                    width: iconContainerSize,
                    height: iconContainerSize,
                    decoration: BoxDecoration(
                      color: jeu.color.withAlpha(51),
                      borderRadius: BorderRadius.circular(borderRadius * 0.8),
                      border: Border.all(color: jeu.color.withAlpha(127)),
                    ),
                    child: Icon(
                      jeu.icon,
                      color: jeu.color,
                      size: iconSize,
                    ),
                  ),
                  
                  SizedBox(width: spacing),
                  
                  // Informations du jeu
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: spacing * 0.5),
                        
                        // Titre
                        Flexible(
                          child: Text(
                            jeu.label,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: spacing * 0.25),
                        
                        // Description
                        Flexible(
                          child: Text(
                            jeu.description,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: fontSizeDescription,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Flèche
                  Container(
                    width: arrowContainerSize,
                    height: arrowContainerSize,
                    decoration: BoxDecoration(
                      color: jeu.color.withAlpha(25),
                      borderRadius: BorderRadius.circular(borderRadius * 0.6),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: jeu.color,
                      size: arrowIconSize,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniJeuItem {
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final Widget Function() builder;

  _MiniJeuItem(this.label, this.description, this.icon, this.color, this.builder);
}