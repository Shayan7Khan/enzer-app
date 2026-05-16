import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordHeader extends StatelessWidget {
  const ResetPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create new password', style: AppTextStyles.futura),
        12.verticalSpace,
        Text(
          "Enter a new password for your account. Make sure it's strong and secure.",
          style: AppTextStyles.bodyMediumRegular.copyWith(
            color: AppColors.gray800,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
