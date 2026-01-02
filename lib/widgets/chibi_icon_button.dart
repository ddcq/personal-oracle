import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChibiIconButton extends StatefulWidget {
  final Widget icon;
  final Color color;
  final VoidCallback? onPressed;
  final double? size;

  const ChibiIconButton({
    super.key,
    required this.icon,
    required this.color,
    this.onPressed,
    this.size,
  });

  @override
  State<ChibiIconButton> createState() => _ChibiIconButtonState();
}

class _ChibiIconButtonState extends State<ChibiIconButton> {
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
                    BoxShadow(
                      color: Colors.black.withAlpha(64),
                      offset: Offset(0, 4.h),
                      blurRadius: 6.r,
                    ),
                  ],
                  border: Border.all(color: borderColor, width: borderWidth),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    color: widget.color,
                    child: SizedBox(
                      width: widget.size ?? 48.w, // Default size
                      height: widget.size ?? 48.w, // Default size
                      child: Center(child: widget.icon),
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
