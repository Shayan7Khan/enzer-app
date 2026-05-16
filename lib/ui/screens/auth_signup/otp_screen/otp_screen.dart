import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/components/otp_app_bar.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/components/otp_fields.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/components/otp_header.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/components/otp_resend_section.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/components/otp_secure_footer.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/components/otp_verify_button.dart';
import 'package:enzer_app/ui/screens/auth_signup/otp_screen/otp_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpViewModel(),
      child: Consumer<OtpViewModel>(
        builder: (context, model, _) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.busy,
          opacity: 0.3,
          color: AppColors.black,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: OtpAppBar(),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 40.h,
                  bottom: 10.h,
                  left: 24.w,
                  right: 24.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OtpHeader(model: model),
                    40.verticalSpace,
                    OtpFields(model: model),
                    15.verticalSpace,
                    OtpResendSection(model: model),
                    24.verticalSpace,
                    OtpVerifyButton(model: model),
                    const Spacer(),
                    const OtpSecureFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
