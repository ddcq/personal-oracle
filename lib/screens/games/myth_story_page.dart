import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';

import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/providers/theme_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Import AdMob
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oracle_d_asgard/widgets/custom_video_player.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/constants/app_env.dart';

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
    _soundService = getIt<SoundService>();
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
    final gamificationService = getIt<GamificationService>();
    final progress = await gamificationService.getStoryProgress(widget.mythStory.id);
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
    if (AppEnv.flagAds != 'enabled') {
      final gamificationService = getIt<GamificationService>();
      await gamificationService.unlockStoryPart(widget.mythStory.id, chapterId);
      setState(() {
        _unlockedCardIdsFuture = _getUnlockedCardIds();
      });
      _showSnackBar('myth_story_page_chapter_unlocked_success'.tr());
      return;
    }

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
              _showSnackBar('myth_story_page_ad_display_failed'.tr());
            },
          );
          ad.show(
            onUserEarnedReward: (ad, reward) async {
              final gamificationService = getIt<GamificationService>();
              await gamificationService.unlockStoryPart(widget.mythStory.id, chapterId);
              setState(() {
                _unlockedCardIdsFuture = _getUnlockedCardIds(); // Refresh unlocked chapters
              });
              _showSnackBar('myth_story_page_chapter_unlocked_success'.tr());
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _isAdLoading = false;
          });
          _showSnackBar('myth_story_page_ad_loading_failed'.tr());
        },
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('myth_story_page_font_size_title'.tr()),
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
                  Text('myth_story_page_sample_text'.tr(), style: TextStyle(fontSize: _fontSize)),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('myth_story_page_close_button'.tr()),
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
      appBar: ChibiAppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Navigator.of(context).pop()),
        actions: [
          IconButton(icon: Icon(Icons.format_size), onPressed: _showFontSizeDialog),
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
        titleText: widget.mythStory.title.tr(),
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
                    return Center(child: Text('${'myth_story_page_error_prefix'.tr()}: ${snapshot.error}'));
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
                    Text(
                      'story_${widget.mythStory.id}_card_${card.id}_title'.tr(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: 8.0),
                    if (isUnlocked) ...[
                      if (card.videoUrl != null)
                        CustomVideoPlayer(videoUrl: card.videoUrl!, placeholderAsset: 'assets/images/stories/${card.imagePath}')
                      else
                        Image.asset('assets/images/stories/${card.imagePath}'),
                      const SizedBox(height: 8.0),
                      Text(
                        card.detailedStory.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface, fontSize: widget.fontSize),
                      ),
                    ] else if (isFirstLockedChapter)
                      Column(
                        children: [
                          Text('myth_story_page_chapter_locked'.tr(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                          const SizedBox(height: 8.0),
                          widget.isAdLoading
                              ? const CircularProgressIndicator()
                              : AppEnv.flagAds == 'enabled'
                              ? ElevatedButton.icon(
                                  onPressed: () => widget.showRewardedAd(card.id),
                                  icon: const Icon(Icons.play_arrow),
                                  label: Text('myth_story_page_unlock_with_ad'.tr()),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    context.push('/shop');
                                  },
                                  child: Text('myth_story_page_unlock_chapter'.tr()),
                                ),
                        ],
                      )
                    else
                      Text('myth_story_page_chapter_locked'.tr(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
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
