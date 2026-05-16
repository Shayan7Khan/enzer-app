import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/home_screen/components/fall_back_circles.dart';
import 'package:enzer_app/ui/screens/home_screen/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class HomeHeader extends StatelessWidget {
  final HomeViewModel model;
  const HomeHeader({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // left trophy svg
          Positioned(
            top: 80.h,
            left: 0,
            child: SvgPicture.asset(
              'assets/images/Vector-2.svg',
              width: 95.w,
              height: 95.h,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
              placeholderBuilder: (_) => Icon(
                Icons.emoji_events_outlined,
                size: 56.sp,
                color: AppColors.white,
              ),
            ),
          ),

          // right circle svg
          Positioned(
            top: 100.h,
            right: -20.w,
            child: Opacity(
              opacity: 0.12,
              child: SvgPicture.asset(
                'assets/images/Vector.svg',
                width: 147.w,
                height: 147.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
                placeholderBuilder: (_) => const FallbackCircles(),
              ),
            ),
          ),

          // center text content
          Positioned.fill(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You are currently',
                    style: AppTextStyles.h6Medium.copyWith(
                      color: AppColors.gray200,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    '# ${NumberFormat('#,###').format(model.userRank)}',
                    style: AppTextStyles.h1Bold.copyWith(
                      color: AppColors.white,
                      fontSize: 42.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    'of ${NumberFormat('#,###').format(model.totalWaitlist)} people on waitlist',
                    style: AppTextStyles.h6Medium.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
