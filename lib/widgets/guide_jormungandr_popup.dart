import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

class GuideJormungandrPopup extends StatelessWidget {
  final VoidCallback onStartGame;

  const GuideJormungandrPopup({super.key, required this.onStartGame});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F23),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF22C55E)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Guide Jörmungandr',
              style: ChibiTextStyles.overlayTitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              '''Aide le serpent-monde à grandir
en dévorant les offrandes des mortels''',
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              '''⌨️ Contrôles:
↑↓←→ Flèches | R: Recommencer''',
              style: TextStyle(color: Colors.white54, fontSize: 12.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ChibiButton(
              text: 'Réveiller le Serpent',
              color: const Color(0xFF22C55E),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onStartGame(); // Trigger game start
              },
            ),
          ],
        ),
      ),
    );
  }
}
