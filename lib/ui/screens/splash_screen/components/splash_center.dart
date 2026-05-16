import 'package:enzer_app/ui/screens/splash_screen/components/splash_logo.dart';
import 'package:enzer_app/ui/screens/splash_screen/components/splash_word_mark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashCenterContent extends StatelessWidget {
  const SplashCenterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SplashLogo(),
          20.verticalSpace,
          const SplashWordmark(),
          10.verticalSpace,
        ],
      ),
    );
  }
}
