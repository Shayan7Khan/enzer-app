import 'package:enzer_app/core/constants/image_path.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/custom_widgets/custom_elevated_button.dart';
import 'package:enzer_app/ui/custom_widgets/custom_text_button.dart';
import 'package:enzer_app/ui/screens/auth_signup/login/components/login_fields.dart';
import 'package:enzer_app/ui/screens/auth_signup/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginForm extends StatefulWidget {
  final LoginViewModel model;
  const LoginForm({super.key, required this.model});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return Form(
      key: model.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          35.verticalSpace,
          SvgPicture.asset(appLogoAuthPath, width: 71.7.w, height: 71.7.h),
          24.verticalSpace,
          const _LoginHeader(),
          32.verticalSpace,
          LoginPhoneField(model: model, passwordFocusNode: _passwordFocusNode),
          16.verticalSpace,
          LoginPasswordField(model: model, focusNode: _passwordFocusNode),
          8.verticalSpace,
          _ErrorAndForgotRow(model: model),
          18.verticalSpace,
          CustomElevatedButton(text: 'Login', onPressed: model.login),
          24.verticalSpace,
          CustomTextButton(
            onPressed: model.onSignUpPressed,
            descriptiveText: 'Don\'t have an account ?',
            highlightedText: ' Sign up',
          ),
        ],
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: AppTextStyles.futura.copyWith(fontSize: 32.sp),
        ),
        12.verticalSpace,
        Text(
          'Log in to continue experiencing\nsmarter payments.',
          textAlign: TextAlign.center,
          style: AppTextStyles.h6Regular.copyWith(
            color: AppColors.gray700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ErrorAndForgotRow extends StatelessWidget {
  final LoginViewModel model;
  const _ErrorAndForgotRow({required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (model.errorMessage != null)
          Flexible(
            child: Text(
              model.errorMessage!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.red,
                fontSize: 13.sp,
              ),
            ),
          )
        else
          const Spacer(),
        GestureDetector(
          onTap: model.onForgotPassword,
          child: Text(
            'Forgot Password?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }
}
