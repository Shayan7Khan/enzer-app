import 'package:enzer_app/core/constants/image_path.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SplashWordmark extends StatelessWidget {
  const SplashWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      enzerLogo,
      width: 125.75.w,
      height: 60.h,
      fit: BoxFit.contain,
      placeholderBuilder: (_) => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'enzer',
              style: TextStyle(color: AppColors.white, letterSpacing: -0.5),
            ),
            TextSpan(
              text: '®',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
