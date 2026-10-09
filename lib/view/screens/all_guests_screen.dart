// guest_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_text_style.dart';
import '../../model/repositories/guest_repository.dart';
import '../../view_model/get all guest cubit/get_all_guests_cubit.dart';
import '../../view_model/get all guest cubit/get_all_guests_state.dart';


class GuestListScreen extends StatelessWidget {
  const GuestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuestListCubit(
        context.read<GuestRepository>(),
      )..loadGuests(),
      child: const GuestListView(),
    );
  }
}

class GuestListView extends StatelessWidget {
  const GuestListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E2A57),
        title: Text(
          'Guest List',
          style: AppTextStyles.interBold.copyWith(
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<GuestListCubit>().loadGuests();
            },
          ),
        ],
      ),
      body: BlocBuilder<GuestListCubit, GuestListState>(
        builder: (context, state) {
          if (state is GuestListLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF19C37D)),
            );
          }

          if (state is GuestListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: AppTextStyles.interRegular.copyWith(
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is GuestListLoaded) {
            if (state.guests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 80.sp, color: Colors.white30),
                    SizedBox(height: 16.h),
                    Text(
                      'No guests found',
                      style: AppTextStyles.interRegular.copyWith(
                        fontSize: 18.sp,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Stats Card
                _buildStatsCard(state.stats),

                // Guest List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: state.guests.length,
                    itemBuilder: (context, index) {
                      final guest = state.guests[index];
                      return _buildGuestCard(guest);
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStatsCard(Map<String, int> stats) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2A57),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', stats['total'] ?? 0, const Color(0xFF19C37D)),
          _buildStatItem('Verified', stats['verified'] ?? 0, Colors.blue),
          _buildStatItem('Remaining', stats['remaining'] ?? 0, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: AppTextStyles.interBold.copyWith(
            fontSize: 28.sp,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.interRegular.copyWith(
            fontSize: 13.sp,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  Widget _buildGuestCard(guest) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2A57),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: guest.verified
              ? const Color(0xFF19C37D).withOpacity(.3)
              : Colors.white.withOpacity(.08),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: guest.verified
                  ? const Color(0xFF19C37D).withOpacity(.15)
                  : Colors.white.withOpacity(.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              guest.verified ? Icons.check_circle : Icons.person,
              color: guest.verified ? const Color(0xFF19C37D) : Colors.white54,
              size: 24.sp,
            ),
          ),

          SizedBox(width: 16.w),

          // Guest Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guest.name,
                  style: AppTextStyles.interBold.copyWith(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'ID: ${guest.guestId}',
                  style: AppTextStyles.interRegular.copyWith(
                    fontSize: 12.sp,
                    color: Colors.white38,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14.sp, color: Colors.white38),
                    SizedBox(width: 4.w),
                    Text(
                      guest.location,
                      style: AppTextStyles.interRegular.copyWith(
                        fontSize: 13.sp,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Companions Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(Icons.people, size: 16.sp, color: Colors.white70),
                SizedBox(width: 6.w),
                Text(
                  guest.companions.toString(),
                  style: AppTextStyles.interBold.copyWith(
                    fontSize: 14.sp,
                    color: Colors.white,
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