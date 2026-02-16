import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/providers/responsive_provider.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/chibi_text_button.dart';

class GuideJormungandrPopup extends StatelessWidget {
  final VoidCallback onStartGame;

  const GuideJormungandrPopup({super.key, required this.onStartGame});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
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
              'widgets_guide_jormungandr_popup_title'.tr(),
              style: ChibiTextStyles.overlayTitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsive.height(8)),
            Text(
              'widgets_guide_jormungandr_popup_description'.tr(),
              style: TextStyle(color: Colors.white70, fontSize: responsive.sp(14)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsive.height(8)),
            Text(
              'widgets_guide_jormungandr_popup_controls'.tr(),
              style: TextStyle(color: Colors.white54, fontSize: responsive.sp(12)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsive.height(16)),
            ChibiTextButton(
              text: 'widgets_guide_jormungandr_popup_start_button'.tr(),
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
