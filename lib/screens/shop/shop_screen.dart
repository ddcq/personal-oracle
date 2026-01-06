import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/models/myth_story.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:easy_localization/easy_localization.dart';

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
    final availableCards =
        unearnedContent['unearned_collectible_cards'] as List<CollectibleCard>;
    availableCards.sort((a, b) => a.price.compareTo(b.price));
    final availableStories =
        unearnedContent['unearned_myth_stories'] as List<MythStory>;

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

  Future<void> _buyCard(CollectibleCard card) async {
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
          content: Text('shop_bought_card'.tr(args: [card.title])),
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
  }

  Future<void> _buyStory(MythStory story, int price) async {
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
            content: Text(
              'shop_bought_story_part'.tr(args: [story.title.tr()]),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('shop_title'.tr()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        imagePath: 'assets/images/backgrounds/main.jpg',
        child: FutureBuilder<Map<String, dynamic>>(
          future: _shopDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Aucune donnée disponible'));
            }

            final coins = snapshot.data!['coins'] as int;
            final availableCards =
                snapshot.data!['availableCards'] as List<CollectibleCard>;
            final availableStories =
                snapshot.data!['availableStories']
                    as List<Map<String, dynamic>>;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 80.0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Colors.amber,
                            size: 30,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            coins.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          return Card(
                            color: Colors.black.withAlpha(200),
                            child: InkWell(
                              onTap: () => _buyCard(card),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      'assets/images/${card.imagePath}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      card.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.monetization_on,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          card.price.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                          return Card(
                            color: Colors.black.withAlpha(200),
                            child: InkWell(
                              onTap: () => _buyStory(story, price),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: imagePath.isNotEmpty
                                        ? Image.asset(
                                            'assets/images/stories/$imagePath',
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(
                                            Icons.book,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      story.title.tr(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.monetization_on,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          price.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
