import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordFooter extends StatelessWidget {
  const ResetPasswordFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 19.sp, color: AppColors.gray700),
          8.horizontalSpace,
          Text(
            'Secure encrypted verification',
            style: AppTextStyles.bodySmallRegular.copyWith(
              color: AppColors.gray700,
            ),
          ),
        ],
      ),
    );
  }
}
