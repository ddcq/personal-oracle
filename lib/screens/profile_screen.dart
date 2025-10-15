import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:oracle_d_asgard/screens/games/myth_story_page.dart';
import 'package:oracle_d_asgard/screens/profile/deity_selection_screen.dart';
import 'package:oracle_d_asgard/services/database_service.dart';
import 'package:oracle_d_asgard/widgets/interactive_collectible_card.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/models/myth_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/data/stories_data.dart';
import 'package:oracle_d_asgard/data/app_data.dart';
import 'package:oracle_d_asgard/models/deity.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart'; // For .sw and .h extensions

import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isAdLoading = false;
  int _tapCount = 0;
  bool _showHiddenButtons = false;

  String? _profileName;
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDeityId;

  Future<List<dynamic>>? _mainDataFuture;
  Future<List<Map<String, dynamic>>>? _quizResultsFuture;

  CollectibleCard? _nextAdRewardCard; // New: to store the next card from ad
  MythStory? _nextAdRewardStory; // New: to store the next story to unlock from ad

  @override
  void initState() {
    super.initState();
    _loadNextAdRewardCard(); // New: load the next card
    _loadNextAdRewardStory(); // New: load the next story
  }

  Future<void> _loadNextAdRewardCard() async {
    final gamificationService = getIt<GamificationService>();
    _nextAdRewardCard = await gamificationService.getRandomUnearnedCollectibleCard(); // Assuming this method exists or will be created
    setState(() {}); // Update UI after loading
  }

  Future<void> _loadNextAdRewardStory() async {
    final gamificationService = getIt<GamificationService>();
    _nextAdRewardStory = await gamificationService.getRandomUnearnedMythStory();
    setState(() {}); // Update UI after loading
  }

  Future<void> _refreshProfileData() async {
    final gamificationService = getIt<GamificationService>();
    _mainDataFuture = Future.wait([
      gamificationService.getGameScores('Snake'),
      gamificationService.getUnlockedCollectibleCards(),
      gamificationService.getUnlockedStoryProgress(),
      gamificationService.getProfileName(),
      gamificationService.getProfileDeityIcon(),
    ]);
    _quizResultsFuture = gamificationService.getQuizResults();
    await _loadNextAdRewardCard();
    await _loadNextAdRewardStory();
    setState(() {});
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
            'Changer le nom',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontFamily: AppTextStyles.amaticSC, color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          content: TextField(
            controller: _nameController,
            autofocus: true,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Nouveau nom',
              hintStyle: TextStyle(color: Colors.black.withAlpha(128)),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
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
                    getIt<GamificationService>().saveProfileName(_nameController.text);
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
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _showSnackBar('Échec de l\'affichage de la publicité. Veuillez réessayer.');
            },
          );
          ad.show(
            onUserEarnedReward: (ad, reward) async {
              // Reward the user
              final gamificationService = getIt<GamificationService>();
              CollectibleCard? wonCard = _nextAdRewardCard;

              if (wonCard != null) {
                await gamificationService.unlockCollectibleCard(wonCard);
                _showRewardDialog(rewardCard: wonCard);
              } else {
                _showRewardDialog(title: 'Collection Complète !', content: 'Vous avez déjà toutes les cartes !');
              }
              // Refresh the UI to show the new card
              _refreshProfileData();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _isAdLoading = false;
          });
          _showSnackBar('Échec du chargement de la publicité. Veuillez réessayer.');
        },
      ),
    );
  }

  void _showRewardedStoryAd() async {
    setState(() {
      _isAdLoading = true;
    });

    RewardedAd.load(
      adUnitId: 'ca-app-pub-9329709593733606/7159103317', // Same ad unit ID for now
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
              _showSnackBar('Échec de l\'affichage de la publicité. Veuillez réessayer.');
            },
          );
          ad.show(
            onUserEarnedReward: (ad, reward) async {
              final gamificationService = getIt<GamificationService>();
              if (_nextAdRewardStory != null) {
                final unlockedStory = await gamificationService.selectRandomUnearnedMythStory(
                  _nextAdRewardStory!,
                ); // Unlock the first chapter of the selected story

                if (unlockedStory != null) {
                  _showRewardDialog(unlockedStoryChapter: unlockedStory.correctOrder.first);
                } else {
                  _showRewardDialog(title: 'Histoire déjà débloquée !', content: 'Vous avez déjà débloqué tous les chapitres de cette histoire.');
                }
              } else {
                _showRewardDialog(title: 'Toutes les histoires sont débloquées !', content: 'Vous avez déjà débloqué toutes les histoires disponibles.');
              }
              _refreshProfileData(); // Refresh the UI to show the new story progress
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _isAdLoading = false;
          });
          _showSnackBar('Échec du chargement de la publicité. Veuillez réessayer.');
        },
      ),
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _clearAndRebuildDatabase() async {
    final dbService = getIt<DatabaseService>();
    try {
      await dbService.deleteDb();
      await dbService.reinitializeDb();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database cleared and rebuilt successfully!')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to clear and rebuild database: $e')));
    }
  }

  Future<void> _unlockAllStories() async {
    final gamificationService = getIt<GamificationService>();
    final allStories = getMythStories();
    for (var story in allStories) {
      await gamificationService.unlockStory(story.title, story.correctOrder.map((card) => card.id).toList());
    }
    setState(() {}); // Refresh the UI
    _showSnackBar('Toutes les histoires ont été débloquées !');
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () async {
              final gamificationService = getIt<GamificationService>();
              final quizResults = await gamificationService.getQuizResults();
              if (quizResults.isNotEmpty) {
                final lastQuizResult = quizResults.first;
                final deityName = lastQuizResult['deity_name'];
                final Deity? deity = AppData.deities[deityName.toLowerCase()];
                if (deity != null) {
                  SharePlus.instance.share(
                    ShareParams(text: 'Mon résultat au quiz Oracle d\'Asgard : Je suis ${deity.name} ! Découvrez votre divinité sur l\'application !'),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: AppBackground(
        child: FutureBuilder<List<dynamic>>(
          future: _mainDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available.'));
            } else {
              final List<Map<String, dynamic>> snakeScores = snapshot.data![0];
              final List<CollectibleCard> unlockedCards = snapshot.data![1];
              final List<Map<String, dynamic>> storyProgress = snapshot.data![2];
              final String? savedName = snapshot.data![3];
              final String? savedDeityIconId = snapshot.data![4];

              if (_profileName == null && savedName != null) {
                _profileName = savedName;
              }
              if (_selectedDeityId == null && savedDeityIconId != null) {
                _selectedDeityId = savedDeityIconId;
              }

              return ListView(
                padding: EdgeInsets.only(top: kToolbarHeight, left: 16.0, right: 16.0, bottom: 16.0),
                children: [
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _quizResultsFuture,
                    builder: (context, quizSnapshot) {
                      if (quizSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (quizSnapshot.hasError) {
                        return Center(child: Text('Error loading quiz result: ${quizSnapshot.error}'));
                      } else if (!quizSnapshot.hasData || quizSnapshot.data!.isEmpty) {
                        return const SizedBox.shrink();
                      } else {
                        final lastQuizResult = quizSnapshot.data!.first;
                        final deityName = lastQuizResult['deity_name'];
                        final Deity? deity = AppData.deities[deityName.toLowerCase()];

                        if (deity == null) {
                          return const SizedBox.shrink();
                        }

                        _profileName ??= deity.name;

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () => _showEditNameDialog(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      _profileName ?? deity.name,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        fontFamily: AppTextStyles.amaticSC,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 70,
                                        letterSpacing: 2.0,
                                        shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.edit, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () async {
                                final newDeityId = await Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(builder: (context) => DeitySelectionScreen(currentDeityId: _selectedDeityId ?? deity.id)),
                                );

                                if (newDeityId != null && newDeityId != _selectedDeityId) {
                                  setState(() {
                                    _selectedDeityId = newDeityId;
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: const Color(0xFFDAA520), width: 5),
                                      boxShadow: const [
                                        BoxShadow(color: Color(0xFFDAA520), offset: Offset(5, 5)),
                                        BoxShadow(color: Color(0xFFFFD700), offset: Offset(-5, -5)),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(AppData.deities[_selectedDeityId]?.icon ?? deity.icon, fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.edit, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  _buildSectionTitle('Paramètres'),
                  _buildSoundSettings(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Scores de jeu'),
                  _buildGameScores(snakeScores),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Cartes à collectionner'),
                  _buildCollectibleCards(unlockedCards),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _tapCount++;
                        if (_tapCount >= 5) {
                          _showHiddenButtons = true;
                        }
                      });
                    },
                    child: _buildSectionTitle('Histoires débloquées'),
                  ),
                  _buildUnlockedStories(storyProgress),
                  const SizedBox(height: 50),
                  if (_showHiddenButtons)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete_forever, size: 20),
                          onPressed: _clearAndRebuildDatabase,
                          tooltip: 'Clear and Rebuild Database',
                        ),
                        SizedBox(width: 20.w),
                        IconButton(icon: const Icon(Icons.book, size: 20), onPressed: _unlockAllStories, tooltip: 'Unlock All Stories'),
                      ],
                    ),
                  const SizedBox(height: 50),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSoundSettings() {
    final soundService = getIt<SoundService>();
    return Card(
      color: Colors.black.withAlpha(100),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Musique d\'ambiance',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: AppTextStyles.amaticSC, fontSize: 22),
            ),
            Switch(
              value: !soundService.isMuted,
              onChanged: (value) {
                soundService.setMuted(!value);
              },
              activeTrackColor: Colors.green,
              inactiveTrackColor: Colors.grey,
            ),
          ],
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
          shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
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
          return 'À l’instant';
        }
        return 'Il y a ${difference.inMinutes} min';
      }
      return 'Aujourd’hui à ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays == 1) {
      return 'Hier à ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Il y a $weeks sem';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Il y a $months mois';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Il y a $years ans';
    }
  }

  Widget _buildGameScores(List<Map<String, dynamic>> scores) {
    if (scores.isEmpty) {
      return Text(
        'Aucun score de Snake pour l’instant.',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70, fontFamily: AppTextStyles.amaticSC, fontSize: 20),
        textAlign: TextAlign.center,
      );
    }

    final mutableScores = List<Map<String, dynamic>>.from(scores);
    mutableScores.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    final topScores = mutableScores.take(3).toList();

    Widget? firstPlace;
    Widget? secondPlace;
    Widget? thirdPlace;

    if (topScores.isNotEmpty) {
      firstPlace = _buildPodiumPlace(topScores[0], 1);
    }
    if (topScores.length > 1) {
      secondPlace = _buildPodiumPlace(topScores[1], 2);
    }
    if (topScores.length > 2) {
      thirdPlace = _buildPodiumPlace(topScores[2], 3);
    }

    return Column(
      children: [
        Text(
          'Podium du Serpent',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: AppTextStyles.amaticSC,
            fontSize: 28,
            shadows: [const Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(3.0, 3.0))],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (secondPlace != null) Flexible(child: secondPlace),
            if (firstPlace != null) Flexible(child: firstPlace),
            if (thirdPlace != null) Flexible(child: thirdPlace),
          ],
        ),
      ],
    );
  }

  Widget _buildPodiumPlace(Map<String, dynamic> score, int rank) {
    final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(score['timestamp']);

    final podiumConfig = {
      1: {
        'color': Colors.amber,
        'height': 160.0,
        'iconSize': 50.0,
        'gradient': const LinearGradient(colors: [Color(0xFFFFFDE7), Colors.amber], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      },
      2: {
        'color': const Color(0xFFC0C0C0),
        'height': 140.0,
        'iconSize': 40.0,
        'gradient': const LinearGradient(colors: [Color(0xFFF5F5F5), Color(0xFFBDBDBD)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      },
      3: {
        'color': const Color(0xFFCD7F32),
        'height': 120.0,
        'iconSize': 40.0,
        'gradient': const LinearGradient(colors: [Color(0xFFFFEADD), Color(0xFFD8A166)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      },
    };

    final config = podiumConfig[rank]!;
    final Color color = config['color'] as Color;
    final double height = config['height'] as double;
    final double iconSize = config['iconSize'] as double;
    final Gradient gradient = config['gradient'] as Gradient;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withAlpha(128), blurRadius: 15, spreadRadius: 5)],
          ),
          child: Icon(Icons.emoji_events, color: color, size: iconSize),
        ),
        const SizedBox(height: 8),
        Container(
          width: 100,
          height: height,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            border: Border.all(color: Colors.black.withAlpha(51)),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(77), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$rank',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withAlpha(153),
                    shadows: const [Shadow(color: Colors.white, blurRadius: 2, offset: Offset(1, 1))],
                  ),
                ),
                const Spacer(),
                Text(
                  '${score['score']}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black.withAlpha(204),
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.amaticSC,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatRelativeTime(timestamp),
                  style: TextStyle(color: Colors.black.withAlpha(179), fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCollectibleCards(List<CollectibleCard> cards) {
    if (cards.isEmpty) {
      final adRewardButton = _nextAdRewardCard != null
          ? _AdRewardButtonWidget(
              imagePath: 'assets/images/${_nextAdRewardCard!.imagePath}',
              title: _nextAdRewardCard!.title,
              icon: Icons.help_outline,
              isAdLoading: _isAdLoading,
              onTap: _showRewardedAd,
            )
          : null;
      if (adRewardButton != null) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.0),
          itemCount: 1,
          itemBuilder: (context, index) {
            return adRewardButton;
          },
        );
      } else {
        return Text(
          'Aucune carte à collectionner débloquée pour l’instant.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70, fontFamily: AppTextStyles.amaticSC, fontSize: 20),
        );
      }
    }

    final Map<String, CollectibleCard> highestTierCards = {};
    const tierPriority = {'chibi': 1, 'premium': 2, 'epic': 3};

    for (final card in cards) {
      final currentCardPriority = tierPriority[card.version.name] ?? 0;
      final existingCard = highestTierCards[card.title];

      if (existingCard == null) {
        highestTierCards[card.title] = card;
      } else {
        final existingCardPriority = tierPriority[existingCard.version.name] ?? 0;
        if (currentCardPriority > existingCardPriority) {
          highestTierCards[card.title] = card;
        }
      }
    }

    final filteredCards = highestTierCards.values.toList();
    filteredCards.sort((a, b) => a.title.compareTo(b.title));

    final adRewardButton = _nextAdRewardCard != null
        ? _AdRewardButtonWidget(
            imagePath: 'assets/images/${_nextAdRewardCard!.imagePath}',
            title: _nextAdRewardCard!.title,
            icon: Icons.help_outline,
            isAdLoading: _isAdLoading,
            onTap: _showRewardedAd,
          )
        : null;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.0),
      itemCount: filteredCards.length + (adRewardButton != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < filteredCards.length) {
          final collectibleCard = filteredCards[index];
          return InteractiveCollectibleCard(card: collectibleCard, playVideo: false)
            .animate(delay: (index * 50).ms)
            .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOutCubic)
            .fadeIn(duration: 300.ms);
        } else {
          return adRewardButton!
            .animate(delay: (index * 50).ms)
            .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOutCubic)
            .fadeIn(duration: 300.ms);
        }
      },
    );
  }

  Widget _buildUnlockedStories(List<Map<String, dynamic>> storyProgress) {
    if (storyProgress.isEmpty) {
      final adRewardStoryButton = _nextAdRewardStory != null
          ? _AdRewardButtonWidget(
              imagePath: 'assets/images/stories/${_nextAdRewardStory!.correctOrder.first.imagePath}',
              title: _nextAdRewardStory!.title,
              icon: Icons.menu_book,
              isAdLoading: _isAdLoading,
              onTap: _showRewardedStoryAd,
            )
          : null;
      if (adRewardStoryButton != null) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.0),
          itemCount: 1,
          itemBuilder: (context, index) {
            return adRewardStoryButton;
          },
        );
      } else {
        return Text(
          'Aucune histoire débloquée pour l’instant.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70, fontFamily: AppTextStyles.amaticSC, fontSize: 20),
        );
      }
    }
    final allMythStories = getMythStories();

    final adRewardStoryButton = _nextAdRewardStory != null
        ? _AdRewardButtonWidget(
            imagePath: 'assets/images/stories/${_nextAdRewardStory!.correctOrder.first.imagePath}',
            title: _nextAdRewardStory!.title,
            icon: Icons.menu_book,
            isAdLoading: _isAdLoading,
            onTap: _showRewardedStoryAd,
          )
        : null;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.0),
      itemCount: storyProgress.length + (adRewardStoryButton != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < storyProgress.length) {
          final progress = storyProgress[index];
          final storyId = progress['story_id'];
          final mythStory = allMythStories.firstWhere(
            (story) => story.title == storyId,
            orElse: () => MythStory(title: 'Histoire inconnue', correctOrder: []), // Fallback
          );
          final unlockedParts = jsonDecode(progress['parts_unlocked']) as List;
          String? lastChapterImagePath;
          if (unlockedParts.isNotEmpty) {
            final lastUnlockedChapterId = unlockedParts.last;
            final lastChapterMythCard = mythStory.correctOrder.firstWhere(
              (card) => card.id == lastUnlockedChapterId,
              orElse: () => mythStory.correctOrder.first, // Fallback to first if last not found
            );
            lastChapterImagePath = lastChapterMythCard.imagePath;
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MythStoryPage(mythStory: mythStory)));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF8B4513), width: 2),
              ),
              child: Stack(
                children: [
                  if (lastChapterImagePath != null)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(
                          'assets/images/stories/$lastChapterImagePath',
                          fit: BoxFit.cover,
                          color: Colors.black.withAlpha(102),
                          colorBlendMode: BlendMode.darken,
                        ),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          mythStory.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppTextStyles.amaticSC,
                            fontSize: 28,
                            shadows: [Shadow(blurRadius: 5.0, color: Colors.black.withAlpha(178), offset: const Offset(2.0, 2.0))],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: mythStory.correctOrder.map((chapter) {
                            final isUnlocked = unlockedParts.contains(chapter.id);
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Container(
                                width: 14,
                                height: 18,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: isUnlocked ? Colors.transparent : Colors.white.withAlpha(100)),
                                child: isUnlocked ? const Icon(Icons.emoji_emotions, color: Colors.yellow, size: 16) : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
            .animate(delay: (index * 80).ms)
            .slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOutCubic)
            .fadeIn(duration: 300.ms);
        } else {
          return adRewardStoryButton!
            .animate(delay: (index * 80).ms)
            .slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOutCubic)
            .fadeIn(duration: 300.ms);
        }
      },
    );
  }

  void _showRewardDialog({CollectibleCard? rewardCard, MythCard? unlockedStoryChapter, String? title, String? content}) {
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
                  child: const Text('OK'),
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

class _AdRewardButtonWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final IconData icon;
  final bool isAdLoading;
  final VoidCallback onTap;

  const _AdRewardButtonWidget({required this.imagePath, required this.title, required this.icon, required this.isAdLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAdLoading ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withAlpha(150), width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10, offset: Offset(0, 5))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover, color: Colors.black.withAlpha(153), colorBlendMode: BlendMode.darken),
              Center(
                child: isAdLoading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, color: Colors.white, size: MediaQuery.of(context).size.width / 6),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text('(pub)', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
