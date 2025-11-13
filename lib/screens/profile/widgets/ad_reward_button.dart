import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class AdRewardButton extends StatelessWidget {
  final String imagePath;
  final String title;
  final IconData icon;
  final bool isAdLoading;
  final VoidCallback onTap;

  const AdRewardButton({
    super.key,
    required this.imagePath,
    required this.title,
    required this.icon,
    required this.isAdLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleGestureDetector(
      onTap: isAdLoading ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withAlpha(150), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                color: Colors.black.withAlpha(153),
                colorBlendMode: BlendMode.darken,
              ),
              Center(
                child: isAdLoading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width / 6,
                          ),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'profile_screen_ad_label'.tr(),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
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
