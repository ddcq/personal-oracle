import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class ScreenTitle extends StatelessWidget {
  final String title;

  const ScreenTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final baseStyle = AppTextStyles.screenTitle;
    const double designFontSize = 60.0;

    final TextStyle finalTextStyle;
    if (isLandscape) {
      final textScaleFactor = ScreenUtil().textScaleFactor;
      final scaleHeight = ScreenUtil().scaleHeight;
      finalTextStyle = baseStyle.copyWith(
        fontSize: designFontSize * scaleHeight * textScaleFactor,
      );
    } else {
      finalTextStyle = baseStyle.copyWith(fontSize: designFontSize.sp);
    }

    return Text(title, textAlign: TextAlign.center, style: finalTextStyle);
  }
}
