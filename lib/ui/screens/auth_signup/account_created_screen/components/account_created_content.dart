import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/account_created_view_model.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/components/accoount_created_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountCreatedContent extends StatelessWidget {
  final AccountCreatedViewModel model;
  const AccountCreatedContent({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, model.contentSlideAnimation.value),
      child: Opacity(
        opacity: model.contentOpacityAnimation.value,
        child: Column(
          children: [
            Text(
              "You're all set!",
              textAlign: TextAlign.center,
              style: AppTextStyles.futura.copyWith(
                fontSize: 32.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            8.verticalSpace,
            Text(
              "Climb the leaderboard to get early access first",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray700,
                fontSize: 16.sp,
                height: 1.6,
              ),
            ),
            20.verticalSpace,
            AccountCreatedButton(model: model),
          ],
        ),
      ),
    );
  }
}
