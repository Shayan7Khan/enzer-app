import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashCopyright extends StatelessWidget {
  const SplashCopyright({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '© ${DateTime.now().year} Enzer | Shop Now, Pay Later. All rights reserved.',
      textAlign: TextAlign.center,
      style: AppTextStyles.captionLargeMedium.copyWith(
        fontSize: 10.sp,
        color: AppColors.white,
      ),
    );
  }
}
