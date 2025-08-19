import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart'; // Assuming AppTextStyles is still needed for font families

class ChibiTextStyles {
  static TextStyle get appBarTitle => TextStyle(
        fontFamily: AppTextStyles.amaticSC,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 70.sp,
        letterSpacing: 2.0.sp,
        shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
      );

  static TextStyle get buttonText => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5.sp,
        color: Colors.white,
        fontFamily: AppTextStyles.amarante,
      );

  static TextStyle get storyTitle => TextStyle(
        fontFamily: AppTextStyles.amaticSC,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24.sp,
        letterSpacing: 2.0.sp,
        shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
      );

  static TextStyle get overlayTitle => TextStyle(
        fontFamily: AppTextStyles.amaticSC,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 40.sp,
        letterSpacing: 2.0.sp,
        shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
      );
}

class ChibiColors {
  static const Color buttonOrange = Color(0xFFF9A825);
  static const Color buttonBlue = Color(0xFF1E88E5);
  static const Color buttonRed = Color(0xFFE53935);
}
