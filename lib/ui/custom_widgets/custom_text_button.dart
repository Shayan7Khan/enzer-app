import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextButton extends StatelessWidget {
  final void Function() onPressed;
  final String descriptiveText;
  final String highlightedText;
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.descriptiveText,
    required this.highlightedText,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 8.h)),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.paragraphLargeRegular.copyWith(
            fontSize: 14.sp,
            color: AppColors.gray800,
          ),
          children: [
            TextSpan(text: descriptiveText),
            TextSpan(
              text: highlightedText,
              style: AppTextStyles.paragraphLargeRegular.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
