import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart'; // Import the new theme file

class ChibiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  const ChibiAppBar({super.key, required this.titleText});

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
        child: Text(
          titleText,
          textAlign: TextAlign.center,
          style: ChibiTextStyles.appBarTitle, // Use the new text style
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
