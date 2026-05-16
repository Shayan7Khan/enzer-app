import 'package:enzer_app/core/constants/app_strings.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.welcomeHeaderMessage,
          textAlign: TextAlign.center,
          style: AppTextStyles.futura,
        ),
        20.verticalSpace,

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTextStyles.bodyLargeRegular.copyWith(
              fontSize: 16.sp,
              color: AppColors.gray900,
            ),
            children: [
              const TextSpan(
                text: 'Get your favourite now and pay over time with simple, ',
              ),
              TextSpan(
                text: 'Shariah-compliant',
                style: AppTextStyles.bodyLargeSemiBold.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(
                text:
                    ' instalments. No hidden fees — just complete flexibility.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
