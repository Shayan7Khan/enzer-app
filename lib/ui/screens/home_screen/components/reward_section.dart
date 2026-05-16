import 'package:enzer_app/core/models/reward_tier.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/home_screen/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardsSection extends StatelessWidget {
  final HomeViewModel model;
  const RewardsSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Earn Rewards',
          style: AppTextStyles.futura.copyWith(
            fontSize: 30.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        10.verticalSpace,
        Text(
          'Refer your friends and enjoy exclusive perks, exciting rewards, and early access to upcoming features as a thank you for spreading the word.',
          textAlign: TextAlign.center,
          style: AppTextStyles.paragraphSmallRegular.copyWith(
            color: AppColors.gray700,
            fontSize: 12.sp,
            height: 1.4,
          ),
        ),
        20.verticalSpace,
        ...model.rewardTiers.map((tier) => _RewardCard(tier: tier)),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  final RewardTier tier;
  const _RewardCard({required this.tier});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tier.title,
                  style: AppTextStyles.paragraphLargeSemiBold.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B2B2C),
                    decoration: tier.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: AppColors.gray600,
                    decorationThickness: 2,
                  ),
                ),
                6.verticalSpace,
                Text(
                  tier.description,
                  style: AppTextStyles.paragraphSmallMedium.copyWith(
                    fontSize: 12.sp,
                    color: Color(0xFF2B2B2C),
                    decoration: tier.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: AppColors.gray600,
                    decorationThickness: 1.5,
                  ),
                ),
              ],
            ),
          ),
          if (tier.isCompleted) ...[
            16.horizontalSpace,
            Container(
              width: 28.r,
              height: 28.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00BA00),
              ),
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
