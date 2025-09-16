import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static const String amaticSC = 'AmaticSC';
  static const String amarante = 'Amarante';

  static const TextStyle body = TextStyle(fontFamily: amaticSC, fontSize: 24, color: Colors.white);

  static const TextStyle cardTitle = TextStyle(fontFamily: amaticSC, fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white);

  static const TextStyle victoryTitle = TextStyle(fontFamily: amaticSC, fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white);

  static TextStyle screenTitle = TextStyle(
    fontFamily: amaticSC,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 60.sp,
    letterSpacing: 2.0.sp,
    shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
  );
}
