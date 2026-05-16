import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.black,
        unselectedLabelColor: AppColors.gray600,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        padding: EdgeInsets.all(4.r),
        tabs: const [
          Tab(text: 'Your Rewards'),
          Tab(text: 'Leaderboard'),
        ],
      ),
    );
  }
}
