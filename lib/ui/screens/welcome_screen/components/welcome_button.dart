import 'package:enzer_app/ui/custom_widgets/custom_elevated_button.dart';
import 'package:enzer_app/ui/custom_widgets/custom_text_button.dart';
import 'package:enzer_app/ui/screens/welcome_screen/welcome_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeButtons extends StatelessWidget {
  final WelcomeScreenViewModel model;
  const WelcomeButtons({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          text: 'Get Early Access',
          onPressed: model.onGetEarlyAccessPressed,
        ),
        15.verticalSpace,
        CustomTextButton(
          onPressed: model.onSignInPressed,
          descriptiveText: 'Already have access ?',
          highlightedText: ' Sign in',
        ),
        8.verticalSpace,
      ],
    );
  }
}
