import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashBottomCircle extends StatelessWidget {
  const SplashBottomCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 690.r,
      left: -46.r,
      child: Container(
        width: 493.r,
        height: 493.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF72256B),
        ),
      ),
    );
  }
}
