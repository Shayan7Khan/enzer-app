import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/home_screen/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PremiumCardSection extends StatelessWidget {
  final HomeViewModel model;
  const PremiumCardSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // card carousel
          Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
            height: 200.h,
            child: PageView.builder(
              controller: model.cardPageController,
              itemCount: model.cardAssets.length,
              onPageChanged: model.onCardPageChanged,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: SvgPicture.asset(
                      model.cardAssets[index],
                      fit: BoxFit.cover,
                      placeholderBuilder: (_) => Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.credit_card,
                            size: 48.sp,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          12.verticalSpace,

          // dot indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              model.cardAssets.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: model.currentCardPage == i ? 23.w : 12.h,
                height: 12.h,
                decoration: BoxDecoration(
                  color: model.currentCardPage == i
                      ? AppColors.primary
                      : AppColors.gray300,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),

          16.verticalSpace,

          // animated title — changes per card
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              model.cardTitles[model.currentCardPage],
              key: ValueKey(model.currentCardPage),
              style: AppTextStyles.futura.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ),

          6.verticalSpace,

          // animated description — changes per card
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              model.cardDescriptions[model.currentCardPage],
              key: ValueKey('desc_${model.currentCardPage}'),
              textAlign: TextAlign.center,
              style: AppTextStyles.paragraphSmallRegular.copyWith(
                fontSize: 12.sp,
                color: AppColors.gray600,
                height: 1.4,
              ),
            ),
          ),

          16.verticalSpace,

          // progress bar — changes per card
          Padding(
            padding: EdgeInsets.only(left: 23.w, right: 23.w, bottom: 16.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Goal Progress',
                      style: AppTextStyles.paragraphSmallSemiBold.copyWith(
                        fontSize: 13.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        model.cardProgressLabel(model.currentCardPage),
                        key: ValueKey('label_${model.currentCardPage}'),
                        style: AppTextStyles.paragraphSmallSemiBold.copyWith(
                          fontSize: 13.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey('progress_${model.currentCardPage}'),
                    tween: Tween(
                      begin: 0,
                      end: model.cardProgress(model.currentCardPage),
                    ),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 10.h,
                      backgroundColor: AppColors.gray200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFE7040),
                      ),
                    ),
                  ),
                ),
                10.verticalSpace,
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    model.cardGoalText(model.currentCardPage),
                    key: ValueKey('goal_${model.currentCardPage}'),
                    style: AppTextStyles.paragraphSmallRegular.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.gray500,
                    ),
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
