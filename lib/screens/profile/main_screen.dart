import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:oracle_d_asgard/screens/profile/widgets/collectible_card_grid.dart';
import 'package:oracle_d_asgard/screens/profile/widgets/game_scores_podium.dart';
import 'package:oracle_d_asgard/screens/profile/widgets/profile_header.dart';
import 'package:oracle_d_asgard/screens/profile/widgets/unlocked_stories_grid.dart';

import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/data/stories_data.dart';

import 'package:oracle_d_asgard/data/app_data.dart';
import 'package:oracle_d_asgard/models/deity.dart';
import 'package:oracle_d_asgard/data/collectible_cards_data.dart';
import 'package:oracle_d_asgard/models/card_version.dart';

import 'package:oracle_d_asgard/utils/text_styles.dart';

import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

import 'package:oracle_d_asgard/widgets/dev_tools_widget.dart';
import 'package:oracle_d_asgard/locator.dart';

import 'package:oracle_d_asgard/services/quiz_service.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Timer? _timer;
  bool _isAdLoading = false;
  int _tapCount = 0;
  bool _showHiddenButtons = false;

  String? _profileName;
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDeityId;

  Future<List<dynamic>>? _mainDataFuture;
  Future<List<Map<String, dynamic>>>? _quizResultsFuture;
  List<Deity> _allSelectableDeities = [];

  CollectibleCard? _nextAdRewardCard; // New: to store the next card from ad
  MythStory?
  _nextAdRewardStory; // New: to store the next story to unlock from ad

  @override
  void initState() {
    super.initState();
    _loadNextAdRewardCard(); // New: load the next card
    _loadNextAdRewardStory(); // New: load the next story
    _loadSelectableDeities();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _loadNextAdRewardCard() async {
    final gamificationService = getIt<GamificationService>();
    _nextAdRewardCard = await gamificationService
        .getRandomUnearnedCollectibleCard(); // Assuming this method exists or will be created
    setState(() {}); // Update UI after loading
  }

  Future<void> _loadNextAdRewardStory() async {
    final gamificationService = getIt<GamificationService>();
    _nextAdRewardStory = await gamificationService.getRandomUnearnedMythStory();
    setState(() {}); // Update UI after loading
  }

  Future<void> _loadSelectableDeities() async {
    final gamificationService = getIt<GamificationService>();

    // 1. Get all possible quiz deity IDs
    final allPossibleQuizDeityIds = QuizService.getAllowedQuizDeityIds()
        .toSet();

    // 2. Get all chibi collectible cards (to access their videoUrl and imagePath)
    final allChibiCards = allCollectibleCards
        .where((card) => card.version == CardVersion.chibi)
        .toList();
    final allChibiCardsMap = {for (var card in allChibiCards) card.id: card};

    // 3. Get unlocked collectible cards
    final unlockedCards = await gamificationService
        .getUnlockedCollectibleCards();
    final unlockedCardIds = unlockedCards.map((card) => card.id).toSet();

    final List<Deity> tempDeities = [];
    final Set<String> addedDeityIds = {}; // To ensure uniqueness

    // Combine all possible quiz deities and unlocked card IDs
    final allDeityOptions = <String>{};
    allDeityOptions.addAll(allPossibleQuizDeityIds);
    allDeityOptions.addAll(unlockedCardIds);

    for (final deityId in allDeityOptions) {
      if (addedDeityIds.contains(deityId)) continue;

      if (unlockedCardIds.contains(deityId)) {
        // Prioritize unlocked collectible card data if available
        final card = allChibiCardsMap[deityId];
        if (card != null) {
          final existingDeity = AppData.deities[card.id];
          tempDeities.add(
            Deity(
              id: card.id,
              name: 'collectible_card_${card.id}_title'.tr(),
              title: 'collectible_card_${card.id}_title'.tr(),
              icon: 'assets/images/${card.imagePath}',
              videoUrl: card.videoUrl,
              description: card.description,
              traits: existingDeity?.traits ?? {},
              colors: existingDeity?.colors ?? [Colors.grey, Colors.black],
              isCollectibleCard: true,
              cardVersion: card.version,
            ),
          );
          addedDeityIds.add(deityId);
        }
      } else if (allPossibleQuizDeityIds.contains(deityId)) {
        // If it's a quiz deity but no unlocked card, use AppData
        final deity = AppData.deities[deityId];
        if (deity != null) {
          tempDeities.add(deity);
          addedDeityIds.add(deityId);
        }
      }
    }

    if (tempDeities.isEmpty) {
      final odin = AppData.deities['odin'];
      if (odin != null) {
        _allSelectableDeities = [odin];
      }
    } else {
      _allSelectableDeities = tempDeities;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _refreshProfileData() async {
    final gamificationService = getIt<GamificationService>();
    await _loadSelectableDeities();
    await _loadNextAdRewardCard();
    await _loadNextAdRewardStory();

    setState(() {
      _mainDataFuture = Future.wait([
        gamificationService.getGameScores('Snake'),
        gamificationService.getUnlockedCollectibleCards(),
        gamificationService.getUnlockedStoryProgress(),
        gamificationService.getProfileName(),
        gamificationService.getProfileDeityIcon(),
        gamificationService.getGameScores('Asgard Wall'),
      ]);
      _quizResultsFuture = gamificationService.getQuizResults();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_mainDataFuture == null) {
      _refreshProfileData();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showEditNameDialog(BuildContext context) async {
    _nameController.text = _profileName ?? '';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withAlpha(230),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.amber, width: 3),
          ),
          title: Text(
            'profile_screen_change_name'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: AppTextStyles.amaticSC,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          content: TextField(
            controller: _nameController,
            autofocus: true,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'profile_screen_new_name'.tr(),
              hintStyle: TextStyle(color: Colors.black.withAlpha(128)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.amber),
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ChibiButton(
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.cancel, color: Colors.white),
                ),
                ChibiButton(
                  color: Colors.amber,
                  onPressed: () {
                    getIt<GamificationService>().saveProfileName(
                      _nameController.text,
                    );
                    setState(() {
                      _profileName = _nameController.text;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.save, color: Colors.white),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showRewardedAd() async {
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
              _loadNextAdRewardCard(); // Reload next card after ad
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
                  title: 'Toutes les cartes sont débloquées !',
                  content:
                      'Vous avez déjà débloqué toutes les cartes disponibles.',
                );
              }
              _refreshProfileData(); // Refresh the UI to show the new card
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
    setState(() {
      _isAdLoading = true;
    });

    RewardedAd.load(
      adUnitId:
          'ca-app-pub-9329709593733606/7159103317', // Same ad unit ID for now
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoading = false;
          });
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadNextAdRewardStory(); // Reload next story after ad
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
                    .selectRandomUnearnedMythStory(
                      _nextAdRewardStory!,
                    ); // Unlock the first chapter of the selected story

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
              _refreshProfileData(); // Refresh the UI to show the new story progress
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
    final random = Random();
    // 50/50 chance to show a card or a story
    if (random.nextBool()) {
      // Show a random collectible card
      final allCards = allCollectibleCards;
      if (allCards.isNotEmpty) {
        final randomCard = allCards[random.nextInt(allCards.length)];
        _showRewardDialog(rewardCard: randomCard);
      }
    } else {
      // Show a random story chapter
      final allStories = getMythStories();
      if (allStories.isNotEmpty) {
        final randomStory = allStories[random.nextInt(allStories.length)];
        if (randomStory.correctOrder.isNotEmpty) {
          final randomChapter = randomStory
              .correctOrder[random.nextInt(randomStory.correctOrder.length)];
          _showRewardDialog(unlockedStoryChapter: randomChapter);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            context.go('/');
          },
        ),
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
                final String? savedName = snapshot.data![3];
                final String? savedDeityIconId = snapshot.data![4];
                final List<Map<String, dynamic>> asgardWallScores =
                    snapshot.data![5];

                if (_profileName == null && savedName != null) {
                  _profileName = savedName;
                }
                if (_selectedDeityId == null && savedDeityIconId != null) {
                  _selectedDeityId = savedDeityIconId;
                }

                return ListView(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight,
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _quizResultsFuture,
                      builder: (context, quizSnapshot) {
                        if (quizSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (quizSnapshot.hasError) {
                          return Center(
                            child: Text(
                              '${'profile_screen_quiz_loading_error'.tr()}: ${quizSnapshot.error}',
                            ),
                          );
                        } else if (!quizSnapshot.hasData ||
                            quizSnapshot.data!.isEmpty) {
                          return const SizedBox.shrink();
                        } else {
                          final lastQuizResult = quizSnapshot.data!.first;
                          final deityName = lastQuizResult['deity_name'];
                          _profileName ??= deityName;

                          return ProfileHeader(
                            profileName: _profileName,
                            selectedDeityId: _selectedDeityId,
                            allSelectableDeities: _allSelectableDeities,
                            onNameChanged: (newName) {
                              setState(() {
                                _profileName = newName;
                              });
                            },
                            onDeityChanged: (newDeityId) {
                              _selectedDeityId = newDeityId;
                              _refreshProfileData();
                            },
                            onEditName: () => _showEditNameDialog(context),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                    _buildSectionTitle('profile_screen_game_scores'.tr()),
                    GameScoresPodium(scores: snakeScores, gameName: 'Snake'),
                    const SizedBox(height: 20),
                    GameScoresPodium(
                      scores: asgardWallScores,
                      gameName: 'Asgard Wall',
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
                          setState(() {}); // Refresh the UI after dev actions
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
  }) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          if (rewardCard != null || unlockedStoryChapter != null) {
            return VictoryPopup(
              rewardCard: rewardCard,
              unlockedStoryChapter: unlockedStoryChapter,
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
