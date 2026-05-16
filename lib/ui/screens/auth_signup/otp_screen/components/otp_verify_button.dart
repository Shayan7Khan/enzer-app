import 'package:enzer_app/ui/custom_widgets/custom_elevated_button.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/otp_screen_view_model.dart';
import 'package:flutter/material.dart';

class OtpVerifyButton extends StatelessWidget {
  final OtpViewModel model;
  const OtpVerifyButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      text: 'Verify',
      onPressed: model.verifyOtp,
      isBold: true,
    );
  }
}
