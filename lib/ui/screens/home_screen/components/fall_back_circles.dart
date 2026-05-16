import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FallbackCircles extends StatelessWidget {
  const FallbackCircles({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.r,
      height: 140.r,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(4, (i) {
          final size = 40.0 + (i * 32.0);
          return Container(
            width: size.r,
            height: size.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25 - (i * 0.05)),
                width: 1.5,
              ),
            ),
          );
        }),
      ),
    );
  }
}
