import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/account_created_view_model.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/components/diamond_shape.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/components/triangle_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountCreatedFloatingShapes extends StatelessWidget {
  final AccountCreatedViewModel model;
  const AccountCreatedFloatingShapes({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final drift = model.floatingShapesAnimation.value;
    final opacity = model.backgroundAnimation.value;

    return Stack(
      children: [
        // Top-left purple circle
        Positioned(
          top: 160.h + (drift * 12),
          left: 48.w,
          child: Opacity(
            opacity: opacity * 0.85,
            child: Container(
              width: 18.r,
              height: 18.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFB06EF5),
              ),
            ),
          ),
        ),

        // Top-right diamond outline
        Positioned(
          top: 140.h - (drift * 8),
          right: 60.w,
          child: Opacity(
            opacity: opacity * 0.7,
            child: DiamondShape(
              size: 32.r,
              color: const Color(0xFFB06EF5),
              filled: false,
            ),
          ),
        ),

        // Right small blue circle
        Positioned(
          top: 240.h + (drift * 10),
          right: 50.w,
          child: Opacity(
            opacity: opacity * 0.6,
            child: Container(
              width: 12.r,
              height: 12.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF7B9EFF),
              ),
            ),
          ),
        ),

        // Left circle outline
        Positioned(
          top: 280.h - (drift * 6),
          left: 36.w,
          child: Opacity(
            opacity: opacity * 0.5,
            child: Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF9B6FD4).withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
            ),
          ),
        ),

        // Bottom-left filled lavender circle
        Positioned(
          top: 340.h + (drift * 14),
          left: 60.w,
          child: Opacity(
            opacity: opacity * 0.5,
            child: Container(
              width: 30.r,
              height: 30.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFCBA8F5),
              ),
            ),
          ),
        ),

        // Bottom-right triangle outline
        Positioned(
          top: 330.h - (drift * 10),
          right: 52.w,
          child: Opacity(
            opacity: opacity * 0.65,
            child: CustomPaint(
              size: Size(30.r, 26.r),
              painter: TrianglePainter(color: const Color(0xFFB06EF5)),
            ),
          ),
        ),
      ],
    );
  }
}
