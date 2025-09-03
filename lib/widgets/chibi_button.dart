import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart'; // Added for HapticFeedback
import 'package:oracle_d_asgard/utils/chibi_theme.dart';

class ChibiButton extends StatefulWidget {
  final String? text;
  final Widget? child;
  final Color color;
  final VoidCallback? onPressed; // Made nullable
  final TextStyle? textStyle;

  const ChibiButton({super.key, this.text, required this.color, this.onPressed, this.child, this.textStyle})
    : assert(text != null || child != null, 'Either text or child must be provided');

  @override
  State<ChibiButton> createState() => _ChibiButtonState();
}

class _ChibiButtonState extends State<ChibiButton> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  bool _isPressed = false; // New state variable

  void _onTapDown(_) {
    setState(() {
      _scale = 0.95;
      _isPressed = true; // Set to true when pressed
    });
  }

  void _onTapUp(_) {
    setState(() {
      _scale = 1.0;
      _isPressed = false; // Set to false when released
    });
    HapticFeedback.mediumImpact();
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
      _isPressed = false; // Set to false if tap is cancelled
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color lightColor = lighten(widget.color, 0.2);
    final Color darkColor = darken(widget.color, 0.2);
    final Color borderColor = darken(widget.color, 0.3);

    return GestureDetector(
      onTap: widget.onPressed, // Keep original onPressed
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _isPressed ? [darkColor, widget.color, lightColor] : [lightColor, widget.color, darkColor], // Conditional gradient
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(64), offset: Offset(0, 4.h), blurRadius: 6.r)],
            border: Border.all(color: borderColor, width: 3.w),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
              color: widget.color,
              child:
                  widget.child ??
                  FittedBox(
                    fit: BoxFit.scaleDown, // Scale down if needed
                    child: Text(widget.text!, textAlign: TextAlign.center, style: widget.textStyle ?? ChibiTextStyles.buttonText),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Color lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lighter = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lighter.toColor();
  }

  Color darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darker = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darker.toColor();
  }
}
