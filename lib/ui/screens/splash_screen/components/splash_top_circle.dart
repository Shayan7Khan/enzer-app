import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashTopCircle extends StatelessWidget {
  const SplashTopCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -80.r,
      left: 100.r,
      child: Container(
        width: 431.r,
        height: 441.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF72256B).withValues(alpha: 0.1),
        ),
      ),
    );
  }
}
