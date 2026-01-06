import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';

class ChibiTextButton extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;

  const ChibiTextButton({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
    this.textStyle,
  });

  @override
  State<ChibiTextButton> createState() => _ChibiTextButtonState();
}

class _ChibiTextButtonState extends State<ChibiTextButton> {
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
    final Color lightColor = lighten(widget.color, 0.1); // Reduced from 0.2
    final Color darkColor = darken(widget.color, 0.3); // Increased from 0.2
    final Color borderColor = darken(widget.color, 0.5); // Increased from 0.3
    final Color innerShadowColor = Colors.black.withAlpha(100);
    final baseStyle = widget.textStyle ?? ChibiTextStyles.buttonText;
    final TextStyle finalTextStyle;

    if (widget.textStyle?.fontSize != null) {
      finalTextStyle = baseStyle;
    } else {
      const double designFontSize = 20.0;
      finalTextStyle = baseStyle.copyWith(fontSize: designFontSize.sp);
    }

    final borderWidth = 3.w;

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child:
          Container(
                padding: EdgeInsets.all(borderWidth),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _isPressed
                        ? [darkColor, widget.color, lightColor]
                        : [lightColor, widget.color, darkColor],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    // Outer shadow - more dramatic
                    BoxShadow(
                      color: Colors.black.withAlpha(120), // Increased from 64
                      offset: Offset(0, 6.h), // Increased from 4.h
                      blurRadius: 12.r, // Increased from 6.r
                    ),
                    // Additional glow effect
                    BoxShadow(
                      color: borderColor.withAlpha(80),
                      offset: Offset(0, 2.h),
                      blurRadius: 4.r,
                      spreadRadius: -1,
                    ),
                  ],
                  border: Border.all(color: borderColor, width: borderWidth),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    decoration: BoxDecoration(
                      // Dark vignette effect from edges
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.8,
                        colors: [
                          widget.color,
                          darken(widget.color, 0.15),
                        ],
                      ),
                    ),
                    child: Container(
                      // Inner shadow overlay
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            innerShadowColor,
                            Colors.transparent,
                            Colors.transparent,
                            innerShadowColor,
                          ],
                          stops: const [0.0, 0.2, 0.8, 1.0],
                        ),
                      ),
                      padding: EdgeInsets.all(borderWidth * 2),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.text,
                          textAlign: TextAlign.center,
                          style: finalTextStyle,
                        ),
                      ),
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
                color: Colors.white.withAlpha(20), // Reduced from 30 for darker look
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
