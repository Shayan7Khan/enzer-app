import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordFooter extends StatelessWidget {
  const ForgotPasswordFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.help_outline_rounded,
            size: 20.sp,
            color: AppColors.gray700,
          ),
          6.horizontalSpace,
          Text(
            'Need help? ',
            style: AppTextStyles.bodySmallRegular.copyWith(
              color: AppColors.gray700,
            ),
          ),
          GestureDetector(
            onTap: () {
              //? have to insert link or email
            },
            child: Text(
              'Contact Support',
              style: AppTextStyles.bodySmallSemiBold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
