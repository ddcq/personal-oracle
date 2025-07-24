// Widget pour les boutons de réponse
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String letter;
  final List<Color>? gradientColors;

  const AnswerButton({super.key, required this.text, required this.onPressed, required this.letter, this.gradientColors});

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
          border: Border.all(color: Colors.white.withAlpha((255 * 0.8).round()), width: 2.5.w),
          boxShadow: [
            BoxShadow(
              color: useGradient ? gradientColors!.last.withAlpha((255 * 0.7).round()) : const Color(0xFF155FA0),
              offset: Offset(0, 6.h),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: Colors.black, // Use black color for the letter on white background
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
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
