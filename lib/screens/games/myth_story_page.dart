import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';

import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/providers/theme_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Import AdMob
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oracle_d_asgard/widgets/custom_video_player.dart';

class MythStoryPage extends StatefulWidget {
  final MythStory mythStory;

  const MythStoryPage({super.key, required this.mythStory});

  @override
  State<MythStoryPage> createState() => _MythStoryPageState();
}

class _MythStoryPageState extends State<MythStoryPage> {
  late Future<List<String>> _unlockedCardIdsFuture;
  late SoundService _soundService;
  bool _isAdLoading = false; // New: Ad loading state
  double _fontSize = 16.0;
  static const double _minFontSize = 12.0;
  static const double _maxFontSize = 24.0;

  @override
  void initState() {
    super.initState();
    _soundService = Provider.of<SoundService>(context, listen: false);
    _soundService.playStoryMusic();
    _unlockedCardIdsFuture = _getUnlockedCardIds();
    _loadFontSize();
  }

  @override
  void dispose() {
    _soundService.playMainMenuMusic();
    super.dispose();
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('storyFontSize') ?? 16.0;
    });
  }

  Future<void> _saveFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('storyFontSize', value);
    setState(() {
      _fontSize = value;
    });
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

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _showRewardedAd(String chapterId) async {
    setState(() {
      _isAdLoading = true;
    });

    RewardedAd.load(
      adUnitId: 'ca-app-pub-9329709593733606/7159103317', // Use your AdMob rewarded ad unit ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoading = false;
          });
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _showSnackBar('''Échec de l'affichage de la publicité. Veuillez réessayer.''');
            },
          );
          ad.show(
            onUserEarnedReward: (ad, reward) async {
              final gamificationService = Provider.of<GamificationService>(context, listen: false);
              await gamificationService.unlockStoryPart(widget.mythStory.title, chapterId);
              setState(() {
                _unlockedCardIdsFuture = _getUnlockedCardIds(); // Refresh unlocked chapters
              });
              _showSnackBar('''Chapitre débloqué avec succès !
''');
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _isAdLoading = false;
          });
          _showSnackBar('''Échec du chargement de la publicité. Veuillez réessayer.''');
        },
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Taille de la police'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: _fontSize,
                    min: _minFontSize,
                    max: _maxFontSize,
                    divisions: (_maxFontSize - _minFontSize).toInt(),
                    label: _fontSize.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _fontSize = value;
                      });
                      _saveFontSize(value);
                    },
                  ),
                  Text('Exemple de texte', style: TextStyle(fontSize: _fontSize)),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            icon: Icon(Icons.format_size, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: _showFontSizeDialog,
          ),
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode, color: Theme.of(context).colorScheme.onPrimary),
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
                    String? firstLockedChapterId;
                    for (var chapter in widget.mythStory.correctOrder) {
                      if (!unlockedCardIds.contains(chapter.id)) {
                        firstLockedChapterId = chapter.id;
                        break;
                      }
                    }

                    return _StoryContent(
                      mythStory: widget.mythStory,
                      unlockedCardIds: unlockedCardIds,
                      firstLockedChapterId: firstLockedChapterId,
                      isAdLoading: _isAdLoading,
                      showRewardedAd: _showRewardedAd,
                      fontSize: _fontSize,
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

class _StoryContent extends StatefulWidget {
  final MythStory mythStory;
  final List<String> unlockedCardIds;
  final String? firstLockedChapterId;
  final bool isAdLoading;
  final Function(String) showRewardedAd;
  final double fontSize;

  const _StoryContent({
    required this.mythStory,
    required this.unlockedCardIds,
    required this.firstLockedChapterId,
    required this.isAdLoading,
    required this.showRewardedAd,
    required this.fontSize,
  });

  @override
  State<_StoryContent> createState() => _StoryContentState();
}

class _StoryContentState extends State<_StoryContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          key: ValueKey(widget.fontSize),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.mythStory.correctOrder.length,
          itemBuilder: (context, index) {
            final card = widget.mythStory.correctOrder[index];
            final isUnlocked = widget.unlockedCardIds.contains(card.id);
            final isFirstLockedChapter = (card.id == widget.firstLockedChapterId);
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
                    if (isUnlocked) ...[
                      if (card.videoUrl != null)
                        CustomVideoPlayer(videoUrl: card.videoUrl!, placeholderAsset: 'assets/images/stories/${card.imagePath}')
                      else
                        Image.asset('assets/images/stories/${card.imagePath}'),
                      const SizedBox(height: 8.0),
                      Text(
                        card.detailedStory,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface, fontSize: widget.fontSize),
                      ),
                    ] else if (isFirstLockedChapter)
                      Column(
                        children: [
                          Text('Chapitre verrouillé', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                          const SizedBox(height: 8.0),
                          widget.isAdLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton.icon(
                                  onPressed: () => widget.showRewardedAd(card.id),
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Débloquer avec une pub'),
                                ),
                        ],
                      )
                    else
                      Text('Chapitre verrouillé', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
