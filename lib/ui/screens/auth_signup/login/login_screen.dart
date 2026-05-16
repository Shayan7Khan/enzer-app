import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/screens/auth_signup/login/components/login_form.dart';
import 'package:enzer_app/ui/screens/auth_signup/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, model, _) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.busy,
          opacity: 0.3,
          color: AppColors.black,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.backgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: LoginForm(model: model),
                    ),
                  ),
                  if (MediaQuery.of(context).viewInsets.bottom == 0)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: const _PrivacyFooter(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrivacyFooter extends StatelessWidget {
  const _PrivacyFooter();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 18.sp, color: AppColors.gray700),
          8.horizontalSpace,
          Text(
            'We respect your privacy.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray700),
          ),
        ],
      ),
    );
  }
}
