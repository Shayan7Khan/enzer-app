import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/ui/screens/auth_signup/reset_password/components/reset_password_app_bar.dart';
import 'package:enzer_app/ui/screens/auth_signup/reset_password/components/reset_password_button.dart';
import 'package:enzer_app/ui/screens/auth_signup/reset_password/components/reset_password_fields.dart';
import 'package:enzer_app/ui/screens/auth_signup/reset_password/components/reset_password_footer.dart';
import 'package:enzer_app/ui/screens/auth_signup/reset_password/components/reset_password_header.dart';
import 'package:enzer_app/ui/screens/auth_signup/reset_password/reset_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResetPasswordViewModel(),
      child: Consumer<ResetPasswordViewModel>(
        builder: (context, model, _) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.busy,
          opacity: 0.3,
          color: AppColors.black,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: ResetPasswordAppBar(),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: model.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              40.verticalSpace,
                              const ResetPasswordHeader(),
                              30.verticalSpace,
                              ResetPasswordFields(model: model),
                              32.verticalSpace,
                              ResetPasswordButton(model: model),
                            ],
                          ),
                        ),
                      ),
                      const ResetPasswordFooter(),
                      5.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
