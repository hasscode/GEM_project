
import 'package:flutter/material.dart';

import 'app_colors.dart';


abstract class AppTextStyles{

  static const  interBold = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,

color: AppColors.softText,

  );

  static const  interRegular = TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,

      color: AppColors.softText,

  );

  static const  interSemiBold = TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,

      color: AppColors.softText,

  );
  static const  interMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,

    color: AppColors.softText,

  );
}