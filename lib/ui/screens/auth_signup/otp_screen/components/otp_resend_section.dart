import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/otp_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpResendSection extends StatelessWidget {
  final OtpViewModel model;
  const OtpResendSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Didn't receive code?",
            style: AppTextStyles.bodySmallRegular.copyWith(
              color: AppColors.gray700,
            ),
          ),
          8.verticalSpace,
          model.isResendEnabled
              ? GestureDetector(
                  onTap: model.resendOtp,
                  child: Text(
                    'Resend Code',
                    style: AppTextStyles.bodySmallSemiBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                )
              : Text(
                  'Resend code in ${model.formattedCountdown}',
                  style: AppTextStyles.bodySmallMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
        ],
      ),
    );
  }
}
