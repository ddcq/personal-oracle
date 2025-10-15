import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart'; // Added for HapticFeedback
import 'package:flutter_animate/flutter_animate.dart';
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

class _ChibiButtonState extends State<ChibiButton> {
  bool _isPressed = false;

  void _onTapDown(_) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(_) {
    setState(() {
      _isPressed = false;
    });
    HapticFeedback.mediumImpact();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color lightColor = lighten(widget.color, 0.2);
    final Color darkColor = darken(widget.color, 0.2);
    final Color borderColor = darken(widget.color, 0.3);
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final baseStyle = widget.textStyle ?? ChibiTextStyles.buttonText;
    // The font size on the design draft.
    const double designFontSize = 20.0;

    final TextStyle finalTextStyle;
    if (isLandscape) {
      // In landscape, scale the font size based on the screen height.
      final textScaleFactor = ScreenUtil().textScaleFactor;
      final scaleHeight = ScreenUtil().scaleHeight;
      finalTextStyle = baseStyle.copyWith(fontSize: designFontSize * scaleHeight * textScaleFactor, letterSpacing: 1.5 * scaleHeight);
    } else {
      // In portrait, scale the font size based on the screen width (default .sp behavior).
      finalTextStyle = baseStyle.copyWith(fontSize: designFontSize.sp);
    }

    final borderWidth = isLandscape ? 3.h : 3.w;
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        padding: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isPressed ? [darkColor, widget.color, lightColor] : [lightColor, widget.color, darkColor],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(64), offset: Offset(0, 4.h), blurRadius: 6.r)],
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.all(borderWidth * 2),
            color: widget.color,
            child: widget.child ??
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(widget.text!, textAlign: TextAlign.center, style: finalTextStyle),
                ),
          ),
        ),
      )
          .animate(target: _isPressed ? 1 : 0)
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(0.95, 0.95),
            duration: 80.ms,
            curve: Curves.easeOut,
          )
          .shimmer(
            delay: (_isPressed ? 0 : 200).ms,
            duration: 300.ms,
            color: Colors.white.withAlpha(30),
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
