import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gem_project/core/styles/app_colors.dart';
import 'package:gem_project/view/widgets/state_card_item_widget.dart';

import '../../core/styles/app_text_style.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF0E2A57),
        elevation: 0,
        // leading: Container(
        //   margin: EdgeInsets.all(8.w),
        //   decoration: BoxDecoration(
        //     color: const Color(0xFF19C37D),
        //     borderRadius: BorderRadius.circular(10.r),
        //   ),
        //   child: Icon(
        //     Icons.dashboard,
        //     color: Colors.white,
        //     size: 30.sp,
        //   ),
        // ),
        title: Text(
          'Event Dashboard',
          style: AppTextStyles.interBold.copyWith(
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 400.h,
                width: 400.w,
                child: GridView(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10),
                children: [
                  StateCardItemWidget(icon: Icons.hourglass_bottom, value: "130", label: 'Remaining', iconColor: Colors.yellow),
                  StateCardItemWidget(icon: Icons.people, value: "250", label: 'All Guests', iconColor: Color(0xff12E57C)),
                  StateCardItemWidget(icon: Icons.people, value: "250", label: 'All Guests', iconColor: Color(0xff12E57C)),
                  StateCardItemWidget(icon: Icons.people, value: "250", label: 'All Guests', iconColor: Color(0xff12E57C)),
                ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
