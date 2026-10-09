import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/styles/app_text_style.dart';
class StateCardItemWidget extends StatelessWidget {
  const StateCardItemWidget({
    super.key,
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
    // return Container(
    //   padding: EdgeInsets.all(20.w), // ✅ أضف padding هنا
    //   decoration: BoxDecoration(
    //     color: Colors.white.withOpacity(0.05),
    //     borderRadius: BorderRadius.circular(20.r),
    //     border: Border.all(
    //       color: Colors.white.withOpacity(0.1),
    //     ),
    //   ),
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.circular(20.r),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         // Icon
    //         Container(
    //           padding: EdgeInsets.all(10.w),
    //           decoration: BoxDecoration(
    //             color: Colors.white.withOpacity(0.08),
    //             borderRadius: BorderRadius.circular(12.r),
    //           ),
    //           child: Icon(
    //             icon,
    //             color: iconColor,
    //             size: 24.sp,
    //           ),
    //         ),
    //
    //         SizedBox(height: 10.h),
    //
    //         // Value
    //         Text(
    //           value,
    //           style: AppTextStyles.interSemiBold.copyWith(
    //             fontSize: 25.sp,
    //             color: Colors.white,
    //           ),
    //         ),
    //
    //         SizedBox(height: 5.h),
    //
    //         // Label
    //         Text(
    //           label,
    //           style: AppTextStyles.interRegular.copyWith(
    //             fontSize: 15.sp,
    //             letterSpacing: 1,
    //             color: Colors.white.withOpacity(0.5),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

   return GlassMorphismCard(
     opacity: .02,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24.sp,
            ),
          ),

          SizedBox(height: 10.h),

          // Value
          Text(
            value,
            style: AppTextStyles.interSemiBold.copyWith(
              fontSize: 25.sp,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 5.h),

          // Label
          Text(
            label,
            style: AppTextStyles.interRegular.copyWith(
              fontSize: 15.sp,
              letterSpacing: 1,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}