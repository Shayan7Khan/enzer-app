import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/custom_widgets/custom_text_field.dart';
import 'package:enzer_app/ui/screens/auth_signup/forget_password/forget_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordPhoneField extends StatelessWidget {
  final ForgotPasswordViewModel model;
  const ForgotPasswordPhoneField({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTextStyles.paragraphSmallRegular.copyWith(
            color: AppColors.gray700,
          ),
        ),
        8.verticalSpace,
        CustomTextField(
          controller: model.phoneCtrl,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            LengthLimitingTextInputFormatter(11),
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: model.validatePhone,
          hintText: '3XXXXXXXXX',
          onTap: () {},
          onSaved: (_) {},
        ),
      ],
    );
  }
}
