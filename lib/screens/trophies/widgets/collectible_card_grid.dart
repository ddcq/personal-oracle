import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/screens/trophies/widgets/ad_reward_button.dart';
import 'package:oracle_d_asgard/widgets/interactive_collectible_card.dart';

class CollectibleCardGrid extends StatelessWidget {
  final List<CollectibleCard> cards;
  final CollectibleCard? nextAdRewardCard;
  final bool isAdLoading;
  final VoidCallback showRewardedAd;

  const CollectibleCardGrid({
    super.key,
    required this.cards,
    this.nextAdRewardCard,
    required this.isAdLoading,
    required this.showRewardedAd,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      final adRewardButton = nextAdRewardCard != null
          ? AdRewardButton(
              imagePath: 'assets/images/${nextAdRewardCard!.imagePath}',
              title: nextAdRewardCard!.title,
              icon: Icons.help_outline,
              isAdLoading: isAdLoading,
              onTap: showRewardedAd,
            )
          : null;
      if (adRewardButton != null) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: 1,
          itemBuilder: (context, index) {
            return adRewardButton;
          },
        );
      } else {
        return Text(
          'profile_screen_no_collectible_cards'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white70,
            fontFamily: 'AmaticSC',
            fontSize: 20,
          ),
        );
      }
    }

    final Map<String, CollectibleCard> highestTierCards = {};
    const tierPriority = {'chibi': 1, 'premium': 2, 'epic': 3};

    for (final card in cards) {
      final currentCardPriority = tierPriority[card.version.name] ?? 0;
      final existingCard = highestTierCards[card.id];

      if (existingCard == null) {
        highestTierCards[card.id] = card;
      } else {
        final existingCardPriority =
            tierPriority[existingCard.version.name] ?? 0;
        if (currentCardPriority > existingCardPriority) {
          highestTierCards[card.id] = card;
        }
      }
    }

    final filteredCards = highestTierCards.values.toList();
    filteredCards.sort((a, b) => a.id.compareTo(b.id));

    final adRewardButton = nextAdRewardCard != null
        ? AdRewardButton(
            imagePath: 'assets/images/${nextAdRewardCard!.imagePath}',
            title: nextAdRewardCard!.title,
            icon: Icons.help_outline,
            isAdLoading: isAdLoading,
            onTap: showRewardedAd,
          )
        : null;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: filteredCards.length + (adRewardButton != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < filteredCards.length) {
          final collectibleCard = filteredCards[index];
          return InteractiveCollectibleCard(
                card: collectibleCard,
                playVideo: false,
              )
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
}
