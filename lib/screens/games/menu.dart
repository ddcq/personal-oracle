import 'package:flutter/material.dart';
import 'qix/main.dart';

import 'asgard_wall/welcome_screen.dart';
import 'snake/screen.dart';
import 'puzzle/screen.dart';
import 'asgard_wall/asgard_wall_game.dart';
import 'order_the_scrolls/screen.dart';

class MenuPrincipal extends StatelessWidget {
  MenuPrincipal({super.key});

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withAlpha(51),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.info_outline, color: Color(0xFFFFD700), size: 24),
            ),
            const SizedBox(width: 12),
            const Text("À propos", style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
        content: const Text(
          "Bienvenue dans les Mini-Jeux des Valeurs !\n\nChaque jeu représente une qualité : sagesse, ruse, honneur, courage, force, passion, nature ou justice. Choisis un jeu et montre ta maîtrise !",
          style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Compris", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  final jeux = <_MiniJeuItem>[
    _MiniJeuItem(
      "Réordonne l'Histoire", 
      "Remets les événements dans l'ordre chronologique",
      Icons.auto_stories,
      const Color(0xFF6366F1),
      "Sagesse",
      () => OrderTheScrollsGame()
    ),
    _MiniJeuItem(
      "La Muraille d'Asgard", 
      "Défends le royaume des dieux nordiques",
      Icons.fort,
      const Color(0xFFEF4444),
      "Force",
      () => AsgardWallApp()
    ),
    _MiniJeuItem(
      "Les Runes Dispersées", 
      "Reconstitue les symboles sacrés vikings",
      Icons.extension,
      const Color(0xFF06B6D4),
      "Patience",
      () => PuzzleGame() // À créer
    ),
    _MiniJeuItem(
      "Le Serpent de Midgard", 
      "Guide Jörmungandr dans sa quête éternelle",
      Icons.trending_up,
      const Color(0xFF22C55E),
      "Ruse",
      () => const SnakeGame()
    ),
    _MiniJeuItem(
      "Conquête de Territoire", 
      "Étends ton domaine en traçant des frontières",
      Icons.crop_square,
      const Color(0xFFFF6B35),
      "Stratégie",
      () => QixGame()
    ),
    _MiniJeuItem(
      "Accueil du Guerrier", 
      "Prépare-toi au combat qui t'attend",
      Icons.favorite,
      const Color(0xFF10B981),
      "Courage",
      () => WelcomeScreen()
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: CustomScrollView(
        slivers: [
          // App Bar personnalisée
          SliverAppBar(
            expandedHeight: 120,
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
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        '⚔️ Mini-Jeux des Valeurs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Forge ton destin nordique',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.help_outline, color: Color(0xFFFFD700)),
                  onPressed: () => _showHelp(context),
                ),
              ),
            ],
          ),

          // Grille des jeux
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2.5,
                mainAxisSpacing: 16,
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
          borderRadius: BorderRadius.circular(20),
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
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: jeu.color.withAlpha(25),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            // Contenu principal
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Icône du jeu
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: jeu.color.withAlpha(51),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: jeu.color.withAlpha(127)),
                    ),
                    child: Icon(
                      jeu.icon,
                      color: jeu.color,
                      size: 30,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Informations du jeu
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Badge de valeur
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: jeu.color.withAlpha(51),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            jeu.valeur,
                            style: TextStyle(
                              color: jeu.color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Titre
                        Text(
                          jeu.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Description
                        Text(
                          jeu.description,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Flèche
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: jeu.color.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: jeu.color,
                      size: 16,
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
  final String valeur;
  final Widget Function() builder;

  _MiniJeuItem(this.label, this.description, this.icon, this.color, this.valeur, this.builder);
}