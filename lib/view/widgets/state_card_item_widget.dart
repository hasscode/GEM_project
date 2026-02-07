import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/styles/app_text_style.dart';
class StateCardItemWidget extends StatelessWidget {
  const StateCardItemWidget({super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });
final IconData icon;
final String value;
final String label;
final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Colors.white70,
                  size: 25.sp,
                ),
              ),

              SizedBox(height: 28.h),

              // Value
              Text(
                value,
                style: AppTextStyles.interSemiBold.copyWith(
                  fontSize: 25.sp,
                  color: Colors.white,

                ),
              ),

    SizedBox(height: 8.h,),

              // Label
              Text(
                label,
                style: AppTextStyles.interRegular.copyWith(
                  fontSize: 18.sp,
                  letterSpacing: 1
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
