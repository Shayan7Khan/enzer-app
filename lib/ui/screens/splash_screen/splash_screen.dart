import 'package:enzer_app/ui/screens/splash_screen/components/splash_bottom_circle.dart';
import 'package:enzer_app/ui/screens/splash_screen/components/splash_center.dart';
import 'package:enzer_app/ui/screens/splash_screen/components/splash_copy_right.dart';
import 'package:enzer_app/ui/screens/splash_screen/components/splash_top_circle.dart';
import 'package:enzer_app/ui/screens/splash_screen/splash_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static final _model = SplashViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFBF00FF), Color(0xFF5E2C4D)],
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              const SplashBottomCircle(),
              const SplashTopCircle(),
              const SplashCenterContent(),
              Positioned(
                left: 0,
                right: 0,
                bottom: 50.h,
                child: const SplashCopyright(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
