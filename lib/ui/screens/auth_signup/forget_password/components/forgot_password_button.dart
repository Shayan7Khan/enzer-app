import 'package:enzer_app/ui/custom_widgets/custom_elevated_button.dart';
import 'package:enzer_app/ui/screens/auth_signup/forget_password/forget_password_view_model.dart';
import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  final ForgotPasswordViewModel model;
  const ForgotPasswordButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(text: 'Send Code', onPressed: model.onSendCode);
  }
}
