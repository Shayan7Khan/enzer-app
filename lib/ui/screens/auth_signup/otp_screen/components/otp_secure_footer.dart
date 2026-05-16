import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpSecureFooter extends StatelessWidget {
  const OtpSecureFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 16.sp, color: AppColors.gray500),
          8.horizontalSpace,
          Text(
            'Secure encrypted verification',
            style: AppTextStyles.captionLargeRegular.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
