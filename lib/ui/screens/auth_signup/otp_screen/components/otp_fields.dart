import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/otp_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpFields extends StatelessWidget {
  final OtpViewModel model;
  const OtpFields({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      numberOfFields: 5,
      fieldWidth: 56.w,
      filled: true,
      fillColor: AppColors.gray100,
      focusedBorderColor: AppColors.primary,
      enabledBorderColor: AppColors.gray300,
      cursorColor: AppColors.black,
      showFieldAsBox: true,
      borderRadius: BorderRadius.circular(12.r),
      textStyle: AppTextStyles.h5Bold.copyWith(
        color: AppColors.black,
        height: 1.0,
        fontSize: 26.sp,
        letterSpacing: 0.5,
      ),
      onSubmit: (value) {
        model.onOtpChanged(value);
        model.verifyOtp();
      },
    );
  }
}
