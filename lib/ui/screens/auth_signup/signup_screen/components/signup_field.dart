import 'package:enzer_app/core/constants/app_strings.dart';
import 'package:enzer_app/core/theme/app_colors.dart';
import 'package:enzer_app/core/theme/app_theme.dart';
import 'package:enzer_app/ui/custom_widgets/custom_text_field.dart';
import 'package:enzer_app/ui/screens/auth_signup/signup_screen/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupField extends StatelessWidget {
  final String label;
  const SignupField(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: AppTextStyles.paragraphLargeRegular.copyWith(
            fontSize: 14.sp,
            color: AppColors.gray800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class FullNameField extends StatelessWidget {
  final SignUpViewModel model;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const FullNameField({
    super.key,
    required this.model,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SignupField(AppStrings.signUpFullNameLabel),
        CustomTextField(
          controller: model.fullNameCtrl,
          focusNode: focusNode,
          hintText: AppStrings.signUpFullNameHint,
          onTap: () {},
          textInputAction: TextInputAction.next,
          validator: model.validateFullName,
          onSaved: (_) {},
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          },
        ),
      ],
    );
  }
}

class NicField extends StatelessWidget {
  final SignUpViewModel model;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const NicField({
    super.key,
    required this.model,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SignupField(AppStrings.signUpNicLabel),
        CustomTextField(
          controller: model.cnicCtrl,
          focusNode: focusNode,
          hintText: AppStrings.signUpNicHint,
          onTap: () {},
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _NicInputFormatter(),
          ],
          validator: model.validateNic,
          onSaved: (_) {},
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          },
          onChanged: (value) {
            if (value.replaceAll('-', '').length == 13) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
        ),
      ],
    );
  }
}

class PhoneField extends StatelessWidget {
  final SignUpViewModel model;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const PhoneField({
    super.key,
    required this.model,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SignupField(AppStrings.signUpPhoneLabel),
        CustomTextField(
          controller: model.phoneCtrl,
          focusNode: focusNode,
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
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          },
          onChanged: (value) {
            if (value.length == 11) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
        ),
      ],
    );
  }
}

class ReferralCodeField extends StatelessWidget {
  final SignUpViewModel model;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const ReferralCodeField({
    super.key,
    required this.model,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SignupField(AppStrings.signUpReferralLabel),
        CustomTextField(
          controller: model.referralCtrl,
          focusNode: focusNode,
          hintText: AppStrings.signUpReferralHint,
          onTap: () {},
          textInputAction: TextInputAction.next,
          validator: model.validateReferralCode,
          onSaved: (_) {},
          inputFormatters: [_ReferralCodeInputFormatter()],
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          },
        ),
      ],
    );
  }
}

class PasswordField extends StatelessWidget {
  final SignUpViewModel model;
  final FocusNode? focusNode;

  const PasswordField({super.key, required this.model, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SignupField(AppStrings.signUpPasswordLabel),
        CustomTextField(
          controller: model.passwordCtrl,
          focusNode: focusNode,
          hintText: AppStrings.signUpPasswordHint,
          obscure: model.isPasswordVisible,
          textInputAction: TextInputAction.done,
          onTap: () {},
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
          validator: model.validatePassword,
          onSaved: (_) {},
        ),
      ],
    );
  }
}

class _NicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('-', '');
    if (digits.length > 13) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 5 || i == 12) buffer.write('-');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ReferralCodeInputFormatter extends TextInputFormatter {
  static const int _maxContentLength = 12;
  static const int _dashBeforeIndex = 5;
  static const int _dashBeforeIndex2 = 8;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toUpperCase();
    final content = raw.length > _maxContentLength
        ? raw.substring(0, _maxContentLength)
        : raw;

    final buffer = StringBuffer();
    for (int i = 0; i < content.length; i++) {
      if (i == _dashBeforeIndex || i == _dashBeforeIndex2) buffer.write('-');
      buffer.write(content[i]);
    }
    final formatted = buffer.toString();

    int newOffset = newValue.selection.baseOffset;
    if (newValue.selection.isCollapsed) {
      final oldContent = oldValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      final newContent = content;
      if (newContent.length < oldContent.length) {
        newOffset = formatted.length;
      } else {
        newOffset = formatted.length.clamp(0, formatted.length);
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: newOffset.clamp(0, formatted.length),
      ),
    );
  }
}
