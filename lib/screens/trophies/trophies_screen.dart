import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:oracle_d_asgard/screens/profile/widgets/collectible_card_grid.dart';
import 'package:oracle_d_asgard/screens/profile/widgets/game_scores_podium.dart';
import 'package:oracle_d_asgard/screens/profile/widgets/unlocked_stories_grid.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';

import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/dev_tools_widget.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/constants/app_env.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class TrophiesScreen extends StatefulWidget {
  const TrophiesScreen({super.key});

  @override
  State<TrophiesScreen> createState() => _TrophiesScreenState();
}

class _TrophiesScreenState extends State<TrophiesScreen> {
  Timer? _timer;
  bool _isAdLoading = false;
  int _tapCount = 0;
  bool _showHiddenButtons = false;

  Future<List<dynamic>>? _mainDataFuture;

  CollectibleCard? _nextAdRewardCard;
  MythStory? _nextAdRewardStory;

  @override
  void initState() {
    super.initState();
    _loadNextAdRewardCard();
    _loadNextAdRewardStory();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _loadNextAdRewardCard() async {
    final gamificationService = getIt<GamificationService>();
    _nextAdRewardCard = await gamificationService
        .getRandomUnearnedCollectibleCard();
    setState(() {});
  }

  Future<void> _loadNextAdRewardStory() async {
    final gamificationService = getIt<GamificationService>();
    _nextAdRewardStory = await gamificationService.getRandomUnearnedMythStory();
    setState(() {});
  }

  Future<void> _refreshTrophiesData() async {
    final gamificationService = getIt<GamificationService>();
    await _loadNextAdRewardCard();
    await _loadNextAdRewardStory();

    setState(() {
      _mainDataFuture = Future.wait([
        gamificationService.getGameScores('Snake'),
        gamificationService.getUnlockedCollectibleCards(),
        gamificationService.getUnlockedStoryProgress(),
        gamificationService.getGameScores('Asgard Wall'),
      ]);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_mainDataFuture == null) {
      _refreshTrophiesData();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showRewardedAd() async {
    if (AppEnv.flagAds != 'enabled') {
      final gamificationService = getIt<GamificationService>();
      final rewardCard = await gamificationService
          .selectRandomUnearnedCollectibleCard();

      if (rewardCard != null) {
        _showRewardDialog(rewardCard: rewardCard);
      } else {
        _showRewardDialog(
          title: 'Toutes les cartes sont débloquées !'.tr(),
          content: 'Vous avez déjà débloqué toutes les cartes disponibles.'
              .tr(),
        );
      }
      _refreshTrophiesData();
      return;
    }

    setState(() {
      _isAdLoading = true;
    });

    RewardedAd.load(
      adUnitId: 'ca-app-pub-9329709593733606/7159103317',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoading = false;
          });
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadNextAdRewardCard();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _showSnackBar('profile_screen_ad_failed'.tr());
            },
          );
          ad.show(
            onUserEarnedReward: (ad, reward) async {
              final gamificationService = getIt<GamificationService>();
              final rewardCard = await gamificationService
                  .selectRandomUnearnedCollectibleCard();

              if (rewardCard != null) {
                _showRewardDialog(rewardCard: rewardCard);
              } else {
                _showRewardDialog(
                  title: 'Toutes les cartes sont débloquées !'.tr(),
                  content:
                      'Vous avez déjà débloqué toutes les cartes disponibles.'
                          .tr(),
                );
              }
              _refreshTrophiesData();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _isAdLoading = false;
          });
          _showSnackBar('profile_screen_ad_failed'.tr());
        },
      ),
    );
  }

  void _showRewardedStoryAd() async {
    if (AppEnv.flagAds != 'enabled') {
      final gamificationService = getIt<GamificationService>();
      if (_nextAdRewardStory != null) {
        final unlockedStory = await gamificationService
            .selectRandomUnearnedMythStory(_nextAdRewardStory!);

        if (unlockedStory != null) {
          _showRewardDialog(
            unlockedStoryChapter: unlockedStory.correctOrder.first,
          );
        } else {
          _showRewardDialog(
            title: 'Histoire déjà débloquée !'.tr(),
            content:
                'Vous avez déjà débloqué tous les chapitres de cette histoire.'
                    .tr(),
          );
        }
      } else {
        _showRewardDialog(
          title: 'Toutes les histoires sont débloquées !'.tr(),
          content: 'Vous avez déjà débloqué toutes les histoires disponibles.'
              .tr(),
        );
      }
      _refreshTrophiesData();
      return;
    }

    setState(() {
      _isAdLoading = true;
    });

    RewardedAd.load(
      adUnitId: 'ca-app-pub-9329709593733606/7159103317',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoading = false;
          });
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadNextAdRewardStory();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _showSnackBar('profile_screen_ad_failed'.tr());
            },
          );
          ad.show(
            onUserEarnedReward: (ad, reward) async {
              final gamificationService = getIt<GamificationService>();
              if (_nextAdRewardStory != null) {
                final unlockedStory = await gamificationService
                    .selectRandomUnearnedMythStory(_nextAdRewardStory!);

                if (unlockedStory != null) {
                  _showRewardDialog(
                    unlockedStoryChapter: unlockedStory.correctOrder.first,
                  );
                } else {
                  _showRewardDialog(
                    title: 'Histoire déjà débloquée !',
                    content:
                        'Vous avez déjà débloqué tous les chapitres de cette histoire.',
                  );
                }
              } else {
                _showRewardDialog(
                  title: 'Toutes les histoires sont débloquées !',
                  content:
                      'Vous avez déjà débloqué toutes les histoires disponibles.',
                );
              }
              _refreshTrophiesData();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _isAdLoading = false;
          });
          _showSnackBar(
            'Échec du chargement de la publicité. Veuillez réessayer.',
          );
        },
      ),
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _showRandomVictoryPopup() {
    _showRewardDialog(coinsEarned: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(
        titleText: 'trophies_screen_title'.tr(),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            context.go('/');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              context.go('/profile');
            },
          ),
        ],
      ),
      body: AppBackground(
        child: Container(
          color: Colors.black.withAlpha(128),
          child: FutureBuilder<List<dynamic>>(
            future: _mainDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${'profile_screen_error_prefix'.tr()}: ${snapshot.error}',
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('profile_screen_no_data_available'.tr()),
                );
              } else {
                final List<Map<String, dynamic>> snakeScores =
                    snapshot.data![0];
                final List<CollectibleCard> unlockedCards = snapshot.data![1];
                final List<Map<String, dynamic>> storyProgress =
                    snapshot.data![2];
                final List<Map<String, dynamic>> asgardWallScores =
                    snapshot.data![3];

                return ListView(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight,
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  children: [
                    const SizedBox(height: 20),
                    _buildSectionTitle('profile_screen_game_scores'.tr()),
                    GameScoresPodium(
                      scores: snakeScores,
                      gameName: 'Snake',
                      noScoresText: 'profile_screen_no_snake_scores'.tr(),
                      podiumTitle: 'profile_screen_snake_podium'.tr(),
                    ),
                    const SizedBox(height: 20),
                    GameScoresPodium(
                      scores: asgardWallScores,
                      gameName: 'Asgard Wall',
                      noScoresText: 'profile_screen_no_asgard_wall_scores'.tr(),
                      podiumTitle: 'profile_screen_asgard_wall_podium'.tr(),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('profile_screen_collectible_cards'.tr()),
                    CollectibleCardGrid(
                      cards: unlockedCards,
                      nextAdRewardCard: _nextAdRewardCard,
                      isAdLoading: _isAdLoading,
                      showRewardedAd: _showRewardedAd,
                    ),
                    const SizedBox(height: 20),
                    SimpleGestureDetector(
                      onTap: () {
                        setState(() {
                          _tapCount++;
                          if (_tapCount >= 5) {
                            _showHiddenButtons = true;
                          }
                        });
                      },
                      child: _buildSectionTitle(
                        'profile_screen_unlocked_stories'.tr(),
                      ),
                    ),
                    UnlockedStoriesGrid(
                      storyProgress: storyProgress,
                      nextAdRewardStory: _nextAdRewardStory,
                      isAdLoading: _isAdLoading,
                      showRewardedStoryAd: _showRewardedStoryAd,
                    ),
                    const SizedBox(height: 50),
                    if (_showHiddenButtons)
                      DevToolsWidget(
                        onVictoryPopupTest: _showRandomVictoryPopup,
                        onShowSnackBar: (message) {
                          _showSnackBar(message);
                          setState(() {});
                        },
                      ),
                    const SizedBox(height: 50),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          fontFamily: AppTextStyles.amaticSC,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 40,
          letterSpacing: 2.0,
          shadows: [
            const Shadow(
              blurRadius: 15.0,
              color: Colors.black87,
              offset: Offset(4.0, 4.0),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showRewardDialog({
    CollectibleCard? rewardCard,
    MythCard? unlockedStoryChapter,
    String? title,
    String? content,
    int? coinsEarned,
  }) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          if (rewardCard != null ||
              unlockedStoryChapter != null ||
              coinsEarned != null) {
            return VictoryPopup(
              rewardCard: rewardCard,
              unlockedStoryChapter: unlockedStoryChapter,
              coinsEarned: coinsEarned,
              hideReplayButton: true,
              onDismiss: () {
                Navigator.of(context).pop();
              },
              onSeeRewards: () {
                Navigator.of(context).pop();
              },
            );
          } else {
            return AlertDialog(
              title: Text(title ?? ''),
              content: Text(content ?? ''),
              actions: <Widget>[
                TextButton(
                  child: Text('profile_screen_ok_button'.tr()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        },
      );
    }
  }
}
