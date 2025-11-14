// deity_card.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/image_utils.dart';
import 'dart:ui'; // For ImageFilter
import 'package:oracle_d_asgard/utils/text_styles.dart';

import 'package:oracle_d_asgard/models/deity.dart'; // Make sure this model matches the structure from AppData

class DeityCard extends StatefulWidget {
  final Deity deity;

  const DeityCard({super.key, required this.deity});

  @override
  State<DeityCard> createState() => _DeityCardState();
}

class _DeityCardState extends State<DeityCard> {
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          child: Image.asset(addAssetPrefix(widget.deity.icon), height: 0.3.sh),
        ),
        SizedBox(height: 8.h),
        // New blurred container for name and title
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withAlpha(
                  50,
                ), // Soft white glow for the edge
                blurRadius: 30.r, // Large blur for soft transition
                spreadRadius: 5.r,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8.0,
                sigmaY: 8.0,
              ), // Blur intensity
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(
                    51,
                  ), // Transparent background for the content area
                  // Optional: a subtle gradient for the background color itself
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withAlpha(25),
                      Colors.white.withAlpha(12),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.deity.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTextStyles.amaticSC,
                        fontSize: isLandscape ? 24.sp : 48.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(3.0, 3.0),
                            blurRadius: 6.0,
                            color: Colors.black.withAlpha(150),
                          ),
                          Shadow(
                            offset: Offset(1.5, 1.5),
                            blurRadius: 3.0,
                            color: Colors.grey.withAlpha(100),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      widget.deity.title.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTextStyles.amaticSC,
                        fontSize: isLandscape ? 14.sp : 28.sp,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: Colors.black.withAlpha(120),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
