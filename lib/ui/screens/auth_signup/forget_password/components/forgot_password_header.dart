import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Forgot password?', style: AppTextStyles.futura),
        12.verticalSpace,
        Text(
          "Don't worry! Enter your phone\nnumber to reset your password.",
          style: AppTextStyles.bodyMediumRegular.copyWith(
            color: AppColors.gray800,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
