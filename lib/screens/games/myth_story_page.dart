import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';

import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/providers/theme_provider.dart';

class MythStoryPage extends StatefulWidget {
  final MythStory mythStory;

  const MythStoryPage({super.key, required this.mythStory});

  @override
  State<MythStoryPage> createState() => _MythStoryPageState();
}

class _MythStoryPageState extends State<MythStoryPage> {
  late Future<List<String>> _unlockedCardIdsFuture;
  late SoundService _soundService;

  @override
  void initState() {
    super.initState();
    _soundService = Provider.of<SoundService>(context, listen: false);
    _soundService.playStoryMusic();
    _unlockedCardIdsFuture = _getUnlockedCardIds();
  }

  @override
  void dispose() {
    _soundService.playMainMenuMusic();
    super.dispose();
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              // Add share functionality here if needed
            },
          ),
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
        title: Text(
          widget.mythStory.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontFamily: AppTextStyles.amaticSC,
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 30, // Adjusted font size for AppBar
            letterSpacing: 2.0,
            shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
          ),
        ),
        centerTitle: true,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: FutureBuilder<List<String>>(
                future: _unlockedCardIdsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final unlockedCardIds = snapshot.data ?? [];
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.mythStory.correctOrder.length,
                          itemBuilder: (context, index) {
                            final card = widget.mythStory.correctOrder[index];
                            final isUnlocked = unlockedCardIds.contains(card.id);
                            return Card(
                              color: Theme.of(context).cardColor, // Use theme's card color
                              margin: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(card.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                                    const SizedBox(height: 8.0),
                                    if (isUnlocked) Image.asset('assets/images/stories/${card.imagePath}') else Icon(Icons.lock, size: 50, color: Theme.of(context).colorScheme.onSurface),
                                    const SizedBox(height: 8.0),
                                    if (isUnlocked)
                                      Text(card.detailedStory, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface))
                                    else
                                      Text('Locked', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
