import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oracle_d_asgard/screens/games/myth_story_page.dart';
import 'package:oracle_d_asgard/widgets/interactive_collectible_card.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/data/stories_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Map<String, MythCard> _allMythCards;
  late Map<String, CollectibleCard> _allCollectibleCards;

  @override
  void initState() {
    super.initState();
    _loadAllMythCards();
    _loadAllCollectibleCards();
  }

  void _loadAllMythCards() {
    _allMythCards = {};
    for (var story in getMythStories()) {
      for (var card in story.correctOrder) {
        _allMythCards[card.id] = card;
      }
    }
  }

  void _loadAllCollectibleCards() {
    _allCollectibleCards = {};
    for (var story in getMythStories()) {
      for (var card in story.collectibleCards) {
        _allCollectibleCards[card.id] = card;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A148C), // Dark Purple
              Color(0xFF880E4F), // Dark Pink
            ],
          ),
        ),
        child: Consumer<GamificationService>(
          builder: (context, gamificationService, child) {
            return FutureBuilder<List<List<Map<String, dynamic>>>>(
              future: Future.wait([
                gamificationService.getGameScores('Snake'),
                gamificationService.getUnlockedTrophies(),
                gamificationService.getUnlockedCollectibleCards(),
                gamificationService.getUnlockedStoryProgress(),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available.'));
                } else {
                  final List<Map<String, dynamic>> snakeScores = snapshot.data![0];
                  final List<Map<String, dynamic>> unlockedTrophies =
                      snapshot.data![1];
                  final List<Map<String, dynamic>> unlockedCards =
                      snapshot.data![2];
                  final List<Map<String, dynamic>> storyProgress =
                      snapshot.data![3];

                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildSectionTitle('Scores de jeu'),
                      _buildGameScores(snakeScores),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Trophées'),
                      _buildTrophies(unlockedTrophies),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Cartes à collectionner'),
                      _buildCollectibleCards(unlockedCards),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Histoires débloquées'),
                      _buildUnlockedStories(storyProgress),
                      const SizedBox(height: 50), // Add some bottom padding
                    ],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Color.fromARGB(150, 0, 0, 0),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return "À l'instant";
        }
        return "Il y a ${difference.inMinutes} min";
      }
      return "Aujourd'hui à ${DateFormat('HH:mm').format(timestamp)}";
    } else if (difference.inDays == 1) {
      return "Hier à ${DateFormat('HH:mm').format(timestamp)}";
    } else if (difference.inDays < 7) {
      return "Il y a ${difference.inDays} jours";
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return "Il y a $weeks sem";
    }
    else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "Il y a $months mois";
    } else {
      final years = (difference.inDays / 365).floor();
      return "Il y a $years ans";
    }
  }

  Widget _buildGameScores(List<Map<String, dynamic>> scores) {
    if (scores.isEmpty) {
      return const Text(
        'Aucun score de Snake pour l’instant.',
        style: TextStyle(color: Colors.white70),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jeu du Serpent :',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 10),
        ...scores.map(
          (score) {
            final DateTime timestamp =
                DateTime.fromMillisecondsSinceEpoch(score['timestamp']);
            return Card(
              color: Colors.white.withAlpha(25),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.score, color: Colors.greenAccent, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Score: ${score['score']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${_formatRelativeTime(timestamp)}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTrophies(List<Map<String, dynamic>> trophies) {
    if (trophies.isEmpty) {
      return const Text(
        'Aucun trophée débloqué pour l’instant.',
        style: TextStyle(color: Colors.white70),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: trophies.length,
      itemBuilder: (context, index) {
        final trophy = trophies[index];
        return Card(
          color: Colors.white.withAlpha(25),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 40),
              const SizedBox(height: 8),
              Text(
                trophy['trophy_id'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCollectibleCards(List<Map<String, dynamic>> cards) {
    if (cards.isEmpty) {
      return const Text(
        'Aucune carte à collectionner débloquée pour l’instant.',
        style: TextStyle(color: Colors.white70),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final cardData = cards[index];
        final collectibleCard = _allCollectibleCards[cardData['card_id']];

        if (collectibleCard == null) {
          return const SizedBox.shrink(); // Should not happen
        }

        return InteractiveCollectibleCard(card: collectibleCard);
      },
    );
  }

  Widget _buildUnlockedStories(List<Map<String, dynamic>> storyProgress) {
    if (storyProgress.isEmpty) {
      return const Text(
        'Aucune histoire débloquée pour l’instant.',
        style: TextStyle(color: Colors.white70),
      );
    }
    final allMythStories = getMythStories();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: storyProgress.length,
      itemBuilder: (context, index) {
        final progress = storyProgress[index];
        final storyId = progress['story_id'];
        final mythStory = allMythStories.firstWhere(
          (story) => story.title == storyId,
          orElse: () => MythStory(title: 'Histoire inconnue', correctOrder: [], collectibleCards: []), // Fallback
        );
        final unlockedParts = jsonDecode(progress['parts_unlocked']);
        final int totalParts = mythStory.correctOrder.length;
        final progressPercentage = totalParts > 0 ? unlockedParts.length / totalParts : 0.0;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MythStoryPage(mythStory: mythStory),
              ),
            );
          },
          child: Card(
            color: Colors.white.withAlpha(25),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book,
                  color: Colors.purpleAccent,
                  size: 40,
                ), // Placeholder icon
                const SizedBox(height: 8),
                Text(
                  mythStory.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progressPercentage,
                  backgroundColor: Colors.grey[700],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progressPercentage * 100).toStringAsFixed(0)}% Terminée',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}