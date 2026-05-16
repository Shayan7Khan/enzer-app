import 'package:enzer_app/ui/custom_widgets/custom_elevated_button.dart';
import 'package:enzer_app/ui/screens/auth_signup/reset_password/reset_password_view_model.dart';
import 'package:flutter/material.dart';

class ResetPasswordButton extends StatelessWidget {
  final ResetPasswordViewModel model;
  const ResetPasswordButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      text: 'Reset Password',
      onPressed: model.onResetPassword,
    );
  }
}
