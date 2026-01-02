import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChibiMenuButton extends StatefulWidget {
  final String text;
  final Widget? child;
  final Color color;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final String? iconPath;

  const ChibiMenuButton({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
    this.child,
    this.textStyle,
    this.iconPath,
  }) : assert(
         iconPath != null || child != null,
         'Either iconPath or child must be provided for ChibiMenuButton',
       );

  @override
  State<ChibiMenuButton> createState() => _ChibiMenuButtonState();
}

class _ChibiMenuButtonState extends State<ChibiMenuButton> {
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
    final baseStyle =
        widget.textStyle ??
        const TextStyle(
          fontFamily: 'Amarante',
          fontWeight: FontWeight.bold,
          fontSize:
              12.0, // Use a default for the base, .sp will be applied later
          color: Colors.white,
        );
    final TextStyle finalTextStyle = baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 12.0).sp,
    );

    final borderWidth = 3.w;

    Widget buttonContent;
    if (widget.child != null) {
      // If child is provided, use it directly
      buttonContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: widget.child!),
          SizedBox(height: 8.h),
          Text(
            widget.text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: finalTextStyle,
          ),
        ],
      );
    } else {
      // If iconPath is provided, create a Column with Image and Text
      buttonContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Image.asset(widget.iconPath!, fit: BoxFit.cover)),
          SizedBox(height: 8.h),
          Text(
            widget.text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: finalTextStyle,
          ),
        ],
      );
    }

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
                  child: buttonContent,
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
              )
              .animate(
                delay:
                    (widget.key is ValueKey<int>
                            ? (widget.key as ValueKey<int>).value * 120
                            : 0)
                        .ms,
              ) // Apply animation based on index from key
              .slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOutCubic)
              .fadeIn(duration: 300.ms),
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
