import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gem_project/core/styles/app_colors.dart';
import 'package:gem_project/core/widgets/custom_button_widget.dart';

import '../../core/styles/app_text_style.dart';
import '../../view_model/initialization_cubit/initialization_cubit.dart';
import '../../view_model/initialization_cubit/initialization_state.dart';
import 'all_guests_screen.dart';
class DataInitializationPage extends StatelessWidget {
  const DataInitializationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitializationCubit, InitializationState>(
      listener: (context, state) {
        /// ✅ Loading
        if (state is InitializationLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        /// ✅ Success
        if (state is InitializationImported) {
          Navigator.pop(context); // close loading

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const GuestListScreen(),
            ),
          );
        }

        /// ✅ Error
        if (state is InitializationError) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),

                /// Title
                Text(
                  "Data Initialization",
                  style: AppTextStyles.interRegular.copyWith(
                    fontSize: 17.5.sp,
                    color: Colors.white70,
                  ),
                ),

                SizedBox(height: 40.h),

                /// Graduation Icon
                Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF19C37D),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 35.sp,
                  ),
                ),

                SizedBox(height: 25.h),

                /// Title
                Text(
                  "Graduation Entry Manager",
                  style: AppTextStyles.interBold.copyWith(
                    fontSize: 22.sp,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 60.h),

                /// Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(22.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E2A57),
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(color: Colors.white.withOpacity(.08)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.4),
                        blurRadius: 25.r,
                        offset: Offset(0, 12.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// Upload icon
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(.06),
                        ),
                        child: Icon(
                          Icons.upload_file_rounded,
                          color: Colors.white,
                          size: 26.sp,
                        ),
                      ),

                      SizedBox(height: 18.h),

                      Text(
                        "Import Guest List",
                        style: AppTextStyles.interRegular.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        "Upload Excel or CSV files to initialize\n"
                            "your graduation entry database.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.interRegular.copyWith(
                          fontSize: 13.sp,
                          color: Colors.white54,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// ✅ Select File Button
                      CustomButtonWidget(
                        textColor: Colors.white,
                        title: 'Select File',
                        backgroundColor: const Color(0xFF19C37D),
                        width: double.infinity,
                        height: 48.h,
                        icon: const Icon(Icons.file_upload,
                            color: Colors.white),
                        onPressed: () async {
                          final result =
                          await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx', 'csv'],
                          );

                          if (result == null) return;

                          final file =
                          File(result.files.single.path!);

                          /// 👇 call cubit
                          context
                              .read<InitializationCubit>()
                              .importExcel(file);
                        },
                      ),

                      SizedBox(height: 12.h),

                      Text(
                        "SUPPORTED: .XLSX, .CSV",
                        style: AppTextStyles.interRegular.copyWith(
                          fontSize: 11.sp,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
