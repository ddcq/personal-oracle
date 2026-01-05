import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';

class EpicButton extends StatefulWidget {
  const EpicButton({super.key, this.iconData, this.imagePath, this.onPressed, this.label, this.size})
    : assert(iconData != null || imagePath != null, 'Either iconData or imagePath must be provided.');

  final IconData? iconData;
  final String? imagePath;
  final VoidCallback? onPressed;
  final String? label;
  final double? size;

  @override
  State<EpicButton> createState() => _EpicButtonState();
}

class _EpicButtonState extends State<EpicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.size ?? 70.sp;
    List<Widget> stackChildren = [];

    if (widget.imagePath != null) {
      stackChildren.add(
        Transform(
          transform: Matrix4.translationValues(-buttonSize / 11, _isPressed ? (-buttonSize / 50) : (-buttonSize / 17.5), 0.0)
            ..setEntry(3, 2, 0.015)
            ..rotateX(-0.7)
            ..rotateZ(-0.5),
          child: Image.asset(widget.imagePath!, width: buttonSize / 3, height: buttonSize / 3, fit: BoxFit.contain),
        ),
      );
    } else {
      stackChildren.add(
        Transform(
          transform: Matrix4.translationValues(-6.0.sp, _isPressed ? 1.0.sp : -4.0.sp, 0.0)
            ..setEntry(3, 2, 0.015)
            ..rotateX(-0.7)
            ..rotateZ(-0.5),
          child: Transform.scale(
            scale: 0.9,
            child: Icon(widget.iconData!, size: 28.sp, color: const Color.fromARGB(255, 220, 255, 255).withAlpha(204)),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onPressed,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(_isPressed ? 'assets/images/pressed_button.webp' : 'assets/images/button.webp'), fit: BoxFit.contain),
            ),
            child: Stack(alignment: Alignment.center, children: stackChildren),
          ),
        ),
        if (widget.label != null) Text(widget.label!, style: ChibiTextStyles.buttonText.copyWith(fontSize: 10.0.sp)),
      ],
    );
  }
}
