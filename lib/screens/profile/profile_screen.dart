import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/data/app_data.dart';
import 'package:oracle_d_asgard/models/deity.dart';
import 'package:oracle_d_asgard/models/card_version.dart';
import 'package:oracle_d_asgard/data/collectible_cards_data.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/screens/profile/widgets/profile_header.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/services/quiz_service.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_icon_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _profileName;
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDeityId;

  Future<List<dynamic>>? _profileDataFuture;
  List<Deity> _allSelectableDeities = [];

  @override
  void initState() {
    super.initState();
    _refreshProfileData();
  }

  Future<void> _loadSelectableDeities() async {
    final gamificationService = getIt<GamificationService>();

    final allPossibleQuizDeityIds = QuizService.getAllowedQuizDeityIds()
        .toSet();
    final allChibiCards = allCollectibleCards
        .where((card) => card.version == CardVersion.chibi)
        .toList();
    final allChibiCardsMap = {for (var card in allChibiCards) card.id: card};
    final unlockedCards = await gamificationService
        .getUnlockedCollectibleCards();
    final unlockedCardIds = unlockedCards.map((card) => card.id).toSet();

    final List<Deity> tempDeities = [];
    final Set<String> addedDeityIds = {};

    final allDeityOptions = <String>{};
    allDeityOptions.addAll(allPossibleQuizDeityIds);
    allDeityOptions.addAll(unlockedCardIds);

    for (final deityId in allDeityOptions) {
      if (addedDeityIds.contains(deityId)) continue;

      if (unlockedCardIds.contains(deityId)) {
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

    setState(() {
      _profileDataFuture = Future.wait([
        gamificationService.getProfileName(),
        gamificationService.getProfileDeityIcon(),
        gamificationService.getQuizResults(),
      ]);
    });
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
                ChibiIconButton(
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.cancel, color: Colors.white),
                ),
                ChibiIconButton(
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
                  icon: const Icon(Icons.save, color: Colors.white),
                ),
              ],
            ),
          ],
        );
      },
    );
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
            icon: const Icon(Icons.shield, color: Colors.white),
            onPressed: () {
              context.go('/trophies');
            },
          ),
        ],
      ),
      body: AppBackground(
        child: Container(
          color: Colors.black.withAlpha(128),
          child: FutureBuilder<List<dynamic>>(
            future: _profileDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${'profile_screen_error_prefix'.tr()}: ${snapshot.error}',
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final String? savedName = snapshot.data![0];
                final String? savedDeityIconId = snapshot.data![1];
                final List<Map<String, dynamic>> quizResults =
                    snapshot.data![2];

                if (_profileName == null && savedName != null) {
                  _profileName = savedName;
                }
                if (quizResults.isNotEmpty) {
                  final lastQuizResult = quizResults.first;
                  final deityName = lastQuizResult['deity_name'];
                  _profileName ??= deityName;
                }

                if (_selectedDeityId == null && savedDeityIconId != null) {
                  _selectedDeityId = savedDeityIconId;
                }

                return ListView(
                  padding: EdgeInsets.only(
                    top: kToolbarHeight + 40,
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  children: [
                    ProfileHeader(
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
                        getIt<GamificationService>().saveProfileDeityIcon(
                          newDeityId,
                        );
                        _refreshProfileData();
                      },
                      onEditName: () => _showEditNameDialog(context),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
