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
    shadows: [
      const Shadow(
        blurRadius: 15.0,
        color: Colors.black87,
        offset: Offset(4.0, 4.0),
      ),
    ],
  );

  static TextStyle get buttonText => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5.sp,
    color: Colors.white,
    fontFamily: AppTextStyles.amarante,
    decoration: TextDecoration.none,
  );

  static TextStyle get storyTitle => TextStyle(
    fontFamily: AppTextStyles.amaticSC,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    letterSpacing: 2.0.sp,
    shadows: [
      const Shadow(
        blurRadius: 15.0,
        color: Colors.black87,
        offset: Offset(4.0, 4.0),
      ),
    ],
  );

  static TextStyle get dialogText => TextStyle(
    color: Colors.white,
    decoration: TextDecoration.none,
    fontFamily: AppTextStyles.amarante,
    fontSize: 20.sp,
    letterSpacing: 1.5.sp,
    shadows: [
      const Shadow(
        blurRadius: 10.0,
        color: Colors.black87,
        offset: Offset(2.0, 2.0),
      ),
    ],
  );

  static TextStyle get overlayTitle => TextStyle(
    fontFamily: AppTextStyles.amaticSC,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 40.sp,
    letterSpacing: 2.0.sp,
    shadows: [
      const Shadow(
        blurRadius: 15.0,
        color: Colors.black87,
        offset: Offset(4.0, 4.0),
      ),
    ],
  );
}

class ChibiColors {
  // Dark epic purple - unified color for all buttons
  static const Color darkEpicPurple = Color(0xFF2D1B4E);
  
  // Legacy colors - now all mapped to dark epic purple
  static const Color buttonOrange = darkEpicPurple;
  static const Color buttonBlue = darkEpicPurple;
  static const Color buttonRed = darkEpicPurple;
  static const Color buttonGreen = darkEpicPurple;
  static const Color buttonPurple = darkEpicPurple;
  static const Color buttonYellow = darkEpicPurple;
}
