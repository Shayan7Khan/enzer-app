import 'package:enzer_app/ui/custom_widgets/custom_elevated_button.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/account_created_view_model.dart';
import 'package:flutter/material.dart';

class AccountCreatedButton extends StatelessWidget {
  final AccountCreatedViewModel model;
  const AccountCreatedButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      text: 'Start Inviting',
      onPressed: model.goToDashboard,
    );
  }
}
