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
import 'package:oracle_d_asgard/data/app_data.dart';
import 'package:oracle_d_asgard/models/deity.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Map<String, MythCard> _allMythCards;
  String? _profileName;
  final TextEditingController _nameController = TextEditingController();
  bool _isNameHovered = false;
  String? _selectedDeityId;
  bool _isDeityIconHovered = false;

  Future<List<dynamic>>? _mainDataFuture;
  Future<List<Map<String, dynamic>>>? _quizResultsFuture;

  @override
  void initState() {
    super.initState();
    _loadAllMythCards();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize futures only once
    if (_mainDataFuture == null) {
      final gamificationService = Provider.of<GamificationService>(context, listen: false);
      _mainDataFuture = Future.wait([
        gamificationService.getGameScores('Snake'),
        gamificationService.getUnlockedCollectibleCards(),
        gamificationService.getUnlockedStoryProgress(),
        gamificationService.getProfileName(),
        gamificationService.getProfileDeityIcon(), // Load the selected deity icon
      ]);
      _quizResultsFuture = gamificationService.getQuizResults();
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
          backgroundColor: Colors.grey[900],
          title: const Text('Changer le nom', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _nameController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Nouveau nom',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sauvegarder', style: TextStyle(color: Colors.amber)),
              onPressed: () {
                Provider.of<GamificationService>(context, listen: false).saveProfileName(_nameController.text);
                setState(() {
                  _profileName = _nameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSelectDeityIconDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Choisir une icône de divinité', style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: AppData.deities.length,
              itemBuilder: (context, index) {
                final deity = AppData.deities.values.elementAt(index);
                final isSelected = _selectedDeityId == deity.id;
                return GestureDetector(
                  onTap: () {
                    Provider.of<GamificationService>(context, listen: false).saveProfileDeityIcon(deity.id);
                    setState(() {
                      _selectedDeityId = deity.id;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: isSelected ? Colors.amber : Colors.transparent, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(deity.icon, fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // Changed _allCollectibleCards to store all versions, keyed by id_version
  
  void _loadAllMythCards() {
    _allMythCards = {};
    for (var story in getMythStories()) {
      for (var card in story.correctOrder) {
        _allMythCards[card.id] = card;
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () async {
              final gamificationService = Provider.of<GamificationService>(context, listen: false);
              final quizResults = await gamificationService.getQuizResults();
              if (quizResults.isNotEmpty) {
                final lastQuizResult = quizResults.first;
                final deityName = lastQuizResult['deity_name'];
                final Deity? deity = AppData.deities[deityName.toLowerCase()];
                if (deity != null) {
                  SharePlus.instance.share(
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ShareParams(text: "Mon résultat au quiz Oracle d'Asgard : Je suis ${deity.name} ! Découvrez votre divinité sur l'application !"),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: AppBackground(
        child: Consumer<GamificationService>(
          builder: (context, gamificationService, child) {
            return FutureBuilder<List<dynamic>>(
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
                  final String? savedDeityIconId = snapshot.data![4]; // New: saved deity icon ID

                  // Set the initial name from saved data if it exists and local state is not set
                  if (_profileName == null && savedName != null) {
                    _profileName = savedName;
                  }
                  // Set the initial deity icon from saved data if it exists and local state is not set
                  if (_selectedDeityId == null && savedDeityIconId != null) {
                    _selectedDeityId = savedDeityIconId;
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _quizResultsFuture,
                        builder: (context, quizSnapshot) {
                          if (quizSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (quizSnapshot.hasError) {
                            return Center(child: Text('Error loading quiz result: ${quizSnapshot.error}'));
                          } else if (!quizSnapshot.hasData || quizSnapshot.data!.isEmpty) {
                            return const SizedBox.shrink(); // No quiz results yet
                          } else {
                            final lastQuizResult = quizSnapshot.data!.first;
                            final deityName = lastQuizResult['deity_name'];
                            final Deity? deity = AppData.deities[deityName.toLowerCase()];

                            if (deity == null) {
                              return const SizedBox.shrink(); // Deity not found
                            }

                            // Set the name from deity if no saved name and no local state
                            _profileName ??= deity.name;

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () => _showEditNameDialog(context),
                                  child: MouseRegion(
                                    onEnter: (_) => setState(() => _isNameHovered = true),
                                    onExit: (_) => setState(() => _isNameHovered = false),
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
                                                  shadows: [
                                                    const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))
                                                  ],
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        AnimatedOpacity(
                                          duration: const Duration(milliseconds: 200),
                                          opacity: _isNameHovered ? 1.0 : 0.0,
                                          child: const Icon(Icons.edit, color: Colors.white, size: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () => _showSelectDeityIconDialog(context),
                                  child: MouseRegion(
                                    onEnter: (_) => setState(() => _isDeityIconHovered = true),
                                    onExit: (_) => setState(() => _isDeityIconHovered = false),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(
                                              color: const Color(0xFFDAA520),
                                              width: 5,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0xFFDAA520),
                                                offset: Offset(5, 5),
                                              ),
                                              BoxShadow(
                                                color: Color(0xFFFFD700),
                                                offset: Offset(-5, -5),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.asset(
                                              AppData.deities[_selectedDeityId]?.icon ?? deity.icon,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          duration: const Duration(milliseconds: 200),
                                          opacity: _isDeityIconHovered ? 1.0 : 0.0,
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withAlpha(128),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: const Icon(Icons.edit, color: Colors.white, size: 40),
                                          ),
                                        ),
                                      ],
                                    ),
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

  Widget _buildSoundSettings() {
    return Consumer<SoundService>(
      builder: (context, soundService, child) {
        return Card(
          color: Colors.white.withAlpha(25),
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Musique d\'ambiance',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: AppTextStyles.amaticSC, fontSize: 22),
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
      },
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
          return "À l’instant";
        }
        return "Il y a ${difference.inMinutes} min";
      }
      return "Aujourd’hui à ${DateFormat('HH:mm').format(timestamp)}";
    } else if (difference.inDays == 1) {
      return "Hier à ${DateFormat('HH:mm').format(timestamp)}";
    } else if (difference.inDays < 7) {
      return "Il y a ${difference.inDays} jours";
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return "Il y a $weeks sem";
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "Il y a $months mois";
    } else {
      final years = (difference.inDays / 365).floor();
      return "Il y a $years ans";
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

    // Define properties for each rank
    final podiumConfig = {
      1: {'color': Colors.amber, 'height': 160.0, 'iconSize': 50.0, 'gradient': const LinearGradient(colors: [Color(0xFFFFFDE7), Colors.amber], begin: Alignment.topCenter, end: Alignment.bottomCenter)},
      2: {'color': const Color(0xFFC0C0C0), 'height': 140.0, 'iconSize': 40.0, 'gradient': const LinearGradient(colors: [Color(0xFFF5F5F5), Color(0xFFBDBDBD)], begin: Alignment.topCenter, end: Alignment.bottomCenter)},
      3: {'color': const Color(0xFFCD7F32), 'height': 120.0, 'iconSize': 40.0, 'gradient': const LinearGradient(colors: [Color(0xFFFFEADD), Color(0xFFD8A166)], begin: Alignment.topCenter, end: Alignment.bottomCenter)},
    };

    final config = podiumConfig[rank]!;
    final Color color = config['color'] as Color;
    final double height = config['height'] as double;
    final double iconSize = config['iconSize'] as double;
    final Gradient gradient = config['gradient'] as Gradient;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Trophy with a subtle glow
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(128),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            Icons.emoji_events,
            color: color,
            size: iconSize,
          ),
        ),
        const SizedBox(height: 8),
        // Podium Block
        Container(
          width: 100,
          height: height,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border.all(color: Colors.black.withAlpha(51)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(77),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
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
                    shadows: const [
                      Shadow(
                        color: Colors.white,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      )
                    ],
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
      return Text(
        'Aucune carte à collectionner débloquée pour l’instant.',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70, fontFamily: AppTextStyles.amaticSC, fontSize: 20),
      );
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
    // Sort cards for a consistent display order, for example by name.
    filteredCards.sort((a, b) => a.title.compareTo(b.title));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.0),
      itemCount: filteredCards.length,
      itemBuilder: (context, index) {
        final collectibleCard = filteredCards[index];
        return InteractiveCollectibleCard(card: collectibleCard);
      },
    );
  }

  Widget _buildUnlockedStories(List<Map<String, dynamic>> storyProgress) {
    if (storyProgress.isEmpty) {
      return Text(
        'Aucune histoire débloquée pour l’instant.',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70, fontFamily: AppTextStyles.amaticSC, fontSize: 20),
      );
    }
    final allMythStories = getMythStories();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.0),
      itemCount: storyProgress.length,
      itemBuilder: (context, index) {
        final progress = storyProgress[index];
        final storyId = progress['story_id'];
        final mythStory = allMythStories.firstWhere(
          (story) => story.title == storyId,
          orElse: () => MythStory(title: 'Histoire inconnue', correctOrder: [], collectibleCards: []), // Fallback
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
              border: Border.all(color: const Color(0xFF8B4513), width: 2), // Brown border for book effect
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
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  color: Colors.black.withAlpha(178),
                                  offset: const Offset(2.0, 2.0),
                                ),
                              ],
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
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isUnlocked ? Colors.yellow : Colors.white.withAlpha(128),
                                boxShadow: isUnlocked
                                    ? [
                                        const BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isUnlocked
                                  ? SvgPicture.asset(
                                      'assets/images/happy_face.svg',
                                      width: 12,
                                      height: 12,
                                    )
                                  : null,
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
        );
      },
    );
  }
}