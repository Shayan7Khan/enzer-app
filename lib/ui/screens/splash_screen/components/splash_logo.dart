import 'package:enzer_app/core/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      appLogo,
      width: 135.25.r,
      height: 135.25.r,
      fit: BoxFit.contain,
      placeholderBuilder: (_) =>
          Icon(Icons.image_outlined, size: 60.r, color: Colors.grey.shade400),
    );
  }
}
