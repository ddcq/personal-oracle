import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class ScreenTitle extends StatelessWidget {
  final String title;

  const ScreenTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.screenTitle;
    const double designFontSize = 60.0;

    final TextStyle finalTextStyle;
    finalTextStyle = baseStyle.copyWith(fontSize: designFontSize.sp);

    return Text(title, textAlign: TextAlign.center, style: finalTextStyle);
  }
}
