import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/models/deity.dart';
import 'package:oracle_d_asgard/screens/profile/deity_selection_screen.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/custom_video_player.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class ProfileHeader extends StatelessWidget {
  final String? profileName;
  final String? selectedDeityId;
  final List<Deity> allSelectableDeities;
  final Function(String) onNameChanged;
  final Function(String) onDeityChanged;
  final Function() onEditName;
  final int? coins; // Add coins parameter

  const ProfileHeader({
    super.key,
    required this.profileName,
    required this.selectedDeityId,
    required this.allSelectableDeities,
    required this.onNameChanged,
    required this.onDeityChanged,
    required this.onEditName,
    this.coins, // Initialize coins
  });

  @override
  Widget build(BuildContext context) {
    final displayDeity = allSelectableDeities.firstWhereOrNull(
      (d) => d.id == selectedDeityId,
    );
    final deityName = displayDeity?.name ?? '';

    return Column(
      children: [
        SimpleGestureDetector(
          onTap: () => onEditName(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  profileName ?? deityName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontFamily: AppTextStyles.amaticSC,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 70,
                    letterSpacing: 2.0,
                    shadows: [
                      const Shadow(
                        blurRadius: 15.0,
                        color: Colors.black87,
                        offset: Offset(4.0, 4.0),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.edit, color: Colors.white, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (coins != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monetization_on, color: Colors.amber, size: 30),
              SizedBox(width: 5),
              Text(
                coins.toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: AppTextStyles.amaticSC,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  shadows: [
                    const Shadow(
                      blurRadius: 5.0,
                      color: Colors.black54,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        const SizedBox(height: 20),
        SimpleGestureDetector(
          onTap: () async {
            final newDeityId = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DeitySelectionScreen(currentDeityId: selectedDeityId ?? ''),
              ),
            );

            if (newDeityId != null && newDeityId != selectedDeityId) {
              onDeityChanged(newDeityId);
              await getIt<GamificationService>().saveProfileDeityIcon(
                newDeityId,
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (allSelectableDeities.isEmpty)
                _buildDeityDisplayPlaceholder()
              else
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color.fromARGB(255, 0, 28, 71),
                      width: 5,
                    ), // Change to deep blue
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 0, 26, 65),
                        offset: Offset(5, 5),
                      ), // Change to deep blue
                      BoxShadow(
                        color: const Color.fromARGB(255, 0, 59, 117),
                        offset: Offset(-5, -5),
                      ), // Change to slightly lighter deep blue
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Builder(
                      builder: (context) {
                        if (displayDeity == null) {
                          return _buildDeityDisplayPlaceholder(error: true);
                        }

                        Widget deityImageWidget;
                        if (displayDeity.videoUrl != null &&
                            displayDeity.videoUrl!.isNotEmpty) {
                          deityImageWidget = CustomVideoPlayer(
                            videoUrl: displayDeity.videoUrl!,
                            placeholderAsset: displayDeity.icon,
                          );
                        } else {
                          deityImageWidget = Image.asset(
                            displayDeity.icon,
                            fit: BoxFit.cover,
                          );
                        }

                        if (displayDeity.isCollectibleCard) {
                          return Transform.translate(
                            offset: const Offset(0, 15), // 10% of 150px height
                            child: Transform.scale(
                              scale: 1.4,
                              child: deityImageWidget,
                            ),
                          );
                        } else {
                          return deityImageWidget;
                        }
                      },
                    ),
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

  Widget _buildDeityDisplayPlaceholder({bool error = false}) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromARGB(255, 0, 28, 71),
          width: 5,
        ), // Change to deep blue
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 26, 65),
            offset: Offset(5, 5),
          ), // Change to deep blue
          BoxShadow(
            color: const Color.fromARGB(255, 0, 59, 117),
            offset: Offset(-5, -5),
          ), // Change to slightly lighter deep blue
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Center(
          child: error
              ? const Icon(Icons.error, color: Colors.red, size: 50)
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
