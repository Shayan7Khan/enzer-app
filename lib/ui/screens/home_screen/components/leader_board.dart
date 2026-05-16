import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/home_screen/components/leaderboard_user_card.dart';
import 'package:enzer_app/ui/screens/home_screen/components/podium_entry.dart';
import 'package:enzer_app/ui/screens/home_screen/home_view_model.dart';
import 'package:enzer_app/ui/screens/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LeaderboardSection extends StatelessWidget {
  final HomeViewModel model;
  const LeaderboardSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    if (model.state == ViewState.busy) {
      return SizedBox(
        height: 400.h,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (model.topThree.isEmpty &&
        model.restOfLeaderboard.isEmpty &&
        model.currentUser.rank == 0) {
      return SizedBox(
        height: 300.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.leaderboard_outlined,
                size: 48.sp,
                color: AppColors.gray600,
              ),
              16.verticalSpace,
              Text(
                'No one on the leaderboard yet.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray600,
                  fontSize: 14.sp,
                ),
              ),
              8.verticalSpace,
              Text(
                'Be the first to invite friends!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray700,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (model.topThree.length < 3) {
      return _LeaderboardList(model: model);
    }

    return _LeaderboardWithPodium(model: model);
  }
}

// Less than 3 users — simple ranked list
class _LeaderboardList extends StatelessWidget {
  final HomeViewModel model;
  const _LeaderboardList({required this.model});

  @override
  Widget build(BuildContext context) {
    final allVisible = [...model.topThree, ...model.restOfLeaderboard]
      ..sort((a, b) => a.rank.compareTo(b.rank));

    return Column(
      children: [
        const _LeaderboardHeader(),
        ...allVisible.map((e) {
          final isCurrentUser = e.rank == model.currentUser.rank;
          return LeaderboardUserCard(
            rank: e.rank,
            name: e.name,
            invites: e.invites,
            highlighted: isCurrentUser,
            onTap: isCurrentUser ? () => Get.to(ProfileScreen()) : () {},
          );
        }),
        5.verticalSpace,
        if (model.showFloatingCard) _CurrentUserCard(model: model),
      ],
    );
  }
}

// 3+ users — podium + ranked list
// replace _LeaderboardWithPodium
class _LeaderboardWithPodium extends StatelessWidget {
  final HomeViewModel model;
  const _LeaderboardWithPodium({required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Podium(model: model),
        ),
        16.verticalSpace,
        const _LeaderboardHeader(),
        Column(
          children: model.restOfLeaderboard.map((e) {
            final isCurrentUser = e.rank == model.currentUser.rank;
            return LeaderboardUserCard(
              rank: e.rank,
              name: e.name,
              invites: e.invites,
              highlighted: isCurrentUser,
              onTap: isCurrentUser ? () => Get.to(ProfileScreen()) : () {},
            );
          }).toList(),
        ),
        if (model.showFloatingCard) ...[
          8.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Stack(children: [_CurrentUserCard(model: model)]),
          ),
        ] else
          5.verticalSpace,
      ],
    );
  }
}

class _LeaderboardHeader extends StatelessWidget {
  const _LeaderboardHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50.w,
            child: Text(
              'Rank',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Name',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            'Invites',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentUserCard extends StatelessWidget {
  final HomeViewModel model;
  const _CurrentUserCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return LeaderboardUserCard(
      rank: model.currentUser.rank,
      name: model.currentUser.name,
      invites: model.currentUser.invites,
      highlighted: true,
      onTap: () => Get.to(ProfileScreen()),
    );
  }
}
