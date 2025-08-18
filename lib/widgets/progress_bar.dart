import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final String? displayText;

  const ProgressBar({super.key, required this.progress, this.displayText});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Colors.amber.shade700;
    final Color lightColor = Colors.amber.shade500;
    final Color darkColor = Colors.amber.shade900;
    final Color borderColor = Colors.brown.shade900;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (displayText != null)
            AutoSizeText(
              displayText!,
              maxLines: 1,
              minFontSize: 10.0,
              stepGranularity: 1.0,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black.withAlpha(128), offset: Offset(2, 2), blurRadius: 4)],
              ),
            ),
          SizedBox(height: 12.h),
          Container(
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: borderColor, width: 3.w),
              color: Colors.black.withAlpha(77),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(128), offset: Offset(0, 4), blurRadius: 6, spreadRadius: 1)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [darkColor.withAlpha(128), baseColor.withAlpha(102)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth * progress,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [lightColor, baseColor, darkColor],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      '${(progress * 100).round()}%',
                      maxLines: 1,
                      minFontSize: 10.0,
                      stepGranularity: 1.0,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black.withAlpha(204), offset: Offset(1, 1), blurRadius: 2)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
