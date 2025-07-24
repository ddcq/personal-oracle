import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';

class AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String letter;
  final List<Color>? gradientColors;

  const AnswerButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.letter,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final bool useGradient = gradientColors != null && gradientColors!.length >= 2;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 90.sw,
        height: 70.h,
        decoration: BoxDecoration(
          gradient: useGradient ? LinearGradient(colors: gradientColors!, begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
          color: useGradient ? null : const Color(0xFF1E88E5), // Blue fallback
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: Colors.white.withAlpha(204), width: 2.5.w),
          boxShadow: [BoxShadow(color: useGradient ? gradientColors!.last.withAlpha(179) : const Color(0xFF155FA0), offset: Offset(0, 6.h), blurRadius: 0)],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: min(10.w, 10.h)),
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: Colors.black, // Use black color for the letter on white background
                      fontSize: min(32.w, 32.h),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: AutoSizeText(
                text,
                maxLines: 2,
                minFontSize: 10.sp,
                stepGranularity: 1.0.sp,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2.sp,
                  shadows: [Shadow(blurRadius: 3.0.r, color: Colors.black54, offset: Offset(2.0.w, 2.0.h))],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
