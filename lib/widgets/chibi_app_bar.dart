import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';

class ChibiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final List<Widget>? actions;
  final Widget? leading;

  const ChibiAppBar({super.key, required this.titleText, this.actions, this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: leading == null,
      leading: leading,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      title: LayoutBuilder(
        builder: (context, constraints) {
          final isHeightFinite = constraints.maxHeight.isFinite;

          final titleStyle = ChibiTextStyles.appBarTitle.copyWith(
            fontSize: isHeightFinite ? constraints.maxHeight * 0.6 : 30.0, // Fallback to 30.0
          );


          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                titleText,
                textAlign: TextAlign.center,
                style: titleStyle,
                softWrap: false, // Keep on one line
                overflow: TextOverflow.ellipsis, // Add ellipsis if it still overflows horizontally
              ),
            ],
          );
        },
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
