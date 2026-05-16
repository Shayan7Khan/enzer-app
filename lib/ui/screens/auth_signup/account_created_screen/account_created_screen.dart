import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/account_created_view_model.dart';
import 'package:enzer_app/ui/screens/auth_signup/account_created_screen/components/account_created_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountCreatedViewModel(),
      child: Consumer<AccountCreatedViewModel>(
        builder: (context, model, _) => AccountCreatedBody(model: model),
      ),
    );
  }
}
