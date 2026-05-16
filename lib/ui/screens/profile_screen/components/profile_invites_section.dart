import 'package:enzer_app/core/constants/image_path.dart';
import 'package:enzer_app/core/models/invited_user.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/profile_screen/profile_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProfileInvitesSection extends StatelessWidget {
  final ProfileViewModel model;
  const ProfileInvitesSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your invites',
          style: AppTextStyles.bodyMediumMedium.copyWith(
            color: AppColors.black,
          ),
        ),
        14.verticalSpace,
        if (model.invitedUsers.isEmpty)
          _EmptyInvites()
        else ...[
          _InvitesHeader(),
          8.verticalSpace,
          ...model.invitedUsers.map((user) => _InviteRow(user: user)),
        ],
      ],
    );
  }
}

class _InvitesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Text(
            'No',
            style: AppTextStyles.bodySmallMedium.copyWith(
              color: AppColors.white,
            ),
          ),
          24.horizontalSpace,
          Text(
            'Name',
            style: AppTextStyles.bodySmallMedium.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteRow extends StatelessWidget {
  final InvitedUser user;
  const _InviteRow({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF0F0F0),
            ),
            child: Center(
              child: Text(
                user.no.toString(),
                style: AppTextStyles.captionLargeMedium.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          30.horizontalSpace,
          Text(
            user.name,
            style: AppTextStyles.bodyMediumBold.copyWith(
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyInvites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Column(
          children: [
            Align(
              child: SvgPicture.asset(
                profileEmptyStateImage,
                width: 120.r,
                height: 120.r,
              ),
            ),
            20.verticalSpace,
            Text(
              'No One Joined Yet',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray800,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            8.verticalSpace,
            Text(
              'Invite friends to unlock your rewards.',
              style: AppTextStyles.paragraphLargeRegular.copyWith(
                color: AppColors.gray600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
