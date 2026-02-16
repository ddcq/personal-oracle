import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart'; // Assuming AppTextStyles is still needed for font families
import 'package:oracle_d_asgard/providers/responsive_provider.dart';

class ChibiTextStyles {
  // NEW RESPONSIVE METHODS - Use these for correct dimensions on web
  // These use ResponsiveProvider and work correctly across all platforms

  static TextStyle appBarTitleResponsive(BuildContext context) {
    final responsive = Responsive(context);
    return TextStyle(
      fontFamily: AppTextStyles.amaticSC,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: responsive.sp(70),
      letterSpacing: responsive.sp(2.0),
      shadows: [
        const Shadow(
          blurRadius: 15.0,
          color: Colors.black87,
          offset: Offset(4.0, 4.0),
        ),
      ],
    );
  }

  static TextStyle buttonTextResponsive(BuildContext context) {
    final responsive = Responsive(context);
    return TextStyle(
      fontSize: responsive.sp(20),
      fontWeight: FontWeight.bold,
      letterSpacing: responsive.sp(1.5),
      color: Colors.white,
      fontFamily: AppTextStyles.amarante,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle storyTitleResponsive(BuildContext context) {
    final responsive = Responsive(context);
    return TextStyle(
      fontFamily: AppTextStyles.amaticSC,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: responsive.sp(24),
      letterSpacing: responsive.sp(2.0),
      shadows: [
        const Shadow(
          blurRadius: 15.0,
          color: Colors.black87,
          offset: Offset(4.0, 4.0),
        ),
      ],
    );
  }

  static TextStyle dialogTextResponsive(BuildContext context) {
    final responsive = Responsive(context);
    return TextStyle(
      color: Colors.white,
      decoration: TextDecoration.none,
      fontFamily: AppTextStyles.amarante,
      fontSize: responsive.sp(20),
      letterSpacing: responsive.sp(1.5),
      shadows: [
        const Shadow(
          blurRadius: 10.0,
          color: Colors.black87,
          offset: Offset(2.0, 2.0),
        ),
      ],
    );
  }

  static TextStyle overlayTitleResponsive(BuildContext context) {
    final responsive = Responsive(context);
    return TextStyle(
      fontFamily: AppTextStyles.amaticSC,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: responsive.sp(40),
      letterSpacing: responsive.sp(2.0),
      shadows: [
        const Shadow(
          blurRadius: 15.0,
          color: Colors.black87,
          offset: Offset(4.0, 4.0),
        ),
      ],
    );
  }

  // LEGACY GETTERS - Kept for backward compatibility
  // These still use flutter_screenutil but will be incorrect on web
  // Gradually replace these with the *Responsive() methods above

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
  static const Color darkEpicPurple = Color.fromARGB(255, 38, 44, 86);

  // Legacy colors - now all mapped to dark epic purple
  static const Color buttonOrange = darkEpicPurple;
  static const Color buttonBlue = darkEpicPurple;
  static const Color buttonRed = darkEpicPurple;
  static const Color buttonGreen = darkEpicPurple;
  static const Color buttonPurple = darkEpicPurple;
  static const Color buttonYellow = darkEpicPurple;
}
