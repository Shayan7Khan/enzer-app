import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/custom_widgets/custom_text_field.dart';
import 'package:enzer_app/ui/screens/auth_signup/reset_password/reset_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordFields extends StatelessWidget {
  final ResetPasswordViewModel model;
  const ResetPasswordFields({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: 'Password'),
        CustomTextField(
          controller: model.passwordCtrl,
          hintText: 'Enter new password',
          obscure: model.isPasswordVisible,
          onTap: () {},
          onSaved: (_) {},
          validator: model.validatePassword,
          suffixIcon: IconButton(
            icon: Icon(
              model.isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20.sp,
              color: AppColors.gray800,
            ),
            onPressed: model.togglePasswordVisibility,
          ),
        ),
        8.verticalSpace,
        Text(
          'Must be at least 8 characters',
          style: AppTextStyles.paragraphSmallRegular,
        ),
        16.verticalSpace,
        _FieldLabel(label: 'Confirm Password'),
        CustomTextField(
          controller: model.confirmPasswordCtrl,
          hintText: 'Re-enter new password',
          obscure: model.isConfirmPasswordVisible,
          onTap: () {},
          onSaved: (_) {},
          validator: model.validateConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              model.isConfirmPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20.sp,
              color: AppColors.gray800,
            ),
            onPressed: model.toggleConfirmPasswordVisibility,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: AppTextStyles.paragraphSmallRegular.copyWith(
          color: AppColors.gray700,
        ),
      ),
    );
  }
}
