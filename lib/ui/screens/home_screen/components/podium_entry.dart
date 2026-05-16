import 'package:enzer_app/core/models/leader_board_entry.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/home_screen/components/rank_mark_clipper.dart';
import 'package:enzer_app/ui/screens/home_screen/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Podium extends StatelessWidget {
  final HomeViewModel model;
  const Podium({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final sorted = List<LeaderboardEntry>.from(model.topThree)
      ..sort((a, b) => a.rank.compareTo(b.rank));

    final first = sorted[0];
    final second = sorted[1];
    final third = sorted[2];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -15,
          left: 0.5.w,
          right: 0.5.w,
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFF4DB8AE),
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.20),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 290.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7DDDD4), Color(0xFF4DB8AE)],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6.r),
              topRight: Radius.circular(6.r),
              bottomLeft: Radius.circular(16.r),
              bottomRight: Radius.circular(16.r),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _PodiumStripe(height: 160.h, width: 85.w),
                    _PodiumStripe(height: 210.h, width: 90.w),
                    _PodiumStripe(height: 160.h, width: 85.w),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 230.h,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _PodiumEntry(
                            entry: second,
                            avatarSize: 85.r,
                            isCurrentUser:
                                second.rank == model.currentUser.rank,
                          ),
                        ),
                      ),
                    ),
                    40.horizontalSpace,
                    Expanded(
                      child: SizedBox(
                        height: 230.h,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: _PodiumEntry(
                            entry: first,
                            avatarSize: 100.r,
                            isCurrentUser: first.rank == model.currentUser.rank,
                          ),
                        ),
                      ),
                    ),
                    40.horizontalSpace,
                    Expanded(
                      child: SizedBox(
                        height: 220.h,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _PodiumEntry(
                            entry: third,
                            avatarSize: 85.r,
                            isCurrentUser: third.rank == model.currentUser.rank,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PodiumStripe extends StatelessWidget {
  final double height;
  final double width;
  const _PodiumStripe({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.r),
          topRight: Radius.circular(5.r),
        ),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.white.withValues(alpha: 0.55),
            Colors.white.withValues(alpha: 0.025),
          ],
        ),
      ),
    );
  }
}

class _PodiumEntry extends StatelessWidget {
  final LeaderboardEntry entry;
  final double avatarSize;
  final bool isCurrentUser;

  const _PodiumEntry({
    required this.entry,
    required this.avatarSize,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        // Avatar + Crown Stack
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Avatar
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isCurrentUser
                    ? const LinearGradient(
                        colors: [Color(0xFFBF00FF), Color(0xFF5E2C4D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isCurrentUser ? null : const Color(0xFFD8C8F0),
                border: Border.all(
                  color: isCurrentUser ? Colors.white : const Color(0xFF4DB8AE),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '${entry.rank}',
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: avatarSize * 0.30,
                    fontWeight: FontWeight.w800,
                    color: isCurrentUser
                        ? Colors.white
                        : const Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ),
            // Crown badge — overlaps bottom center of avatar
            Positioned(
              bottom: -5.r,
              child: ClipPath(
                clipper: RankMarkClipper(),
                child: isCurrentUser
                    ? Container(
                        width: 29.r,
                        height: 29.r,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFBF00FF), Color(0xFF5E2C4D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.h, left: 3.w),
                            child: Text(
                              '👑',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 29.r,
                        height: 29.r,
                        color: const Color(0xFF4A2890),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.h, left: 3.w),
                            child: Text(
                              '👑',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        // Name
        if (isCurrentUser)
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFBF00FF), Color(0xFF5E2C4D)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Text(
              entry.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          )
        else
          Text(
            entry.name,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        3.verticalSpace,
        Text(
          '${entry.invites} Invites',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 11.sp,
            color: isCurrentUser
                ? const Color(0xFFBF00FF)
                : const Color(0xFF1A1A2E).withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}
