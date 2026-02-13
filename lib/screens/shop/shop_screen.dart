import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oracle_d_asgard/widgets/epic_button.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late Future<Map<String, dynamic>> _shopDataFuture;

  @override
  void initState() {
    super.initState();
    _shopDataFuture = _fetchShopData();
  }

  Future<Map<String, dynamic>> _fetchShopData() async {
    final gamificationService = getIt<GamificationService>();
    final coins = await gamificationService.getCoins();
    final unearnedContent = await gamificationService.getUnearnedContent();
    final availableCards = unearnedContent.collectibleCards;
    availableCards.sort((a, b) => a.price.compareTo(b.price));
    final availableStories = unearnedContent.mythStories;

    // For stories, we need to know the price of the *next* unearned chapter
    final List<Map<String, dynamic>> storiesWithPrices = [];
    for (var story in availableStories) {
      final unlockedChaptersCount = await gamificationService
          .getUnlockedChapterCountForStory(story.id);
      final price = _calculateStoryPrice(unlockedChaptersCount);
      final imagePath = (unlockedChaptersCount < story.correctOrder.length)
          ? story.correctOrder[unlockedChaptersCount].imagePath
          : ''; // Default or error image
      storiesWithPrices.add({
        'story': story,
        'price': price,
        'imagePath': imagePath,
      });
    }

    // Sort stories by price
    storiesWithPrices.sort(
      (a, b) => (a['price'] as int).compareTo(b['price'] as int),
    );

    return {
      'coins': coins,
      'availableCards': availableCards,
      'availableStories': storiesWithPrices,
    };
  }

  int _calculateStoryPrice(int unlockedChaptersCount) {
    if (unlockedChaptersCount == 0) {
      return 40;
    } else {
      return 40 + (unlockedChaptersCount * 10);
    }
  }

  Future<void> _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String itemName,
    required int price,
    required String imagePath,
    required VoidCallback onConfirm,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withAlpha(217),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.amber, width: 2),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(imagePath, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  itemName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      price.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EpicButton(
                  iconData: Icons.close,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: 'cancel'.tr(),
                ),
                EpicButton(
                  iconData: Icons.check,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  label: 'confirm'.tr(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _buyCard(CollectibleCard card) async {
    _showConfirmationDialog(
      context: context,
      title: 'shop_buy_card_title'.tr(),
      itemName: card.title,
      price: card.price,
      imagePath: 'assets/images/${card.imagePath}',
      onConfirm: () async {
        final gamificationService = getIt<GamificationService>();
        final currentCoins = await gamificationService.getCoins();

        if (currentCoins >= card.price) {
          await gamificationService.saveCoins(currentCoins - card.price);
          await gamificationService.unlockCollectibleCard(card);
          setState(() {
            _shopDataFuture = _fetchShopData();
          });
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'shop_bought_card_prefix'.tr()),
                    TextSpan(
                      text: '«${card.title}»',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: 'shop_bought_card_suffix'.tr()),
                  ],
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('shop_not_enough_coins'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  Future<void> _buyStory(MythStory story, int price, String imagePath) async {
    _showConfirmationDialog(
      context: context,
      title: 'shop_buy_story_title'.tr(),
      itemName: story.title.tr(),
      price: price,
      imagePath: imagePath,
      onConfirm: () async {
        final gamificationService = getIt<GamificationService>();
        final currentCoins = await gamificationService.getCoins();

        if (currentCoins >= price) {
          final unlockedChaptersCount = await gamificationService
              .getUnlockedChapterCountForStory(story.id);
          final nextChapterIndex = unlockedChaptersCount;

          if (nextChapterIndex < story.correctOrder.length) {
            final nextChapterId = story.correctOrder[nextChapterIndex].id;
            await gamificationService.saveCoins(currentCoins - price);
            await gamificationService.unlockStoryPart(story.id, nextChapterId);
            setState(() {
              _shopDataFuture = _fetchShopData();
            });
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'shop_bought_story_part_prefix'.tr()),
                      TextSpan(
                        text: '«${story.title.tr()}»',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'shop_bought_story_part_suffix'.tr()),
                    ],
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('shop_story_all_unlocked'.tr()),
                backgroundColor: Colors.blue,
              ),
            );
          }
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('shop_not_enough_coins'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _shopDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: AppBackground(
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('shop_title'.tr())),
            body: AppBackground(
              child: Center(child: Text('Erreur: ${snapshot.error}')),
            ),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text('shop_title'.tr())),
            body: const AppBackground(
              child: Center(child: Text('Aucune donnée disponible')),
            ),
          );
        }

        final coins = snapshot.data!['coins'] as int;
        final availableCards =
            snapshot.data!['availableCards'] as List<CollectibleCard>;
        final availableStories =
            snapshot.data!['availableStories'] as List<Map<String, dynamic>>;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('shop_title'.tr()),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      coins.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: AppBackground(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: kToolbarHeight + MediaQuery.of(context).padding.top,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'shop_cards_section_title'.tr(),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    if (availableCards.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'shop_no_cards_available'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.7,
                            ),
                        itemCount: availableCards.length,
                        itemBuilder: (context, index) {
                          final card = availableCards[index];
                          final canAfford = coins >= card.price;
                          return Opacity(
                            opacity: canAfford ? 1.0 : 0.5,
                            child: Card(
                              color: Colors.black.withAlpha(200),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: canAfford ? () => _buyCard(card) : null,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                        child: Image.asset(
                                          'assets/images/${card.imagePath}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 48,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        child: Text(
                                          card.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.monetization_on,
                                            color: canAfford
                                                ? Colors.amber
                                                : Colors.grey,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            card.price.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: canAfford
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'shop_stories_section_title'.tr(),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    if (availableStories.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'shop_no_stories_available'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.7,
                            ),
                        itemCount: availableStories.length,
                        itemBuilder: (context, index) {
                          final storyData = availableStories[index];
                          final story = storyData['story'] as MythStory;
                          final price = storyData['price'] as int;
                          final imagePath = storyData['imagePath'] as String;
                          final canAfford = coins >= price;
                          return Opacity(
                            opacity: canAfford ? 1.0 : 0.5,
                            child: Card(
                              color: Colors.black.withAlpha(200),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: canAfford
                                    ? () => _buyStory(
                                        story,
                                        price,
                                        imagePath.isNotEmpty
                                            ? 'assets/images/stories/$imagePath'
                                            : 'assets/images/icons/story.png',
                                      )
                                    : null,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                        child: imagePath.isNotEmpty
                                            ? Image.asset(
                                                'assets/images/stories/$imagePath',
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                color: Colors.black54,
                                                child: const Icon(
                                                  Icons.book,
                                                  color: Colors.white,
                                                  size: 50,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 48,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        child: Text(
                                          story.title.tr(),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.monetization_on,
                                            color: canAfford
                                                ? Colors.amber
                                                : Colors.grey,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            price.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: canAfford
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
