
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/app_text_style.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    required this.textColor,
    required this.title,
    required this.onPressed,
    required this.backgroundColor,
    required this.width,
    required this.height,
    required this.icon
  });

  final String title;
  final Color textColor;
  final Color backgroundColor;
  final void Function()? onPressed;
  final double height;
  final double width;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
icon:icon?? SizedBox.shrink() ,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          backgroundColor: backgroundColor,
          overlayColor: Colors.black,
shadowColor: backgroundColor,
          elevation: 6

        ),
        label: Text(
          title,
          style: AppTextStyles.interBold.copyWith(
            color: textColor,
            fontSize: 17.sp,
          ),
        ),
      ),
    );
  }
}
