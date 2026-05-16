import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/ui/screens/auth_signup/signup_screen/components/signup_form.dart';
import 'package:enzer_app/ui/screens/auth_signup/signup_screen/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder: (context, model, _) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.busy,
          opacity: 0.3,
          color: AppColors.black,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: SignUpForm(model: model),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
