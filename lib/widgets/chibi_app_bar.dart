import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart'; // Import the new theme file

class ChibiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final String? subtitleText;
  final List<Widget>? actions;

  const ChibiAppBar({
    super.key,
    required this.titleText,
    this.subtitleText,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      title: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titleText,
              textAlign: TextAlign.center,
              style: ChibiTextStyles.appBarTitle,
            ),
            if (subtitleText != null)
              Text(
                subtitleText!,
                textAlign: TextAlign.center,
                style: ChibiTextStyles.buttonText.copyWith(fontSize: 16),
              ),
          ],
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}