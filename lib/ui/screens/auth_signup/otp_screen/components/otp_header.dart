import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/otp_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpHeader extends StatelessWidget {
  final OtpViewModel model;
  const OtpHeader({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Verify your number',
            textAlign: TextAlign.center,
            style: AppTextStyles.h4Bold.copyWith(color: AppColors.black),
          ),
          12.verticalSpace,
          Text(
            'We sent a 5-digit code to',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmallRegular.copyWith(
              color: AppColors.gray700,
              height: 1.45,
            ),
          ),
          6.verticalSpace,
          Text(
            model.phone,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLargeSemiBold.copyWith(
              color: AppColors.black,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
