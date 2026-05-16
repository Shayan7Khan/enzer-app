import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/custom_widgets/custom_text_field.dart';
import 'package:enzer_app/ui/screens/auth_signup/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginFields extends StatelessWidget {
  final String label;
  const LoginFields(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class LoginPhoneField extends StatelessWidget {
  final LoginViewModel model;
  final FocusNode? passwordFocusNode;

  const LoginPhoneField({
    super.key,
    required this.model,
    this.passwordFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('phone'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoginFields('Phone Number'),
        CustomTextField(
          controller: model.phoneCtrl,
          hintText: '03XXXXXXXXX',
          onTap: () {},
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            LengthLimitingTextInputFormatter(11),
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: model.validatePhone,
          onSaved: (_) {},
          onChanged: (value) {
            if (value.length == 11) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            }
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
        ),
      ],
    );
  }
}

class LoginPasswordField extends StatelessWidget {
  final LoginViewModel model;
  final FocusNode? focusNode;

  const LoginPasswordField({super.key, required this.model, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoginFields('Password'),
        CustomTextField(
          controller: model.passwordCtrl,
          hintText: '••••••••',
          obscure: !model.isPasswordVisible,
          focusNode: focusNode,
          textInputAction: TextInputAction.done,
          onTap: () {},
          suffixIcon: IconButton(
            icon: Icon(
              model.isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20.sp,
              color: AppColors.gray800,
            ),
            onPressed: model.togglePasswordVisibility,
          ),
          validator: model.validatePassword,
          onSaved: (_) {},
        ),
      ],
    );
  }
}
