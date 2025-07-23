// deity_card.dart
import 'package:flutter/material.dart';
import '../models/deity.dart'; // Make sure this model matches the structure from AppData
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeityCard extends StatelessWidget {
  final Deity deity;

  const DeityCard({super.key, required this.deity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: deity.colors,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: deity.colors.first.withAlpha(76),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            deity.icon,
            width: 160.w,
            height: 160.h,
          ),
          SizedBox(width: 24.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deity.name,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  deity.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white.withAlpha(229),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
