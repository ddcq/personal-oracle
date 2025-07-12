import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/model.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:provider/provider.dart';

class MythStoryPage extends StatefulWidget {
  final MythStory mythStory;

  const MythStoryPage({super.key, required this.mythStory});

  @override
  State<MythStoryPage> createState() => _MythStoryPageState();
}

class _MythStoryPageState extends State<MythStoryPage> {
  late Future<List<String>> _unlockedCardIdsFuture;

  @override
  void initState() {
    super.initState();
    _unlockedCardIdsFuture = _getUnlockedCardIds();
  }

  Future<List<String>> _getUnlockedCardIds() async {
    final gamificationService = Provider.of<GamificationService>(context, listen: false);
    final progress = await gamificationService.getStoryProgress(widget.mythStory.title);
    if (progress != null) {
      final unlockedParts = jsonDecode(progress['parts_unlocked']);
      return List<String>.from(unlockedParts);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mythStory.title),
      ),
      body: FutureBuilder<List<String>>(
        future: _unlockedCardIdsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final unlockedCardIds = snapshot.data ?? [];
            return ListView.builder(
              itemCount: widget.mythStory.correctOrder.length,
              itemBuilder: (context, index) {
                final card = widget.mythStory.correctOrder[index];
                final isUnlocked = unlockedCardIds.contains(card.id);
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8.0),
                        if (isUnlocked)
                          Image.asset(card.imagePath)
                        else
                          const Icon(Icons.lock, size: 50),
                        const SizedBox(height: 8.0),
                        if (isUnlocked)
                          Text(
                            card.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        else
                          const Text('Locked'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}