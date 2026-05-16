import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/account_created_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountCreatedCheckIcon extends StatelessWidget {
  final AccountCreatedViewModel model;
  const AccountCreatedCheckIcon({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: model.checkScaleAnimation.value * model.pulseAnimation.value,
      child: Opacity(
        opacity: model.checkOpacityAnimation.value,
        child: Container(
          width: 160.r,
          height: 160.r,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF22C55E),
          ),
          child: Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 100.sp,
            weight: 900,
          ),
        ),
      ),
    );
  }
}
