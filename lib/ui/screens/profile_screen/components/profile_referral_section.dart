import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/profile_screen/profile_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileReferralSection extends StatelessWidget {
  final ProfileViewModel model;
  const ProfileReferralSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your referral link',
          style: AppTextStyles.bodyMediumMedium.copyWith(
            color: AppColors.black,
          ),
        ),
        12.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Row(
            children: [
              Icon(Icons.link, color: AppColors.primary, size: 22.sp),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  (model.referralCode.isNotEmpty ? model.referralCode : '—'),
                  style: AppTextStyles.bodyMediumMedium.copyWith(
                    color: AppColors.black,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await model.copyReferralCode();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Referral code copied'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.copy_outlined,
                  color: AppColors.black,
                  size: 22.sp,
                ),
                padding: EdgeInsets.all(8.r),
                constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
