import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:oracle_d_asgard/widgets/chibi_icon_button.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/models/card_version.dart';

import 'package:oracle_d_asgard/data/collectible_cards_data.dart';
import 'package:oracle_d_asgard/data/stories_data.dart';
import 'package:oracle_d_asgard/services/database_service.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/locator.dart';

class DevToolsWidget extends StatelessWidget {
  final VoidCallback? onVictoryPopupTest;
  final Function(String message) onShowSnackBar;

  const DevToolsWidget({
    super.key,
    this.onVictoryPopupTest,
    required this.onShowSnackBar,
  });

  Future<void> _clearAndRebuildDatabase() async {
    final dbService = getIt<DatabaseService>();
    try {
      await dbService.deleteDb();
      await dbService.reinitializeDb();
      onShowSnackBar('profile_screen_database_cleared_success'.tr());
    } catch (e) {
      onShowSnackBar('${'profile_screen_database_clear_failed'.tr()}: $e');
    }
  }

  Future<void> _unlockAllCollectibleCards(CardVersion version) async {
    final gamificationService = getIt<GamificationService>();
    final allCardsOfVersion = allCollectibleCards
        .where((card) => card.version == version)
        .toList();
    for (var card in allCardsOfVersion) {
      await gamificationService.unlockCollectibleCard(card);
    }
    onShowSnackBar(
      'profile_screen_all_cards_unlocked'.tr(
        namedArgs: {'version': version.name},
      ),
    );
  }

  Future<void> _unlockAllStories() async {
    final gamificationService = getIt<GamificationService>();
    final allStories = getMythStories();
    for (var story in allStories) {
      await gamificationService.unlockStory(
        story.id,
        story.correctOrder.map((card) => card.id).toList(),
      );
    }
    onShowSnackBar('profile_screen_all_stories_unlocked'.tr());
  }

  void _showRandomVictoryPopup() {
    if (onVictoryPopupTest != null) {
      onVictoryPopupTest!();
    }
  }

  Future<void> _clearCache() async {
    try {
      await DefaultCacheManager().emptyCache();
      onShowSnackBar('profile_screen_cache_cleared_success'.tr());
    } catch (e) {
      onShowSnackBar('${'profile_screen_cache_clear_failed'.tr()}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChibiIconButton(
              color: ChibiColors.buttonRed,
              onPressed: _clearAndRebuildDatabase,
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 20,
              ),
            ),
            ChibiIconButton(
              color: ChibiColors.buttonBlue,
              onPressed: _unlockAllStories,
              icon: const Icon(Icons.book, color: Colors.white, size: 20),
            ),
            ChibiIconButton(
              color: ChibiColors.buttonPurple,
              onPressed: _showRandomVictoryPopup,
              icon: const Icon(
                Icons.celebration,
                color: Colors.white,
                size: 20,
              ),
            ),
            ChibiIconButton(
              color: ChibiColors.buttonYellow,
              onPressed: _clearCache,
              icon: const Icon(
                Icons.cleaning_services,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChibiIconButton(
              color: ChibiColors.buttonGreen,
              onPressed: () => _unlockAllCollectibleCards(CardVersion.chibi),
              icon: const Icon(
                Icons.card_giftcard,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 20.w),
            ChibiIconButton(
              color: ChibiColors.buttonOrange,
              onPressed: () => _unlockAllCollectibleCards(CardVersion.premium),
              icon: const Icon(
                Icons.card_membership,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 20.w),
            ChibiIconButton(
              color: ChibiColors.buttonYellow,
              onPressed: () => _unlockAllCollectibleCards(CardVersion.epic),
              icon: const Icon(Icons.diamond, color: Colors.white, size: 20),
            ),
          ],
        ),
      ],
    );
  }
}
