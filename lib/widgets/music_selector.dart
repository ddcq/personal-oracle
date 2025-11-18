import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class MusicSelector extends StatelessWidget {
  final String label;
  final SoundService soundService;
  final Future<List<CollectibleCard>> unlockedCardsFuture;
  final Function(String?) onChanged;
  final bool isReadingMusic; // true for reading music, false for ambient music

  const MusicSelector({
    super.key,
    required this.label,
    required this.soundService,
    required this.unlockedCardsFuture,
    required this.onChanged,
    this.isReadingMusic = false,
  });

  String _getCurrentValue() {
    if (isReadingMusic) {
      if (soundService.isReadingPageMusicMuted) {
        return 'mute';
      } else if (soundService.readingPageMusicCardId != null) {
        return soundService.readingPageMusicCardId!;
      } else if (soundService.readingPageMusicAsset != null) {
        return soundService.readingPageMusicAsset!;
      } else {
        return 'default';
      }
    } else {
      if (soundService.isMuted) {
        return 'mute';
      } else if (soundService.currentAmbientMusicCardId != null) {
        return soundService.currentAmbientMusicCardId!;
      } else {
        return 'default';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: AppTextStyles.amaticSC,
              fontSize: 22,
            ),
          ),
          ListenableBuilder(
            listenable: soundService,
            builder: (context, child) {
              return FutureBuilder<List<CollectibleCard>>(
                future: unlockedCardsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text(
                      'Error',
                      style: TextStyle(color: Colors.white),
                    );
                  }

                  final unlockedCards = snapshot.data ?? [];
                  final List<DropdownMenuItem<String>> items = [
                    DropdownMenuItem<String>(
                      value: 'mute',
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          'settings_screen_sound_mute'.tr(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'default',
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          'settings_screen_sound_default'.tr(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ];

                  final Set<String> addedCardIds = {};
                  for (var card in unlockedCards) {
                    if (addedCardIds.add(card.id)) {
                      items.add(
                        DropdownMenuItem<String>(
                          value: card.id,
                          child: SizedBox(
                            width: 120,
                            child: Text(
                              'collectible_card_${card.id}_title'.tr(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    }
                  }

                  String value = _getCurrentValue();
                  // Ensure currentValue is in the list of items, otherwise default to 'default'
                  if (items.where((item) => item.value == value).isEmpty) {
                    value = 'default';
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: value,
                      underline: const SizedBox(),
                      dropdownColor: Colors.black87,
                      style: const TextStyle(color: Colors.white),
                      items: items,
                      onChanged: onChanged,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
