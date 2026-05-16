import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaderboardUserCard extends StatelessWidget {
  final int rank;
  final String name;
  final int invites;
  final bool highlighted;
  final VoidCallback onTap;

  const LeaderboardUserCard({
    super.key,
    required this.rank,
    required this.name,
    required this.invites,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: highlighted
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFBF00FF), Color(0xFF5E2C4D)],
                )
              : null,
          color: highlighted ? null : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Rank circle
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: highlighted ? AppColors.white : const Color(0xFFF3F3F3),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: AppTextStyles.paragraphSmallSemiBold.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            14.horizontalSpace,

            // Name
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.bodyMediumSemiBold.copyWith(
                  color: highlighted ? AppColors.white : AppColors.gray700,
                  fontSize: 16,
                ),
              ),
            ),

            // Invites
            Text(
              '$invites',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: highlighted ? AppColors.white : AppColors.black,
              ),
            ),

            if (highlighted) ...[
              10.horizontalSpace,
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13.sp,
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
