
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_images.dart';
import '../../../../core/styles/app_text_style.dart';
class SplashScreenBodyWidget extends StatelessWidget {
  const SplashScreenBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const Spacer(flex: 1,),

        // LOGO CONTAINER
        FadeIn(
          delay: Duration(milliseconds: 500),
          duration: Duration(milliseconds: 400),
          child: Container(
            width: 150.w,
            height: 150.h,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26.sp),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 30.sp,
                  spreadRadius: 4.sp,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: BorderRadius.circular(22.sp),
                image: DecorationImage(image: AssetImage(AppImages.logoImagePng),fit: BoxFit.cover)
              ),

            ),
          ),
        ),


        const Spacer(flex: 1),




      ],
    );
  }
}
