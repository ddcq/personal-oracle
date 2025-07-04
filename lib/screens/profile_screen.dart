import 'package:flutter/material.dart';
import 'package:personal_oracle/services/gamification_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Consumer<GamificationService>(
        builder: (context, gamificationService, child) {
          return FutureBuilder<List<List<Map<String, dynamic>>>>(
            future: Future.wait([
              gamificationService.getGameScores('Snake'),
              gamificationService.getUnlockedTrophies(),
              gamificationService.getUnlockedCollectibleCards(),
              gamificationService.getUnlockedStories(),
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
                final List<Map<String, dynamic>> unlockedTrophies = snapshot.data![1];
                final List<Map<String, dynamic>> unlockedCards = snapshot.data![2];
                final List<Map<String, dynamic>> unlockedStories = snapshot.data![3];

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      _buildSectionTitle('Game Scores'),
                      _buildGameScores(snakeScores),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Trophies'),
                      _buildTrophies(unlockedTrophies),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Collectible Cards'),
                      _buildCollectibleCards(unlockedCards),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Unlocked Stories'),
                      _buildUnlockedStories(unlockedStories),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildGameScores(List<Map<String, dynamic>> scores) {
    if (scores.isEmpty) {
      return const Text('No Snake scores yet.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Snake Game:', style: Theme.of(context).textTheme.bodyMedium),
        ...scores.map((score) => Text('Score: ${score['score']} at ${DateTime.fromMillisecondsSinceEpoch(score['timestamp']).toLocal()}')),
      ],
    );
  }

  Widget _buildTrophies(List<Map<String, dynamic>> trophies) {
    if (trophies.isEmpty) {
      return const Text('No trophies unlocked yet.');
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: trophies.map((trophy) => Chip(label: Text(trophy['trophy_id']))).toList(),
    );
  }

  Widget _buildCollectibleCards(List<Map<String, dynamic>> cards) {
    if (cards.isEmpty) {
      return const Text('No collectible cards unlocked yet.');
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: cards.map((card) => Chip(label: Text(card['card_id']))).toList(),
    );
  }

  Widget _buildUnlockedStories(List<Map<String, dynamic>> stories) {
    if (stories.isEmpty) {
      return const Text('No stories unlocked yet.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stories.map((story) => Text(story['story_id'], style: Theme.of(context).textTheme.bodyMedium)).toList(),
    );
  }
}
