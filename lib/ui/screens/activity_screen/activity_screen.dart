import 'package:enzer_app/core/models/notification_items.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/locator.dart';
import 'package:enzer_app/ui/screens/activity_screen/activity_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  static final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: locator<ActivityViewModel>(),
      child: Consumer<ActivityViewModel>(
        builder: (context, model, _) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.white, AppColors.primary50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              surfaceTintColor: AppColors.backgroundColor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Activity',
                style: AppTextStyles.h5Bold.copyWith(color: AppColors.black),
              ),
            ),
            body: Stack(
              children: [
                RefreshIndicator(
                  key: _refreshKey,
                  color: AppColors.primary,
                  onRefresh: model.fetchNotifications,
                  child: model.groupedNotifications.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: _EmptyState(),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          itemCount: model.groupedNotifications.length,
                          itemBuilder: (context, index) {
                            final label = model.groupedNotifications.keys
                                .elementAt(index);
                            final items = model.groupedNotifications[label]!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _DateHeader(label: label),
                                ...items.map(
                                  (n) => _NotificationCard(
                                    notification: n,
                                    timeAgo: model.formatTimeAgo(n.createdAt),
                                  ),
                                ),
                                16.verticalSpace,
                              ],
                            );
                          },
                        ),
                ),
                if (model.isRefreshing)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.primary50,
                      minHeight: 2,
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 56.sp,
            color: AppColors.gray400,
          ),
          16.verticalSpace,
          Text(
            'No activity yet',
            style: AppTextStyles.bodyMediumSemiBold.copyWith(
              color: AppColors.gray600,
              fontSize: 16.sp,
            ),
          ),
          8.verticalSpace,
          Text(
            'Your referral activity will appear here.',
            style: AppTextStyles.paragraphLargeRegular.copyWith(
              color: AppColors.gray500,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, top: 4.h),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.gray600,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final String timeAgo;

  const _NotificationCard({required this.notification, required this.timeAgo});

  Widget _buildRichBody(String body) {
    final baseStyle = AppTextStyles.paragraphSmallMedium.copyWith(
      fontSize: 13.sp,
      color: AppColors.gray600,
      fontWeight: FontWeight.w500,
      height: 1.4,
    );
    final boldStyle = baseStyle.copyWith(
      fontWeight: FontWeight.w800,
      color: AppColors.gray800,
    );

    final List<InlineSpan> spans = [];

    final joinedParts = body.split(' joined ');
    if (joinedParts.length == 2) {
      spans.add(TextSpan(text: joinedParts[0], style: boldStyle));
      spans.add(TextSpan(text: ' joined ', style: baseStyle));

      final rest = joinedParts[1];
      final spotsMatch = RegExp(r'moved up (\d+) (spots?)').firstMatch(rest);
      if (spotsMatch != null) {
        final before = rest.substring(0, spotsMatch.start);
        final number = spotsMatch.group(1)!;
        final spotWord = spotsMatch.group(2)!;
        final after = rest.substring(spotsMatch.end);
        spans.add(TextSpan(text: before, style: baseStyle));
        spans.add(TextSpan(text: 'moved up ', style: baseStyle));
        spans.add(TextSpan(text: '$number $spotWord', style: boldStyle));
        spans.add(TextSpan(text: after, style: baseStyle));
      } else {
        spans.add(TextSpan(text: rest, style: baseStyle));
      }
    } else {
      spans.add(TextSpan(text: body, style: baseStyle));
    }

    return RichText(text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final displayBody = notification.title.isNotEmpty
        ? notification.title
        : notification.body;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFFCF2FF) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isUnread ? AppColors.primary50 : const Color(0xFFEEEEEE),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: isUnread ? const Color(0xFFF2CCFF) : AppColors.gray100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: isUnread
                ? ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF5B0090)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  )
                : Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.gray800,
                    size: 28.sp,
                  ),
          ),
          14.horizontalSpace,
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildRichBody(displayBody)),
                8.horizontalSpace,
                Text(
                  timeAgo,
                  style: AppTextStyles.paragraphSmallMedium.copyWith(
                    fontSize: 11.sp,
                    color: AppColors.gray500,
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
