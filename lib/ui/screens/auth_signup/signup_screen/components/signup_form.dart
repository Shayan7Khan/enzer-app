import 'package:enzer_app/core/constants/app_strings.dart';
import 'package:enzer_app/core/constants/image_path.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/custom_widgets/custom_elevated_button.dart';
import 'package:enzer_app/ui/custom_widgets/custom_text_button.dart';
import 'package:enzer_app/ui/screens/auth_signup/signup_screen/components/signup_field.dart';
import 'package:enzer_app/ui/screens/auth_signup/signup_screen/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpForm extends StatefulWidget {
  final SignUpViewModel model;
  const SignUpForm({super.key, required this.model});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _nicFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _referralFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _nicFocusNode.dispose();
    _phoneFocusNode.dispose();
    _referralFocusNode.dispose();
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
          const _SignUpHeader(),
          32.verticalSpace,
          FullNameField(
            model: model,
            focusNode: _nameFocusNode,
            nextFocusNode: _nicFocusNode,
          ),
          16.verticalSpace,
          NicField(
            model: model,
            focusNode: _nicFocusNode,
            nextFocusNode: _phoneFocusNode,
          ),
          16.verticalSpace,
          PhoneField(
            model: model,
            focusNode: _phoneFocusNode,
            nextFocusNode: _referralFocusNode,
          ),
          16.verticalSpace,
          ReferralCodeField(
            model: model,
            focusNode: _referralFocusNode,
            nextFocusNode: _passwordFocusNode,
          ),
          16.verticalSpace,
          PasswordField(model: model, focusNode: _passwordFocusNode),
          10.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppStrings.signUpPasswordHintText,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12.sp,
                color: AppColors.gray700,
              ),
            ),
          ),
          14.verticalSpace,
          CustomElevatedButton(
            text: 'Request Access',
            onPressed: model.requestSignUp,
          ),
          16.verticalSpace,
          CustomTextButton(
            onPressed: model.onSignInPressed,
            descriptiveText: 'Already have access ?',
            highlightedText: ' Sign in',
          ),
          16.verticalSpace,
          const _TermsFooter(),
          10.verticalSpace,
        ],
      ),
    );
  }
}

class _SignUpHeader extends StatelessWidget {
  const _SignUpHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.signUpHeaderMessage,
          textAlign: TextAlign.center,
          style: AppTextStyles.futura.copyWith(fontSize: 32),
        ),
        12.verticalSpace,
        Text(
          AppStrings.signUpMessage,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLargeRegular.copyWith(
            fontSize: 18.sp,
            color: AppColors.gray700,
          ),
        ),
      ],
    );
  }
}

class _TermsFooter extends StatelessWidget {
  const _TermsFooter();

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: 13.sp,
          color: AppColors.gray900,
        ),
        children: [
          const TextSpan(text: AppStrings.signUpTermsPrefix),
          TextSpan(
            text: AppStrings.signUpTermsAndConditions,
            recognizer: TapGestureRecognizer()
              ..onTap = () =>
                  _launchUrl('https://enzer.gethalalnow.com/Terms&condition'),
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 13.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
          const TextSpan(text: AppStrings.signUpTermsAnd),
          TextSpan(
            text: AppStrings.signUpPrivacyPolicy,
            recognizer: TapGestureRecognizer()
              ..onTap = () =>
                  _launchUrl('https://enzer.gethalalnow.com/privacy'),
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 13.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
          const TextSpan(text: AppStrings.signUpTermsSuffix),
        ],
      ),
    );
  }
}
