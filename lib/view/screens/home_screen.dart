import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gem_project/core/styles/app_colors.dart';
import 'package:gem_project/core/widgets/custom_button_widget.dart';
import 'package:gem_project/core/widgets/custom_text_form_field.dart';
import 'package:gem_project/view/widgets/state_card_item_widget.dart';

import '../../core/styles/app_text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final TextEditingController manualVerifyController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    manualVerifyController=TextEditingController();
  }
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,

                    mainAxisSpacing: 5.h,
                  ),
                  children: [
                    StateCardItemWidget(
                      icon: CupertinoIcons.hourglass,
                      value: "130",
                      label: 'REMAINING',
                      iconColor: Colors.grey,
                    ),
                    StateCardItemWidget(
                      icon: Icons.people,
                      value: "250",
                      label: 'TOTAL GUESTS',
                      iconColor: Color(0xff12E57C),
                    ),
                    StateCardItemWidget(
                      icon: Icons.check_circle,
                      value: "120",
                      label: 'VERIFIED',
                      iconColor: Color(0xff6CF0AF),
                    ),
                    StateCardItemWidget(
                      icon: Icons.stop_circle_outlined,
                      value: "13",
                      label: 'DENIED',
                      iconColor: Color(0xffF87171),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButtonWidget(
                textColor: Color(0xff6CF0AF),
                title: "Scan QRCode",
                onPressed: () {},
                backgroundColor: Colors.white,
                width: double.infinity,
                height: 60,
                icon: Icon(
                  CupertinoIcons.qrcode_viewfinder,
                  color: Color(0xff6CF0AF),
                ),
              ),
            ),
SizedBox(height: 24.h,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomTextFormField(textEditingController: manualVerifyController, obscureText: false, title: 'Manual verify by ID', hintText: 'Enter The Guest ID', titleExist: true),
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    manualVerifyController.clear();
  }
}
