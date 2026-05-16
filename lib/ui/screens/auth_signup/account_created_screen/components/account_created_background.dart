import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/account_created_view_model.dart';
import 'package:flutter/material.dart';

class AccountCreatedBackground extends StatelessWidget {
  final AccountCreatedViewModel model;
  const AccountCreatedBackground({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: model.backgroundAnimation.value,
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.2,
            colors: [Color(0xFFF3EEFF), Color(0xFFFAF8FF), Color(0xFFFFFFFF)],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
      ),
    );
  }
}
